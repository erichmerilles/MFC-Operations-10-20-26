# Phase 1 Repository Audit

**Reviewed:** 2026-10-21  
**Scope:** QuickBooks Desktop Enterprise 24.0 preparation only. No live or sandbox QuickBooks request was made.

## Documentation convention

This repository stores project handoffs, audits, test plans, and reports as Markdown files at the repository root; there is no existing `docs/` directory. To avoid creating a parallel documentation tree, these six Phase 1 deliverables use the established root convention:

- `PHASE_1_REPOSITORY_AUDIT.md`
- `QUICKBOOKS_ENVIRONMENT_READINESS.md`
- `QUICKBOOKS_FIELD_MAPPING.md`
- `QUICKBOOKS_INTEGRATION_WORKFLOW.md`
- `QUICKBOOKS_INTEGRATION_TEST_PLAN.md`
- `PHASE_1_READINESS_REPORT.md`

Related prior reports are retained and linked; none were deleted or replaced.

## Architecture and application entry points

- PHP application using PDO with MariaDB/MySQL (`backend/core/database.php`).
- Presentation and route pages live in `frontend/`; persistence and core logic live in `backend/controllers/` and `backend/core/`.
- `index.php` is the root entry point. Authentication, role checks, CSRF validation, prepared statements, and activity logging are implemented in shared backend code.
- Local data uses `withdrawal_qb` by default. The E2E harness has a separate guarded `test` database path; never repoint it at operational data.

## Data model and relationships

| Domain | Tables and important relations | Integration status |
|---|---|---|
| Customers | `clients.id`, `client_name`, optional legacy `qb_list_id`, `active`; referenced by `withdrawals.client_id`, `invoices.customer_id`, `sales_orders.customer_id` | Local records exist; exact QuickBooks FullName is not verified. |
| Products/items | `products.id`, `product_name`, `qb_code`, `qb_description`, optional legacy `qb_list_id`, `u_m`, `default_price`, `active`; withdrawal lines reference `products.id` | `qb_code` is a business code and is not assumed to equal QB FullName. Local record active is not QB or stock status. |
| Withdrawals | `withdrawals` and `withdrawal_items`, with lines linked to product master; this remains the source workflow | Saved locally. Not a QuickBooks transaction. |
| Invoices | `invoices` references one `withdrawal_id`, customer, document number/date, PO, memo, local status; `invoice_items` stores line snapshots, product/site, whole quantity, price/amount, local tax/lot/expiry | Locally prepared only. Invoice source lines are validated against their withdrawal. |
| Sales Orders | Separate `sales_orders` and `sales_order_items` from `20261019_sales_order_preparation.sql`; one local draft per source withdrawal | Locally prepared only. S.O. NO. and line data are local. No posting relationship to `qb_jobs`. |
| Queue/status | `qb_jobs` has an invoice FK, unique request key and unique invoice FK, invoice-oriented statuses/XML/result fields | Schema only. No queue processor or web service was found; it cannot be considered an active connector. |
| Audit | `activity_logs` | Local actions are logged; connector request/response audit has not been implemented. |

## Invoice preparation path

1. Staff saves a withdrawal through the existing withdrawal workflow.
2. `frontend/invoice_preparation.php` creates/loads a local `invoices` header and `invoice_items` lines from that withdrawal; staff may add invoice-only lines.
3. The page submits to `backend/controllers/invoice_save.php`, which requires login and CSRF, locks the header row, validates customer, unique invoice number, date, memo and lines, enforces source withdrawal/product ownership, recalculates amount, saves atomically, and logs the draft save.
4. The controller redirects back to local preparation. There is no send operation, invoice qbXML, connector transport, or QuickBooks result handling in this path.

Invoice `memo` is persisted as a local header field (`invoices.memo`) and displayed adjacent to PO in the app. Its candidate QuickBooks destination is transaction `Memo` (which appears in the QuickBooks invoice footer area in intended UI usage), but actual field/version and rendered form placement have not been verified against the target company file. It is not presently transmitted.

## Sales Order preparation path

1. Staff saves a withdrawal locally.
2. `frontend/sales_order_preparation.php` creates/loads a local Sales Order draft and snapshots product `qb_code`, `qb_list_id`, `qb_description`, unit and price where available.
3. `backend/controllers/sales_order_save.php` requires login and CSRF, locks the draft, validates header and line data, verifies active customer/product/site and unambiguous local QB Code, recalculates amount, saves local rows atomically, and logs the save.
4. The controller explicitly reports that the draft was not sent to QuickBooks. No SalesOrderAdd request or QuickBooks result is produced.

The displayed Sales Order ITEM (`item_code`) is the Product Master `qb_code`; the legacy technical reference (`qb_item_list_id`) is stored separately when available. `DESCRIPTION` is stored independently. A QuickBooks item code is not proof that the intended company has an item with that FullName or that it is the correct item.

## Integration boundary actually present

Inspected the backend/frontend search results, schema, settings and QuickBooks status page. Present: optional local legacy ListID columns, an invoice-only `qb_jobs` schema, a status view, and read-only `backend/core/quickbooks_readiness.php`. The readiness checker no longer makes missing stored ListIDs blockers; it separates local validation from live FullName resolution. Not found: QBWC WSDL methods, `.qwc` config, SOAP service endpoint, credentials/ticket protocol, qbXML request builder, transaction-type dispatcher, polling/request processor, response parser, customer/item lookup adapter, retry/reconciliation endpoint, or live posting controller.

The repository advertises Desktop Enterprise 24.0 as the intended target and Web Connector/qbXML as the intended route. These are project requirements, not verified facts about the deployed Windows host, QuickBooks edition, company file, QBWC installation, authorization, network, or supported qbXML version.

## Tests, configuration and safety

- Local test scripts: `tests/qa_regression.php`, `tests/e2e_http_regression.php` with `tests/e2e_db_guard.php`.
- DB connection is configured through `WQ_DB_HOST`, `WQ_DB_NAME`, `WQ_DB_USER`, and `WQ_DB_PASS`; secrets must not appear in reports or logs.
- Most recent recorded test results are in `QUICKBOOKS_INTEGRATION_TEST_RESULTS.md` and `E2E_REGRESSION_SUMMARY.md` (dated 2026-10-20): QA assertions PASS, 14 guarded HTTP cases PASS, PHP lint PASS, browser subcheck blocked, QuickBooks not connected/tested.
- Git was not available on PATH during review. Branch and complete working-tree status could not be confirmed. Existing project files were read before this documentation-only update; no code, configuration, schema or local data was changed.

## Findings

1. The local draft architecture is separate for Invoices and Sales Orders and is suitable to retain as the preparation layer.
2. There is currently no implementation that carries either transaction from local draft into QuickBooks.
3. Customer and item identity mapping is insufficient for safe transaction references (see `PRODUCT_MAPPING_READINESS.md`).
4. Several displayed/local optional fields have no verified QB mapping; keep them local until individually confirmed.
5. Invoice-only `qb_jobs` constraints cannot represent Sales Order jobs without a deliberate, tested persistence design.

See [environment readiness](QUICKBOOKS_ENVIRONMENT_READINESS.md), [field mapping](QUICKBOOKS_FIELD_MAPPING.md), [workflow/recovery](QUICKBOOKS_INTEGRATION_WORKFLOW.md), [test plan](QUICKBOOKS_INTEGRATION_TEST_PLAN.md), and [readiness decision](PHASE_1_READINESS_REPORT.md).
