# MFC-Operations — Project Handoff for Codex

> **Purpose:** Give Codex a reliable starting point for future work so it can understand the application's architecture, workflows, conventions, and recent changes without re-reading every file on every task.
>
> **Repository:** https://github.com/erichmerilles/MFC-Operations  
> **Primary branch reviewed:** `main`  
> **Application source folder:** `MFC-Operations/`  
> **Last handoff review:** 2026-10-20
>
> **Important:** This document is a project map, not a substitute for checking the specific files involved in a change. The repository is the source of truth. If the code, database, or this document disagree, inspect the current code and schema and update this document as needed. Do not assume static review proves runtime behavior.

---

## 1. Project overview

MFC-Operations is a PHP/MySQL internal operations application for managing withdrawal records and preparing invoice drafts for QuickBooks Desktop Enterprise Solutions 24.0.

The application separates presentation pages from backend operations:

- **Frontend:** PHP pages, shared layout, styles, and browser-side JavaScript.
- **Backend:** application bootstrap/configuration, authentication and shared helpers, POST controllers, JSON APIs, exports, database schema, and migrations.
- **Database:** MySQL, normally run locally through XAMPP during development.
- **QuickBooks:** invoice preparation is currently a local draft workflow. QuickBooks Web Connector / qbXML posting must not be described as implemented or verified unless the relevant integration code and real company-file tests prove it.

The application should preserve the distinction between the original withdrawal transaction and the invoice draft created from it.

## 2. Repository and source layout

The repository has a project folder nested inside the repository. Most application files are under `MFC-Operations/`, not the repository root.

The documented layout is approximately:

```text
MFC-Operations/
├── index.php
├── frontend/
│   ├── assets/                 # CSS, JavaScript, and frontend assets
│   ├── includes/               # Shared visual layout and navigation
│   ├── login.php
│   ├── setup.php               # Initial administrator setup; remove after use
│   ├── dashboard.php
│   ├── withdrawal_form.php
│   ├── withdrawal_print.php
│   ├── withdrawals.php
│   ├── invoice_preparation.php
│   ├── clients.php             # Client master and invoice history
│   ├── products_sites.php      # Product and site master data
│   ├── settings.php
│   └── quickbooks_status.php   # Status view; not proof of working QB integration
└── backend/
    ├── config/
    │   └── app.php             # Application bootstrap/configuration
    ├── core/                   # Database, authentication, authorization,
    │                           # validation, and shared business helpers
    ├── controllers/            # POST actions (for example save withdrawal/invoice)
    ├── api/                    # JSON endpoints called by frontend JavaScript
    ├── exports/                # CSV export endpoints
    ├── database/
    │   ├── schema.sql          # Initial database schema
    │   └── migrations/         # Controlled changes to existing databases
    └── ...
```

This is a guide to the expected structure, not an exhaustive file listing. Check the actual repository tree before adding a new file or assuming a path.

### Key file references

- [Repository](https://github.com/erichmerilles/MFC-Operations)
- [Application README](https://github.com/erichmerilles/MFC-Operations/blob/main/MFC-Operations/README.md)
- [Withdrawal register](https://github.com/erichmerilles/MFC-Operations/blob/main/MFC-Operations/frontend/withdrawals.php)
- [Withdrawal form](https://github.com/erichmerilles/MFC-Operations/blob/main/MFC-Operations/frontend/withdrawal_form.php)
- [Invoice preparation](https://github.com/erichmerilles/MFC-Operations/blob/main/MFC-Operations/frontend/invoice_preparation.php)
- [Clients page](https://github.com/erichmerilles/MFC-Operations/blob/main/MFC-Operations/frontend/clients.php)
- [Products & Sites page](https://github.com/erichmerilles/MFC-Operations/blob/main/MFC-Operations/frontend/products_sites.php)
- [Shared sidebar](https://github.com/erichmerilles/MFC-Operations/blob/main/MFC-Operations/frontend/includes/sidebar.php)
- [Client invoice history API](https://github.com/erichmerilles/MFC-Operations/blob/main/MFC-Operations/backend/api/client_invoice_history.php)
- [Client invoice detail API](https://github.com/erichmerilles/MFC-Operations/blob/main/MFC-Operations/backend/api/client_invoice_detail.php)
- [Application README's database upgrade instructions](https://github.com/erichmerilles/MFC-Operations/blob/main/MFC-Operations/README.md)

## 3. Main business workflow

### A. Withdrawal workflow

1. An authenticated user opens the Withdrawal Register.
2. The user creates or opens a withdrawal in `frontend/withdrawal_form.php`.
3. The form loads active clients and eligible products from the database.
4. Withdrawal line items are saved to the withdrawal tables by the relevant backend controller.
5. The user can find saved withdrawals in `frontend/withdrawals.php`.
6. A saved withdrawal can be opened, printed, or used as the source for invoice preparation.

A withdrawal is the original operational record. Invoice-only edits must not silently change the withdrawal's original line items or values.

### B. Invoice preparation workflow

1. The user opens Invoice Preparation from a saved withdrawal.
2. `frontend/invoice_preparation.php` locates the withdrawal and its invoice draft.
3. If a draft does not exist, the page creates an invoice header and copies withdrawal lines into `invoice_items`.
4. Invoice lines are stored separately from withdrawal lines. They may contain invoice-specific item mapping, description, unit, price, amount, tax choice, site, and additional invoice-only lines, according to the current schema and UI.
5. The invoice save controller validates the submitted data and saves the draft.
6. The invoice status controls whether it can be edited. Current code treats statuses such as `Invoiced`, `Queued`, `Processing`, and `Uncertain Result` as locked because a submission may have occurred.
7. The current package explicitly warns that QuickBooks posting is unavailable until the Web Connector service, field mappings, and company-file behavior have been implemented and verified.

Invoice drafts also have a local `invoices.memo` field. `frontend/invoice_preparation.php` loads it with the invoice header and posts edits to `backend/controllers/invoice_save.php`; the controller validates and saves it in the existing invoice update transaction. Existing installations need `20261019_invoice_memo.sql`. This memo is not synchronized to QuickBooks.

Displayed monetary values use PHP peso formatting with two decimals and thousands separators. Editable price fields show grouped values when not focused and accept correctly grouped comma input; database values remain numeric.

The invoice line table in `frontend/invoice_preparation.php` uses fixed pixel widths for compact fields and lets Description take the remaining space, styled in `frontend/assets/css/app.css`. The shared header adds an asset modification-time query to the CSS URL so updated styles are fetched. Product selection displays only `products.qb_description`. QB Code remains in the item-code field and product identity/mappings remain in their existing values. Opening a draft does not update saved invoice descriptions.

The invoice page passed `php -l`. A scan of the product master found no QB descriptions containing code or mapping annotations; those labels had been added by product option markup. Local HTTP draft workflows are exercised by `tests/e2e_http_regression.php`. Phase 2 browser checks now cover withdrawal, invoice, and Sales Order draft create/save/reload, narrow layouts, and invoice/Sales Order print output. The dedicated `withdrawal_print.php` route remains unverified; see `E2E_REGRESSION_RESULTS.md`.

**Do not implement automatic QuickBooks posting, enable a send action, or claim successful QB integration unless that is explicitly requested and all integration prerequisites are verified.**

Sales Order Preparation is implemented as a separate local-only workflow in `frontend/sales_order_preparation.php` with saves handled by `backend/controllers/sales_order_save.php`. It uses separate `sales_orders` and `sales_order_items` tables from `20261019_sales_order_preparation.sql`, links each draft to its source withdrawal, and preserves invoice records unchanged. Apply the migration before using the screen. S.O. NO. is manually entered and unique; customer/date/PO default from the withdrawal; ITEM is shown using the authoritative Product Master `qb_code` mapping (never the withdrawal HT code), and missing or ambiguous QB Codes block draft save. The technical `qb_list_id` is stored separately and is not the displayed code. DESCRIPTION defaults to the stored QB product description; SITE is selected from active sites; ORDERED defaults to the whole withdrawal quantity; U/M and RATE default from Product Master; AMOUNT is recalculated from ORDERED × RATE. LOT NUMBER, CLASS, STATUS, FULFILLED QUANTITY, EXPIRATION DATE, TAX, and Memo remain optional local values. The app has no live QuickBooks Sales Order submission or verified field mapping/reference lookup; do not queue or send these drafts.

### C. Client invoice history workflow (recent update)

1. The authenticated user opens `frontend/clients.php`.
2. Clients are displayed in an accordion, with search and client-list pagination.
3. Opening a client's accordion loads invoice history through `backend/api/client_invoice_history.php`.
4. Invoice history is scoped to the selected client and paginated at 10 invoices per page.
5. Clicking an invoice number / details action opens a Bootstrap modal.
6. The modal requests `backend/api/client_invoice_detail.php` with the selected invoice ID and client ID.
7. The detail API verifies that the invoice belongs to that client, then loads the invoice header and actual invoice rows from `invoice_items`. It does **not** use withdrawal rows as a substitute for the invoice's saved rows.
8. The modal displays the stored invoice lines and a calculated sum of saved line amounts.

## 4. Data concepts and mapping rules

Use the actual current schema and controller validation as the final authority. The following distinctions are important:

- **Client/customer:** A record in `clients`; invoice headers reference a client/customer ID.
- **Withdrawal:** Original operational record, identified by a withdrawal number such as `withdrawal_no`.
- **Withdrawal line:** An item in `withdrawal_items`, linked to a withdrawal and product.
- **Invoice draft/header:** A record in `invoices`, associated with a source withdrawal and customer.
- **Invoice line:** A saved row in `invoice_items`, associated with an invoice. Invoice rows can differ from withdrawal rows.
- **Product:** Master record in `products`.
- **Site:** Master record in `sites`; invoice lines store their selected site through `site_id` where applicable.

### Product identifiers and descriptions

Do not treat the following as interchangeable:

- **HT Code:** Withdrawal-side business code.
- **HT Description:** Withdrawal-side display description.
- **QB Code:** Invoice-side business code/item code.
- **QB Description:** Invoice-side invoice description.
- **`qb_list_id`:** Technical QuickBooks ListID/reference, not the same as the business-facing QB Code.

Product/site master logic has been updated to support separate withdrawal and invoice mappings. Do not reintroduce assumptions that one legacy product code or description is always correct for both workflows.

### Site rules

- Sites are maintained as master records.
- Invoice site selection is associated with each invoice line.
- The intended updated design does not rely on a product-level default site.
- Before changing schema or queries involving sites, search the current code for `default_site_id` and confirm the migration's staged cleanup has actually been completed in the target database.

### Amounts and invoice totals

- The invoice preparation page currently computes its displayed sum from saved `invoice_items.amount` values.
- The client invoice detail API likewise calculates `subtotal` by summing saved line amounts.
- Do not assume this is the final QuickBooks invoice total, tax-inclusive total, or total after all discounts/charges. Confirm the actual business rules and schema before changing the label or calculation.
- If the source of the final total is not explicitly represented, label the value accurately as a subtotal/sum of saved line amounts rather than inventing tax or discount rules.

## 5. Authentication, security, and coding conventions

Follow the patterns already used by nearby files.

- Frontend pages generally load the application through `require_once __DIR__ . '/../backend/config/app.php'` or a shared layout that loads it.
- Authenticated pages use `require_login()`.
- Administrator-only client maintenance uses `require_admin()`.
- Product/site management uses the current authorization helper, including `can_manage_products_sites($pdo)` and `require_products_sites_manager()` where appropriate.
- State-changing POST requests should validate CSRF tokens using the existing `verify_csrf()` pattern.
- Use PDO prepared statements for user-provided values. Never concatenate untrusted input into SQL.
- Validate IDs, page numbers, quantities, prices, dates, and status transitions on the server. Browser validation is not a security boundary.
- Keep API responses JSON and use appropriate HTTP status codes for errors.
- Avoid returning raw exception messages or database details to the browser. Log technical details server-side and return a safe message.
- Escape HTML output using the existing `e()` helper.
- Use the existing activity logging conventions for master-data changes.
- Respect existing role and permission behavior. Hiding a button is not sufficient authorization.
- Keep the current frontend design system, shared layout, sidebar, and Bootstrap conventions. Do not add another CSS/JS framework without a clear need.
- Avoid destructive database changes. Do not delete historical products, sites, clients, withdrawals, invoices, or line items just to make a UI change.
- Do not rename tables or columns, change status values, or alter foreign keys without tracing all reads/writes and preparing a safe migration.

## 6. Recent updates already present in the reviewed `main` branch

These are the changes observed in the repository during the handoff review. Confirm the current branch before relying on them.

### A. Dedicated Clients page

- `frontend/clients.php` provides a dedicated Clients screen.
- The shared sidebar contains a Clients navigation link.
- The page supports searching and paginating the client list.
- Clients are displayed as accordion entries.
- Client maintenance actions are restricted to administrators in the page's server-side POST handling.
- Client data remains in the database; moving the UI out of Products & Sites should not delete client records.

### B. Client invoice history API

`backend/api/client_invoice_history.php`:

- Requires login.
- Validates the client ID and checks that the client exists.
- Returns the selected client's invoices, 10 invoices per page.
- Orders history by invoice date and invoice ID descending.
- Aggregates `invoice_items` by invoice before joining the totals to invoice headers, avoiding duplicate invoice header rows due to line-item joins.
- Returns invoice metadata, item count, total quantity, and the sum of stored line amounts.

### C. Invoice details modal and API

`backend/api/client_invoice_detail.php`:

- Requires login and validates invoice/client IDs.
- Checks that the requested invoice belongs to the requested client.
- Loads the invoice header and its saved `invoice_items` rows.
- Joins the site name where available and returns the stored product code/name, description, quantity, unit, price, amount, and tax code fields supported by the query.
- Orders invoice rows by `invoice_items.id`.
- Calculates `subtotal` as the sum of saved `invoice_items.amount`.

The Clients page uses a Bootstrap modal for invoice detail display. Preserve the use of actual invoice rows; do not replace this with withdrawal rows.

### D. Products & Sites separation and mapping work

`frontend/products_sites.php` focuses on product/site master data rather than being the main client-management screen. The current product logic includes separate HT and QB mapping fields and product/site permission checks.

The README documents a staged migration for product/site permissions and mapping cleanup. **Do not assume every migration step has been run in every local database.** The live database must be checked before relying on schema changes or removing legacy columns.

### E. Controlled QA remediation (2026-10-20)

- Client invoice-history loading now uses one error-handled loader for initial load, retry, and pagination. Retry calls the loader directly, and request sequence checks prevent stale responses from overwriting newer pages. Browser interaction testing remains outstanding.
- Invoice detail labels the saved line sum **Line Amount Subtotal**. The API still sums saved line amounts and does not calculate tax-inclusive totals.
- Products & Sites deletion guards count withdrawal, invoice, and Sales Order transaction references. The application directs users to deactivate referenced masters instead.
- `backend/database/migrations/20261020_restrict_historical_master_deletes.sql` changes transaction product/site foreign keys to RESTRICT. Its behavior passed an isolated migration test. A read-only inspection on 2026-10-20 found `RESTRICT` on withdrawal, invoice, and Sales Order product/site foreign keys in the configured `withdrawal_qb` database; no migration ledger exists, so deployment provenance is unknown. Do not rerun the migration there without inspecting the target constraints.
- CSV export neutralizes formula-leading text cells while leaving numeric columns and stored database values unchanged.
- Client, product/site, employee, and product/site permission mutations now commit their business write and activity log together.
- Session bootstrap sets strict mode, HttpOnly, SameSite=Lax, and HTTPS-dependent Secure behavior. Logout is a CSRF-protected POST.
- Login failures are audited without usernames/passwords and limited to 20 failures per source IP per rolling 15 minutes. External firewall, proxy, and router protections remain unverified.
- `PRODUCT_MAPPING_REVIEW.md` summarizes the current active mapping state; `PRODUCT_MAPPING_RECONCILIATION.md` contains the read-only 92-product reconciliation. No inferred or edited mappings are included.
- `tests/qa_regression.php` uses the empty `test` schema and cleans up its fixture tables. It refuses to run against a nonempty test schema.

The remediation and local draft paths received isolated-database, CLI, authenticated HTTP, and Edge browser checks. The 2026-10-20 browser run exercised withdrawal creation/reopen, invoice/Sales Order draft save/reload, narrow table scrolling, mapping display, and invoice/Sales Order print output with synthetic test records. The local Edge session could not load external Bootstrap/SweetAlert CDN assets; a native confirmation fallback was verified, while CDN-dependent styling remains unverified. Role/CRUD coverage, the dedicated withdrawal print route, deployed HTTPS, and QuickBooks integration readiness remain open. See `E2E_REGRESSION_RESULTS.md`.

### E. QuickBooks readiness preparation (2026-10-20)

- `backend/core/quickbooks_readiness.php` performs read-only preflight checks for saved invoice and Sales Order drafts. It checks current client/product active state, customer/item QB ListIDs, QB Code/description, duplicate local mappings, and basic quantity/rate values; it always blocks posting while the connector/company file and mappings remain unverified. It neither creates jobs nor sends requests.
- Invoice saving now requires each `WITHDRAWAL` line to reference a withdrawal item belonging to the source withdrawal and the same product. `ADDITIONAL` remains an explicit valid source type and can omit the source ID. Isolated HTTP coverage rejects missing, invalid, and mismatched source references and accepts an additional line.
- Sales Order draft save now uses the common confirmation attributes/handler. New Sales Order lines preserve an empty QB Description rather than filling it from HT description or product name.
- Read-only mapping inventory found 92 app-active products and 2 inactive; 18 active rows lack QB Code and QB Description, and all 92 lack QB ListID. All 816 active local clients lack QB ListID. The schema has no stock/lifecycle state, so no products were classified as out-of-stock or phased-out and no product/customer data was changed. See `PRODUCT_MAPPING_READINESS.md` and `QUICKBOOKS_READINESS_AUDIT.md`.
- The code/settings name Desktop Enterprise 24.0 and the README describes Web Connector/qbXML as the intended path, but the actual installation, company file, and connector have not been verified. No live/sandbox QuickBooks call or transaction was made. See `QUICKBOOKS_INTEGRATION_DESIGN.md` and `QUICKBOOKS_INTEGRATION_TEST_RESULTS.md`.

## 7. Database and migration safety

The application README documents XAMPP setup and database upgrade steps. Important rules:

- Back up the existing MySQL database before any migration.
- Do not import `schema.sql` over an existing production or working database; it is for initial setup.
- Check the current migration files and migration history before running a script twice.
- The README mentions an invoice-number migration and `backend/database/migrations/20261015_product_site_permissions.sql`.
- The product/site migration is staged. It calls for reviewing duplicate codes and incomplete mappings, completing authoritative HT mappings, deploying compatible PHP files, verifying that the code no longer reads `products.default_site_id`, inspecting `SHOW CREATE TABLE products`, and only then applying the commented final DDL/unique indexes where appropriate.
- Do not manufacture HT codes or QuickBooks IDs. They must come from authoritative company data.
- Preserve historical transaction IDs and invoice-line `site_id` values.
- Inspect actual transaction product/site foreign-key names and delete rules before applying `20261020_restrict_historical_master_deletes.sql`. Apply only to a target with the old `SET NULL` constraints and the Sales Order tables, after backup. This database has no migration ledger, and the configured database inspected on 2026-10-20 already reports the target `RESTRICT` behavior; do not rerun the migration there.
- Validate the migration against the actual database version and real company records before running any DDL.
- Withdrawal and invoice line quantities are whole units in the current form/controller logic and initial schema. The `20261019_whole_number_quantities.sql` migration checks for fractional historical quantities and stops before DDL if any exist; resolve those records against authoritative data rather than rounding them automatically. Price and kg-per-box fields remain decimal values.

## 8. Local development and testing

The application README describes an XAMPP setup. Typical checks:

1. Confirm the project is placed in the intended `htdocs` folder and `APP_BASE_URL` / `WQ_BASE_URL` matches the local URL configuration.
2. Confirm database credentials and the database name in the current configuration.
3. Use a disposable/test database or backup before testing migrations.
4. Log in with a test account appropriate to the role being tested.
5. Test both an administrator and a normal employee / permission-limited account.
6. Check PHP syntax for every modified PHP file.
7. Test actual browser flows, not only direct API calls.
8. Inspect browser console/network errors and PHP/server logs.
9. Test empty data, multiple pages, invalid IDs, inactive records, and server/network failures.
10. Test a real saved invoice with multiple invoice rows and confirm the modal rows match `invoice_items` exactly.
11. Verify that invoice-specific edits do not modify the original withdrawal.
12. Do not mark QuickBooks integration as tested unless it is tested against the intended QuickBooks Enterprise company file through the required Web Connector/qbXML workflow.
13. For repeatable local HTTP testing, follow `E2E_REGRESSION_TEST_PLAN.md`; the two regression scripts require an empty `test` schema, and the PHP test server must use `tests/e2e_db_guard.php` as its auto-prepend guard.

A static source review alone cannot confirm that the application runs against the user's local PHP version, database schema, data, browser, or QuickBooks environment.

## 9. How Codex should work on this repository

At the beginning of a task, Codex should:

1. Read this handoff file.
2. Confirm the checked-out repository, current branch, and working-tree changes. Do not overwrite user changes.
3. Inspect only the files directly involved in the requested task and their immediate dependencies (shared helpers, API/controller, relevant schema/migration, and calling frontend).
4. Search for all references to the affected tables, columns, functions, routes, and status values before changing them.
5. Verify the real schema and current migrations instead of assuming that the local database matches `schema.sql`.
6. Make the smallest safe change that satisfies the request. Avoid broad refactors and unrelated formatting.
7. Preserve the separated frontend/backend architecture and existing UI conventions.
8. Validate server-side authorization, CSRF, input validation, prepared SQL, output escaping, and error handling.
9. Run available syntax checks/tests. If a browser/database/integration test cannot be run, state that explicitly.
10. Review the diff for accidental changes and report:
    - files changed;
    - behavior changed;
    - schema/migration impact;
    - tests actually run and results;
    - tests not run and why;
    - remaining risks or manual steps.

### Do not do these things

- Do not re-analyze every file unless the requested change genuinely requires a broad audit.
- Do not assume a file's existence means the feature works end-to-end.
- Do not fabricate schema columns, functions, endpoints, business rules, or QuickBooks mappings.
- Do not copy invoice detail from `withdrawal_items` when saved `invoice_items` are required.
- Do not silently alter invoice totals, tax behavior, prices, quantities, or status transitions.
- Do not delete or reset database records to make tests pass.
- Do not enable unverified QuickBooks posting.
- Do not report a test as passed unless it was actually run.

## 10. Suggested task prompt for Codex

Paste this after the specific feature or bug request:

> Read `MFC-Operations/PROJECT_HANDOFF.md` first. Treat it as orientation, not as proof that the current code or database is unchanged. Confirm the current branch and working-tree changes, then inspect only the relevant files and their direct dependencies. Search for all references to any affected tables, columns, routes, helpers, and status values before editing. Preserve the frontend/backend separation, existing business rules, historical records, security checks, and QuickBooks integration boundary. Make the smallest safe change. Run the available syntax checks and targeted tests, and clearly distinguish verified results from anything that could not be tested in this environment. Report the exact files changed, tests run, database impact, and remaining risks. Do not perform unrelated refactoring.

## 11. Keep this document current

Update this file whenever a significant change affects:

- folder structure or entry points;
- withdrawal or invoice workflow;
- database tables, columns, indexes, or migrations;
- roles and permissions;
- product/site/client mapping rules;
- invoice calculation rules;
- QuickBooks integration status;
- known bugs, test procedures, or deployment steps.

Prefer concise, verified statements. Mark assumptions and untested behavior explicitly.
