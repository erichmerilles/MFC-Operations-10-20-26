# QuickBooks Readiness Audit

**Reviewed:** 2026-10-21  
**Outcome:** **NO-GO for QuickBooks communication and transaction testing now.** No test company/connector is verified, name resolution has not been implemented, and data-to-name associations are unverified. Non-posting local-preflight work may continue.  
**Data source:** Read-only inspection of the configured `withdrawal_qb` MariaDB schema. No operational writes or migrations were made.

> **Current-status note (2026-10-21):** This audit records the source and database findings at its review point; its statement below that no QBWC handlers or query processor existed is historical and has been superseded. A local WSDL-backed, read-only Customer/Item QBWC service and in-memory mock tests have since been added. This does not change the NO-GO for QuickBooks communication: Apache endpoint behavior, the effective active database/schema, live QBWC authentication, company-file name resolution, and transaction posting remain unverified. No live connection or transaction was performed.

## Verified architecture

- The application is PHP with PDO/MariaDB, split into `frontend/` and `backend/`.
- Withdrawals save locally. Invoice and Sales Order preparation save local drafts in separate tables. Sales Order saving explicitly reports that it was not sent to QuickBooks.
- At the audit's review point, `qb_jobs` existed for invoices, with a unique request key and one job per invoice, and had no Sales Order relation. The audit found no Web Connector WSDL handlers, qbXML generation/response processor, connector credentials, QWC file, item/customer lookup adapter, or posting controller. That source inventory is historical; the current read-only query service is described in the status note above. A queue table by itself is not a working connector.
- `frontend/settings.php` labels the intended target QuickBooks Desktop Enterprise Solutions 24.0, and the README says Web Connector/qbXML is the required future path. The actual installed edition, company file, Web Connector, Windows host/network arrangement, approval, and SDK version have not been inspected or tested.
- Intuit SDK examples show name-based `CustomerRef.FullName` and `ItemRef.FullName` references for Desktop transactions; a local ListID is not inherently required where the chosen request supports FullName. This documents protocol capability only, not that local names/codes match QuickBooks or that this deployment is compatible: [QBSDK Programmer's Guide](https://static.developer.intuit.com/qbSDK-current/doc/pdf/QBSDK_ProGuide.pdf), [Web Connector overview](https://static.developer.intuit.com/output_html/qbdesktop/docs/get-started/get-started-with-quickbooks-web-connector.html).
- No automatic posting or fake QuickBooks response was added. `backend/core/quickbooks_readiness.php` now separates local preflight from live integration blockers. It checks local customer/product activation/name, QB Code/description, duplicate local QB Codes, and quantity/rate basics. It no longer requires local ListIDs or checks their duplicate counts. It adds explicit blockers because customer `FullName` and item FullName have not been resolved against the intended company and the connector/company file remain unverified. It neither creates jobs nor sends requests.

## Product and customer findings

The live schema and records were read in a read-only transaction. Exact counts and lifecycle limitations are in [PRODUCT_MAPPING_READINESS.md](PRODUCT_MAPPING_READINESS.md) and the product-level crosswalk is in [PRODUCT_MAPPING_RECONCILIATION.md](PRODUCT_MAPPING_RECONCILIATION.md).

- 92 of 94 product records are `active=1`; 2 are `active=0`.
- Among the 92 active products, 74 have QB Code and QB Description, 18 lack both, and all 92 lack a stored QB ListID. The absent ListIDs are not by themselves a blocker for a supported FullName reference; the actual QuickBooks item FullName/code match is not known or checked.
- There are 819 client records, 816 active. All 816 active clients lack a stored QB ListID. This is not by itself a blocker for a supported FullName reference; the exact current-file customer name is not known or checked.
- `products.active` and `clients.active` are the only relevant lifecycle flags. There is no stock quantity, out-of-stock state, discontinued/phased-out state, or mapping verification field. The business statement that incompletely mapped products are out of stock or phased out is recorded as a general statement only; it does not establish which individual product has which status. No product status was bulk-changed.
- Local display names and QB Codes are not proof of corresponding QuickBooks FullNames. Historical products and transaction records remain untouched. Do not require staff to populate legacy ListID fields merely to save local drafts or pass local-only checks.

## Implemented fixes

- Invoice POST validation now requires every `WITHDRAWAL` source line to contain a valid withdrawal item that belongs to the invoice's source withdrawal and has the same product. Source type must be explicitly `WITHDRAWAL` or `ADDITIONAL`. Explicit additional invoice lines may still omit a source item.
- Sales Order drafts now use the shared confirmation handler (SweetAlert with the existing native `window.confirm` fallback).
- New Sales Order initialization no longer substitutes HT description/product name when QB Description is blank. A saved local draft may preserve a staff-entered description, but the readiness check blocks a future QB send while the master QB Description is missing.
- Invoice and Sales Order pages show expandable read-only readiness blockers and continue to state that local draft saves do not mean posting.
- Local preflight now distinguishes local validation from live QuickBooks name resolution. `local_ready` may be true when required local data is valid; `posting_ready` remains false until exact customer/item names and connector/company identity are verified live. The existing `ready` field remains false for compatibility.

## Lifecycle decision

No lifecycle migration or stock calculation was introduced. Existing `active` flags remain unchanged. An authorized business user must identify, product by product, whether each incomplete record is available, out of stock, phased out/discontinued, or otherwise blocked. Any future status change must preserve historical viewing, printing, and references, and must not silently replace a historical item.

## Repository state limitation

Git was not available on PATH. Branch, commit, and complete working-tree state could not be recorded. Existing files were inspected before editing and changes were limited to the files listed in the implementation report; no commits or pushes were made.
