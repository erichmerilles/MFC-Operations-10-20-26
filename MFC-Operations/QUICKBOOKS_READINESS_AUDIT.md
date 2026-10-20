# QuickBooks Readiness Audit

**Reviewed:** 2026-10-20  
**Outcome:** **NO-GO for sandbox transaction testing now.** Mapping prerequisites and lifecycle classifications are incomplete, and no test company/connector is verified. Non-posting design work may continue.  
**Data source:** Read-only inspection of the configured `withdrawal_qb` MariaDB schema. No operational writes or migrations were made.

## Verified architecture

- The application is PHP with PDO/MariaDB, split into `frontend/` and `backend/`.
- Withdrawals save locally. Invoice and Sales Order preparation save local drafts in separate tables. Sales Order saving explicitly reports that it was not sent to QuickBooks.
- `qb_jobs` exists for invoices, with a unique request key and one job per invoice. It has no Sales Order relation. Search found no Web Connector WSDL handlers, qbXML generation/response processor, connector credentials, QWC file, item/customer lookup adapter, or posting controller. A queue table by itself is not a working connector.
- `frontend/settings.php` labels the intended target QuickBooks Desktop Enterprise Solutions 24.0, and the README says Web Connector/qbXML is the required future path. The actual installed edition, company file, Web Connector, Windows host/network arrangement, approval, and SDK version have not been inspected or tested.
- Intuit documents Web Connector as a Windows intermediary that passes qbXML between a web service and QuickBooks Desktop; the connector is installed on the QuickBooks machine or local network. The official API reference includes Sales Order Add. This establishes a plausible future path, not compatibility with this deployment or its company file: [Web Connector overview](https://static.developer.intuit.com/output_html/qbdesktop/docs/get-started/get-started-with-quickbooks-web-connector.html), [SalesOrderAdd reference](https://developer.intuit.com/app/developer/qbdesktop/docs/api-reference/qbdesktop/salesorderadd).
- No automatic posting or fake QuickBooks response was added. The new `backend/core/quickbooks_readiness.php` is a read-only preflight for saved invoice and Sales Order drafts. It checks local customer/product activation, QB codes, descriptions, ListIDs, duplicate local mappings, and quantity/rate basics; it always reports the unverified connector/company-file blocker. Readiness is not posting.

## Product and customer findings

The live schema and records were read in a read-only transaction. Exact counts and lifecycle limitations are in [PRODUCT_MAPPING_READINESS.md](PRODUCT_MAPPING_READINESS.md) and the product-level crosswalk is in [PRODUCT_MAPPING_RECONCILIATION.md](PRODUCT_MAPPING_RECONCILIATION.md).

- 92 of 94 product records are `active=1`; 2 are `active=0`.
- Among the 92 active products, 74 have QB Code and QB Description, 18 lack both, and all 92 lack a QB ListID. Therefore none has a complete local customer/item reference set for a future connector.
- There are 819 client records, 816 active. All 816 active clients lack a QB ListID.
- `products.active` and `clients.active` are the only relevant lifecycle flags. There is no stock quantity, out-of-stock state, discontinued/phased-out state, or mapping verification field. The business statement that incompletely mapped products are out of stock or phased out is recorded as a general statement only; it does not establish which individual product has which status. No product status was bulk-changed.
- Product/client display names and QB Codes are not substitutes for a verified QuickBooks ListID. Historical products and transaction records remain untouched.

## Implemented fixes

- Invoice POST validation now requires every `WITHDRAWAL` source line to contain a valid withdrawal item that belongs to the invoice's source withdrawal and has the same product. Source type must be explicitly `WITHDRAWAL` or `ADDITIONAL`. Explicit additional invoice lines may still omit a source item.
- Sales Order drafts now use the shared confirmation handler (SweetAlert with the existing native `window.confirm` fallback).
- New Sales Order initialization no longer substitutes HT description/product name when QB Description is blank. A saved local draft may preserve a staff-entered description, but the readiness check blocks a future QB send while the master QB Description is missing.
- Invoice and Sales Order pages show expandable read-only readiness blockers and continue to state that local draft saves do not mean posting.

## Lifecycle decision

No lifecycle migration or stock calculation was introduced. Existing `active` flags remain unchanged. An authorized business user must identify, product by product, whether each incomplete record is available, out of stock, phased out/discontinued, or otherwise blocked. Any future status change must preserve historical viewing, printing, and references, and must not silently replace a historical item.

## Repository state limitation

Git was not available on PATH. Branch, commit, and complete working-tree state could not be recorded. Existing files were inspected before editing and changes were limited to the files listed in the implementation report; no commits or pushes were made.
