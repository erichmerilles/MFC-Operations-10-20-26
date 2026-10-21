<?php

declare(strict_types=1);

/**
 * Isolated HTTP regression test. It only runs against an empty MariaDB schema
 * named `test`, creates synthetic fixtures, and drops only tables it creates.
 */
$root = dirname(__DIR__);
$host = getenv('WQ_DB_HOST') ?: '127.0.0.1';
$user = getenv('WQ_DB_USER') ?: 'root';
$pass = getenv('WQ_DB_PASS') ?: '';
$pdo = new PDO("mysql:host={$host};dbname=test;charset=utf8mb4", $user, $pass, [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
]);
$assert = static function (bool $condition, string $message): void {
    if (!$condition) throw new RuntimeException($message);
};
$assert($pdo->query('SELECT DATABASE()')->fetchColumn() === 'test', 'Refusing to run outside the `test` schema.');
$assert((int)$pdo->query("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='test'")->fetchColumn() === 0, 'Refusing to run because the `test` schema is not empty.');
$base = rtrim(getenv('MFC_E2E_BASE_URL') ?: '', '/');
$assert($base !== '' && in_array((string)parse_url($base, PHP_URL_HOST), ['127.0.0.1', 'localhost'], true), 'Set MFC_E2E_BASE_URL to the explicitly loopback PHP test server URL.');

$created = [];
$cookieFile = tempnam(sys_get_temp_dir(), 'mfc-e2e-cookie-');
$checks = 0;
$passCase = static function (string $id, string $message) use (&$checks): void {
    $checks++;
    echo "PASS {$id}: {$message}\n";
};

try {
    $schema = file_get_contents($root . '/backend/database/schema.sql');
    if ($schema === false) throw new RuntimeException('Could not read the initial schema.');
    $schema = preg_replace('/^\s*--.*$/m', '', $schema);
    foreach (array_filter(array_map('trim', explode(';', $schema))) as $sql) {
        if (preg_match('/^(CREATE\s+DATABASE|USE\s|INSERT\s+IGNORE)/i', $sql)) continue;
        $pdo->exec($sql);
        if (preg_match('/^CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?`?(\w+)`?/i', $sql, $match)) $created[] = $match[1];
    }
    $soMigration = file_get_contents($root . '/backend/database/migrations/20261019_sales_order_preparation.sql');
    if ($soMigration === false) throw new RuntimeException('Could not read Sales Order migration.');
    $soMigration = preg_replace('/^\s*--.*$/m', '', $soMigration);
    foreach (array_filter(array_map('trim', explode(';', $soMigration))) as $sql) {
        $pdo->exec($sql);
        if (preg_match('/^CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?`?(\w+)`?/i', $sql, $match)) $created[] = $match[1];
    }
    $assert(count($created) >= 12, 'Expected application tables were not initialized.');

    $employee = $pdo->prepare("INSERT INTO employees(full_name,username,password_hash,role,active) VALUES(?,?,?,'Admin',1)");
    $employee->execute(['E2E Test User', 'mfc-e2e-' . bin2hex(random_bytes(3)), password_hash('Synthetic-Test-Password-2026', PASSWORD_DEFAULT)]);
    $employeeId = (int)$pdo->lastInsertId();
    $pdo->exec("INSERT INTO clients(client_name,active) VALUES('E2E Synthetic Customer',1)");
    $clientId = (int)$pdo->lastInsertId();
    $pdo->exec("INSERT INTO sites(site_name,active) VALUES('E2E Synthetic Site',1)");
    $siteId = (int)$pdo->lastInsertId();
    $product = $pdo->prepare('INSERT INTO products(product_name,ht_code,qb_code,ht_description,qb_description,item_code,description,u_m,default_price,qb_list_id,active) VALUES(?,?,?,?,?,?,?,?,?,NULL,1)');
    $product->execute(['E2E Chicken', 'HT-E2E-01', 'QB-ALPHA-01', 'Chicken withdrawal label', 'Chicken QB description', 'Legacy-A', 'Legacy desc A', 'BOX', 25]);
    $productA = (int)$pdo->lastInsertId();
    $product->execute(['E2E Beef', 'HT-E2E-02', 'QB-BETA-02', 'Beef withdrawal label', 'Beef QB description', 'Legacy-B', 'Legacy desc B', 'CASE', 40.5]);
    $productB = (int)$pdo->lastInsertId();
    $passCase('E2E-SETUP', 'Empty test schema initialized from project DDL with a synthetic customer and two QB-coded products, all with local ListIDs left NULL.');

    $request = static function (string $path, ?array $body = null, ?string $cookieOverride = null) use ($base, $cookieFile): array {
        $ch = curl_init($base . $path);
        $options = [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_HEADER => true,
            CURLOPT_FOLLOWLOCATION => false,
            CURLOPT_CONNECTTIMEOUT => 2,
            CURLOPT_TIMEOUT => 15,
        ];
        if ($cookieOverride === null) {
            $options[CURLOPT_COOKIEJAR] = $cookieFile;
            $options[CURLOPT_COOKIEFILE] = $cookieFile;
        } else {
            $options[CURLOPT_COOKIE] = $cookieOverride;
        }
        curl_setopt_array($ch, $options);
        if ($body !== null) {
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($body));
        }
        $raw = curl_exec($ch);
        if ($raw === false) {
            $message = curl_error($ch);
            curl_close($ch);
            throw new RuntimeException('HTTP request to ' . $path . ' failed: ' . $message);
        }
        $size = (int)curl_getinfo($ch, CURLINFO_HEADER_SIZE);
        $status = (int)curl_getinfo($ch, CURLINFO_RESPONSE_CODE);
        curl_close($ch);
        return ['status' => $status, 'headers' => substr($raw, 0, $size), 'body' => substr($raw, $size)];
    };
    $csrf = static function (string $html) use ($assert): string {
        $assert((bool)preg_match('/name="_csrf"\s+value="([^"]+)"/', $html, $m), 'CSRF token missing from form.');
        return html_entity_decode($m[1], ENT_QUOTES | ENT_HTML5, 'UTF-8');
    };
    $unauth = $request('/frontend/dashboard.php');
    $assert($unauth['status'] === 302 && str_contains($unauth['headers'], '/frontend/login.php'), 'Protected dashboard was accessible without authentication.');
    $passCase('AUTH-HTTP-01', 'Unauthenticated dashboard request redirects to sign in.');

    $login = $request('/frontend/login.php');
    $token = $csrf($login['body']);
    $bad = $request('/frontend/login.php', ['_csrf' => $token, 'username' => 'missing-user', 'password' => 'wrong']);
    $assert($bad['status'] === 200 && str_contains($bad['body'], 'Invalid username or password.'), 'Invalid credentials did not return a generic error (HTTP ' . $bad['status'] . ', response: ' . substr(strip_tags($bad['body']), 0, 180) . ').');
    $goodToken = $csrf($bad['body']);
    $beforeCookie = preg_match('/PHPSESSID\s+([^\s]+)/', (string)file_get_contents($cookieFile), $cm) ? $cm[1] : '';
    $good = $request('/frontend/login.php', ['_csrf' => $goodToken, 'username' => $pdo->query('SELECT username FROM employees WHERE id=' . $employeeId)->fetchColumn(), 'password' => 'Synthetic-Test-Password-2026']);
    $assert($good['status'] === 302 && str_contains($good['headers'], '/frontend/dashboard.php'), 'Valid synthetic credentials did not log in.');
    $afterCookie = preg_match('/PHPSESSID\s+([^\s]+)/', (string)file_get_contents($cookieFile), $cm) ? $cm[1] : '';
    $assert($beforeCookie !== '' && $afterCookie !== '' && $beforeCookie !== $afterCookie, 'Session ID did not rotate after authentication.');
    $dashboard = $request('/frontend/dashboard.php');
    $assert($dashboard['status'] === 200, 'Authenticated dashboard did not load.');
    $passCase('AUTH-HTTP-02', 'Invalid login is generic; synthetic valid login succeeds and rotates the session ID.');
    $loginHeaders = strtolower($login['headers']);
    $goodHeaders = strtolower($good['headers']);
    $assert(str_contains($goodHeaders, 'httponly') && str_contains($goodHeaders, 'samesite=lax'), 'Authenticated session cookie lacks HttpOnly or SameSite=Lax: ' . str_replace("\r\n", ' | ', trim($good['headers'])));
    $passCase('AUTH-HTTP-03', 'HTTP session cookie exposes HttpOnly and SameSite=Lax; Secure is deployment-dependent on HTTP.');

    $form = $request('/frontend/withdrawal_form.php');
    $withdrawalToken = $csrf($form['body']);
    $withdrawalNo = '2030-900001';
    $withdrawalBody = [
        '_csrf' => $withdrawalToken,
        'withdrawal_id' => '',
        'withdrawal_no' => $withdrawalNo,
        'client_id' => (string)$clientId,
        'client_name' => 'E2E Synthetic Customer',
        'form_date' => '2030-01-15',
        'time_received' => '',
        'pick_up_time' => '',
        'po_no' => 'PO-E2E-01',
        'internal_note' => 'synthetic test note',
        'items' => [
            ['product_search' => 'E2E Chicken - Chicken withdrawal label', 'product_id' => (string)$productA, 'quantity' => '10', 'remarks' => "=cmd,\"quoted\"\nnext line"],
            ['product_search' => 'E2E Beef - Beef withdrawal label', 'product_id' => (string)$productB, 'quantity' => '2', 'remarks' => 'second line'],
        ],
    ];
    $savedWithdrawal = $request('/backend/controllers/withdrawal_save.php', $withdrawalBody);
    $assert($savedWithdrawal['status'] === 302, 'Valid withdrawal POST did not redirect after save.');
    $withdrawalId = (int)$pdo->query("SELECT id FROM withdrawals WHERE withdrawal_no='2030-900001'")->fetchColumn();
    $assert($withdrawalId > 0 && (int)$pdo->query("SELECT COUNT(*) FROM withdrawal_items WHERE withdrawal_id={$withdrawalId}")->fetchColumn() === 2, 'Withdrawal header or lines were not persisted.');
    $assert((int)$pdo->query("SELECT SUM(quantity) FROM withdrawal_items WHERE withdrawal_id={$withdrawalId}")->fetchColumn() === 12, 'Withdrawal quantities did not persist correctly.');
    $reopened = $request('/frontend/withdrawal_form.php?withdrawal_no=' . rawurlencode($withdrawalNo));
    $assert($reopened['status'] === 200 && str_contains($reopened['body'], 'E2E Chicken'), 'Saved withdrawal did not reopen with its product.');
    $passCase('WITHDRAWAL-HTTP-01', 'Created, persisted, and reopened a two-line withdrawal through the real page and save controller.');

    $csv = $request('/backend/exports/withdrawals.php');
    $csvStream = fopen('php://temp', 'w+');
    fwrite($csvStream, $csv['body']);
    rewind($csvStream);
    fgetcsv($csvStream);
    $csvFirstLine = fgetcsv($csvStream);
    fclose($csvStream);
    $assert($csv['status'] === 200 && str_contains(strtolower($csv['headers']), 'text/csv') && ($csvFirstLine[11] ?? null) === "'=cmd,\"quoted\"\nnext line", 'CSV export response, quoting, or formula neutralization failed.');
    $passCase('CSV-HTTP-01', 'Authenticated export returns CSV and neutralizes formula-leading remarks while preserving CSV quoting/newlines.');

    $invoicePage = $request('/frontend/invoice_preparation.php?withdrawal_no=' . rawurlencode($withdrawalNo));
    $assert($invoicePage['status'] === 200 && str_contains($invoicePage['body'], 'Invoice Preparation'), 'Invoice preparation page did not load.');
    $invoiceId = (int)$pdo->query("SELECT id FROM invoices WHERE withdrawal_id={$withdrawalId}")->fetchColumn();
    $assert($invoiceId > 0 && (int)$pdo->query("SELECT COUNT(*) FROM invoice_items WHERE invoice_id={$invoiceId}")->fetchColumn() === 2, 'Opening invoice preparation did not create a separate two-line draft.');
    $invoiceToken = $csrf($invoicePage['body']);
    $invoiceLineIds = [];
    foreach ([$productA, $productB] as $productId) {
        $invoiceLineIdQuery = $pdo->prepare('SELECT id FROM invoice_items WHERE invoice_id=? AND product_id=? ORDER BY id LIMIT 1');
        $invoiceLineIdQuery->execute([$invoiceId, $productId]);
        $invoiceLineIds[] = (string)$invoiceLineIdQuery->fetchColumn();
    }
    $invoicePayload = [
        '_csrf' => $invoiceToken,
        'invoice_id' => (string)$invoiceId,
        'withdrawal_no' => $withdrawalNo,
        'customer_id' => (string)$clientId,
        'invoice_number' => 'E2E-INV-0001',
        'invoice_date' => '2030-01-15',
        'po_no' => 'PO-E2E-01',
        'memo' => 'Synthetic invoice memo',
        'items' => [
            ['id' => $invoiceLineIds[0], 'source_type' => 'WITHDRAWAL', 'withdrawal_item_id' => '1', 'product_id' => (string)$productA, 'site_id' => (string)$siteId, 'quantity' => '10', 'lot_number' => '', 'item_code' => 'QB-ALPHA-01', 'description' => 'ignored source label', 'u_m' => 'BOX', 'price_each' => '25.00', 'expiration_date' => '', 'tax_code' => 'Non'],
            ['id' => $invoiceLineIds[1], 'source_type' => 'WITHDRAWAL', 'withdrawal_item_id' => '2', 'product_id' => (string)$productB, 'site_id' => (string)$siteId, 'quantity' => '2', 'lot_number' => '', 'item_code' => 'QB-BETA-02', 'description' => '', 'u_m' => 'CASE', 'price_each' => '40.50', 'expiration_date' => '', 'tax_code' => 'Non'],
        ],
    ];
    $invoiceSaved = $request('/backend/controllers/invoice_save.php', $invoicePayload);
    $assert($invoiceSaved['status'] === 302, 'Invoice draft POST did not redirect.');
    $invoiceRow = $pdo->query("SELECT invoice_number,memo FROM invoices WHERE id={$invoiceId}")->fetch();
    $invoiceLines = $pdo->query("SELECT item_code,description,quantity,price_each,amount FROM invoice_items WHERE invoice_id={$invoiceId} ORDER BY id")->fetchAll();
    $assert($invoiceRow['invoice_number'] === 'E2E-INV-0001' && $invoiceRow['memo'] === 'Synthetic invoice memo', 'Invoice header and memo were not persisted.');
    $assert(count($invoiceLines) === 2 && $invoiceLines[0]['item_code'] === 'QB-ALPHA-01' && $invoiceLines[0]['description'] === 'Chicken QB description' && (float)$invoiceLines[0]['amount'] === 250.0 && (float)$invoiceLines[1]['amount'] === 81.0, 'Invoice mappings, descriptions, or amounts were incorrect.');
    $invoiceReload = $request('/frontend/invoice_preparation.php?withdrawal_no=' . rawurlencode($withdrawalNo));
    $assert($invoiceReload['status'] === 200 && str_contains($invoiceReload['body'], 'Synthetic invoice memo'), 'Saved invoice memo did not reload.');
    $assert(str_contains($invoiceReload['body'], 'Readiness checks') && str_contains($invoiceReload['body'], 'posting is unavailable'), 'Invoice page does not distinguish local draft from QuickBooks readiness.');
    $invoiceMappingPage = $request('/frontend/invoice_preparation.php?withdrawal_no=' . rawurlencode($withdrawalNo));
    $assert(str_contains($invoiceMappingPage['body'], 'Customer name has not been resolved against the configured QuickBooks company file') && str_contains($invoiceMappingPage['body'], 'Local required fields pass') && !str_contains($invoiceMappingPage['body'], 'Customer has no QuickBooks ListID') && !str_contains($invoiceMappingPage['body'], 'QuickBooks mapping required'), 'Invoice readiness still requires a stored ListID or fails to distinguish local validation from live name resolution.');
    foreach ([$productA, $productB] as $index => $productId) {
        $invoiceLineIdQuery = $pdo->prepare('SELECT id FROM invoice_items WHERE invoice_id=? AND product_id=? ORDER BY id LIMIT 1');
        $invoiceLineIdQuery->execute([$invoiceId, $productId]);
        $invoiceLineIds[$index] = (string)$invoiceLineIdQuery->fetchColumn();
        $invoicePayload['items'][$index]['id'] = $invoiceLineIds[$index];
    }
    $sourceIds = [];
    foreach ([$productA, $productB] as $productId) {
        $sourceQuery = $pdo->prepare('SELECT id FROM withdrawal_items WHERE withdrawal_id=? AND product_id=?');
        $sourceQuery->execute([$withdrawalId, $productId]);
        $sourceIds[] = (string)$sourceQuery->fetchColumn();
    }
    foreach ([
        ['missing source ID', static function (array &$payload): void { $payload['items'][0]['withdrawal_item_id'] = ''; }],
        ['invalid source ID', static function (array &$payload): void { $payload['items'][0]['withdrawal_item_id'] = '99999999'; }],
        ['mismatched source product', static function (array &$payload) use ($productB): void { $payload['items'][0]['product_id'] = (string)$productB; $payload['items'][0]['item_code'] = 'QB-BETA-02'; }],
    ] as [$caseName, $mutate]) {
        $invalidInvoice = $invoicePayload;
        $mutate($invalidInvoice);
        $request('/backend/controllers/invoice_save.php', $invalidInvoice);
        $assert($pdo->query("SELECT invoice_number FROM invoices WHERE id={$invoiceId}")->fetchColumn() === 'E2E-INV-0001' && (int)$pdo->query("SELECT COUNT(*) FROM invoice_items WHERE invoice_id={$invoiceId}")->fetchColumn() === 2, "Invoice {$caseName} changed the saved draft.");
        $errorPage = $request('/frontend/invoice_preparation.php?withdrawal_no=' . rawurlencode($withdrawalNo));
        $expectedError = str_contains($caseName, 'missing') ? 'A withdrawal-sourced invoice line must reference a valid withdrawal item.' : (str_contains($caseName, 'invalid') ? 'A withdrawal-sourced invoice line must keep its saved source withdrawal item.' : 'A source invoice line no longer matches this withdrawal product.');
        $assert(str_contains($errorPage['body'], $expectedError), "Invoice {$caseName} did not return the expected validation error.");
    }
    $additionalInvoice = $invoicePayload;
    $additionalInvoice['items'][0]['withdrawal_item_id'] = $sourceIds[0];
    $additionalInvoice['items'][1]['withdrawal_item_id'] = $sourceIds[1];
    $additionalInvoice['items'][] = ['id' => '', 'source_type' => 'ADDITIONAL', 'withdrawal_item_id' => '', 'product_id' => (string)$productA, 'site_id' => (string)$siteId, 'quantity' => '1', 'lot_number' => '', 'item_code' => 'QB-ALPHA-01', 'description' => '', 'u_m' => 'BOX', 'price_each' => '25.00', 'expiration_date' => '', 'tax_code' => 'Non'];
    $request('/backend/controllers/invoice_save.php', $additionalInvoice);
    $additionalLine = $pdo->query("SELECT source_type,withdrawal_item_id FROM invoice_items WHERE invoice_id={$invoiceId} ORDER BY id DESC LIMIT 1")->fetch();
    $assert($additionalLine['source_type'] === 'ADDITIONAL' && $additionalLine['withdrawal_item_id'] === null, 'Valid additional invoice line did not save without a source withdrawal item.');
    $passCase('INVOICE-HTTP-01', 'Withdrawal lines require matching source rows; missing, invalid, and mismatched references are rejected, while an explicit additional line saves. Local draft readiness remains distinct from posting.');

    $pdo->prepare('UPDATE products SET qb_description=NULL WHERE id=?')->execute([$productB]);
    $soPage = $request('/frontend/sales_order_preparation.php?withdrawal_no=' . rawurlencode($withdrawalNo));
    $pdo->prepare('UPDATE products SET qb_description=? WHERE id=?')->execute(['Beef QB description', $productB]);
    $assert($soPage['status'] === 200 && str_contains($soPage['body'], 'S.O. NO.') && !str_contains($soPage['body'], 'Invoice No.') && str_contains($soPage['body'], 'data-confirm-submit') && str_contains($soPage['body'], 'Readiness checks'), 'Sales Order label, shared confirmation, or readiness display is missing.');
    $soId = (int)$pdo->query("SELECT id FROM sales_orders WHERE withdrawal_id={$withdrawalId}")->fetchColumn();
    $assert($soId > 0 && (int)$pdo->query("SELECT COUNT(*) FROM sales_order_items WHERE sales_order_id={$soId}")->fetchColumn() === 2, 'Sales Order preparation did not create a separate two-line local draft.');
    preg_match('/<thead[^>]*>(.*?)<\/thead>/si', $soPage['body'], $thead);
    preg_match_all('/<th[^>]*>(.*?)<\/th>/si', $thead[1] ?? '', $headers);
    $columns = array_map(static fn(string $html): string => preg_replace('/\s*\*$/', '', trim(html_entity_decode(strip_tags($html), ENT_QUOTES | ENT_HTML5, 'UTF-8'))), $headers[1] ?? []);
    $expectedColumns = ['ITEM', 'DESCRIPTION', 'SITE', 'ORDERED', 'LOT NUMBER', 'U/M', 'RATE', 'CLASS', 'AMOUNT', 'STATUS', 'FULFILLED QUANTITY', 'EXPIRATION DATE', 'TAX'];
    $assert($columns === $expectedColumns, 'Sales Order columns do not match the required exact order. Found: ' . implode(' | ', $columns));
    $soLineA = $pdo->query("SELECT item_code,qb_item_list_id,description FROM sales_order_items WHERE sales_order_id={$soId} AND product_id={$productA}")->fetch();
    $soLineB = $pdo->query("SELECT item_code,qb_item_list_id,description FROM sales_order_items WHERE sales_order_id={$soId} AND product_id={$productB}")->fetch();
    $assert($soLineA['item_code'] === 'QB-ALPHA-01' && $soLineB['item_code'] === 'QB-BETA-02' && $soLineA['description'] === 'Chicken QB description' && $soLineB['description'] === '', 'Sales Order failed to preserve mapped QB descriptions or keep a missing description blank.');
    $assert(!str_contains($soPage['body'], 'Chicken withdrawal label') && !str_contains($soPage['body'], 'Beef withdrawal label') && str_contains($soPage['body'], 'QuickBooks item ListID is missing') === false, 'Sales Order unexpectedly used the HT description fallback or required a stored ListID.');
    $soToken = $csrf($soPage['body']);
    $soPayload = [
        '_csrf' => $soToken,
        'sales_order_id' => (string)$soId,
        'withdrawal_no' => $withdrawalNo,
        'so_number' => 'E2E-SO-0001',
        'customer_id' => (string)$clientId,
        'sales_order_date' => '2030-01-15',
        'po_no' => 'PO-E2E-01',
        'memo' => 'Synthetic SO memo',
        'items' => [
            ['product_id' => (string)$productA, 'description' => 'Chicken QB description', 'site_id' => (string)$siteId, 'ordered_quantity' => '10', 'lot_number' => '', 'u_m' => '', 'rate' => '25.00', 'class_name' => '', 'line_status' => '', 'fulfilled_quantity' => '', 'expiration_date' => '', 'tax_code' => ''],
            ['product_id' => (string)$productB, 'description' => 'Beef QB description', 'site_id' => (string)$siteId, 'ordered_quantity' => '2', 'lot_number' => '', 'u_m' => '', 'rate' => '40.50', 'class_name' => '', 'line_status' => '', 'fulfilled_quantity' => '', 'expiration_date' => '', 'tax_code' => ''],
        ],
    ];
    $soSaved = $request('/backend/controllers/sales_order_save.php', $soPayload);
    $assert($soSaved['status'] === 302, 'Sales Order draft POST did not redirect.');
    $soHeader = $pdo->query("SELECT so_number,memo,qb_customer_list_id FROM sales_orders WHERE id={$soId}")->fetch();
    $soLines = $pdo->query("SELECT item_code,qb_item_list_id,description,ordered_quantity,rate,amount FROM sales_order_items WHERE sales_order_id={$soId} ORDER BY line_no")->fetchAll();
    $assert($soHeader['so_number'] === 'E2E-SO-0001' && $soHeader['memo'] === 'Synthetic SO memo' && $soHeader['qb_customer_list_id'] === null, 'Sales Order header fields were not persisted correctly without a stored customer ListID.');
    $assert(count($soLines) === 2 && (float)$soLines[0]['amount'] === 250.0 && (float)$soLines[1]['amount'] === 81.0 && $soLines[0]['qb_item_list_id'] === null && $soLines[1]['qb_item_list_id'] === null, 'Sales Order values/amounts did not persist independently of stored item ListIDs.');
    $soReload = $request('/frontend/sales_order_preparation.php?withdrawal_no=' . rawurlencode($withdrawalNo));
    $assert($soReload['status'] === 200 && str_contains($soReload['body'], 'E2E-SO-0001') && str_contains($soReload['body'], 'Synthetic SO memo'), 'Saved Sales Order draft did not reload.');
    $soMappingPage = $request('/frontend/sales_order_preparation.php?withdrawal_no=' . rawurlencode($withdrawalNo));
    $assert(str_contains($soMappingPage['body'], 'Line 2: QB Code has not been resolved to an authoritative QuickBooks item FullName') && str_contains($soMappingPage['body'], 'Local required fields pass') && !str_contains($soMappingPage['body'], 'QuickBooks item ListID is missing'), 'Sales Order readiness must identify the pending authoritative name lookup without requiring a stored ListID.');
    $passCase('SALES-ORDER-HTTP-01', 'Created, validated, saved, and reloaded a two-line local Sales Order without stored customer/item ListIDs; local posting readiness still requires live FullName resolution.');

    $badSo = $soPayload;
    $badSo['so_number'] = 'E2E-SO-INVALID';
    $badSo['items'][0]['site_id'] = '';
    $badSoResponse = $request('/backend/controllers/sales_order_save.php', $badSo);
    $assert($badSoResponse['status'] === 302, 'Invalid Sales Order submission did not return through the workflow.');
    $savedNumber = $pdo->query("SELECT so_number FROM sales_orders WHERE id={$soId}")->fetchColumn();
    $savedLineCount = (int)$pdo->query("SELECT COUNT(*) FROM sales_order_items WHERE sales_order_id={$soId}")->fetchColumn();
    $assert($savedNumber === 'E2E-SO-0001' && $savedLineCount === 2, 'Invalid missing-SITE submission changed saved Sales Order data.');
    $badNotice = $request('/frontend/sales_order_preparation.php?withdrawal_no=' . rawurlencode($withdrawalNo));
    $assert(str_contains($badNotice['body'], 'Line 1: SITE is required.'), 'Missing SITE did not show a line-specific validation message.');
    $passCase('SALES-ORDER-HTTP-02', 'Direct backend submission with missing SITE is rejected with a line-specific message and leaves prior data intact.');

    $pdo->prepare('UPDATE products SET qb_code=NULL WHERE id=?')->execute([$productB]);
    $badMapping = $soPayload;
    $badMapping['so_number'] = 'E2E-SO-NOMAP';
    $badMappingResponse = $request('/backend/controllers/sales_order_save.php', $badMapping);
    $pdo->prepare('UPDATE products SET qb_code=? WHERE id=?')->execute(['QB-BETA-02', $productB]);
    $mappingNotice = $request('/frontend/sales_order_preparation.php?withdrawal_no=' . rawurlencode($withdrawalNo));
    $assert($badMappingResponse['status'] === 302 && str_contains($mappingNotice['body'], 'Line 2: ITEM has no QB Code mapping') && $pdo->query("SELECT so_number FROM sales_orders WHERE id={$soId}")->fetchColumn() === 'E2E-SO-0001', 'Missing QB mapping was not rejected without changing the saved draft.');
    $passCase('SALES-ORDER-HTTP-03', 'A temporarily missing QB Code mapping blocks backend save with a line-specific error; the prior draft is preserved.');

    $badRate = $soPayload;
    $badRate['so_number'] = 'E2E-SO-BADRATE';
    $badRate['items'][0]['rate'] = '1,2';
    $badRateResponse = $request('/backend/controllers/sales_order_save.php', $badRate);
    $rateNotice = $request('/frontend/sales_order_preparation.php?withdrawal_no=' . rawurlencode($withdrawalNo));
    $assert($badRateResponse['status'] === 302 && str_contains($rateNotice['body'], 'Line 1: RATE must be a non-negative amount') && $pdo->query("SELECT so_number FROM sales_orders WHERE id={$soId}")->fetchColumn() === 'E2E-SO-0001', 'Invalid monetary grouping was not rejected without changing the saved draft.');
    $passCase('SALES-ORDER-HTTP-04', 'Malformed monetary grouping is rejected by the backend and does not change the saved draft.');

    $mapProduct = $pdo->query("SELECT product_name,ht_code,quantity FROM withdrawal_items WHERE withdrawal_id={$withdrawalId} ORDER BY line_no")->fetchAll();
    $assert($mapProduct[0]['product_name'] === 'E2E Chicken' && $mapProduct[0]['ht_code'] === 'HT-E2E-01' && (int)$mapProduct[0]['quantity'] === 10, 'Invoice/Sales Order preparation modified source withdrawal product data.');
    $assert((int)$pdo->query("SELECT COUNT(*) FROM invoices WHERE withdrawal_id={$withdrawalId}")->fetchColumn() === 1 && (int)$pdo->query("SELECT COUNT(*) FROM sales_orders WHERE withdrawal_id={$withdrawalId}")->fetchColumn() === 1, 'Invoice/Sales Order drafts were not kept separate.');
    $assert((int)$pdo->query("SELECT COUNT(*) FROM activity_logs WHERE entity_type IN ('withdrawal','invoice','sales_order') AND action IN ('CREATE','UPDATE','SAVE_DRAFT')")->fetchColumn() >= 3, 'Expected local workflow audit events are missing.');
    $passCase('INTEGRITY-HTTP-01', 'Original withdrawal remains intact; invoice and Sales Order are separate records with audit activity.');

    $logoutToken = $csrf($soReload['body']);
    $oldSessionId = preg_match('/PHPSESSID\s+([^\s]+)/', (string)file_get_contents($cookieFile), $cm) ? $cm[1] : '';
    $assert($oldSessionId !== '', 'Could not capture the authenticated session ID for logout reuse testing.');
    $csrfLogout = $request('/backend/controllers/logout.php', []);
    $assert($csrfLogout['status'] === 403, 'Logout without CSRF was not rejected.');
    $passCase('AUTH-HTTP-04A', 'Logout request without CSRF is rejected.');
    $logout = $request('/backend/controllers/logout.php', ['_csrf' => $logoutToken]);
    $assert($logout['status'] === 302, 'Valid POST+CSRF logout did not redirect.');
    $afterLogout = $request('/frontend/dashboard.php', null, 'PHPSESSID=' . $oldSessionId);
    $assert($afterLogout['status'] === 302, 'Authenticated session remained usable after logout.');
    $passCase('AUTH-HTTP-04', 'Logout requires CSRF, succeeds with a valid token, and invalidates access to protected pages.');

    echo "RESULT: {$checks} HTTP/database end-to-end cases passed. No QuickBooks transaction was attempted.\n";
} catch (Throwable $e) {
    fwrite(STDERR, 'FAIL: ' . $e->getMessage() . "\n");
    $GLOBALS['e2e_exit_code'] = 1;
} finally {
    if (is_file($cookieFile)) unlink($cookieFile);
    foreach (array_reverse(array_unique($created)) as $table) {
        $pdo->exec("DROP TABLE IF EXISTS `{$table}`");
    }
    $remaining = (int)$pdo->query("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='test'")->fetchColumn();
    if ($remaining !== 0) {
        fwrite(STDERR, "CLEANUP ERROR: {$remaining} table(s) remain in isolated test schema.\n");
        $GLOBALS['e2e_exit_code'] = 1;
    } else {
        echo "CLEANUP: isolated test schema returned to zero tables.\n";
    }
}
exit((int)($GLOBALS['e2e_exit_code'] ?? 0));
