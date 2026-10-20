<?php
declare(strict_types=1);

/**
 * Read-only preflight for locally saved invoice and Sales Order drafts.
 * This does not create jobs, call QuickBooks, or mark a transaction posted.
 */
function quickbooks_transaction_readiness(PDO $pdo, string $transactionType, int $transactionId): array
{
    if (!in_array($transactionType, ['invoice', 'sales_order'], true) || $transactionId < 1) {
        throw new InvalidArgumentException('A valid local transaction is required.');
    }

    if ($transactionType === 'invoice') {
        $headerSql = 'SELECT i.id,i.customer_id,c.active AS customer_active,c.qb_list_id AS customer_qb_list_id,NULL AS stored_customer_qb_list_id FROM invoices i LEFT JOIN clients c ON c.id=i.customer_id WHERE i.id=?';
        $lineSql = 'SELECT ii.product_id,ii.quantity,ii.price_each AS rate,p.active AS product_active,p.qb_code,p.qb_description,p.qb_list_id,(SELECT COUNT(*) FROM products pc WHERE pc.qb_code IS NOT NULL AND TRIM(pc.qb_code)=TRIM(p.qb_code)) AS qb_code_count,(SELECT COUNT(*) FROM products pl WHERE pl.qb_list_id IS NOT NULL AND TRIM(pl.qb_list_id)=TRIM(p.qb_list_id)) AS qb_list_id_count FROM invoice_items ii LEFT JOIN products p ON p.id=ii.product_id WHERE ii.invoice_id=? ORDER BY ii.id';
    } else {
        $headerSql = 'SELECT so.id,so.customer_id,c.active AS customer_active,c.qb_list_id AS customer_qb_list_id,so.qb_customer_list_id AS stored_customer_qb_list_id FROM sales_orders so LEFT JOIN clients c ON c.id=so.customer_id WHERE so.id=?';
        $lineSql = 'SELECT soi.product_id,soi.ordered_quantity AS quantity,soi.rate,p.active AS product_active,p.qb_code,p.qb_description,p.qb_list_id,(SELECT COUNT(*) FROM products pc WHERE pc.qb_code IS NOT NULL AND TRIM(pc.qb_code)=TRIM(p.qb_code)) AS qb_code_count,(SELECT COUNT(*) FROM products pl WHERE pl.qb_list_id IS NOT NULL AND TRIM(pl.qb_list_id)=TRIM(p.qb_list_id)) AS qb_list_id_count FROM sales_order_items soi LEFT JOIN products p ON p.id=soi.product_id WHERE soi.sales_order_id=? ORDER BY soi.line_no';
    }

    $headerQuery = $pdo->prepare($headerSql);
    $headerQuery->execute([$transactionId]);
    $header = $headerQuery->fetch();
    if (!$header) return ['ready' => false, 'blockers' => ['Local transaction was not found.'], 'line_count' => 0];

    $blockers = [];
    $customerListId = trim((string)($header['customer_qb_list_id'] ?? ''));
    if ((int)($header['customer_active'] ?? 0) !== 1) $blockers[] = 'Customer is missing or inactive in the local client master.';
    if ($customerListId === '') $blockers[] = 'Customer has no QuickBooks ListID in the client master.';
    if ($transactionType === 'sales_order' && trim((string)($header['stored_customer_qb_list_id'] ?? '')) !== $customerListId) {
        $blockers[] = 'Saved Sales Order customer mapping differs from the current client master; review the draft before any future posting.';
    }
    if ($customerListId !== '') {
        $duplicateCustomer = $pdo->prepare('SELECT COUNT(*) FROM clients WHERE qb_list_id=?');
        $duplicateCustomer->execute([$customerListId]);
        if ((int)$duplicateCustomer->fetchColumn() !== 1) $blockers[] = 'Customer QuickBooks ListID is missing or ambiguous in the local client master.';
    }

    $lineQuery = $pdo->prepare($lineSql);
    $lineQuery->execute([$transactionId]);
    $lines = $lineQuery->fetchAll();
    if (!$lines) $blockers[] = 'Transaction has no saved lines.';
    foreach ($lines as $index => $line) {
        $lineNo = $index + 1;
        if (!$line['product_id'] || $line['product_active'] === null) $blockers[] = "Line {$lineNo}: product master record is missing.";
        elseif ((int)$line['product_active'] !== 1) $blockers[] = "Line {$lineNo}: product is inactive in the local product master.";
        $qbCode = trim((string)($line['qb_code'] ?? ''));
        $qbDescription = trim((string)($line['qb_description'] ?? ''));
        $qbListId = trim((string)($line['qb_list_id'] ?? ''));
        if ($qbCode === '') $blockers[] = "Line {$lineNo}: QuickBooks item code is missing.";
        elseif ((int)$line['qb_code_count'] !== 1) $blockers[] = "Line {$lineNo}: QuickBooks item code is ambiguous.";
        if ($qbDescription === '') $blockers[] = "Line {$lineNo}: QuickBooks description is missing from Product Master.";
        if ($qbListId === '') $blockers[] = "Line {$lineNo}: QuickBooks item ListID is missing from Product Master.";
        elseif ((int)$line['qb_list_id_count'] !== 1) $blockers[] = "Line {$lineNo}: QuickBooks item ListID is ambiguous.";
        if (!is_numeric($line['quantity']) || (float)$line['quantity'] <= 0) $blockers[] = "Line {$lineNo}: quantity must be positive.";
        if ($line['rate'] === null || !is_numeric($line['rate']) || (float)$line['rate'] < 0) $blockers[] = "Line {$lineNo}: rate is missing or invalid.";
    }

    // No installed connector/company file has been verified in this environment.
    $blockers[] = 'QuickBooks edition, connector, company file, and current mapping identifiers have not been verified; posting is unavailable.';
    return ['ready' => false, 'blockers' => array_values(array_unique($blockers)), 'line_count' => count($lines)];
}
