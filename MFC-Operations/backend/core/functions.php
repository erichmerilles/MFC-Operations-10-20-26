<?php

declare(strict_types=1);
function e(mixed $value): string
{
    return htmlspecialchars((string)$value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}
function current_page(): string
{
    return basename($_SERVER['PHP_SELF'] ?? 'dashboard.php');
}
function nav_active(string $page): string
{
    return current_page() === $page ? 'active' : '';
}
function status_class(string $status): string
{
    $s = strtolower($status);
    if (str_contains($s, 'invoiced') || str_contains($s, 'completed')) return 'status-success';
    if (str_contains($s, 'error') || str_contains($s, 'uncertain')) return 'status-danger';
    if (str_contains($s, 'processing') || str_contains($s, 'queued')) return 'status-info';
    if (str_contains($s, 'ready')) return 'status-teal';
    return 'status-muted';
}
function csrf_token(): string
{
    if (empty($_SESSION['_csrf'])) $_SESSION['_csrf'] = bin2hex(random_bytes(32));
    return $_SESSION['_csrf'];
}
function verify_csrf(): void
{
    $sessionToken = (string)($_SESSION['_csrf'] ?? '');
    $submittedToken = (string)($_POST['_csrf'] ?? '');
    if ($sessionToken === '' || $submittedToken === '' || !hash_equals($sessionToken, $submittedToken)) {
        http_response_code(403);
        exit('Your session token expired. Refresh the page and try again.');
    }
}
function flash(string $type, string $message): void
{
    $_SESSION['_flash'] = ['type' => $type, 'message' => $message];
}
function take_flash(): ?array
{
    $f = $_SESSION['_flash'] ?? null;
    unset($_SESSION['_flash']);
    return $f;
}
function log_activity(PDO $pdo, string $action, string $entity, ?int $entityId, string $details = ''): void
{
    $stmt = $pdo->prepare('INSERT INTO activity_logs(employee_id,action,entity_type,entity_id,details,ip_address,created_at) VALUES(?,?,?,?,?,?,NOW())');
    $stmt->execute([$_SESSION['user']['id'] ?? null, $action, $entity, $entityId, $details, substr($_SERVER['REMOTE_ADDR'] ?? '', 0, 45)]);
}
function login_attempts_throttled(PDO $pdo, string $ipAddress, int $limit = 20, int $windowMinutes = 15): bool
{
    if ($limit < 1 || $windowMinutes < 1) throw new InvalidArgumentException('Login throttle settings must be positive.');
    $stmt = $pdo->prepare("SELECT COUNT(*) FROM activity_logs WHERE action='LOGIN_FAILED' AND entity_type='authentication' AND ip_address=? AND created_at >= DATE_SUB(NOW(), INTERVAL {$windowMinutes} MINUTE)");
    $stmt->execute([substr($ipAddress, 0, 45)]);
    return (int)$stmt->fetchColumn() >= $limit;
}
function log_failed_login(PDO $pdo): void
{
    log_activity($pdo, 'LOGIN_FAILED', 'authentication', null, 'Invalid credentials');
}
function csv_safe_text_cell(string $value): string
{
    return preg_match('/^[\s\p{Z}\p{Cf}\x00-\x1F\x7F-\x9F]*[=+\-@]/u', $value) === 1 ? "'" . $value : $value;
}
function next_withdrawal_no(PDO $pdo): string
{
    $prefix = date('Y-');
    $stmt = $pdo->prepare('SELECT withdrawal_no FROM withdrawals WHERE withdrawal_no LIKE ?');
    $stmt->execute([$prefix . '%']);
    $highest = 101000;
    while (($number = $stmt->fetchColumn()) !== false) {
        if (preg_match('/^\d{4}-(\d+)$/D', (string)$number, $matches)) {
            $sequence = (int)$matches[1];
            if ($sequence > $highest) $highest = $sequence;
        }
    }
    $seq = $highest + 1;
    return $prefix . str_pad((string)$seq, 6, '0', STR_PAD_LEFT);
}
function get_sites(PDO $pdo): array
{
    return $pdo->query('SELECT id,site_name,active FROM sites WHERE active=1 ORDER BY site_name')->fetchAll();
}
function get_products(PDO $pdo): array
{
    return $pdo->query('SELECT id,product_name,ht_code,qb_code,ht_description,qb_description,item_code,description,u_m,default_price,kg_per_box,qb_list_id,active FROM products WHERE active=1 ORDER BY product_name')->fetchAll();
}

function withdrawal_product_label(string $name, ?string $description): string
{
    $name = trim($name);
    $label = $name;
    $description = trim((string)$description);
    if ($description !== '' && strcasecmp($name, $description) !== 0) $label .= ' - ' . $description;
    return $label;
}
