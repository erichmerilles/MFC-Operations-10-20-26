# MFC Operations QA Audit Report

**Audit date:** 2026-10-20  
**Scope:** Read-only baseline audit of the current PHP/MySQL application  
**Repository state:** Branch and working-tree state could not be confirmed because `git` is unavailable in this environment. No existing application files were changed.

## 1. Executive Summary

The source has a clear PHP frontend, shared authentication/helpers, backend controllers/APIs, and a MySQL data model. All 30 PHP files pass PHP 8.2.12 syntax checks. The configured `withdrawal_qb` MariaDB database was inspected read-only: core transaction tables and additive Sales Order/invoice memo schema are present; checked detail relationships have no orphan rows; saved invoice and Sales Order amounts agree with their line calculations; and the withdrawal and invoice quantity columns are unsigned whole-number types.

The audit found several concrete issues that should be addressed before relying on all workflows: active products have incomplete mappings, the invoice-history Retry/pagination error paths are faulty, CSV values are not protected against spreadsheet formula execution, Sales Order product/site references are omitted from master-data deletion guards, and client invoice history labels a sum of saved line amounts as “Invoice Total” without calculating tax. Runtime workflow/security testing and browser/print review were not possible, so release readiness cannot be established.

**Overall assessment: INSUFFICIENT EVIDENCE.** This is not a release approval. The application documentation correctly identifies QuickBooks posting as unimplemented/unverified; no qbXML or Sales Order request processor was found, and no QuickBooks transactions were attempted.

## 2. Project Architecture and Module Inventory

| Module | Main files | Backend dependencies / tables | QA status |
|---|---|---|---|
| Authentication and initial setup | `frontend/login.php`, `frontend/setup.php`, `backend/controllers/logout.php`, `backend/core/auth.php` | `employees`, `activity_logs`; password hashing and session helpers | Source inspected; syntax passes; live login/logout and access-control cases blocked |
| Dashboard and navigation | `frontend/dashboard.php`, `frontend/includes/*` | `withdrawals`, `withdrawal_items`, `clients`, `qb_jobs` | Source inspected; browser behavior not exercised |
| Withdrawal register, editing, and printing | `frontend/withdrawals.php`, `frontend/withdrawal_form.php`, `frontend/withdrawal_print.php`, `backend/controllers/withdrawal_save.php` | `withdrawals`, `withdrawal_items`, `clients`, `products`, `sites`, `activity_logs` | Source and database consistency inspected; form/save/print runtime tests blocked |
| Client management and invoice history | `frontend/clients.php`, `backend/api/client_invoice_history.php`, `backend/api/client_invoice_detail.php` | `clients`, `invoices`, `invoice_items`, `withdrawals`, `sites` | Source/API query inspected; Retry defect found; HTTP/UI tests blocked |
| Product and site master | `frontend/products_sites.php`, `backend/api/products.php`, `backend/core/auth.php` | `products`, `sites`, `employee_permissions`, transaction references | Permission checks and mapping data inspected; incomplete active mappings found |
| Invoice preparation | `frontend/invoice_preparation.php`, `backend/controllers/invoice_save.php` | `invoices`, `invoice_items`, `withdrawals`, `products`, `sites`, `clients` | Source and stored calculations inspected; data consistency passes; UI/save behavior blocked |
| Sales Order preparation | `frontend/sales_order_preparation.php`, `backend/controllers/sales_order_save.php` | `sales_orders`, `sales_order_items`, `withdrawals`, `products`, `sites`, `clients` | Local-only workflow confirmed; stored calculations pass; no QB posting implementation found |
| QuickBooks status | `frontend/quickbooks_status.php` | `qb_jobs`, invoices and related records | Empty queue observed; page is status/history only, not a posting service |
| Withdrawal CSV export | `backend/exports/withdrawals.php` | Withdrawal and client tables | Source inspected; spreadsheet formula-injection risk found; browser/download test blocked |
| Shared UI and formatting | `frontend/assets/css/app.css`, `frontend/assets/js/app.js`, shared header/footer | Bootstrap and SweetAlert2 from jsDelivr | Source inspected; JavaScript execution, responsive rendering, and console checks blocked |

The project keeps major responsibilities in the expected folders, but several frontend pages (`clients.php`, `products_sites.php`, `settings.php`, and preparation pages) contain direct PDO queries and some write logic. This is the established architecture in the current source; no refactor was performed as part of this audit.

## 3. Features Identified

- Login with `password_verify`, hashed account creation, session regeneration after login, role checks, CSRF tokens, and activity logging.
- Withdrawal register/search, add/edit form, product autocomplete, integer quantity validation, source-preserving transaction save, CSV export, and print view.
- Client maintenance for administrators, client search/pagination, invoice-history pagination, and invoice detail modal/API.
- Product/site master maintenance with administrator or delegated product/site permission checks and separate HT/QB code and description fields.
- Locally stored invoice drafts with line validation, QB Code validation, saved amount recalculation, memo, tax choice, and no active QuickBooks posting.
- Separate locally stored Sales Order drafts with QB Code display/validation, line amounts, and no active QuickBooks posting.
- QuickBooks status page backed by `qb_jobs`; it does not perform the Web Connector transaction processing.

## 4. Testing Environment and Limitations

- PHP CLI: **8.2.12** (`C:\xampp\php\php.exe`).
- Database: configured database name `withdrawal_qb`; server reports **MariaDB 10.4.32**. The database was queried read-only. SQL mode: `NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION`.
- PHP CLI reports `session.use_strict_mode=Off`, `session.cookie_httponly=Off`, `session.cookie_secure=Off`, and no `session.cookie_samesite` value. The web SAPI may use a different php.ini; its settings were not verified.
- Git is not installed/available, so current branch and pre-existing worktree changes could not be confirmed.
- A request to `http://localhost/MFC-Operations/frontend/login.php` returned no HTTP response. No browser executable, Node/npm, PHPUnit, Composer, or static-analysis executable was available through `PATH`.
- No test account was used, no application rows were inserted/updated/deleted, and no migration was run. No QuickBooks Desktop company file/Web Connector was available.
- The live database includes an additional `product_mapping_import_stage` table with 99 rows and 9 columns. It is not defined in the checked-in schema/migrations or referenced by application code. Its purpose/retention owner should be confirmed before any cleanup; no row values were inspected.

## 5. Test Execution Summary

The test-case catalog below has **20** cases: **9 executed** (8 passed, 1 failed), **10 blocked**, **0 not tested**, and **1 not applicable**. “Failed” here refers to the active Product Master mapping completeness check, not to a destructive or workflow test.

| ID | Module / scenario | Expected result | Actual result | Status |
|---|---|---|---|---|
| T01 | PHP syntax, all 30 PHP files | No parse errors | All 30 passed `php -l` | PASS |
| T02 | Connect to configured database and identify engine/version | Read-only connection succeeds | Connected to `withdrawal_qb`; MariaDB 10.4.32 | PASS |
| T03 | Required invoice/Sales Order schema present | Fields/tables used by current code exist | Invoice `invoice_number`/`memo`, `sales_orders`, and `sales_order_items` present | PASS |
| T04 | Transaction table engines and declared foreign keys | InnoDB tables and expected referential constraints | All listed application tables use InnoDB; expected FK relationships are present | PASS |
| T05 | Withdrawal, invoice, Sales Order line orphan checks | No detail rows without headers | Zero orphan withdrawal, invoice, or Sales Order detail rows in checked joins | PASS |
| T06 | Whole-number quantity data/schema | No fractional history; whole-number columns | Zero fractional withdrawal/invoice quantities; both columns are `BIGINT UNSIGNED NOT NULL` | PASS |
| T07 | Stored line amount consistency | Stored amount equals rounded quantity × price/rate | Zero mismatches across current invoice and Sales Order line rows | PASS |
| T08 | Duplicate withdrawal, invoice, and Sales Order numbers | No duplicate nonblank identifiers | Zero duplicates in checked groups | PASS |
| T09 | Active Product Master mapping completeness | Active products used by invoice/Sales Order workflows have required authoritative mappings | 18 active products lack QB Code, 18 lack QB Description, 1 lacks HT Code; 92 active products lack QB ListID | FAIL |
| T10 | Login/logout and protected-page authorization | Valid/invalid login and anonymous access behave correctly | Could not run without the web runtime and test credentials | BLOCKED |
| T11 | Client/product/site CRUD, CSRF, and authorization | Valid actions save; invalid/unauthorized actions reject | No safe test database; no test writes made | BLOCKED |
| T12 | Withdrawal create/edit, quantity validation, and print flow | Values save/reload correctly; invalid requests reject | No web runtime/test fixture; not executed | BLOCKED |
| T13 | Invoice draft load/edit/validation/round trip | Saved lines and header reload without corrupting source withdrawal | No browser-authenticated round trip; not executed | BLOCKED |
| T14 | Sales Order draft load/edit/mapping/validation round trip | Draft persists and remains separate from withdrawal/invoice records | No browser-authenticated round trip; not executed | BLOCKED |
| T15 | Client invoice-history APIs and pagination/retry | API errors recover visibly and preserve pagination state | Source paths inspected; HTTP behavior could not be run | BLOCKED |
| T16 | Responsive desktop/mobile rendering and browser console | No layout overflow or JavaScript errors beyond intentional table scroll | No browser available | BLOCKED |
| T17 | Print preview, page breaks, and print output | Output is complete and legible | No browser/PDF print engine available | BLOCKED |
| T18 | Dynamic security cases (CSRF, IDOR, XSS, SQL injection) | Unauthorized/manipulated requests are rejected | Static review only; dynamic testing not available | BLOCKED |
| T19 | JavaScript syntax/runtime checks | JavaScript parses and interactions run | Node/npm and browser runtime unavailable | BLOCKED |
| T20 | QuickBooks transaction creation | Verified QB transaction and returned identifiers | Not applicable: Web Connector/qbXML transaction submission is explicitly not implemented | NOT APPLICABLE |

## 6. Detailed Functional Test Results

### Verified from read-only database checks

Current aggregate counts: 2 employees, 819 clients, 94 products (92 active), 3 withdrawals with 4 lines, 2 invoices with 3 lines, 1 Sales Order with 2 lines, and 0 QuickBooks jobs. These counts do not independently prove successful end-user workflows.

- No duplicate withdrawal numbers, nonblank invoice numbers, or nonblank Sales Order numbers were found.
- Invoice and Sales Order line amounts matched the stored quantity × price/rate calculation for all existing rows.
- The one active product missing an HT Code and the 18 missing QB Code/QB Description mappings are legacy/product-master readiness issues. The application should not invent mappings to resolve them.
- All 92 active products lack a QB ListID. This is consistent with the documented non-integrated state and prevents proving a QuickBooks item reference mapping.
- Two actual withdrawal lines were read-only compared to their Product Master mapping: withdrawal HT codes `HSC045-042` and `HSC045-075` mapped to QB Codes `LUTBE10182504` and `LUTCN77ORG10010`, respectively. Their QB ListIDs were empty. This confirms distinct codes in the data; it does not constitute a browser/UI or QB transaction test.

### Static behavior review

- Mutating controllers/pages generally require login and CSRF verification; Product & Sites mutators also check the delegated permission. Prepared statements are used for user-supplied database values in inspected handlers.
- Invoice save locks the invoice row, validates mapping and fields, recalculates amounts on the server, and updates header/lines in a transaction.
- Sales Order save validates selected product/site records and recalculates line amounts on the server. Sales Order preparation and save remain local-only.
- API invoice detail scopes the invoice by both invoice ID and client ID. The client-history/details JavaScript HTML-escapes returned text before interpolation.
- Static review is not proof against runtime SQL, browser, permission, or race-condition failures.

## 7. Database and Data Integrity Findings

- The live database has the additive invoice memo and Sales Order tables required by current pages. The Sales Order migration appears applied in this database; no migration was executed during QA.
- All checked application tables use InnoDB and expected foreign keys are present. Withdrawal and invoice quantities are whole-number columns; Sales Order ordered/fulfilled quantities are also defined as unsigned whole-number columns.
- Checked detail rows have no orphans, and persisted amount calculations are consistent.
- Product Master readiness is incomplete: 18 active products lack QB Code, 18 lack QB Description, 1 lacks HT Code, and all 92 active products lack `qb_list_id`. The empty ListIDs are a known integration limitation, but missing QB business codes/descriptions block use of some active products in invoice/Sales Order preparation.
- `product_mapping_import_stage` is a live 99-row table outside the project’s current schema/migration inventory. It was not modified or inspected at row level.
- The Sales Order schema uses `ON DELETE SET NULL` for product and site references. The Products & Sites delete checks currently count withdrawal/invoice references but omit Sales Order references; see F02.

## 8. Backend and API Findings

- The inspected transaction controllers use prepared SQL for submitted identifiers and wrap multi-row withdrawal/invoice/Sales Order writes in transactions.
- Client invoice detail verifies ownership by requiring `invoice_id` and `client_id` to match the same invoice.
- Client invoice-history pagination interpolates only fixed-size/validated integer-derived LIMIT/OFFSET values; the client list clamps the requested page to its computed page count.
- The withdrawal export is authenticated, but values are written directly through `fputcsv` without formula neutralization; see F03.
- Master-data operations mutate records and then write activity logs without a transaction. If logging fails after the primary write, the user can receive an error although the change has committed; see F06.
- No Sales Order QBXML builder, Web Connector processor, or supported item-reference resolution request was found. The Sales Order page explicitly states posting is unavailable.

## 9. Frontend and Print QA Findings

- Shared layout, Bootstrap, reusable form/table styles, and responsive table wrappers are used. The Sales Order table intentionally scrolls horizontally for its 13 columns.
- Dynamic client history and invoice detail values are passed through an `escapeHtml` helper before being inserted into HTML.
- Client invoice history has a broken Retry action and unhandled pagination failure path; see F04.
- Client invoice details label the sum of stored line amounts as “Invoice Total”; tax is not calculated by the API and invoice preparation itself states tax follows QuickBooks configuration; see F05.
- No screenshot, browser console, narrow viewport comparison, modal interaction, or print output was captured because no browser/HTTP server was available.

## 10. Security Findings

- **F03 (P2):** CSV formula injection risk in withdrawal export. User-controlled remarks and other text are passed to `fputcsv`; CSV quoting alone does not neutralize spreadsheet formula-leading values.
- **F07 (P2, deployment hardening):** Session cookie flags are not set in application bootstrap. The CLI PHP settings report strict mode off, HttpOnly off, Secure off, and no SameSite value. Confirm the web SAPI settings; the application does regenerate the session ID on successful login.
- **F08 (P2, conditional exposure):** No application-level login throttling/lockout was found. Network-layer throttling was not assessable. Risk depends on whether the login is reachable beyond a trusted local network.
- **F09 (P3):** Logout is a state-changing GET with no CSRF check. A cross-site navigation can log a user out; it does not directly modify business records.
- No obvious SQL concatenation of untrusted values or unescaped dynamic client-history HTML was found in the inspected handlers/pages. These are static observations only, not penetration-test results.

## 11. Defect Register (Sorted by Severity)

### F01 — P1 — Incomplete mappings for active products

- **Affected module:** Product Master, invoice preparation, Sales Order preparation.
- **Evidence:** Read-only database check found 18 active products with no QB Code, 18 with no QB Description, and 1 with no HT Code. Invoice product choices are filtered by QB Code; Sales Order allows selection of products without a code but blocks save with a mapping error.
- **Reproduction:** Select one of the active unmapped products in Product Master/withdrawal data, then attempt invoice or Sales Order preparation.
- **Expected:** Active operational products have mappings confirmed against the authoritative lists.
- **Actual:** The application data marks products active despite missing invoice/Sales Order mappings, so the products can enter withdrawals but cannot complete those preparation workflows.
- **Probable cause:** Legacy or imported product records predate mapping completeness enforcement.
- **Recommended correction:** Review and complete mappings from authoritative company records, or deactivate products only after the business owner confirms they are no longer selectable. Do not invent codes.
- **Regression tests:** Verify each affected product’s withdrawal availability and invoice/Sales Order handling after mapping review.

### F02 — P2 — Product/site deletion guards omit Sales Order references

- **Affected module:** Products & Sites; Sales Order history.
- **Evidence:** `frontend/products_sites.php` counts withdrawal and invoice product references but not `sales_order_items`; site deletion counts invoice references but not Sales Order lines. `20261019_sales_order_preparation.sql` defines Sales Order product/site FKs with `ON DELETE SET NULL`.
- **Reproduction:** Create a valid Sales Order line for a product/site that has no withdrawal/invoice references, then delete that master record. The master record can be deleted and the Sales Order FK becomes NULL.
- **Expected:** Historical Sales Order mappings remain linked or the master record is protected from deletion.
- **Actual:** Sales Order-only references are not considered by the UI deletion guard; the database silently clears the FK.
- **Current-data note:** No current product/site matched the exact “Sales Order refs but no withdrawal/invoice refs” candidate query, so this is a latent path rather than observed historical loss.
- **Recommended correction:** Include Sales Order line references in counts, delete guards, and “in use” messaging; prefer deactivation for referenced records.
- **Regression tests:** Attempt product/site deletion for Sales Order-only references and verify it is blocked without changing historical lines.

### F03 — P2 — Withdrawal CSV export does not neutralize spreadsheet formulas

- **Affected module:** Withdrawal CSV export.
- **Evidence:** `backend/exports/withdrawals.php:8` passes database values directly to `fputcsv`; withdrawal remarks accept free text in `backend/controllers/withdrawal_save.php`.
- **Reproduction:** Save a withdrawal remark beginning with a spreadsheet formula prefix such as `=`, `+`, `-`, or `@`, export the register, then open the CSV in spreadsheet software.
- **Expected:** Exported text remains inert when opened in spreadsheet software.
- **Actual:** CSV quoting is used, but no formula-prefix neutralization is applied.
- **Recommended correction:** Escape formula-leading cells in the CSV export while preserving the stored value in MySQL.
- **Regression tests:** Export values with formula prefixes, leading whitespace, commas, quotes, and newlines; confirm safe display and valid CSV parsing.

### F04 — P2 — Client invoice-history Retry and pagination failures do not recover correctly

- **Affected module:** `frontend/clients.php` invoice-history accordion.
- **Evidence:** Retry handler clicks the accordion button (`frontend/clients.php:160-163`), which toggles/collapses an already-open panel instead of directly retrying the request. Pagination handlers call `loadHistory()` without a rejection handler (`:201`); the loader sets “Loading” before awaiting the request (`:168-175`).
- **Reproduction:** Expand a client while the history request fails; click Retry. Separately, click a history page while that request fails.
- **Expected:** Retry reruns the failed page request while keeping the accordion open; pagination failures show a retryable error and retain the current page.
- **Actual:** Retry can collapse the panel; a pagination failure can leave the history area on “Loading invoice history…” with an unhandled rejection.
- **Recommended correction:** Call the loader directly from Retry and wrap all pagination requests in shared error-state handling.
- **Regression tests:** Simulate initial-load and page-change network/500 failures, then retry and verify page/accordion state.

### F05 — P2 — Invoice detail calls saved line sum “Invoice Total”

- **Affected module:** Client invoice detail modal.
- **Evidence:** `backend/api/client_invoice_detail.php` sets `subtotal` to the sum of `invoice_items.amount`; `frontend/clients.php:234` labels it “Invoice Total.” No tax calculation is performed by this API, and invoice preparation says tax treatment follows QuickBooks configuration.
- **Reproduction:** Open an invoice with taxable lines and compare the modal label with the actual sum of stored line amounts.
- **Expected:** The label describes the value actually calculated, or a verified final tax-inclusive invoice total is used.
- **Actual:** A saved-line subtotal is presented as the invoice total despite tax not being calculated here.
- **Recommended correction:** Label the value “Line Amount Subtotal” unless a verified tax-inclusive total becomes available.
- **Regression tests:** Confirm label and amount semantics for taxable, non-taxable, and mixed lines.

### F06 — P2 — Master-data changes and activity logging are not atomic

- **Affected module:** Clients, Products & Sites, employee/permission administration.
- **Evidence:** Pages perform a primary INSERT/UPDATE/DELETE and then call `log_activity()` without an enclosing transaction (for example `frontend/clients.php:26,30`, `frontend/products_sites.php:23,56,72`, and `frontend/settings.php:21,24,37`).
- **Reproduction:** Cause the activity-log insert to fail after a valid master-data write (for example in a controlled test database with a failing log insert).
- **Expected:** Either both the change and its audit record commit, or neither commits and the UI reports failure.
- **Actual:** The primary write is autocommitted before logging; a later log failure can report an error even though the business change persisted.
- **Recommended correction:** Wrap each related business mutation and audit insert in a database transaction.
- **Regression tests:** Inject a log failure and verify rollback of each covered mutation.

### F07 — P2 — Session cookie hardening is not explicit in bootstrap

- **Affected module:** Authentication/session security.
- **Evidence:** `backend/config/app.php:4-5` starts a session without setting cookie flags. PHP CLI reports strict mode, HttpOnly, Secure, and SameSite values as noted above; Apache/web SAPI values are unknown.
- **Expected:** Production deployment uses strict session IDs, HttpOnly, appropriate SameSite, and Secure on HTTPS.
- **Actual:** The app does not set these options itself; the observed CLI defaults are weak.
- **Recommended correction:** Confirm the web SAPI configuration and set appropriate session cookie parameters before `session_start()` for the deployment protocol.
- **Regression tests:** Inspect response `Set-Cookie` headers over the actual deployment URL and test login session rotation.

### F08 — P2 — No application login throttling was found

- **Affected module:** Login.
- **Evidence:** `frontend/login.php` performs a username lookup and `password_verify()` per POST; no rate limiter, lockout, or failed-attempt counter was found in the application source.
- **Expected:** Repeated credential guessing is throttled by the app or a verified network control.
- **Actual:** No application control was found; upstream controls were not assessable.
- **Recommended correction:** Confirm a trusted-network boundary or add a rate limit that does not enable easy account-denial attacks.
- **Regression tests:** Exercise repeated failures and verify throttling, auditability, and recovery for valid users.

### F09 — P3 — Logout is a state-changing GET without CSRF validation

- **Affected module:** `backend/controllers/logout.php`.
- **Evidence:** The endpoint calls `logout_user()` on any method and does not call `verify_csrf()`.
- **Expected:** Logout should be an intentional same-origin action protected against cross-site navigation if that behavior is required by the application’s threat model.
- **Actual:** A cross-site link/image navigation can terminate the session.
- **Recommended correction:** Make logout a CSRF-protected POST action.
- **Regression tests:** Verify GET is rejected and valid same-origin POST ends the session.

## 12. Screenshots, Logs, and Reproduction Evidence

- No screenshots or browser console logs were available; the browser runtime was unavailable.
- PHP lint output: 30 PHP files checked, 0 syntax failures.
- Database checks were read-only and reported aggregate counts only; no credentials or row-level personal information are included here.
- To reproduce client-history defects, use browser developer tools to force the invoice-history endpoint to return a network error/500 and exercise both Retry and a pagination button.
- To reproduce the CSV risk, use a disposable test database and a free-text remark beginning with a spreadsheet formula prefix; do not use live accounting data.

## 13. Recommended Fix Order

1. Resolve active product mapping completeness using authoritative HT/QB lists; do not fabricate QB Codes, descriptions, or ListIDs.
2. Protect Sales Order product/site historical references from master-data deletion.
3. Neutralize spreadsheet formula values in CSV output.
4. Correct client invoice-history Retry and pagination error handling.
5. Relabel the invoice line sum accurately.
6. Make master-data writes and activity logs atomic.
7. Confirm and harden web-session cookie policy; verify login throttling and convert logout to CSRF-protected POST.
8. Run authenticated functional and responsive/print tests on a disposable database and browser.
9. Treat QuickBooks integration as a separate implementation/testing milestone; populate real ListIDs and verify Web Connector/qbXML only against an approved test company file.

## 14. Regression Testing Plan

- Run `php -l` across all PHP files after each remediation.
- Use a disposable MySQL/MariaDB database with copied schema and nonfinancial fixtures; test invalid and valid CRUD submissions, CSRF rejection, duplicate/race paths, and audit-log rollback.
- Verify invoice/Sales Order line-required fields, mapping failures, server-calculated amounts, historic withdrawal preservation, and product/site deletion blocking.
- Exercise client-history first load, pagination, retry, and invoice-detail ownership with network failures and special-character fields.
- Export CSV fixtures containing formula prefixes and CSV punctuation, then inspect the output in a spreadsheet-compatible test environment.
- Test login, role restrictions, session cookie headers, session rotation, and logout using the actual web SAPI.
- Use a browser at desktop and narrow widths; inspect console/network errors and print previews for withdrawal forms.
- Do not run QB transactions until the Web Connector and company-file mappings are implemented and verified in a dedicated QuickBooks test company.

## 15. Outstanding Risks and Blocked Tests

- Core create/edit UI workflows were not exercised end to end because no local HTTP server/browser session and no isolated test database workflow were available.
- Login authorization, CSRF, direct endpoint access, and session cookie behavior under Apache remain unverified.
- JavaScript parsing/runtime errors, visual overflow, mobile usability, and print pagination remain unverified.
- Concurrent duplicate submissions and database failure/recovery behavior were not stress-tested.
- 92 active products have no QB ListID; the current application contains no QuickBooks transaction processor. No QuickBooks result can be claimed.
- The extra `product_mapping_import_stage` table’s owner and lifecycle are unknown.
- Current `withdrawal_qb` row counts are small, so query performance/scaling was not meaningfully tested.

## 16. Overall QA Assessment

**INSUFFICIENT EVIDENCE.** The remediation checks below improve coverage, but full authenticated browser workflows, deployment HTTPS behavior, and production migration execution remain unverified. QuickBooks integration remains explicitly unimplemented/unverified and must not be treated as a working feature.

## 17. Controlled Remediation and Regression Results (2026-10-20)

The original audit findings and test table above are retained as the baseline. The results here supersede only the corresponding remediation status. No writes were made to the configured `withdrawal_qb` database and no QuickBooks transaction was created.

| Finding | Baseline | Current result | Evidence and remaining work |
|---|---|---|---|
| F01 Product mappings | Incomplete active mappings | **Unresolved; safe review prepared** | `PRODUCT_MAPPING_REVIEW.md` lists active products with missing values using stable IDs and current mapping fields. Current read-only counts remain: 1 missing HT Code, 18 missing QB Codes, 18 missing QB Descriptions, and 92 missing ListIDs. No product mapping or active state was changed. Business mappings need authoritative company confirmation; ListIDs need a future verified QuickBooks lookup. |
| F02 Historical references | Deletion guards omitted Sales Orders; FKs used `SET NULL` | **Code fixed; production migration pending** | Product/site guards and displayed reference counts include Sales Orders. A migration changes withdrawal, invoice, and Sales Order transaction product/site FKs to `RESTRICT`, preserving nullable links and existing rows. The migration and SO-only, mixed-reference, unused-delete cases passed in the isolated `test` schema. It was not applied to `withdrawal_qb`; until applied, direct database deletion can still clear those links. |
| F03 CSV formula injection | Text cells passed directly to `fputcsv` | **Fixed and focused-tested** | Text output cells are neutralized when formula prefixes follow whitespace/control/format characters; numeric quantity and line columns are not transformed. The isolated test covered `=`, `+`, `-`, `@`, leading controls, commas, quotes, embedded newlines, and ordinary text. Stored database values are not updated. |
| F04 Invoice-history retry | Retry toggled accordion; pagination failures were unhandled | **Code fixed; browser scenarios unverified** | One loader handles initial load, retry, and pagination; failures render a retry action; request IDs ignore stale responses. Static checks passed. No browser assertion result was obtained, so the required network/HTTP failure, client-switch, empty-history, and final-page interactions remain unverified. |
| F05 Invoice total label | Saved line sum labeled `Invoice Total` | **Label corrected** | Detail UI now says `Line Amount Subtotal`; the API continues to return the sum of stored line amounts and performs no tax calculation. Source checks passed; taxable/non-taxable browser examples were not exercised. |
| F06 Business/audit atomicity | Master writes could commit before log insertion | **Code fixed; isolated transaction behavior tested** | Client, product/site, employee, and permission updates now begin, commit, and roll back with their activity entries. A disposable test-schema transaction confirmed that a simulated audit failure rolls back its business write; source guards confirm transaction handling in all three pages. Authenticated handler-level CRUD was not run. |
| F07 Session cookies | Bootstrap relied on implicit defaults | **Code fixed; HTTP and CLI checks passed** | Apache login GET returned a session cookie with `HttpOnly` and `SameSite=Lax` over local HTTP, without `Secure`. CLI probes confirmed strict mode, HTTPS-dependent `Secure`, and login session-ID rotation. HTTPS response headers and the deployed web SAPI remain unverified. |
| F08 Login throttling | No app limiter or verified upstream limit | **App limiter added and isolated-tested** | The app records generic failed-login events without usernames/passwords and throttles after 20 failures from one source IP in 15 minutes; attempts age out, so no permanent account lock is created. Apache configuration showed no request-throttling module configured. Network firewall, proxy, and router controls were not accessible for review. Shared-IP throttling is a short-lived operational risk. |
| F09 Logout CSRF | Logout was a state-changing GET | **POST/CSRF code and local HTTP paths checked** | Logout GET returned 405, a POST without a token returned 403, a valid-token POST returned 302, and the protected dashboard redirected after logout. The HTTP test used an anonymous session; authenticated sign-in/out was not exercised. Shared CSRF verification rejects absent tokens on either side and now uses a standard 403 response. |

### Remediation files

- Modified: `backend/core/functions.php`, `backend/config/app.php`, `backend/exports/withdrawals.php`, `backend/controllers/logout.php`, `frontend/login.php`, `frontend/includes/topbar.php`, `frontend/clients.php`, `frontend/products_sites.php`, `frontend/settings.php`, `backend/database/schema.sql`, `README.md`, and `PROJECT_HANDOFF.md`.
- Added: `backend/database/migrations/20261020_restrict_historical_master_deletes.sql`, `tests/qa_regression.php`, and the controlled internal `PRODUCT_MAPPING_REVIEW.md`.

### Checks performed

- PHP 8.2.12 syntax check: **31 PHP files passed**.
- `php tests/qa_regression.php`: **passed** for isolated Sales Order-only and mixed product/site reference protection, genuinely unused deletes, existing Sales Order link preservation, CSV neutralization/quoting, audit-failure rollback, login-throttle threshold and recovery, and source assertions for the UI/API changes.
- The MariaDB `test` schema was empty before the regression run and empty after fixture cleanup. The configured `withdrawal_qb` schema was queried read-only only.
- Read-only current-schema query confirmed the modified reference-count queries are compatible with present transaction tables. No data migration was applied to the configured database.
- Local Apache HTTP checks: login GET 200 with expected cookie attributes; logout GET 405; POST without a CSRF token 403; valid-token POST 302; dashboard after logout 302 to login.
- Session configuration CLI probes: strict mode enabled, HttpOnly true, SameSite Lax, Secure false for HTTP and true when HTTPS is indicated; `login_user()` rotated the session ID in both probes.
- No existing PHPUnit/Composer test suite, JavaScript runtime harness, usable browser automation result, or live QuickBooks environment was available. The attempted headless Edge history test did not produce a result; browser interaction acceptance cases remain blocked.
- Git remains unavailable, so branch and pre-existing worktree state cannot be confirmed.

### Deployment steps and remaining risks

1. Back up the target database, inspect its actual FK names and Sales Order migration status, then run `20261020_restrict_historical_master_deletes.sql` once. Do not run it against a schema that already has the replacement constraints.
2. Confirm authoritative HT/QB codes and descriptions for the rows in `PRODUCT_MAPPING_REVIEW.md`. Do not populate ListIDs until a verified QuickBooks lookup workflow exists.
3. Verify Apache HTTPS termination sets `HTTPS`/port state correctly so session cookies receive `Secure`; assess any reverse proxy, firewall, or network-level login controls.
4. Exercise authenticated client/product/site/settings CRUD, failed audit logging, login throttling from the actual staff network, logout/session rotation, and invoice-history retries in a browser using disposable fixtures.
5. Keep QuickBooks readiness **not verified**. The current code still has no Sales Order posting processor or verified QBXML flow.
