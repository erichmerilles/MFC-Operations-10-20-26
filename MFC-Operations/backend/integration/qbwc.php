<?php

declare(strict_types=1);

function qbwcEndpointLogFailure(Throwable $exception): void
{
    $class = (new ReflectionClass($exception))->getShortName();
    error_log('[QBWC] Unexpected failure (' . $class . ').');
}

$initialBufferLevel = ob_get_level();
ob_start();
set_error_handler(static function (int $severity, string $message, string $file, int $line): bool {
    if ((error_reporting() & $severity) === 0) {
        return false;
    }
    qbwcEndpointLogFailure(new ErrorException('', 0, $severity));
    throw new ErrorException('QBWC internal processing error.', 0, $severity);
});
ini_set('display_errors', '0');

try {
    require_once __DIR__ . '/../config/app.php';
    require_once __DIR__ . '/qbwc_service.php';

    $wsdlPath = __DIR__ . '/qbwc.wsdl';

    if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'GET') {
        if (isset($_GET['wsdl'])) {
            header('Content-Type: text/xml; charset=UTF-8');
            readfile($wsdlPath);
            echo (string)ob_get_clean();
            exit;
        }

        http_response_code(200);
        echo 'QBWC read-only endpoint is available at this URL. This phase does not post transactions to QuickBooks.';
        echo (string)ob_get_clean();
        exit;
    }

    if (!class_exists('SoapServer')) {
        http_response_code(503);
        header('Content-Type: text/plain; charset=UTF-8');
        echo 'PHP SOAP support is required for the QBWC endpoint.';
        echo (string)ob_get_clean();
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
    echo (string)ob_get_clean();
} catch (Throwable $exception) {
    qbwcEndpointLogFailure($exception);
    while (ob_get_level() > $initialBufferLevel) {
        ob_end_clean();
    }

    http_response_code(500);
    if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'GET') {
        header('Content-Type: text/plain; charset=UTF-8');
        echo 'The QBWC endpoint could not process this request.';
    } else {
        header('Content-Type: text/xml; charset=UTF-8');
        echo '<?xml version="1.0" encoding="UTF-8"?>'
            . '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'
            . '<SOAP-ENV:Body><SOAP-ENV:Fault><faultcode>SOAP-ENV:Server</faultcode>'
            . '<faultstring>The request could not be processed.</faultstring></SOAP-ENV:Fault></SOAP-ENV:Body>'
            . '</SOAP-ENV:Envelope>';
    }
}
