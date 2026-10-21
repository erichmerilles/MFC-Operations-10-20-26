<?php

declare(strict_types=1);

require_once __DIR__ . '/../backend/integration/qbwc_service.php';

function qbwc_assert(bool $condition, string $message): void
{
    if (!$condition) {
        throw new RuntimeException($message);
    }
}

function qbwc_db(): PDO
{
    $pdo = new PDO('sqlite::memory:', null, null, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);
    $pdo->exec(<<<'SQL'
        CREATE TABLE qbwc_sessions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            ticket TEXT NOT NULL UNIQUE,
            username TEXT NOT NULL,
            status TEXT NOT NULL DEFAULT 'active',
            authenticated_at TEXT NOT NULL,
            expires_at TEXT NOT NULL,
            last_error TEXT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NULL
        );
        CREATE TABLE qbwc_readonly_jobs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            session_id INTEGER NULL,
            request_type TEXT NOT NULL,
            request_id TEXT NOT NULL,
            request_xml TEXT NOT NULL,
            status TEXT NOT NULL DEFAULT 'queued',
            attempts INTEGER NOT NULL DEFAULT 0,
            response_code TEXT NOT NULL DEFAULT '',
            response_hash TEXT NULL,
            diagnostic TEXT NOT NULL DEFAULT '',
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            completed_at TEXT NULL
        );
    SQL);
    return $pdo;
}

function qbwc_soap_call(SoapServer $server, string $method, array $arguments): DOMDocument
{
    $request = '<?xml version="1.0" encoding="UTF-8"?>'
        . '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:qb="http://developer.intuit.com/">'
        . '<soap:Body><qb:' . $method . '>';
    foreach ($arguments as $name => $value) {
        $request .= '<qb:' . $name . '>' . htmlspecialchars((string)$value, ENT_QUOTES | ENT_XML1, 'UTF-8') . '</qb:' . $name . '>';
    }
    $request .= '</qb:' . $method . '></soap:Body></soap:Envelope>';

    $_SERVER['HTTP_SOAPACTION'] = '"http://developer.intuit.com/' . $method . '"';
    ob_start();
    try {
        $server->handle($request);
        $response = (string)ob_get_contents();
    } finally {
        ob_end_clean();
    }

    $dom = new DOMDocument();
    qbwc_assert($dom->loadXML($response), 'Native SoapServer returned malformed XML for ' . $method . '.');
    return $dom;
}

function qbwc_soap_result(DOMDocument $response, string $method): DOMElement
{
    $responseNode = $response->getElementsByTagNameNS(QuickBooksWebConnectorService::QBWC_NAMESPACE, $method . 'Response')->item(0);
    qbwc_assert($responseNode instanceof DOMElement, $method . ' response wrapper has the wrong namespace or name.');
    $result = $responseNode->getElementsByTagNameNS(QuickBooksWebConnectorService::QBWC_NAMESPACE, $method . 'Result')->item(0);
    qbwc_assert($result instanceof DOMElement, $method . ' response result has the wrong namespace or name.');
    return $result;
}

function qbwc_soap_server(QuickBooksWebConnectorService $service): SoapServer
{
    $server = new SoapServer(__DIR__ . '/../backend/integration/qbwc.wsdl', [
        'cache_wsdl' => WSDL_CACHE_NONE,
        'encoding' => 'UTF-8',
    ]);
    $server->setObject(new QuickBooksSoapServiceAdapter($service));
    return $server;
}

function qbwc_wsdl_result_type(DOMDocument $wsdl, string $resultName): string
{
    $xpath = new DOMXPath($wsdl);
    $type = $xpath->query('//*[local-name()="element" and @name="' . $resultName . '"]/@type')->item(0);
    qbwc_assert($type instanceof DOMAttr, 'WSDL return type is missing for ' . $resultName . '.');
    return $type->value;
}

function qbwc_wsdl_parameters(DOMDocument $wsdl, string $operation): array
{
    $xpath = new DOMXPath($wsdl);
    $xpath->registerNamespace('xsd', 'http://www.w3.org/2001/XMLSchema');
    $elements = $xpath->query('//xsd:element[@name="' . $operation . '"]/xsd:complexType/xsd:sequence/xsd:element');
    $parameters = [];
    foreach ($elements as $element) {
        $parameters[] = [$element->getAttribute('name'), $element->getAttribute('type')];
    }
    return $parameters;
}

function qbwc_response_xml(string $type, string $requestId, string $statusCode = '0', string $body = ''): string
{
    $resultTag = $type === 'CustomerQuery' ? 'CustomerQueryRs' : 'ItemQueryRs';
    $message = $statusCode === '0' ? '' : 'QBWC mock error detail that must not be persisted.';
    return '<QBXML><QBXMLMsgsRs><' . $resultTag
        . ' requestID="' . htmlspecialchars($requestId, ENT_QUOTES | ENT_XML1, 'UTF-8') . '"'
        . ' statusCode="' . $statusCode . '" statusSeverity="' . ($statusCode === '0' ? 'Info' : 'Error') . '"'
        . ' statusMessage="' . htmlspecialchars($message, ENT_QUOTES | ENT_XML1, 'UTF-8') . '">'
        . $body . '</' . $resultTag . '></QBXMLMsgsRs></QBXML>';
}

function qbwc_job(PDO $pdo, int $id): array
{
    $stmt = $pdo->prepare('SELECT * FROM qbwc_readonly_jobs WHERE id = ?');
    $stmt->execute([$id]);
    $row = $stmt->fetch();
    qbwc_assert($row !== false, 'Expected queued job was not persisted.');
    return $row;
}

$previousUser = getenv('WQ_QBWC_USERNAME');
$previousPassword = getenv('WQ_QBWC_PASSWORD');
putenv('WQ_QBWC_USERNAME=qbwc-test-user');
putenv('WQ_QBWC_PASSWORD=qbwc-test-password');

try {
    $pdo = qbwc_db();
    $service = new QuickBooksWebConnectorService($pdo);

    $wsdlPath = __DIR__ . '/../backend/integration/qbwc.wsdl';
    $wsdl = new DOMDocument();
    qbwc_assert($wsdl->load($wsdlPath), 'The local QBWC WSDL is not well-formed XML.');
    qbwc_assert($wsdl->documentElement?->getAttribute('targetNamespace') === QuickBooksWebConnectorService::QBWC_NAMESPACE, 'WSDL target namespace is incorrect.');
    $binding = $wsdl->getElementsByTagNameNS('http://schemas.xmlsoap.org/wsdl/', 'binding')->item(0);
    qbwc_assert($binding instanceof DOMElement && $binding->getElementsByTagNameNS('http://schemas.xmlsoap.org/wsdl/soap/', 'binding')->item(0)?->getAttribute('style') === 'document', 'WSDL binding must use document style.');
    $soapBinding = $binding?->getElementsByTagNameNS('http://schemas.xmlsoap.org/wsdl/soap/', 'binding')->item(0);
    qbwc_assert($soapBinding instanceof DOMElement && $soapBinding->getAttribute('transport') === 'http://schemas.xmlsoap.org/soap/http', 'WSDL must use SOAP 1.1 over HTTP.');
    $bindingOperations = $binding?->getElementsByTagNameNS('http://schemas.xmlsoap.org/wsdl/', 'operation');
    qbwc_assert($bindingOperations?->length === 8, 'WSDL must define all eight QBWC callbacks.');
    $soapAddress = $wsdl->getElementsByTagNameNS('http://schemas.xmlsoap.org/wsdl/soap/', 'address')->item(0);
    qbwc_assert($soapAddress instanceof DOMElement && $soapAddress->getAttribute('location') === 'http://localhost/MFC-Operations/backend/integration/qbwc.php', 'WSDL service address must match the local QBWC endpoint.');
    foreach ($bindingOperations as $bindingOperation) {
        foreach ([0, 1] as $direction) {
            $body = $bindingOperation->getElementsByTagNameNS('http://schemas.xmlsoap.org/wsdl/soap/', 'body')->item($direction);
            qbwc_assert($body instanceof DOMElement && $body->getAttribute('use') === 'literal', 'Every SOAP body must use literal encoding.');
        }
    }
    $expectedReturnTypes = [
        'serverVersionResult' => 'xsd:string',
        'clientVersionResult' => 'xsd:string',
        'authenticateResult' => 'tns:ArrayOfString',
        'sendRequestXMLResult' => 'xsd:string',
        'receiveResponseXMLResult' => 'xsd:int',
        'getLastErrorResult' => 'xsd:string',
        'connectionErrorResult' => 'xsd:string',
        'closeConnectionResult' => 'xsd:string',
    ];
    foreach ($expectedReturnTypes as $resultName => $expectedType) {
        qbwc_assert(qbwc_wsdl_result_type($wsdl, $resultName) === $expectedType, 'Unexpected WSDL result type for ' . $resultName . '.');
    }
    $expectedParameters = [
        'serverVersion' => [],
        'clientVersion' => [['strVersion', 'xsd:string']],
        'authenticate' => [['strUserName', 'xsd:string'], ['strPassword', 'xsd:string']],
        'sendRequestXML' => [
            ['ticket', 'xsd:string'], ['strHCPResponse', 'xsd:string'], ['strCompanyFileName', 'xsd:string'],
            ['qbXMLCountry', 'xsd:string'], ['qbXMLMajorVers', 'xsd:int'], ['qbXMLMinorVers', 'xsd:int'],
        ],
        'receiveResponseXML' => [['ticket', 'xsd:string'], ['response', 'xsd:string'], ['hresult', 'xsd:int'], ['message', 'xsd:string']],
        'getLastError' => [['ticket', 'xsd:string']],
        'connectionError' => [['ticket', 'xsd:string'], ['hresult', 'xsd:string'], ['message', 'xsd:string']],
        'closeConnection' => [['ticket', 'xsd:string']],
    ];
    foreach ($expectedParameters as $operation => $parameters) {
        qbwc_assert(qbwc_wsdl_parameters($wsdl, $operation) === $parameters, 'WSDL parameter names, types, or order are incorrect for ' . $operation . '.');
        qbwc_assert(str_contains($wsdl->saveXML(), 'soapAction="http://developer.intuit.com/' . $operation . '"'), 'WSDL SOAP action is missing for ' . $operation . '.');
    }

    qbwc_assert($service->authenticate('wrong-user', 'wrong-password') === ['nvu', ''], 'Invalid credentials must return the QBWC nvu sentinel.');
    qbwc_assert((int)$pdo->query('SELECT COUNT(*) FROM qbwc_sessions')->fetchColumn() === 0, 'Invalid credentials must not create a session.');
    putenv('WQ_QBWC_USERNAME');
    putenv('WQ_QBWC_PASSWORD');
    qbwc_assert($service->authenticate('qbwc-test-user', 'qbwc-test-password') === ['nvu', ''], 'Missing service credentials must return nvu.');
    qbwc_assert((int)$pdo->query('SELECT COUNT(*) FROM qbwc_sessions')->fetchColumn() === 0, 'Missing service credentials must not create a session.');
    putenv('WQ_QBWC_USERNAME=qbwc-test-user');
    putenv('WQ_QBWC_PASSWORD=qbwc-test-password');
    qbwc_assert($service->authenticate('qbwc-test-user', 'qbwc-test-password') === ['none', ''], 'Valid credentials with no pending work must return the QBWC none sentinel.');
    qbwc_assert((int)$pdo->query('SELECT COUNT(*) FROM qbwc_sessions')->fetchColumn() === 0, 'No-work authentication must not create a session.');

    $customerJobId = $service->enqueueCustomerQuery(['Acme, Inc.']);
    $itemJobId = $service->enqueueItemQuery(['Widget 100']);
    qbwc_assert($customerJobId > 0 && $itemJobId > $customerJobId, 'Server-generated query jobs were not enqueued.');
    foreach (['InvoiceAddRq', 'InvoiceModRq', 'SalesOrderAddRq', 'SalesOrderModRq', 'CustomerAddRq', 'CustomerModRq', 'CustomerDelRq', 'ItemAddRq', 'ItemModRq', 'ItemDelRq'] as $operation) {
        $unapproved = '<QBXML><QBXMLMsgsRq onError="stopOnError"><' . $operation . '/></QBXMLMsgsRq></QBXML>';
        qbwc_assert(QuickBooksQueryBuilder::validateAndRebuildReadOnlyRequest($unapproved) === null, $operation . ' must be rejected.');
    }
    $otherRejected = [
        '<notQBXML/>',
        '<QBXML><QBXMLMsgsRq><CustomerQueryRq/></QBXMLMsgsRq></QBXML>',
        '<QBXML><QBXMLMsgsRq onError="stopOnError"><CustomerQueryRq requestID="1"/><ItemQueryRq requestID="2"/></QBXMLMsgsRq></QBXML>',
        '<QBXML><QBXMLMsgsRq onError="stopOnError"><CustomerQueryRq></QBXMLMsgsRq></QBXML>',
        '<!DOCTYPE QBXML [<!ENTITY xxe SYSTEM "file:///not-read">]><QBXML>&xxe;</QBXML>',
        '<QBXML><QBXMLMsgsRq onError="stopOnError"><CustomerQueryRq requestID="1"/><InvoiceAddRq/></QBXMLMsgsRq></QBXML>',
        '<QBXML><CustomerQueryRq/></QBXML>',
        '<QBXML><QBXMLMsgsRq onError="stopOnError"><CustomerQueryRq requestID="1"><Unexpected/></CustomerQueryRq></QBXMLMsgsRq></QBXML>',
    ];
    foreach ($otherRejected as $unapproved) {
        qbwc_assert(QuickBooksQueryBuilder::validateAndRebuildReadOnlyRequest($unapproved) === null, 'Malformed, mixed, or structurally unexpected QBXML must be rejected.');
    }

    $ticketResult = $service->authenticate('qbwc-test-user', 'qbwc-test-password');
    qbwc_assert($ticketResult[0] !== '' && $ticketResult[0] !== 'none' && $ticketResult[1] === '', 'Valid credentials with pending work must create a session and select the current company file.');
    $ticket = $ticketResult[0];
    $sessionIdStmt = $pdo->prepare('SELECT id FROM qbwc_sessions WHERE ticket = ?');
    $sessionIdStmt->execute([$ticket]);
    $sessionId = (int)$sessionIdStmt->fetchColumn();
    qbwc_assert((int)$pdo->query('SELECT COUNT(*) FROM qbwc_readonly_jobs WHERE session_id = ' . $sessionId)->fetchColumn() === 2, 'Authentication must bind eligible jobs to this session.');

    $invalidSessionRejected = false;
    try {
        $service->sendRequestXML('not-a-session', '', '', 'US', 13, 0);
    } catch (RuntimeException $exception) {
        $invalidSessionRejected = str_contains($exception->getMessage(), 'Invalid or expired');
    }
    qbwc_assert($invalidSessionRejected, 'Invalid session tickets must not retrieve jobs.');
    $expiredSessionTicket = bin2hex(random_bytes(24));
    $expiredSession = $pdo->prepare('INSERT INTO qbwc_sessions (ticket, username, status, authenticated_at, expires_at, created_at) VALUES (?, ?, ?, datetime("now","-1 day"), datetime("now","-1 minute"), datetime("now"))');
    $expiredSession->execute([$expiredSessionTicket, 'qbwc-test-user', 'active']);
    $expiredSessionRejected = false;
    try {
        $service->sendRequestXML($expiredSessionTicket, '', '', 'US', 13, 0);
    } catch (RuntimeException $exception) {
        $expiredSessionRejected = str_contains($exception->getMessage(), 'Invalid or expired');
    }
    qbwc_assert($expiredSessionRejected, 'Expired session tickets must not retrieve jobs.');

    $callerWriteXml = '<QBXML><QBXMLMsgsRq onError="stopOnError"><InvoiceAddRq/></QBXMLMsgsRq></QBXML>';
    $customerXml = $service->sendRequestXML($ticket, $callerWriteXml, '', 'US', 13, 0);
    $customerJob = qbwc_job($pdo, $customerJobId);
    qbwc_assert($customerXml === $customerJob['request_xml'] && !str_contains($customerXml, 'InvoiceAddRq'), 'sendRequestXML must return the server-generated queued query, never caller XML.');
    qbwc_assert($service->sendRequestXML($ticket, '<notQBXML/>', '', 'US', 13, 0) === $customerXml, 'Repeated sendRequestXML callbacks must return the same in-flight request.');
    qbwc_assert((int)qbwc_job($pdo, $customerJobId)['attempts'] === 1, 'A repeated in-flight callback must not consume another retry.');

    $customerRequest = QuickBooksQueryBuilder::validateAndRebuildReadOnlyRequest($customerXml);
    qbwc_assert($customerRequest !== null && $customerRequest['requestId'] === $customerJob['request_id'], 'Dispatched customer request ID must match its queued job.');
    $customerResponse = qbwc_response_xml('CustomerQuery', $customerRequest['requestId'], '0', '<CustomerRet><ListID>80000001</ListID><FullName>Acme, Inc.</FullName><Name>Acme, Inc.</Name></CustomerRet>');
    qbwc_assert($service->receiveResponseXML($ticket, $customerResponse, 0, '') === 50, 'One of two successful query responses must report partial progress.');
    qbwc_assert(qbwc_job($pdo, $customerJobId)['status'] === 'completed', 'Valid customer response must complete the matching job.');
    qbwc_assert($service->receiveResponseXML($ticket, $customerResponse, 0, '') === 50, 'Repeated response callbacks must be idempotent.');

    $itemXml = $service->sendRequestXML($ticket, '', '', 'US', 13, 0);
    $itemJob = qbwc_job($pdo, $itemJobId);
    qbwc_assert($itemXml === $itemJob['request_xml'] && str_contains($itemXml, '<ItemQueryRq'), 'Only the server-generated queued ItemQuery may be returned next.');
    $itemRequest = QuickBooksQueryBuilder::validateAndRebuildReadOnlyRequest($itemXml);
    $itemResponse = qbwc_response_xml('ItemQuery', $itemRequest['requestId'], '0', '<ItemInventoryRet><ListID>80000002</ListID><Name>Widget 100</Name><FullName>Widget 100</FullName><IsActive>true</IsActive></ItemInventoryRet>');
    qbwc_assert($service->receiveResponseXML($ticket, $itemResponse, 0, '') === 100, 'All successful query responses must report 100 percent progress.');
    qbwc_assert(qbwc_job($pdo, $itemJobId)['status'] === 'completed', 'Valid item response must complete its matching job.');
    qbwc_assert(qbwc_job($pdo, $itemJobId)['response_hash'] !== null, 'Response idempotency must persist only a response hash.');
    qbwc_assert($service->sendRequestXML($ticket, $callerWriteXml, '', 'US', 13, 0) === '', 'A session with no remaining work must not return a request.');
    qbwc_assert($pdo->query('PRAGMA table_info(qbwc_readonly_jobs)')->fetchAll() !== [], 'Read-only job storage must be present.');

    $errorJobId = $service->enqueueCustomerQuery(['Error Test']);
    $errorTicket = $service->authenticate('qbwc-test-user', 'qbwc-test-password')[0];
    $errorRequest = $service->sendRequestXML($errorTicket, '', '', 'US', 13, 0);
    $errorRequestMeta = QuickBooksQueryBuilder::validateAndRebuildReadOnlyRequest($errorRequest);
    $qbErrorResponse = qbwc_response_xml('CustomerQuery', $errorRequestMeta['requestId'], '3100');
    qbwc_assert($service->receiveResponseXML($errorTicket, $qbErrorResponse, 0, '') === 0, 'QuickBooks error responses must not report success.');
    $errorJob = qbwc_job($pdo, $errorJobId);
    qbwc_assert($errorJob['status'] === 'failed' && $errorJob['response_code'] === '3100', 'QuickBooks errors must be classified and persisted.');
    qbwc_assert(!str_contains($errorJob['diagnostic'], 'Error Test') && !str_contains($errorJob['diagnostic'], 'mock error detail'), 'Stored error diagnostics must not contain sensitive response details.');
    qbwc_assert(!str_contains($errorJob['diagnostic'], 'qbwc-test-password') && !str_contains($service->getLastError($errorTicket), 'qbwc-test-password'), 'Authentication credentials must never appear in diagnostics.');
    $service->closeConnection($errorTicket);

    $hresultJobId = $service->enqueueItemQuery(['HRESULT Test']);
    $hresultTicket = $service->authenticate('qbwc-test-user', 'qbwc-test-password')[0];
    $service->sendRequestXML($hresultTicket, '', '', 'US', 13, 0);
    qbwc_assert($service->receiveResponseXML($hresultTicket, '<untrusted-response/>', 1, 'ignored sensitive response message') === 0, 'Transport errors must not report successful progress.');
    qbwc_assert(qbwc_job($pdo, $hresultJobId)['status'] === 'failed', 'Transport errors must explicitly fail the queued request.');
    qbwc_assert(!str_contains($service->getLastError($hresultTicket), 'sensitive response message'), 'Vendor response messages must not be persisted verbatim.');
    $service->closeConnection($hresultTicket);

    $retryJobId = $service->enqueueItemQuery(['Retry Test']);
    $retryTicket = $service->authenticate('qbwc-test-user', 'qbwc-test-password')[0];
    $retryXml1 = $service->sendRequestXML($retryTicket, '', '', 'US', 13, 0);
    $retryMeta = QuickBooksQueryBuilder::validateAndRebuildReadOnlyRequest($retryXml1);
    qbwc_assert($service->receiveResponseXML($retryTicket, '<bad-xml', 0, '') === 0, 'Malformed responses must return zero progress.');
    qbwc_assert(qbwc_job($pdo, $retryJobId)['status'] === 'retry', 'Malformed responses must remain retryable.');
    $retryXml2 = $service->sendRequestXML($retryTicket, '', '', 'US', 13, 0);
    qbwc_assert($retryXml2 === $retryXml1 && (int)qbwc_job($pdo, $retryJobId)['attempts'] === 2, 'Retry must preserve the server-generated request and increment its attempt count.');
    $wrongTypeResponse = qbwc_response_xml('CustomerQuery', $retryMeta['requestId'], '0');
    qbwc_assert($service->receiveResponseXML($retryTicket, $wrongTypeResponse, 0, '') === 0, 'Mismatched response types must not complete a job.');
    $retryXml3 = $service->sendRequestXML($retryTicket, '', '', 'US', 13, 0);
    qbwc_assert($retryXml3 === $retryXml1 && (int)qbwc_job($pdo, $retryJobId)['attempts'] === 3, 'Second malformed response must permit the configured final retry.');
    qbwc_assert($service->receiveResponseXML($retryTicket, '<QBXML><QBXMLMsgsRs><ItemQueryRs requestID="wrong" statusCode="0" statusSeverity="Info" statusMessage=""/></QBXMLMsgsRs></QBXML>', 0, '') === 0, 'Unrelated request IDs must not complete a job.');
    qbwc_assert(qbwc_job($pdo, $retryJobId)['status'] === 'failed', 'Retry limit must fail rather than complete malformed responses.');
    $service->closeConnection($retryTicket);

    $cleanupJobId = $service->enqueueCustomerQuery(['Cleanup Test']);
    $cleanupTicket = $service->authenticate('qbwc-test-user', 'qbwc-test-password')[0];
    $cleanupXml = $service->sendRequestXML($cleanupTicket, '', '', 'US', 13, 0);
    $service->closeConnection($cleanupTicket);
    qbwc_assert(qbwc_job($pdo, $cleanupJobId)['status'] === 'queued' && qbwc_job($pdo, $cleanupJobId)['session_id'] === null, 'Closing an incomplete session must return eligible work to the queue.');
    $cleanupTicket2 = $service->authenticate('qbwc-test-user', 'qbwc-test-password')[0];
    qbwc_assert($service->sendRequestXML($cleanupTicket2, '', '', 'US', 13, 0) === $cleanupXml, 'A released job must remain available for retry in a new authenticated session.');
    $service->connectionError($cleanupTicket2, '0', 'ignored message');
    qbwc_assert(qbwc_job($pdo, $cleanupJobId)['status'] === 'queued', 'Connection errors must release retryable work.');
    $cleanupTicket3 = $service->authenticate('qbwc-test-user', 'qbwc-test-password')[0];
    $cleanupRetryXml = $service->sendRequestXML($cleanupTicket3, '', '', 'US', 13, 0);
    $cleanupRetryMeta = QuickBooksQueryBuilder::validateAndRebuildReadOnlyRequest($cleanupRetryXml);
    $cleanupResponse = qbwc_response_xml('CustomerQuery', $cleanupRetryMeta['requestId']);
    qbwc_assert($service->receiveResponseXML($cleanupTicket3, $cleanupResponse, 0, '') === 100, 'A released job must complete successfully after retry.');
    $service->closeConnection($cleanupTicket3);

    $expiredJobId = $service->enqueueItemQuery(['Expired Session']);
    $expiredWorkTicket = $service->authenticate('qbwc-test-user', 'qbwc-test-password')[0];
    $service->sendRequestXML($expiredWorkTicket, '', '', 'US', 13, 0);
    $expireWork = $pdo->prepare('UPDATE qbwc_sessions SET expires_at = datetime("now","-1 minute") WHERE ticket = ?');
    $expireWork->execute([$expiredWorkTicket]);
    $replacementTicket = $service->authenticate('qbwc-test-user', 'qbwc-test-password')[0];
    qbwc_assert($replacementTicket !== '' && qbwc_job($pdo, $expiredJobId)['session_id'] !== null, 'Expired-session cleanup must return eligible in-flight work to a new session.');

    $parseCustomer = QuickBooksQueryBuilder::parseReadOnlyQueryResponse($customerResponse, 'CustomerQuery', $customerRequest['requestId']);
    qbwc_assert($parseCustomer['status'] === 'success' && count($parseCustomer['records']) === 1, 'Customer response parser must return valid records.');
    $parseItem = QuickBooksQueryBuilder::parseReadOnlyQueryResponse($itemResponse, 'ItemQuery', $itemRequest['requestId']);
    qbwc_assert($parseItem['status'] === 'success' && count($parseItem['records']) === 1, 'Item response parser must return valid records.');
    qbwc_assert(QuickBooksQueryBuilder::parseReadOnlyQueryResponse($qbErrorResponse, 'CustomerQuery', $errorRequestMeta['requestId'])['status'] === 'quickbooks_error', 'QuickBooks response errors must be classified.');
    qbwc_assert(QuickBooksQueryBuilder::parseReadOnlyQueryResponse($itemResponse, 'CustomerQuery', $itemRequest['requestId'])['status'] === 'malformed', 'Mismatched query response types must be classified as malformed.');
    qbwc_assert(QuickBooksQueryBuilder::parseReadOnlyQueryResponse('<QBXML><QBXMLMsgsRs>', 'ItemQuery', $itemRequest['requestId'])['status'] === 'malformed', 'Malformed XML must be classified as malformed.');
    $dtdResponse = '<!DOCTYPE QBXML [<!ENTITY xxe SYSTEM "file:///not-read">]><QBXML>&xxe;</QBXML>';
    qbwc_assert(QuickBooksQueryBuilder::parseReadOnlyQueryResponse($dtdResponse, 'ItemQuery', $itemRequest['requestId'])['status'] === 'malformed', 'DTD/entity response payloads must be rejected.');

    $soap = qbwc_soap_server($service);
    qbwc_assert(qbwc_soap_result(qbwc_soap_call($soap, 'serverVersion', []), 'serverVersion')->textContent === '1.0.0', 'serverVersion SOAP contract failed.');
    qbwc_assert(qbwc_soap_result(qbwc_soap_call($soap, 'clientVersion', ['strVersion' => '1.0.0']), 'clientVersion')->textContent === '', 'clientVersion SOAP contract failed.');

    $noneResponse = qbwc_soap_call($soap, 'authenticate', ['strUserName' => 'qbwc-test-user', 'strPassword' => 'qbwc-test-password']);
    $noneValues = qbwc_soap_result($noneResponse, 'authenticate')->getElementsByTagNameNS(QuickBooksWebConnectorService::QBWC_NAMESPACE, 'string');
    qbwc_assert($noneValues->length === 2 && $noneValues->item(0)->textContent === 'none' && $noneValues->item(1)->textContent === '', 'SOAP no-work authentication sentinel failed.');
    $invalidResponse = qbwc_soap_call($soap, 'authenticate', ['strUserName' => 'wrong-user', 'strPassword' => 'wrong-password']);
    $invalidValues = qbwc_soap_result($invalidResponse, 'authenticate')->getElementsByTagNameNS(QuickBooksWebConnectorService::QBWC_NAMESPACE, 'string');
    qbwc_assert($invalidValues->length === 2 && $invalidValues->item(0)->textContent === 'nvu' && $invalidValues->item(1)->textContent === '', 'SOAP invalid-user sentinel failed.');

    $soapJobId = $service->enqueueCustomerQuery(['SOAP Test']);
    $soapAuth = qbwc_soap_call($soap, 'authenticate', ['strUserName' => 'qbwc-test-user', 'strPassword' => 'qbwc-test-password']);
    $soapAuthValues = qbwc_soap_result($soapAuth, 'authenticate')->getElementsByTagNameNS(QuickBooksWebConnectorService::QBWC_NAMESPACE, 'string');
    qbwc_assert($soapAuthValues->length === 2 && $soapAuthValues->item(0)->textContent !== '' && $soapAuthValues->item(1)->textContent === '', 'SOAP valid authentication result array failed.');
    $soapTicket = $soapAuthValues->item(0)->textContent;
    $soapSend = qbwc_soap_call($soap, 'sendRequestXML', [
        'ticket' => $soapTicket,
        'strHCPResponse' => $callerWriteXml,
        'strCompanyFileName' => '',
        'qbXMLCountry' => 'US',
        'qbXMLMajorVers' => '13',
        'qbXMLMinorVers' => '0',
    ]);
    $soapQuery = qbwc_soap_result($soapSend, 'sendRequestXML')->textContent;
    $soapMeta = QuickBooksQueryBuilder::validateAndRebuildReadOnlyRequest($soapQuery);
    $soapResponseXml = qbwc_response_xml('CustomerQuery', $soapMeta['requestId']);
    $soapReceive = qbwc_soap_call($soap, 'receiveResponseXML', [
        'ticket' => $soapTicket,
        'response' => $soapResponseXml,
        'hresult' => '0',
        'message' => '',
    ]);
    $soapProgress = qbwc_soap_result($soapReceive, 'receiveResponseXML');
    qbwc_assert($soapProgress->textContent === '100' && ctype_digit($soapProgress->textContent), 'SOAP receiveResponseXML progress result must be an integer percentage.');
    qbwc_assert(qbwc_job($pdo, $soapJobId)['status'] === 'completed', 'SOAP response must complete only a validated query response.');
    qbwc_assert(qbwc_soap_result(qbwc_soap_call($soap, 'getLastError', ['ticket' => $soapTicket]), 'getLastError')->textContent === '', 'getLastError SOAP contract failed.');
    $soapClose = qbwc_soap_call($soap, 'closeConnection', ['ticket' => $soapTicket]);
    qbwc_assert(qbwc_soap_result($soapClose, 'closeConnection')->textContent === 'OK', 'closeConnection SOAP contract failed.');

    $soapConnectionJobId = $service->enqueueItemQuery(['SOAP Connection Error']);
    $soapConnectionAuth = qbwc_soap_call($soap, 'authenticate', ['strUserName' => 'qbwc-test-user', 'strPassword' => 'qbwc-test-password']);
    $soapConnectionTicket = qbwc_soap_result($soapConnectionAuth, 'authenticate')->getElementsByTagNameNS(QuickBooksWebConnectorService::QBWC_NAMESPACE, 'string')->item(0)->textContent;
    $service->sendRequestXML($soapConnectionTicket, '', '', 'US', 13, 0);
    $soapConnectionError = qbwc_soap_call($soap, 'connectionError', [
        'ticket' => $soapConnectionTicket,
        'hresult' => '0',
        'message' => 'ignored message',
    ]);
    qbwc_assert(qbwc_soap_result($soapConnectionError, 'connectionError')->textContent === 'OK', 'connectionError SOAP contract failed.');
    qbwc_assert(qbwc_job($pdo, $soapConnectionJobId)['status'] === 'queued', 'SOAP connectionError must release retryable work.');

    echo "PASS QBWC-READONLY: authentication sentinels, server-generated queue, response parsing/retries, SOAP contract, and lifecycle\n";
} finally {
    if ($previousUser === false) {
        putenv('WQ_QBWC_USERNAME');
    } else {
        putenv('WQ_QBWC_USERNAME=' . $previousUser);
    }
    if ($previousPassword === false) {
        putenv('WQ_QBWC_PASSWORD');
    } else {
        putenv('WQ_QBWC_PASSWORD=' . $previousPassword);
    }
}
