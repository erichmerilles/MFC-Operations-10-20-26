<?php

declare(strict_types=1);
if (session_status() === PHP_SESSION_NONE) {
    $cookieParams = session_get_cookie_params();
    $isHttps = !empty($_SERVER['HTTPS']) && strtolower((string)$_SERVER['HTTPS']) !== 'off';
    $isHttps = $isHttps || (int)($_SERVER['SERVER_PORT'] ?? 0) === 443;
    ini_set('session.use_strict_mode', '1');
    session_set_cookie_params([
        'lifetime' => $cookieParams['lifetime'],
        'path' => $cookieParams['path'],
        'domain' => $cookieParams['domain'],
        'secure' => $isHttps,
        'httponly' => true,
        'samesite' => 'Lax',
    ]);
    session_start();
}
define('APP_NAME', 'Withdrawal & QuickBooks Invoicing System');
define('APP_BASE_URL', rtrim(getenv('WQ_BASE_URL') ?: '/MFC-Operations', '/'));
define('APP_VERSION', 'Phase 2 · MySQL Backend');
date_default_timezone_set('Asia/Manila');
require_once __DIR__ . '/../core/database.php';
require_once __DIR__ . '/../core/functions.php';
require_once __DIR__ . '/../core/auth.php';
