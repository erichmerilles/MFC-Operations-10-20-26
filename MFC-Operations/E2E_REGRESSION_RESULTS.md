# MFC Operations E2E Regression Results

**Run date:** 2026-10-20 (Asia/Taipei)  
**Environment:** Windows/XAMPP PHP CLI and MariaDB 10.4.32, PHP 8.2.12.  
**Test database:** `test` (isolated; verified empty before setup and after cleanup).  
**Operational database:** `withdrawal_qb` (read-only inspection only).  
**QuickBooks:** no posting attempted.

**Phase 2 browser run:** 2026-10-20, Microsoft Edge 155.0.4283.62 via Edge DevTools Protocol; test pages used the guarded `test` database and synthetic fixtures. Evidence is in [`tests/evidence/phase2/`](tests/evidence/phase2/).

## Baseline and scope

- Git executable was unavailable in this environment. Branch, commit hash, and full working-tree state at test start could not be established. This report does not claim a clean working tree.
- Preserved the pre-existing code and local documentation; added a repeatable guarded HTTP test and QA deliverables. No application workflow implementation was changed during this test run.
- PHP: 8.2.12. MariaDB: 10.4.32. Required `pdo_mysql`, `curl`, and `mbstring` extensions were present.
- No Composer/PHPUnit, Node/npm, Playwright, or chromedriver command/configuration was available. Edge was installed, so browser checks used its DevTools Protocol in an isolated temporary profile.
- Final syntax check included 34 PHP files (including QA and E2E support scripts).

## Commands and execution

1. `php tests/qa_regression.php` — passed in the isolated `test` schema. It exercised historical-reference protection, CSV sanitization, audit-failure rollback, login throttling/window recovery, and source-level invoice-history/subtotal/logout guards. The suite removed its fixtures.
2. Started PHP 8.2's built-in server on `127.0.0.1:18765` with `WQ_DB_NAME=test`, an isolated session directory, `WQ_BASE_URL=/`, and `tests/e2e_db_guard.php` as `auto_prepend_file`. The guard checks the server's connected schema is exactly `test` before PHP page/controller code runs.
3. `MFC_E2E_BASE_URL=http://127.0.0.1:18765 php tests/e2e_http_regression.php` (PowerShell environment assignments) — **14 HTTP/database cases passed**. It imported current DDL and the Sales Order draft migration into the empty test schema, used only synthetic fixtures, and cleaned the created schema tables.
4. `php -l` across all 34 project PHP files — all passed.
5. Read-only schema/data queries against `withdrawal_qb`; no insert, update, delete, DDL, or migration was run against it.
6. Edge browser session against the guarded local server: created/reopened a two-line withdrawal (quantities 10 and 2), saved/reloaded invoice and Sales Order drafts, checked QB codes/descriptions and the exact Sales Order columns, captured 1440×1000 and 768×1024 views, and generated landscape invoice/Sales Order print PDFs.
7. `php tests/qa_regression.php` after adding the F10 assertions — all six groups passed; the test schema returned to zero tables.

## Regression matrix results

| ID | Expected result | Actual result / evidence | Status |
|---|---|---|---|
| AUTH-HTTP-01 | Unauthenticated protected access redirects to login | Dashboard returned 302 before login | PASS |
| AUTH-HTTP-02 | Invalid login is generic; valid login rotates session | Generic invalid message; synthetic Admin login returned 302; PHPSESSID changed | PASS |
| AUTH-HTTP-03 | Session cookie has HttpOnly/SameSite; Secure follows HTTPS | Authenticated HTTP response had HttpOnly and SameSite=Lax; no Secure on HTTP | PASS |
| AUTH-HTTP-04A | Logout without CSRF rejected | POST without token returned 403 | PASS |
| AUTH-HTTP-04 | Logout with CSRF invalidates session | Valid POST redirected; replayed old session to protected dashboard redirected to login | PASS |
| WITHDRAWAL-HTTP-01 | Two-line withdrawal persists and reopens accurately | Created through form/controller; DB header, two lines, quantities, and reopened product verified | PASS |
| CSV-HTTP-01 | Export keeps CSV structure and neutralizes formula input | CSV response parsed with `fgetcsv`; formula prefix neutralized; quote/comma/newline preserved | PASS |
| INVOICE-HTTP-01 | Invoice draft source integrity and explicit additional-line behavior | Two mapped lines and one explicit `ADDITIONAL` line persisted; missing/invalid source IDs and mismatched source products were rejected with the previous draft intact | PASS |
| SALES-ORDER-HTTP-01 | SO header, 13 columns, mappings, readiness, and totals are correct | `S.O. NO.`; exact column order; mapped QB Codes/ListIDs; missing QB description stayed blank on initial copy; saved descriptions/memo and amounts were verified; readiness panel rendered | PASS |
| SALES-ORDER-HTTP-02 | Missing required SITE rejected on backend | Direct POST returned line 1 SITE error; previous draft and lines unchanged | PASS |
| SALES-ORDER-HTTP-03 | Missing QB mapping blocks save; no fallback | Temporarily blanked synthetic product mapping; line 2 error returned; saved draft unchanged; test mapping restored | PASS |
| SALES-ORDER-HTTP-04 | Invalid monetary grouping rejected | Direct POST with RATE `1,2` returned line 1 RATE error; saved draft unchanged | PASS |
| INTEGRITY-HTTP-01 | Invoice/SO drafts remain separate from withdrawal; audit entries exist | Original HT codes, product labels, quantities persisted unchanged; separate invoice/SO rows and audit events verified | PASS |
| F02-DB | Product/site historical references protected; unused records remain deletable | Isolated migration test covered SO-only and mixed references, rejected referenced deletes, accepted unused deletes | PASS |
| F03-CSV | Formula leads and control characters neutralized without damaging normal CSV | Isolated cases covered `=`, `+`, `-`, `@`, controls, ordinary strings, quoting, and newlines | PASS |
| F06-DB | Business write rolls back if audit insert fails | Synthetic FK failure rolled back business row in isolated transaction | PASS |
| F08-DB | Login throttle is per IP and recovers after window | 20 failed records throttled one IP, did not affect another, recovered after 16 minutes | PASS |
| F04/F05/F09-SRC | Retry, subtotal wording, API, logout method/token guards match expectations | Source assertions passed; these do not prove browser behavior | PASS (source-level only) |
| PHP-LINT | All PHP files parse | 34 files passed `php -l` | PASS |
| F11-SOURCE-READINESS | Invoice/Sales Order QuickBooks preparation guards remain present | QA assertions cover strict invoice source validation, shared Sales Order confirmation, no HT description fallback, and central readiness checks | PASS |
| OPERATIONAL-FK-READ | Configured schema has historical product/site delete rules | `information_schema` showed `RESTRICT` on withdrawal, invoice, and Sales Order product/site references | PASS (read-only inspection) |
| UI-BROWSER | Desktop/narrow withdrawal, invoice, Sales Order; save/reload, mapping, print | Edge 155 assertions passed for withdrawal create/reopen and invoice/SO save/reload; Sales Order columns, QB codes, and descriptions matched. Screenshots/PDFs are in `tests/evidence/phase2/`. No JS runtime errors were captured. | PASS (scoped; see limitations) |
| QB-POST | Invoice/SO transmitted and reconciled in QB Enterprise 24.0 | No connector/request processor/company-file test environment; no posting attempted | BLOCKED |
| DEPLOY-HTTPS | Secure cookie through production HTTPS/proxy | Only local HTTP tested; HTTPS termination not available here | BLOCKED |
| AUTH-THROTTLE-HTTP | 20 bad logins and recovery through HTTP | Throttle algorithm passed isolated DB test; repeated HTTP load/response timing not exercised | NOT RUN |
| CRUD-ROLES | Admin/employee permissions and business CRUD over HTTP | Not exercised with a matrix of synthetic roles | NOT RUN |
| WITHDRAWAL-INVALID | Invalid dates/IDs/quantities, duplicate numbers, edit and rollback | Valid create/reopen path tested; remaining negative/edit cases not exercised | NOT RUN |
| INVOICE-NEGATIVE | Duplicate number, invalid tax/date/price, invoice API scope/pagination/retry | Valid draft path tested; negative and history/API browser scenarios not exercised | NOT RUN |
| PRINT-OUTPUT | Printed withdrawal/invoice/SO layout excludes screen controls | Invoice and Sales Order PDFs rendered on one landscape page with all line columns and subtotal; navigation/action controls were hidden. The dedicated `withdrawal_print.php` route was not opened. | PARTIAL |
| MAPPING-READINESS | Active company mappings complete and authoritative | Read-only inventory found 92 app-active and 2 inactive products: 18 active missing QB Codes/descriptions and all 92 missing ListIDs; all 816 active clients lack ListIDs. Stock/lifecycle and current-company verification are unavailable. See `PRODUCT_MAPPING_READINESS.md`. | NEEDS REVIEW (business data) |
| MIGRATION-PROVENANCE | Migration ledger identifies the deployment event | No migration-history table found/used; current FK definitions match target RESTRICT behavior, provenance is unknown | NEEDS REVIEW |

**Counts for the matrix above:** 22 PASS, 2 BLOCKED, 4 NOT RUN, 1 PARTIAL, 2 NEEDS REVIEW, 0 application FAIL. The E2E program reports 14 passed cases including isolated fixture setup; the matrix splits these into individual HTTP assertions. The isolated/source groups and lint/schema checks are separately represented in the matrix.

## Current configured database (read-only)

Connection resolved to `withdrawal_qb`; MariaDB 10.4.32. Observed row counts at review time:

| Table | Rows |
|---|---:|
| clients | 819 |
| products | 94 |
| sites | 7 |
| withdrawals | 5 |
| withdrawal_items | 6 |
| invoices | 3 |
| invoice_items | 4 |
| sales_orders | 2 |
| sales_order_items | 3 |

The configured schema currently reports `RESTRICT` for withdrawal product, invoice product/site, and Sales Order product/site foreign keys. The migration file has no ledger record, and its original constraint names differ from the current replacement names; **do not run it against this configured database**. For another database, inspect its actual constraints before deciding whether migration is needed.

`PRODUCT_MAPPING_REVIEW.md` summarizes the active mapping state; [`PRODUCT_MAPPING_RECONCILIATION.md`](PRODUCT_MAPPING_RECONCILIATION.md) lists all 92 active products and duplicate checks. QB business codes/descriptions and technical ListIDs were not invented or changed. The E2E mapping behavior passed with controlled synthetic values only.

## Phase 2 browser findings

- Edge authenticated as the synthetic Admin. Browser UI created/saved a separate two-line withdrawal and reopened it; the original test withdrawal stayed available for downstream draft preparation.
- Invoice and Sales Order Save actions were exercised through browser forms, then reopened. The SweetAlert fallback to native `window.confirm` was used when the CDN script was unavailable; successful save notices and persisted header values were checked.
- At 768 px, withdrawal, invoice, and Sales Order tables remained horizontally scrollable; no required Sales Order columns were removed. The 13-column order, QB item codes, and actual descriptions were checked.
- Invoice/Sales Order print media hid navigation and action controls, removed horizontal clipping, and produced one-page landscape PDFs with 10 mm margins. The Sales Order subtotal stays with its lines. Dedicated `withdrawal_print.php` was not tested.
- The local Edge browser could not load external Bootstrap/SweetAlert CDN resources. The native confirmation fallback was tested; CDN-styled dialogs and the Bootstrap-dependent login appearance remain unverified. Login background now points to the existing `login.png` asset.
- No JavaScript runtime errors were captured on the tested workflow pages. Role-specific authorization, invoice-history retry, deployed HTTPS/proxy behavior, and QuickBooks remain unverified.

## Defects and fixes

The browser pass confirmed and fixed the login image path, missing SweetAlert fallback for form confirmations, and invoice/Sales Order print layout. No outstanding confirmed application defect was reproduced in the tested scope. No operational data was changed.

See [`E2E_REGRESSION_DEFECTS.md`](E2E_REGRESSION_DEFECTS.md) for scope and outstanding data/environment issues.

## Unverified risks and release recommendation

- Role-specific authorization, invoice-history retry, the dedicated withdrawal print route, deployed HTTPS/proxy behavior, and visual styling dependent on external CDN assets remain unverified.
- Business-role authorization paths and destructive operations were not exercised over HTTP.
- HTTPS cookie behavior through the target proxy, deployment firewall/rate limits, and production session storage remain unverified.
- Product mapping data is incomplete, and ListIDs still require verified QuickBooks lookup.
- Actual QuickBooks Invoice/Sales Order posting is absent/unverified. Local save is not evidence of QB creation.
- Migration provenance cannot be inferred from current FKs alone.

**Release recommendation: CONDITIONAL GO for continued supervised local acceptance on an isolated test database; NO-GO for production QuickBooks use.** Browser coverage now verifies the main withdrawal, invoice-draft, and Sales Order-draft journeys and invoice/SO print layout. The role matrix, dedicated withdrawal print route, deployment security, complete authoritative mappings, and live QuickBooks prerequisites still need separate verification.
