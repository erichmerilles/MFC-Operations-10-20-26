<?php require_once __DIR__ . '/../config/app.php';
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Allow: POST');
    http_response_code(405);
    exit('Method not allowed.');
}
verify_csrf();
if (!empty($_SESSION['user'])) {
    try {
        log_activity(db(), 'LOGOUT', 'employee', (int)$_SESSION['user']['id'], 'User signed out');
    } catch (Throwable $e) {
    }
}
logout_user();
header('Location: ' . APP_BASE_URL . '/frontend/login.php');
exit;
