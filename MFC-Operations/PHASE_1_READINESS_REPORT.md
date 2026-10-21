# Phase 1 QuickBooks Readiness Report

**Date:** 2026-10-21  
**Scope:** Audit and preparation for sending local Invoices and Sales Orders to QuickBooks Desktop Enterprise 24.0 through QBWC/qbXML. No live/sandbox QuickBooks transaction was created.

## Executive summary

**Phase 1 preparation decision: PASS.** The repository, local draft workflows, schema, integration boundary, mapping gaps, field candidates, reliability controls and gated test plan are documented.

**QuickBooks posting readiness: FAIL / NO-GO.** The app has no implemented Web Connector service, qbXML transaction builder/processor or QuickBooks response/reconciliation path. The customer/item identifiers are materially incomplete. Do not implement live posting or begin transaction-level acceptance testing until the Critical and High blockers are resolved.

## Verified architecture and existing components

- PHP + PDO/MariaDB; `frontend/`, `backend/controllers/`, `backend/core/` separation.
- Withdrawals are locally persisted. Invoice drafts persist in `invoices`/`invoice_items`; Sales Orders persist separately in `sales_orders`/`sales_order_items`.
- Save routes require login and CSRF, use prepared statements/transactions, validate server-side values, calculate amounts, and log local save actions.
- `invoices.memo` and `sales_orders.memo` are local only. SO code snapshots business QB Code and technical ListID separately.
- `qb_jobs` is an invoice-only schema/status structure with unique request key and invoice uniqueness constraint. No active worker/service consumes it. It cannot be treated as a functioning integration or extended to SO by assumption.
- The read-only draft readiness preflight separates local checks from live QuickBooks integration checks. It does not post or enqueue.
- Repository documentation names QB Desktop Enterprise 24.0 and QBWC/qbXML as intended targets. Deployment, company file, host, QBWC, authorization and qbXML version are unverified.
- No `.qwc`, WSDL/SOAP endpoint, qbXML builder, request dispatcher, QBWC request handler, response parser, or QuickBooks transaction send operation was found.

## Critical and High blockers

| Severity | Blocker | Impact |
|---|---|---|
| **Critical** | No verified target QuickBooks edition/build, intended company file or isolated test company. | Cannot validate authorization, fields, references or transaction behavior. |
| **Critical** | No connector/service, authentication, qbXML exchange or response processor implemented. | Neither local workflow can currently create a QB transaction. |
| **Critical** | Customer FullNames and product FullName/QB Code associations are not verified against the intended company file. | Name-based references cannot be resolved safely yet; an empty stored ListID is not itself the blocker. |
| **Critical** | No duplicate/uncertain result reconciliation implementation; `qb_jobs` is invoice-only and has no active processor. | Timeout/retry can duplicate or misreport transactions if posting were enabled. |
| **High** | 18 active products also lack QB Code/Description; no approved product lifecycle crosswalk. | Mapping/current use cannot be determined; do not infer discontinued or out-of-stock. |
| **High** | Invoice footer Memo and multiple SO fields (Site, Lot, U/M, Class, Status, Fulfilled, Expiration, Tax) have no target-company verified member/semantics. | Silent omission or invented mapping could change the transaction meaning. |
| **High** | Hosting/network/TLS and credential controls for QBWC unverified. | Connector cannot be safely configured or authenticated. |
| **Medium** | Git executable unavailable on PATH. | Branch and complete pre-existing working tree state were not confirmable. |

## Mapping findings

The last recorded read-only operational DB snapshot (2026-10-20) found 94 product rows: 92 `active=1`, 2 `active=0`; among active products, 18 lack both QB Code and QB Description and all 92 lack legacy QB ListID. There are 819 clients: 816 active and all 816 active records lack legacy QB ListID. These absent IDs are not inherently a blocker where qbXML accepts verified FullName references. No current-company FullName/code mapping is verified, and no customer export was present among repository CSV/XLSX/XML/QWC assets. Missing mapping does not establish product lifecycle. See [PRODUCT_MAPPING_RECONCILIATION.md](PRODUCT_MAPPING_RECONCILIATION.md) and [PRODUCT_MAPPING_READINESS.md](PRODUCT_MAPPING_READINESS.md).

## Field mapping status

- Candidate shared target references are `CustomerRef.FullName` and line `ItemRef.FullName` where supported, plus `TxnDate`, transaction `RefNumber`, `Desc`, `Quantity`, and `Rate`; amounts are calculated/validated server-side. The QBSDK Programmer's Guide contains FullName examples for these customer/item references. Local client names/item codes must still be verified against the intended company; no lookup or add operation is implemented.
- Invoice memo is local `invoices.memo`; proposed destination is transaction `Memo` intended for footer display. Verify request support, size and actual invoice form/template placement. It is not currently transmitted.
- Sales Order must use distinct SalesOrderAdd. Its displayed ITEM is `qb_code`; the actual QuickBooks item FullName must be resolved and code association verified. Do not assume `qb_code` equals FullName.
- No field mapping is established for local Site/Lot/U/M/Class/line Status/Fulfilled Quantity/Expiration/Tax labels. Keep optional values local until supported fields or explicit approved disposition are established.
- Full source-by-source proposal, local validation and verification state are in [QUICKBOOKS_FIELD_MAPPING.md](QUICKBOOKS_FIELD_MAPPING.md).

## Security, reliability and duplicate risk

Local login, CSRF, prepared SQL, transactions and activity logs cover draft persistence. They do not protect a future connector endpoint. Before any send, implement QBWC method authentication/state handling, secret storage/redaction, role control, durable atomic transaction claims, per-type dispatch, attempt history, response validation and reconciliation. A timeout after handoff must become Outcome Unknown and must not automatically retry. Exactly-once delivery is not established. Detailed workflow/recovery is in [QUICKBOOKS_INTEGRATION_WORKFLOW.md](QUICKBOOKS_INTEGRATION_WORKFLOW.md).

## Tests performed and limitations

Most recent local verification for the name-based preflight update (2026-10-21):

- Guarded `php tests/e2e_http_regression.php`: PASS, 14 HTTP/database cases. Customer and product `qb_list_id` fixture values remained NULL; local Invoice/Sales Order saves passed and the pages showed unresolved live FullName checks. The isolated `test` schema was cleaned to zero tables.
- PHP syntax scan: PASS, 33 PHP files.
- `php tests/qa_regression.php`: FAIL at F10. It expects `assets/images/login.png`, while the current `frontend/login.php` contains `assets/images/.png`; the image file exists. Earlier QA groups passed before it stopped, and F11 therefore did not execute in this run. This unrelated issue was not changed.
- The 2026-10-20 full QA run and 34-file syntax pass are historical results only.
- Operational DB mapping inventory: read-only snapshot dated 2026-10-20.
- QBWC connectivity, qbXML validation against target, transaction adds, rejection response, timeout recovery and reconciliation: NOT RUN; target connector/company unavailable.
- No migration, operational DB write, QuickBooks request or QuickBooks transaction occurred.

Source: [QUICKBOOKS_INTEGRATION_TEST_RESULTS.md](QUICKBOOKS_INTEGRATION_TEST_RESULTS.md), [E2E_REGRESSION_SUMMARY.md](E2E_REGRESSION_SUMMARY.md). Do not represent local tests as proof of QuickBooks integration.

## Operator confirmations and ordered remediation

1. Confirm intended Desktop Enterprise regional edition, release/build and approved company file; provision an isolated test company and authorized test operator.
2. Confirm QBWC/SDK version, Windows host, installation, company authorization and permission scope. Confirm PHP service topology, endpoint reachability and compatible HTTPS/TLS.
3. Export customer and item FullNames, item code/type, and active state from that company. An exported ListID may be retained as optional diagnostic data but must not be a staff-maintained prerequisite. Approve a crosswalk; resolve duplicate names, renames, inactive records and transactions actually in scope. Do not fabricate IDs or infer product lifecycle.
4. Have business owners approve all transaction semantics: Invoice footer Memo, PO, customer/document numbering, currency, tax, class, U/M, Site/Lot, Status/Fulfilled and Expiration. Decide which fields are local-only if unsupported; no silent discard.
5. Select qbXML version and verify InvoiceAdd/SalesOrderAdd field/member requirements against matching Intuit OSR/SDK and test company. Separate builders and confirm Sales Orders are never sent as invoices.
6. Implement secure QBWC transport, role-authorized transaction coordination, durable idempotency/attempt state, response parsing and reconciliation. Keep payload/logs redacted and limited.
7. Execute [QUICKBOOKS_INTEGRATION_TEST_PLAN.md](QUICKBOOKS_INTEGRATION_TEST_PLAN.md) in isolated application and QuickBooks test environments. Demonstrate success, rejection, concurrency, lost response, lookup and safe recovery.
8. Obtain operator sign-off and only then prepare a separate controlled production deployment review. Phase 1 does not authorize production posting.

## Final decision

**PASS — Phase 1 audit/preparation deliverables are complete.**  
**FAIL / NO-GO — QuickBooks posting and transaction-level integration testing are not ready.** This task updates local readiness so a missing stored ListID does not block preflight, but does not implement the required live name resolver or transaction send path.

This report is a preparation artifact; it does not certify that the external QuickBooks system, connector, field mappings or transaction operations work.
