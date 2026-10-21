<?php

declare(strict_types=1);

require_once __DIR__ . '/../config/app.php';
require_once __DIR__ . '/qbwc_qbxml.php';

final class QuickBooksSessionStore
{
    private PDO $pdo;

    public function __construct(PDO $pdo)
    {
        $this->pdo = $pdo;
    }

    public function createSession(string $username): string
    {
        $ticket = bin2hex(random_bytes(24));
        $now = new DateTimeImmutable('now');
        $expiresAt = $now->modify('+30 minutes')->format('Y-m-d H:i:s');
        $stmt = $this->pdo->prepare('INSERT INTO qbwc_sessions (ticket, username, status, expires_at, authenticated_at, created_at) VALUES (?, ?, ?, ?, ?, ?)');
        $stmt->execute([$ticket, trim($username), 'active', $expiresAt, $now->format('Y-m-d H:i:s'), $now->format('Y-m-d H:i:s')]);
        return $ticket;
    }

    public function expireStaleSessions(): void
    {
        $now = (new DateTimeImmutable('now'))->format('Y-m-d H:i:s');
        $stmt = $this->pdo->prepare('SELECT id FROM qbwc_sessions WHERE status = ? AND expires_at <= ?');
        $stmt->execute(['active', $now]);
        $sessionIds = $stmt->fetchAll(PDO::FETCH_COLUMN);
        foreach ($sessionIds as $sessionId) {
            $this->releaseSessionJobs((int)$sessionId);
            $update = $this->pdo->prepare('UPDATE qbwc_sessions SET status = ?, updated_at = ? WHERE id = ? AND status = ?');
            $update->execute(['expired', $now, (int)$sessionId, 'active']);
        }
    }

    public function createSessionForPendingJobs(string $username): ?string
    {
        $this->pdo->beginTransaction();
        try {
            $lockClause = $this->pdo->getAttribute(PDO::ATTR_DRIVER_NAME) === 'mysql' ? ' FOR UPDATE' : '';
            $pending = $this->pdo->query("SELECT id FROM qbwc_readonly_jobs WHERE session_id IS NULL AND status IN ('queued', 'retry') ORDER BY id LIMIT 1" . $lockClause);
            if ($pending->fetchColumn() === false) {
                $this->pdo->rollBack();
                return null;
            }

            $ticket = $this->createSession($username);
            $session = $this->validateTicket($ticket);
            if ($session === null) {
                throw new RuntimeException('The new QBWC session could not be validated.');
            }

            $stmt = $this->pdo->prepare("UPDATE qbwc_readonly_jobs SET session_id = ?, updated_at = ? WHERE session_id IS NULL AND status IN ('queued', 'retry')");
            $stmt->execute([(int)$session['id'], (new DateTimeImmutable('now'))->format('Y-m-d H:i:s')]);
            if ($stmt->rowCount() === 0) {
                $this->pdo->rollBack();
                return null;
            }
            $this->pdo->commit();
            return $ticket;
        } catch (Throwable $exception) {
            if ($this->pdo->inTransaction()) {
                $this->pdo->rollBack();
            }
            throw $exception;
        }
    }

    public function enqueueQuery(string $requestType, array $fullNames): int
    {
        if (!in_array($requestType, ['CustomerQuery', 'ItemQuery'], true)) {
            throw new InvalidArgumentException('Only read-only customer and item query jobs are supported.');
        }
        if (count($fullNames) > 100) {
            throw new InvalidArgumentException('A read-only query can contain at most 100 names.');
        }
        foreach ($fullNames as $fullName) {
            if (!is_string($fullName) || trim($fullName) === '' || strlen($fullName) > 255) {
                throw new InvalidArgumentException('Read-only query names must be non-empty strings of at most 255 bytes.');
            }
        }
        $fullNames = array_values($fullNames);
        $requestXml = $requestType === 'CustomerQuery'
            ? QuickBooksQueryBuilder::buildCustomerQuery($fullNames)
            : QuickBooksQueryBuilder::buildItemQuery($fullNames);
        $validated = QuickBooksQueryBuilder::validateAndRebuildReadOnlyRequest($requestXml);
        if ($validated === null || $validated['type'] !== $requestType) {
            throw new RuntimeException('The generated read-only query failed validation.');
        }
        $stmt = $this->pdo->prepare('INSERT INTO qbwc_readonly_jobs (request_type, request_xml, request_id, status, attempts, created_at, updated_at) VALUES (?, ?, ?, ?, 0, ?, ?)');
        $now = (new DateTimeImmutable('now'))->format('Y-m-d H:i:s');
        $stmt->execute([$requestType, $requestXml, $validated['requestId'], 'queued', $now, $now]);
        return (int)$this->pdo->lastInsertId();
    }

    public function validateTicket(string $ticket): ?array
    {
        $now = (new DateTimeImmutable('now'))->format('Y-m-d H:i:s');
        $stmt = $this->pdo->prepare('SELECT * FROM qbwc_sessions WHERE ticket = ? AND status = ? AND expires_at > ? LIMIT 1');
        $stmt->execute([$ticket, 'active', $now]);
        $session = $stmt->fetch();
        if ($session === false) {
            return null;
        }
        return $session;
    }

    public function invalidateTicket(string $ticket): void
    {
        $stmt = $this->pdo->prepare('UPDATE qbwc_sessions SET status = ?, updated_at = ? WHERE ticket = ?');
        $stmt->execute(['closed', (new DateTimeImmutable('now'))->format('Y-m-d H:i:s'), $ticket]);
    }

    public function setLastError(string $ticket, string $message): void
    {
        $stmt = $this->pdo->prepare('UPDATE qbwc_sessions SET last_error = ?, updated_at = ? WHERE ticket = ?');
        $stmt->execute([$message, (new DateTimeImmutable('now'))->format('Y-m-d H:i:s'), $ticket]);
    }

    public function getLastError(string $ticket): string
    {
        $stmt = $this->pdo->prepare('SELECT last_error FROM qbwc_sessions WHERE ticket = ? LIMIT 1');
        $stmt->execute([$ticket]);
        $value = $stmt->fetchColumn();
        return is_string($value) ? $value : '';
    }

    public function nextJobForSession(int $sessionId): ?array
    {
        while (true) {
            $stmt = $this->pdo->prepare("SELECT * FROM qbwc_readonly_jobs WHERE session_id = ? AND status IN ('in_flight', 'queued', 'retry') ORDER BY id LIMIT 1");
            $stmt->execute([$sessionId]);
            $job = $stmt->fetch();
            if ($job === false) {
                return null;
            }
            if ($job['status'] === 'in_flight') {
                return $job;
            }
            if ((int)$job['attempts'] >= 3) {
                $this->updateJob((int)$job['id'], 'failed', 'Retry limit reached for this read-only query.', '', true);
                continue;
            }
            $update = $this->pdo->prepare("UPDATE qbwc_readonly_jobs SET status = 'in_flight', attempts = attempts + 1, updated_at = ? WHERE id = ? AND status IN ('queued', 'retry')");
            $update->execute([(new DateTimeImmutable('now'))->format('Y-m-d H:i:s'), (int)$job['id']]);
            if ($update->rowCount() === 1) {
                $job['status'] = 'in_flight';
                $job['attempts'] = (int)$job['attempts'] + 1;
                return $job;
            }
        }
    }

    public function activeJobForSession(int $sessionId): ?array
    {
        $stmt = $this->pdo->prepare("SELECT * FROM qbwc_readonly_jobs WHERE session_id = ? AND status = 'in_flight' ORDER BY id LIMIT 1");
        $stmt->execute([$sessionId]);
        $job = $stmt->fetch();
        return $job === false ? null : $job;
    }

    public function updateJob(int $jobId, string $status, string $diagnostic, string $responseCode = '', bool $completed = false): void
    {
        $now = (new DateTimeImmutable('now'))->format('Y-m-d H:i:s');
        $completedAt = $completed ? $now : null;
        $stmt = $this->pdo->prepare('UPDATE qbwc_readonly_jobs SET status = ?, response_code = ?, diagnostic = ?, updated_at = ?, completed_at = ? WHERE id = ?');
        $stmt->execute([$status, $responseCode, $diagnostic, $now, $completedAt, $jobId]);
    }

    public function updateJobResponse(int $jobId, string $status, string $diagnostic, string $responseCode): void
    {
        $this->updateJob($jobId, $status, $diagnostic, $responseCode, $status === 'completed' || $status === 'failed');
    }

    public function getProgress(int $sessionId): int
    {
        $stmt = $this->pdo->prepare("SELECT COUNT(*) AS total, SUM(status = 'completed') AS completed, SUM(status = 'failed') AS failed FROM qbwc_readonly_jobs WHERE session_id = ?");
        $stmt->execute([$sessionId]);
        $counts = $stmt->fetch();
        $total = (int)($counts['total'] ?? 0);
        $completed = (int)($counts['completed'] ?? 0);
        $failed = (int)($counts['failed'] ?? 0);
        if ($total === 0 || $failed > 0) {
            return 0;
        }
        if ($completed === $total) {
            return 100;
        }
        return min(99, (int)floor(($completed / $total) * 100));
    }

    public function releaseSessionJobs(int $sessionId): void
    {
        $now = (new DateTimeImmutable('now'))->format('Y-m-d H:i:s');
        $stmt = $this->pdo->prepare("UPDATE qbwc_readonly_jobs SET status = CASE WHEN attempts < 3 THEN 'queued' ELSE 'failed' END, session_id = NULL, diagnostic = CASE WHEN attempts < 3 THEN 'Session ended before the read-only query completed.' ELSE 'Retry limit reached after session cleanup.' END, updated_at = ?, completed_at = CASE WHEN attempts < 3 THEN NULL ELSE ? END WHERE session_id = ? AND status IN ('queued', 'in_flight', 'retry')");
        $stmt->execute([$now, $now, $sessionId]);
    }

    public function findSessionId(string $ticket): ?int
    {
        $stmt = $this->pdo->prepare('SELECT id FROM qbwc_sessions WHERE ticket = ? LIMIT 1');
        $stmt->execute([$ticket]);
        $id = $stmt->fetchColumn();
        return $id === false ? null : (int)$id;
    }

    public function findJobByResponseHash(int $sessionId, string $responseHash): ?array
    {
        $stmt = $this->pdo->prepare('SELECT * FROM qbwc_readonly_jobs WHERE session_id = ? AND response_hash = ? LIMIT 1');
        $stmt->execute([$sessionId, $responseHash]);
        $job = $stmt->fetch();
        return $job === false ? null : $job;
    }

    public function saveResponseHash(int $jobId, string $responseHash): void
    {
        $stmt = $this->pdo->prepare('UPDATE qbwc_readonly_jobs SET response_hash = ?, updated_at = ? WHERE id = ?');
        $stmt->execute([$responseHash, (new DateTimeImmutable('now'))->format('Y-m-d H:i:s'), $jobId]);
    }
}

final class QuickBooksReadOnlyResolver
{
    public static function classifyCustomerMatch(string $localCustomerName, array $quickBooksCustomers): string
    {
        $needle = trim($localCustomerName);
        if ($needle === '') {
            return 'UNMAPPED';
        }

        $matches = [];
        foreach ($quickBooksCustomers as $customer) {
            $fullName = trim((string)($customer['FullName'] ?? $customer['Name'] ?? ''));
            if ($fullName === '') {
                continue;
            }
            if (strcasecmp($fullName, $needle) === 0) {
                $matches[] = $customer;
            }
        }

        if (count($matches) > 1) {
            return 'AMBIGUOUS';
        }
        if (count($matches) === 1) {
            return 'MATCHED';
        }
        return 'NOT_FOUND';
    }

    public static function classifyProductMatch(string $localProductCode, array $quickBooksItems): string
    {
        $needle = trim($localProductCode);
        if ($needle === '') {
            return 'UNMAPPED';
        }

        $matches = [];
        foreach ($quickBooksItems as $item) {
            $codeCandidates = [
                (string)($item['ItemCode'] ?? ''),
                (string)($item['Name'] ?? ''),
                (string)($item['FullName'] ?? ''),
            ];
            foreach ($codeCandidates as $candidate) {
                if (strcasecmp(trim($candidate), $needle) === 0) {
                    $matches[] = $item;
                    break;
                }
            }
        }

        if (count($matches) > 1) {
            return 'AMBIGUOUS';
        }
        if (count($matches) === 1) {
            return 'MATCHED';
        }
        return 'NOT_FOUND';
    }
}

final class QuickBooksWebConnectorService
{
    public const QBWC_NAMESPACE = 'http://developer.intuit.com/';

    private PDO $pdo;
    private QuickBooksSessionStore $sessionStore;

    public function __construct(?PDO $pdo = null)
    {
        $this->pdo = $pdo ?? db();
        $this->sessionStore = new QuickBooksSessionStore($this->pdo);
    }

    public function serverVersion(): string
    {
        return '1.0.0';
    }

    public function clientVersion(string $strVersion): string
    {
        return '';
    }

    public function authenticate(string $strUserName, string $strPassword): array
    {
        $expectedUser = getenv('WQ_QBWC_USERNAME');
        $expectedPassword = getenv('WQ_QBWC_PASSWORD');

        if ($expectedUser === false || $expectedPassword === false || trim((string)$expectedUser) === '' || trim((string)$expectedPassword) === '') {
            return ['nvu', ''];
        }

        if (!hash_equals((string) $expectedUser, (string) $strUserName) || !hash_equals((string) $expectedPassword, (string) $strPassword)) {
            return ['nvu', ''];
        }

        $this->sessionStore->expireStaleSessions();
        $ticket = $this->sessionStore->createSessionForPendingJobs($strUserName);
        return $ticket === null ? ['none', ''] : [$ticket, ''];
    }

    public function enqueueCustomerQuery(array $fullNames = []): int
    {
        return $this->sessionStore->enqueueQuery('CustomerQuery', $fullNames);
    }

    public function enqueueItemQuery(array $fullNames = []): int
    {
        return $this->sessionStore->enqueueQuery('ItemQuery', $fullNames);
    }

    public function sendRequestXML(string $ticket, string $strHCPResponse, string $strCompanyFileName, string $qbXMLCountry, int $qbXMLMajorVers, int $qbXMLMinorVers): string
    {
        $session = $this->sessionStore->validateTicket($ticket);
        if ($session === null) {
            throw new RuntimeException('Invalid or expired QBWC session ticket.');
        }

        $job = $this->sessionStore->nextJobForSession((int)$session['id']);
        if ($job === null) {
            return '';
        }

        $validatedRequest = QuickBooksQueryBuilder::validateAndRebuildReadOnlyRequest((string)$job['request_xml']);
        if (
            $validatedRequest === null
            || $validatedRequest['type'] !== $job['request_type']
            || $validatedRequest['requestId'] !== $job['request_id']
        ) {
            $this->sessionStore->updateJob((int)$job['id'], 'failed', 'Queued request failed read-only validation.', '', true);
            $this->sessionStore->setLastError($ticket, 'Queued request failed read-only validation.');
            return '';
        }

        return $validatedRequest['xml'];
    }

    public function receiveResponseXML(string $ticket, string $response, int $hresult, string $message): int
    {
        $session = $this->sessionStore->validateTicket($ticket);
        if ($session === null) {
            throw new RuntimeException('Invalid or expired QBWC session ticket.');
        }

        $sessionId = (int)$session['id'];
        if ($response !== '') {
            $responseHash = hash('sha256', $response);
            if ($this->sessionStore->findJobByResponseHash($sessionId, $responseHash) !== null) {
                return $this->sessionStore->getProgress($sessionId);
            }
        }

        $job = $this->sessionStore->activeJobForSession($sessionId);
        if ($job === null) {
            $this->sessionStore->setLastError($ticket, 'No in-flight read-only query is associated with this session.');
            return $this->sessionStore->getProgress($sessionId);
        }

        $responseHash = hash('sha256', $response);
        $parsed = $hresult === 0
            ? QuickBooksQueryBuilder::parseReadOnlyQueryResponse($response, (string)$job['request_type'], (string)$job['request_id'])
            : ['status' => 'quickbooks_error', 'code' => '', 'diagnostic' => 'QuickBooks reported a processing error.'];
        $this->sessionStore->saveResponseHash((int)$job['id'], $responseHash);

        if ($parsed['status'] === 'success') {
            $this->sessionStore->updateJobResponse((int)$job['id'], 'completed', 'Read-only query completed successfully.', '0');
            return $this->sessionStore->getProgress($sessionId);
        }

        if ($parsed['status'] === 'quickbooks_error') {
            $this->sessionStore->updateJobResponse((int)$job['id'], 'failed', $parsed['diagnostic'], $parsed['code']);
            $this->sessionStore->setLastError($ticket, $parsed['diagnostic']);
            return 0;
        }

        $retry = (int)$job['attempts'] < 3;
        $status = $retry ? 'retry' : 'failed';
        $diagnostic = $retry ? 'Malformed or mismatched QuickBooks response; the query is eligible for retry.' : 'Malformed or mismatched QuickBooks response; retry limit reached.';
        $this->sessionStore->updateJobResponse((int)$job['id'], $status, $diagnostic, '');
        $this->sessionStore->setLastError($ticket, $diagnostic);
        return 0;
    }

    public function getLastError(string $ticket): string
    {
        return $this->sessionStore->getLastError($ticket);
    }

    public function connectionError(string $ticket, string $hresult, string $message): string
    {
        $session = $this->sessionStore->validateTicket($ticket);
        if ($session !== null) {
            $this->sessionStore->setLastError($ticket, 'Connection error reported by QuickBooks Web Connector.');
            $this->sessionStore->releaseSessionJobs((int)$session['id']);
            $this->sessionStore->invalidateTicket($ticket);
        }
        return 'OK';
    }

    public function closeConnection(string $ticket): string
    {
        $session = $this->sessionStore->validateTicket($ticket);
        if ($session !== null) {
            $this->sessionStore->releaseSessionJobs((int)$session['id']);
            $this->sessionStore->invalidateTicket($ticket);
        }
        return 'OK';
    }

    public function parseCustomerResponse(string $responseXml): array
    {
        return QuickBooksQueryBuilder::parseCustomerQueryResponse($responseXml);
    }

    public function parseItemResponse(string $responseXml): array
    {
        return QuickBooksQueryBuilder::parseItemQueryResponse($responseXml);
    }

    public function resolveCustomerMatch(string $localName, array $qbCustomers): string
    {
        return QuickBooksReadOnlyResolver::classifyCustomerMatch($localName, $qbCustomers);
    }

    public function resolveProductMatch(string $localCode, array $qbItems): string
    {
        return QuickBooksReadOnlyResolver::classifyProductMatch($localCode, $qbItems);
    }
}

final class QuickBooksSoapServiceAdapter
{
    private QuickBooksWebConnectorService $service;

    public function __construct(QuickBooksWebConnectorService $service)
    {
        $this->service = $service;
    }

    public function serverVersion(stdClass $parameters): stdClass
    {
        return (object)['serverVersionResult' => $this->service->serverVersion()];
    }

    public function clientVersion(stdClass $parameters): stdClass
    {
        return (object)['clientVersionResult' => $this->service->clientVersion((string)$parameters->strVersion)];
    }

    public function authenticate(stdClass $parameters): stdClass
    {
        return (object)['authenticateResult' => $this->service->authenticate((string)$parameters->strUserName, (string)$parameters->strPassword)];
    }

    public function sendRequestXML(stdClass $parameters): stdClass
    {
        return (object)['sendRequestXMLResult' => $this->service->sendRequestXML(
            (string)$parameters->ticket,
            (string)$parameters->strHCPResponse,
            (string)$parameters->strCompanyFileName,
            (string)$parameters->qbXMLCountry,
            (int)$parameters->qbXMLMajorVers,
            (int)$parameters->qbXMLMinorVers
        )];
    }

    public function receiveResponseXML(stdClass $parameters): stdClass
    {
        return (object)['receiveResponseXMLResult' => $this->service->receiveResponseXML(
            (string)$parameters->ticket,
            (string)$parameters->response,
            (int)$parameters->hresult,
            (string)$parameters->message
        )];
    }

    public function getLastError(stdClass $parameters): stdClass
    {
        return (object)['getLastErrorResult' => $this->service->getLastError((string)$parameters->ticket)];
    }

    public function connectionError(stdClass $parameters): stdClass
    {
        return (object)['connectionErrorResult' => $this->service->connectionError(
            (string)$parameters->ticket,
            (string)$parameters->hresult,
            (string)$parameters->message
        )];
    }

    public function closeConnection(stdClass $parameters): stdClass
    {
        return (object)['closeConnectionResult' => $this->service->closeConnection((string)$parameters->ticket)];
    }
}
