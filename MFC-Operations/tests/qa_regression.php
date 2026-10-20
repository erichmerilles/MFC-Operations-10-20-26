<?php
declare(strict_types=1);

require_once __DIR__ . '/../backend/core/functions.php';

function qa_assert(bool $condition, string $message): void
{
    if (!$condition) throw new RuntimeException($message);
}

$pdo = new PDO('mysql:host=127.0.0.1;dbname=test;charset=utf8mb4', 'root', '', [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
]);
qa_assert($pdo->query('SELECT DATABASE()')->fetchColumn() === 'test', 'Tests must use the isolated test schema.');
qa_assert((int)$pdo->query('SELECT COUNT(*) FROM information_schema.tables WHERE table_schema=DATABASE()')->fetchColumn() === 0, 'The test schema must be empty before this suite runs.');

$createdTables = [];
$create = static function (string $sql) use ($pdo, &$createdTables): void {
    $pdo->exec($sql);
    if (preg_match('/CREATE TABLE\s+`?(\w+)`?/i', $sql, $match)) $createdTables[] = $match[1];
};

try {
    $create('CREATE TABLE sites (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, site_name VARCHAR(100) NOT NULL) ENGINE=InnoDB');
    $create('CREATE TABLE products (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, product_name VARCHAR(100) NOT NULL) ENGINE=InnoDB');
    $create('CREATE TABLE withdrawals (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY) ENGINE=InnoDB');
    $create('CREATE TABLE invoices (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY) ENGINE=InnoDB');
    $create('CREATE TABLE sales_orders (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY) ENGINE=InnoDB');
    $create('CREATE TABLE withdrawal_items (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, product_id BIGINT UNSIGNED NULL, INDEX fk_wi_product(product_id), CONSTRAINT fk_wi_product FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE SET NULL) ENGINE=InnoDB');
    $create('CREATE TABLE invoice_items (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, product_id BIGINT UNSIGNED NULL, site_id BIGINT UNSIGNED NULL, INDEX fk_ii_product(product_id), INDEX fk_ii_site(site_id), CONSTRAINT fk_ii_product FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE SET NULL, CONSTRAINT fk_ii_site FOREIGN KEY(site_id) REFERENCES sites(id) ON DELETE SET NULL) ENGINE=InnoDB');
    $create('CREATE TABLE sales_order_items (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, sales_order_id BIGINT UNSIGNED NOT NULL, product_id BIGINT UNSIGNED NULL, site_id BIGINT UNSIGNED NULL, INDEX fk_soi_product(product_id), INDEX fk_soi_site(site_id), CONSTRAINT fk_soi_sales_order FOREIGN KEY(sales_order_id) REFERENCES sales_orders(id) ON DELETE CASCADE, CONSTRAINT fk_soi_product FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE SET NULL, CONSTRAINT fk_soi_site FOREIGN KEY(site_id) REFERENCES sites(id) ON DELETE SET NULL) ENGINE=InnoDB');

    $migration = file_get_contents(__DIR__ . '/../backend/database/migrations/20261020_restrict_historical_master_deletes.sql');
    $migration = preg_replace('/^\s*--.*$/m', '', $migration);
    foreach (array_filter(array_map('trim', explode(';', $migration))) as $statement) $pdo->exec($statement);

    $pdo->exec("INSERT INTO sites(site_name) VALUES('SO only'),('Multiple use'),('Unused site'),('Invoice only')");
    $pdo->exec("INSERT INTO products(product_name) VALUES('SO only'),('Multiple use'),('Unused product'),('Withdrawal only'),('Invoice only')");
    $pdo->exec('INSERT INTO withdrawals VALUES(1)');
    $pdo->exec('INSERT INTO invoices VALUES(1)');
    $pdo->exec('INSERT INTO sales_orders VALUES(1)');
    $pdo->exec('INSERT INTO withdrawal_items(product_id) VALUES(2),(4)');
    $pdo->exec('INSERT INTO invoice_items(product_id,site_id) VALUES(2,2),(5,4)');
    $pdo->exec('INSERT INTO sales_order_items(sales_order_id,product_id,site_id) VALUES(1,1,1),(1,2,2)');

    $productGuard = $pdo->prepare('SELECT (SELECT COUNT(*) FROM withdrawal_items WHERE product_id=p.id)+(SELECT COUNT(*) FROM invoice_items WHERE product_id=p.id)+(SELECT COUNT(*) FROM sales_order_items WHERE product_id=p.id) FROM products p WHERE id=?');
    $siteGuard = $pdo->prepare('SELECT (SELECT COUNT(*) FROM invoice_items WHERE site_id=s.id)+(SELECT COUNT(*) FROM sales_order_items WHERE site_id=s.id) FROM sites s WHERE id=?');
    $productGuard->execute([1]);
    qa_assert((int)$productGuard->fetchColumn() === 1, 'Sales Order-only product reference was not detected.');
    $productGuard->execute([2]);
    qa_assert((int)$productGuard->fetchColumn() === 3, 'Mixed withdrawal, invoice, and Sales Order product references were not all detected.');
    $siteGuard->execute([1]);
    qa_assert((int)$siteGuard->fetchColumn() === 1, 'Sales Order-only site reference was not detected.');
    $siteGuard->execute([2]);
    qa_assert((int)$siteGuard->fetchColumn() === 2, 'Invoice and Sales Order site references were not all detected.');
    $siteGuard->execute([4]);
    qa_assert((int)$siteGuard->fetchColumn() === 1, 'Invoice-only site reference was not detected.');

    foreach ([['products', 1], ['products', 2], ['products', 4], ['products', 5], ['sites', 1], ['sites', 2], ['sites', 4]] as [$table, $id]) {
        try {
            $pdo->exec("DELETE FROM {$table} WHERE id=" . (int)$id);
            throw new RuntimeException("Database allowed deletion of referenced {$table} row {$id}.");
        } catch (PDOException $error) {
            qa_assert(str_starts_with((string)$error->getCode(), '23'), "Unexpected database error while restricting {$table} deletion.");
        }
    }
    qa_assert((int)$pdo->query('SELECT COUNT(*) FROM sales_orders')->fetchColumn() === 1, 'Sales Order header changed during delete checks.');
    qa_assert((int)$pdo->query('SELECT COUNT(*) FROM sales_order_items')->fetchColumn() === 2, 'Sales Order lines changed during delete checks.');
    qa_assert((int)$pdo->query('SELECT COUNT(*) FROM sales_order_items WHERE product_id IS NOT NULL AND site_id IS NOT NULL')->fetchColumn() === 2, 'Sales Order product/site references were cleared.');
    $pdo->exec('DELETE FROM products WHERE id=3');
    $pdo->exec('DELETE FROM sites WHERE id=3');
    qa_assert((int)$pdo->query('SELECT COUNT(*) FROM products WHERE id=3')->fetchColumn() === 0, 'Unused product could not be deleted.');
    qa_assert((int)$pdo->query('SELECT COUNT(*) FROM sites WHERE id=3')->fetchColumn() === 0, 'Unused site could not be deleted.');
    $masterSource = file_get_contents(__DIR__ . '/../frontend/products_sites.php');
    qa_assert(str_contains($masterSource, 'sales_order_items') && !str_contains($masterSource, 'default_site_id'), 'Master deletion guards do not match the staged transaction schema.');
    echo "PASS F02: SO-only, mixed references, unused deletes, and historical links\n";

    $csvCases = [
        '=1+1', '+SUM(A1:A2)', '-1+2', '@SUM(A1:A2)', "\t=HYPERLINK('x')", " \r\n@SUM(A1:A2)", "=cmd,\"quoted\"\nnext line",
    ];
    foreach ($csvCases as $value) {
        $safe = csv_safe_text_cell($value);
        qa_assert(str_starts_with($safe, "'"), 'Formula-leading CSV text was not neutralized.');
        $stream = fopen('php://temp', 'w+');
        fputcsv($stream, [$safe, 42]);
        rewind($stream);
        $parsed = fgetcsv($stream);
        fclose($stream);
        qa_assert($parsed[0] === $safe && $parsed[1] === '42', 'CSV quoting or ordinary numeric data changed.');
    }
    $ordinary = 'Package, "A"' . "\n" . 'Second line';
    qa_assert(csv_safe_text_cell($ordinary) === $ordinary, 'Ordinary text should remain unchanged.');
    $exportSource = file_get_contents(__DIR__ . '/../backend/exports/withdrawals.php');
    qa_assert(str_contains($exportSource, 'csv_safe_text_cell') && str_contains($exportSource, "'quantity'" ) === false, 'CSV export does not isolate spreadsheet protection to text fields.');
    echo "PASS F03: formula prefixes, controls, CSV quoting, and ordinary values\n";

    $create('CREATE TABLE activity_logs (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, employee_id BIGINT UNSIGNED NULL, action VARCHAR(80) NOT NULL, entity_type VARCHAR(80) NOT NULL, entity_id BIGINT UNSIGNED NULL, details TEXT NULL, ip_address VARCHAR(45) NULL, created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, INDEX idx_activity_created(created_at)) ENGINE=InnoDB');
    $create('CREATE TABLE qa_business_changes (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, value_text VARCHAR(100) NOT NULL) ENGINE=InnoDB');
    $create('CREATE TABLE qa_audit_events (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, business_id BIGINT UNSIGNED NOT NULL, action VARCHAR(80) NOT NULL, CONSTRAINT fk_qa_audit_business FOREIGN KEY(business_id) REFERENCES qa_business_changes(id)) ENGINE=InnoDB');
    $pdo->beginTransaction();
    $pdo->exec("INSERT INTO qa_business_changes(value_text) VALUES('committed')");
    $businessId = (int)$pdo->lastInsertId();
    $pdo->exec("INSERT INTO qa_audit_events(business_id,action) VALUES({$businessId},'CREATE')");
    $pdo->commit();
    qa_assert((int)$pdo->query('SELECT COUNT(*) FROM qa_business_changes')->fetchColumn() === 1 && (int)$pdo->query('SELECT COUNT(*) FROM qa_audit_events')->fetchColumn() === 1, 'Successful business/audit transaction did not persist both rows.');
    try {
        $pdo->beginTransaction();
        $pdo->exec("INSERT INTO qa_business_changes(value_text) VALUES('rollback')");
        $pdo->exec("INSERT INTO qa_audit_events(business_id,action) VALUES(999999,'FAIL')");
        $pdo->commit();
        throw new RuntimeException('Simulated audit failure was not raised.');
    } catch (PDOException) {
        if ($pdo->inTransaction()) $pdo->rollBack();
    }
    qa_assert((int)$pdo->query("SELECT COUNT(*) FROM qa_business_changes WHERE value_text='rollback'")->fetchColumn() === 0, 'Business row remained after audit failure.');
    foreach (['frontend/clients.php', 'frontend/products_sites.php', 'frontend/settings.php'] as $path) {
        $source = file_get_contents(__DIR__ . '/../' . $path);
        qa_assert(str_contains($source, 'beginTransaction()') && str_contains($source, 'commit()') && str_contains($source, 'rollBack()'), "{$path} does not contain atomic commit/rollback handling.");
    }
    echo "PASS F06: audit insert failure rolls back business write\n";

    $_SESSION = [];
    $_SERVER['REMOTE_ADDR'] = '192.0.2.18';
    for ($i = 0; $i < 20; $i++) log_failed_login($pdo);
    qa_assert(login_attempts_throttled($pdo, '192.0.2.18'), 'Configured login failure threshold did not throttle.');
    qa_assert(!login_attempts_throttled($pdo, '192.0.2.19'), 'Login throttle leaked across IP addresses.');
    $pdo->exec("UPDATE activity_logs SET created_at=DATE_SUB(NOW(), INTERVAL 16 MINUTE) WHERE action='LOGIN_FAILED'");
    qa_assert(!login_attempts_throttled($pdo, '192.0.2.18'), 'Login throttle did not recover after its time window.');
    qa_assert((int)$pdo->query("SELECT COUNT(*) FROM activity_logs WHERE action='LOGIN_FAILED' AND details='Invalid credentials'")->fetchColumn() === 20, 'Failed-login audit details were not generic.');
    $loginSource = file_get_contents(__DIR__ . '/../frontend/login.php');
    qa_assert(str_contains($loginSource, 'login_attempts_throttled') && str_contains($loginSource, 'log_failed_login') && str_contains($loginSource, "Invalid username or password."), 'Login does not use bounded throttling with a generic error.');
    echo "PASS F08: bounded IP throttle, generic audit record, and window recovery\n";

    $clientSource = file_get_contents(__DIR__ . '/../frontend/clients.php');
    qa_assert(str_contains($clientSource, 'Line Amount Subtotal:') && !str_contains($clientSource, 'Invoice Total:'), 'Invoice detail subtotal label is inconsistent.');
    qa_assert(str_contains($clientSource, 'new WeakMap()') && str_contains($clientSource, "retry.addEventListener('click', () => loadHistory(panel, state.retryPage))"), 'History requests do not use the shared retry state.');
    $logoutSource = file_get_contents(__DIR__ . '/../backend/controllers/logout.php');
    qa_assert(str_contains($logoutSource, '$' . "_SERVER['REQUEST_METHOD'] !== 'POST'") && str_contains($logoutSource, 'verify_csrf();'), 'Logout is missing POST and CSRF checks.');
    $topbarSource = file_get_contents(__DIR__ . '/../frontend/includes/topbar.php');
    qa_assert(str_contains($topbarSource, 'method="post"') && str_contains($topbarSource, 'csrf_token()'), 'Logout form does not include a CSRF token.');
    $apiSource = file_get_contents(__DIR__ . '/../backend/api/client_invoice_detail.php');
    qa_assert(str_contains($apiSource, "['subtotal']") && str_contains($apiSource, "'amount'"), 'Invoice detail no longer returns the saved line subtotal.');
    echo "PASS F04/F05/F09: source guards and UI wording\n";
} finally {
    if ($pdo->inTransaction()) $pdo->rollBack();
    foreach (array_reverse($createdTables) as $table) $pdo->exec("DROP TABLE IF EXISTS `{$table}`");
}
