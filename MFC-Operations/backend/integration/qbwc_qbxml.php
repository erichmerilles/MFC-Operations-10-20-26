<?php

declare(strict_types=1);

final class QuickBooksQueryBuilder
{
    public static function buildCustomerQuery(array $fullNames = [], ?string $requestId = null): string
    {
        $requestId ??= 'customer-query-' . bin2hex(random_bytes(6));
        $xml = [];
        $xml[] = '<?xml version="1.0" encoding="utf-8"?>';
        $xml[] = '<QBXML>';
        $xml[] = '<QBXMLMsgsRq onError="stopOnError">';
        $xml[] = '<CustomerQueryRq requestID="' . self::escapeXml($requestId) . '">';
        foreach ($fullNames as $fullName) {
            $xml[] = '<FullName>' . self::escapeXml(trim((string) $fullName)) . '</FullName>';
        }
        $xml[] = '</CustomerQueryRq>';
        $xml[] = '</QBXMLMsgsRq>';
        $xml[] = '</QBXML>';
        return implode('', $xml);
    }

    public static function buildItemQuery(array $fullNames = [], ?string $requestId = null): string
    {
        $requestId ??= 'item-query-' . bin2hex(random_bytes(6));
        $xml = [];
        $xml[] = '<?xml version="1.0" encoding="utf-8"?>';
        $xml[] = '<QBXML>';
        $xml[] = '<QBXMLMsgsRq onError="stopOnError">';
        $xml[] = '<ItemQueryRq requestID="' . self::escapeXml($requestId) . '">';
        foreach ($fullNames as $fullName) {
            $xml[] = '<FullName>' . self::escapeXml(trim((string) $fullName)) . '</FullName>';
        }
        $xml[] = '</ItemQueryRq>';
        $xml[] = '</QBXMLMsgsRq>';
        $xml[] = '</QBXML>';
        return implode('', $xml);
    }

    public static function detectRequestType(string $qbXml): string
    {
        $normalized = trim($qbXml);
        if ($normalized === '') {
            return 'Other';
        }
        if (str_contains($normalized, '<CustomerQueryRq') || str_contains($normalized, '<CustomerQueryRs')) {
            return 'CustomerQuery';
        }
        if (str_contains($normalized, '<ItemQueryRq') || str_contains($normalized, '<ItemQueryRs')) {
            return 'ItemQuery';
        }
        return 'Other';
    }

    public static function validateAndRebuildReadOnlyRequest(string $qbXml): ?array
    {
        if (trim($qbXml) === '' || strlen($qbXml) > 1048576 || preg_match('/<!\s*(DOCTYPE|ENTITY)\b/i', $qbXml) === 1) {
            return null;
        }

        $dom = self::loadSecureXml($qbXml, 1048576);
        if ($dom === null) {
            return null;
        }

        $root = $dom->documentElement;
        if (!$root instanceof DOMElement || $root->nodeName !== 'QBXML' || $root->namespaceURI !== null || $root->hasAttributes()) {
            return null;
        }
        foreach ($dom->childNodes as $documentChild) {
            if ($documentChild !== $root && !($documentChild instanceof DOMText && trim($documentChild->textContent) === '')) {
                return null;
            }
        }

        $rootChildren = self::elementChildren($root);
        if ($rootChildren === null || count($rootChildren) !== 1 || $rootChildren[0]->nodeName !== 'QBXMLMsgsRq' || $rootChildren[0]->namespaceURI !== null) {
            return null;
        }

        $messageNode = $rootChildren[0];
        if ($messageNode->attributes->length !== 1 || !$messageNode->hasAttribute('onError') || $messageNode->getAttribute('onError') !== 'stopOnError') {
            return null;
        }

        $requests = self::elementChildren($messageNode);
        if ($requests === null || count($requests) !== 1) {
            return null;
        }

        $request = $requests[0];
        if (!in_array($request->nodeName, ['CustomerQueryRq', 'ItemQueryRq'], true) || $request->namespaceURI !== null) {
            return null;
        }
        if ($request->attributes->length !== 1 || !$request->hasAttribute('requestID') || trim($request->getAttribute('requestID')) === '') {
            return null;
        }

        $fullNames = [];
        $queryFields = self::elementChildren($request);
        if ($queryFields === null) {
            return null;
        }
        foreach ($queryFields as $child) {
            if ($child->nodeName !== 'FullName' || $child->namespaceURI !== null || $child->hasAttributes() || !self::hasOnlyTextContent($child)) {
                return null;
            }
            $fullName = trim($child->textContent);
            if ($fullName === '') {
                return null;
            }
            $fullNames[] = $fullName;
        }

        $requestType = $request->nodeName === 'CustomerQueryRq' ? 'CustomerQuery' : 'ItemQuery';
        $requestId = $request->getAttribute('requestID');
        $rebuiltXml = $requestType === 'CustomerQuery'
            ? self::buildCustomerQuery($fullNames, $requestId)
            : self::buildItemQuery($fullNames, $requestId);

        return [
            'type' => $requestType,
            'requestId' => $requestId,
            'xml' => $rebuiltXml,
        ];
    }

    public static function parseReadOnlyQueryResponse(string $xml, string $expectedType, string $expectedRequestId): array
    {
        $malformed = ['status' => 'malformed', 'code' => '', 'diagnostic' => 'QuickBooks returned a malformed or mismatched query response.', 'records' => []];
        if (
            !in_array($expectedType, ['CustomerQuery', 'ItemQuery'], true)
            || $expectedRequestId === ''
            || trim($xml) === ''
            || strlen($xml) > 4194304
            || preg_match('/<!\s*(DOCTYPE|ENTITY)\b/i', $xml) === 1
        ) {
            return $malformed;
        }

        $dom = self::loadSecureXml($xml, 4194304);
        if ($dom === null) {
            return $malformed;
        }

        $root = $dom->documentElement;
        if (!$root instanceof DOMElement || $root->nodeName !== 'QBXML' || $root->namespaceURI !== null || $root->hasAttributes()) {
            return $malformed;
        }
        foreach ($dom->childNodes as $documentChild) {
            if ($documentChild !== $root && !($documentChild instanceof DOMText && trim($documentChild->textContent) === '')) {
                return $malformed;
            }
        }

        $rootChildren = self::elementChildren($root);
        if (
            $rootChildren === null
            || count($rootChildren) !== 1
            || $rootChildren[0]->nodeName !== 'QBXMLMsgsRs'
            || $rootChildren[0]->namespaceURI !== null
        ) {
            return $malformed;
        }
        $responseNodes = self::elementChildren($rootChildren[0]);
        $expectedResponse = $expectedType . 'Rs';
        if (
            $responseNodes === null
            || count($responseNodes) !== 1
            || $responseNodes[0]->nodeName !== $expectedResponse
            || $responseNodes[0]->namespaceURI !== null
        ) {
            return $malformed;
        }

        $responseNode = $responseNodes[0];
        $allowedAttributes = ['requestID', 'statusCode', 'statusSeverity', 'statusMessage', 'iteratorID', 'iteratorRemainingCount'];
        foreach ($responseNode->attributes as $attribute) {
            if (!in_array($attribute->nodeName, $allowedAttributes, true)) {
                return $malformed;
            }
        }
        if (
            !$responseNode->hasAttribute('requestID')
            || !hash_equals($expectedRequestId, $responseNode->getAttribute('requestID'))
            || !$responseNode->hasAttribute('statusCode')
            || !$responseNode->hasAttribute('statusSeverity')
            || !$responseNode->hasAttribute('statusMessage')
            || preg_match('/^\d+$/', $responseNode->getAttribute('statusCode')) !== 1
            || !in_array($responseNode->getAttribute('statusSeverity'), ['Info', 'Warning', 'Error'], true)
        ) {
            return $malformed;
        }

        $statusCode = $responseNode->getAttribute('statusCode');
        if ($statusCode !== '0' || $responseNode->getAttribute('statusSeverity') === 'Error') {
            return [
                'status' => 'quickbooks_error',
                'code' => $statusCode,
                'diagnostic' => 'QuickBooks returned ' . $expectedType . ' error code ' . $statusCode . '.',
                'records' => [],
            ];
        }

        $records = [];
        $recordElements = self::elementChildren($responseNode);
        if ($recordElements === null) {
            return $malformed;
        }
        $allowedRecordTags = $expectedType === 'CustomerQuery'
            ? ['CustomerRet']
            : ['ItemInventoryRet', 'ItemNonInventoryRet', 'ItemServiceRet', 'ItemOtherChargeRet', 'ItemGroupRet'];
        foreach ($recordElements as $recordElement) {
            if (!in_array($recordElement->nodeName, $allowedRecordTags, true) || $recordElement->namespaceURI !== null) {
                return $malformed;
            }
            $records[] = $expectedType === 'CustomerQuery'
                ? self::normalizeCustomerRecord($recordElement)
                : self::normalizeItemRecord($recordElement);
        }

        return ['status' => 'success', 'code' => '0', 'diagnostic' => 'Read-only query completed successfully.', 'records' => $records];
    }

    public static function parseCustomerQueryResponse(string $xml): array
    {
        $result = ['records' => [], 'errors' => [], 'success' => false];
        if (trim($xml) === '') {
            return $result;
        }

        $dom = self::loadSecureXml($xml, 4194304);
        if ($dom === null) {
            $result['errors'][] = 'Malformed XML in QuickBooks customer response.';
            return $result;
        }

        if (!$dom->documentElement instanceof DOMElement || $dom->documentElement->nodeName !== 'QBXML') {
            $result['errors'][] = 'Unexpected root in QuickBooks customer response.';
            return $result;
        }
        $queryStatus = self::getStatus($dom, 'CustomerQueryRs');
        if ($queryStatus !== null && $queryStatus['code'] !== '0') {
            $result['errors'][] = $queryStatus['message'];
            return $result;
        }

        $records = [];
        foreach ($dom->getElementsByTagName('CustomerRet') as $node) {
            $records[] = self::normalizeCustomerRecord($node);
        }
        $result['records'] = $records;
        $result['success'] = true;
        return $result;
    }

    public static function parseItemQueryResponse(string $xml): array
    {
        $result = ['records' => [], 'errors' => [], 'success' => false];
        if (trim($xml) === '') {
            return $result;
        }

        $dom = self::loadSecureXml($xml, 4194304);
        if ($dom === null) {
            $result['errors'][] = 'Malformed XML in QuickBooks item response.';
            return $result;
        }

        if (!$dom->documentElement instanceof DOMElement || $dom->documentElement->nodeName !== 'QBXML') {
            $result['errors'][] = 'Unexpected root in QuickBooks item response.';
            return $result;
        }
        $queryStatus = self::getStatus($dom, 'ItemQueryRs');
        if ($queryStatus !== null && $queryStatus['code'] !== '0') {
            $result['errors'][] = $queryStatus['message'];
            return $result;
        }

        $records = [];
        foreach (['ItemInventoryRet', 'ItemNonInventoryRet', 'ItemServiceRet', 'ItemOtherChargeRet', 'ItemGroupRet'] as $tagName) {
            foreach ($dom->getElementsByTagName($tagName) as $node) {
                $records[] = self::normalizeItemRecord($node);
            }
        }
        $result['records'] = $records;
        $result['success'] = true;
        return $result;
    }

    public static function normalizeCustomerRecord(DOMNode $node): array
    {
        $values = self::nodeToMap($node);
        return [
            'ListID' => (string)($values['ListID'] ?? ''),
            'FullName' => (string)($values['FullName'] ?? $values['Name'] ?? ''),
            'Name' => (string)($values['Name'] ?? ''),
            'IsActive' => strtolower((string)($values['IsActive'] ?? '')) === 'true' || (string)($values['IsActive'] ?? '') === '1',
            'raw' => $values,
        ];
    }

    public static function normalizeItemRecord(DOMNode $node): array
    {
        $values = self::nodeToMap($node);
        return [
            'ListID' => (string)($values['ListID'] ?? ''),
            'FullName' => (string)($values['FullName'] ?? $values['Name'] ?? ''),
            'Name' => (string)($values['Name'] ?? ''),
            'ItemType' => (string)($values['ItemType'] ?? ''),
            'IsActive' => strtolower((string)($values['IsActive'] ?? '')) === 'true' || (string)($values['IsActive'] ?? '') === '1',
            'ItemCode' => (string)($values['ItemCode'] ?? $values['Name'] ?? $values['FullName'] ?? ''),
            'raw' => $values,
        ];
    }

    private static function loadSecureXml(string $xml, int $maxBytes): ?DOMDocument
    {
        if (trim($xml) === '' || strlen($xml) > $maxBytes || preg_match('/<!\s*(DOCTYPE|ENTITY)\b/i', $xml) === 1) {
            return null;
        }

        $previousErrorMode = libxml_use_internal_errors(true);
        try {
            $dom = new DOMDocument();
            return $dom->loadXML($xml, LIBXML_NONET | LIBXML_NOBLANKS) ? $dom : null;
        } finally {
            libxml_clear_errors();
            libxml_use_internal_errors($previousErrorMode);
        }
    }

    private static function escapeXml(string $value): string
    {
        return htmlspecialchars($value, ENT_QUOTES | ENT_XML1, 'UTF-8');
    }

    private static function elementChildren(DOMElement $node): ?array
    {
        $elements = [];
        foreach ($node->childNodes as $child) {
            if ($child instanceof DOMElement) {
                $elements[] = $child;
                continue;
            }
            if (($child instanceof DOMText || $child instanceof DOMCdataSection) && trim($child->textContent) !== '') {
                return null;
            }
            if (!$child instanceof DOMText && !$child instanceof DOMCdataSection) {
                return null;
            }
        }
        return $elements;
    }

    private static function hasOnlyTextContent(DOMElement $node): bool
    {
        foreach ($node->childNodes as $child) {
            if (!$child instanceof DOMText && !$child instanceof DOMCdataSection) {
                return false;
            }
        }
        return true;
    }

    private static function nodeToMap(DOMNode $node): array
    {
        $map = [];
        foreach ($node->childNodes as $child) {
            if (!$child instanceof DOMElement) {
                continue;
            }
            $map[$child->nodeName] = $child->textContent;
        }
        return $map;
    }

    private static function getStatus(DOMDocument $dom, string $containerName): ?array
    {
        $container = $dom->getElementsByTagName($containerName)->item(0);
        if (!$container) {
            return null;
        }
        $statusCode = $container->getAttribute('statusCode');
        $statusSeverity = $container->getAttribute('statusSeverity');
        $statusMessage = $container->getAttribute('statusMessage');
        if ($statusCode === '' && $statusSeverity === '' && $statusMessage === '') {
            foreach ($container->childNodes as $child) {
                if ($child instanceof DOMElement && $child->nodeName === 'statusCode') {
                    $statusCode = $child->textContent;
                }
                if ($child instanceof DOMElement && $child->nodeName === 'statusSeverity') {
                    $statusSeverity = $child->textContent;
                }
                if ($child instanceof DOMElement && $child->nodeName === 'statusMessage') {
                    $statusMessage = $child->textContent;
                }
            }
        }
        if ($statusCode === '' && $statusSeverity === '' && $statusMessage === '') {
            return ['code' => '0', 'message' => 'OK'];
        }
        return ['code' => (string) $statusCode, 'message' => trim((string) ($statusMessage ?: 'QuickBooks query failed.'))];
    }
}
