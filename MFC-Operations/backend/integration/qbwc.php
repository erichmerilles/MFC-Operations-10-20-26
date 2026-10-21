<?php

declare(strict_types=1);

require_once __DIR__ . '/../config/app.php';
require_once __DIR__ . '/qbwc_service.php';

$wsdlPath = __DIR__ . '/qbwc.wsdl';

if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'GET') {
    if (isset($_GET['wsdl'])) {
        header('Content-Type: text/xml; charset=UTF-8');
        readfile($wsdlPath);
        exit;
    }

    http_response_code(200);
    echo 'QBWC read-only endpoint is available at this URL. This phase does not post transactions to QuickBooks.';
    exit;
}

if (!class_exists('SoapServer')) {
    http_response_code(503);
    echo 'PHP SOAP support is required for the QBWC endpoint.';
    exit;
}

$server = new SoapServer($wsdlPath, [
    'cache_wsdl' => WSDL_CACHE_NONE,
    'encoding' => 'UTF-8',
]);
$service = new QuickBooksWebConnectorService(db());
$server->setObject(new QuickBooksSoapServiceAdapter($service));
header('Content-Type: text/xml; charset=UTF-8');
$server->handle();
