<?php
declare(strict_types=1);

/**
 * Read-only local preflight for saved invoice and Sales Order drafts.
 * Name-based references are supported by QuickBooks Desktop, so stored local
 * ListIDs are not a local readiness requirement. This does not perform a live
 * name lookup, create jobs, call QuickBooks, or mark a transaction posted.
 */
function quickbooks_transaction_readiness(PDO $pdo, string $transactionType, int $transactionId): array
{
    if (!in_array($transactionType, ['invoice', 'sales_order'], true) || $transactionId < 1) {
        throw new InvalidArgumentException('A valid local transaction is required.');
    }

    if ($transactionType === 'invoice') {
        $headerSql = 'SELECT i.id,i.customer_id,c.client_name,c.active AS customer_active FROM invoices i LEFT JOIN clients c ON c.id=i.customer_id WHERE i.id=?';
        $lineSql = 'SELECT ii.product_id,ii.quantity,ii.price_each AS rate,p.active AS product_active,p.qb_code,p.qb_description,(SELECT COUNT(*) FROM products pc WHERE pc.qb_code IS NOT NULL AND TRIM(pc.qb_code)=TRIM(p.qb_code)) AS qb_code_count FROM invoice_items ii LEFT JOIN products p ON p.id=ii.product_id WHERE ii.invoice_id=? ORDER BY ii.id';
    } else {
        $headerSql = 'SELECT so.id,so.customer_id,c.client_name,c.active AS customer_active FROM sales_orders so LEFT JOIN clients c ON c.id=so.customer_id WHERE so.id=?';
        $lineSql = 'SELECT soi.product_id,soi.ordered_quantity AS quantity,soi.rate,p.active AS product_active,p.qb_code,p.qb_description,(SELECT COUNT(*) FROM products pc WHERE pc.qb_code IS NOT NULL AND TRIM(pc.qb_code)=TRIM(p.qb_code)) AS qb_code_count FROM sales_order_items soi LEFT JOIN products p ON p.id=soi.product_id WHERE soi.sales_order_id=? ORDER BY soi.line_no';
    }

    $headerQuery = $pdo->prepare($headerSql);
    $headerQuery->execute([$transactionId]);
    $header = $headerQuery->fetch();
    if (!$header) return [
        'ready' => false,
        'local_ready' => false,
        'posting_ready' => false,
        'local_blockers' => ['Local transaction was not found.'],
        'integration_blockers' => [],
        'blockers' => ['Local transaction was not found.'],
        'line_count' => 0,
    ];

    $localBlockers = [];
    $integrationBlockers = [];
    $customerName = trim((string)($header['client_name'] ?? ''));
    if ((int)($header['customer_active'] ?? 0) !== 1) $localBlockers[] = 'Customer is missing or inactive in the local client master.';
    if ($customerName === '') $localBlockers[] = 'Customer name is empty in the local client master.';
    else $integrationBlockers[] = 'Customer name has not been resolved against the configured QuickBooks company file.';

    $lineQuery = $pdo->prepare($lineSql);
    $lineQuery->execute([$transactionId]);
    $lines = $lineQuery->fetchAll();
    if (!$lines) $localBlockers[] = 'Transaction has no saved lines.';
    foreach ($lines as $index => $line) {
        $lineNo = $index + 1;
        if (!$line['product_id'] || $line['product_active'] === null) $localBlockers[] = "Line {$lineNo}: product master record is missing.";
        elseif ((int)$line['product_active'] !== 1) $localBlockers[] = "Line {$lineNo}: product is inactive in the local product master.";
        $qbCode = trim((string)($line['qb_code'] ?? ''));
        $qbDescription = trim((string)($line['qb_description'] ?? ''));
        if ($qbCode === '') $localBlockers[] = "Line {$lineNo}: QuickBooks item code is missing.";
        elseif ((int)$line['qb_code_count'] !== 1) $localBlockers[] = "Line {$lineNo}: QuickBooks item code is ambiguous in the local product master.";
        if ($qbDescription === '') $localBlockers[] = "Line {$lineNo}: QuickBooks description is missing from Product Master.";
        if ($qbCode !== '') $integrationBlockers[] = "Line {$lineNo}: QB Code has not been resolved to an authoritative QuickBooks item FullName.";
        if (!is_numeric($line['quantity']) || (float)$line['quantity'] <= 0) $localBlockers[] = "Line {$lineNo}: quantity must be positive.";
        if ($line['rate'] === null || !is_numeric($line['rate']) || (float)$line['rate'] < 0) $localBlockers[] = "Line {$lineNo}: rate is missing or invalid.";
    }

    // A live name lookup and connector/company verification are intentionally
    // not simulated by comparing local labels or stored ListID snapshots.
    $integrationBlockers[] = 'QuickBooks edition, Web Connector, company file, and live name-resolution service are not verified; posting is unavailable.';
    $localBlockers = array_values(array_unique($localBlockers));
    $integrationBlockers = array_values(array_unique($integrationBlockers));
    return [
        'ready' => false,
        'local_ready' => $localBlockers === [],
        'posting_ready' => false,
        'local_blockers' => $localBlockers,
        'integration_blockers' => $integrationBlockers,
        'blockers' => array_values(array_unique(array_merge($localBlockers, $integrationBlockers))),
        'line_count' => count($lines),
    ];
}
