<?php

declare(strict_types=1);

// Use only as PHP's auto_prepend_file for the local E2E server.
if (PHP_SAPI === 'cli-server') {
    require_once __DIR__ . '/../backend/config/app.php';
    if (db()->query('SELECT DATABASE()')->fetchColumn() !== 'test') {
        http_response_code(503);
        header('Content-Type: text/plain; charset=utf-8');
        exit('E2E server refused the request because it is not connected to the isolated test schema.');
    }
}
