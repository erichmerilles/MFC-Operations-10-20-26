<?php require_once __DIR__ . '/../config/app.php';
require_login();
$s = db()->query('SELECT w.withdrawal_no,w.saved_on,w.time_received,w.pick_up_time,c.client_name,w.form_date,wi.line_no,wi.ht_code,wi.ht_description,wi.product_name,wi.quantity,wi.remarks,w.po_no,w.status FROM withdrawals w JOIN clients c ON c.id=w.client_id LEFT JOIN withdrawal_items wi ON wi.withdrawal_id=w.id ORDER BY w.id DESC,wi.line_no');
header('Content-Type: text/csv; charset=utf-8');
header('Content-Disposition: attachment; filename="withdrawals-' . date('Ymd-His') . '.csv"');
$out = fopen('php://output', 'w');
fputcsv($out, ['Withdrawal No', 'Saved On', 'Time Received', 'Pick Up Time', 'Client Name', 'Form Date', 'Line No', 'HT Code', 'HT Description', 'Product', 'Quantity', 'Remarks', 'PO No', 'Status']);
while ($r = $s->fetch()) {
    foreach (['withdrawal_no', 'saved_on', 'time_received', 'pick_up_time', 'client_name', 'form_date', 'ht_code', 'ht_description', 'product_name', 'remarks', 'po_no', 'status'] as $column) {
        if ($r[$column] !== null) $r[$column] = csv_safe_text_cell((string)$r[$column]);
    }
    fputcsv($out, $r);
}
fclose($out);
exit;
