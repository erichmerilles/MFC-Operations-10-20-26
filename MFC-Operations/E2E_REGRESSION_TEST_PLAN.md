# MFC Operations E2E Regression Test Plan

**Prepared:** 2026-10-20  
**Application root:** `C:\xampp\htdocs\MFC-Operations`  
**Primary scope:** local PHP/MariaDB withdrawal, invoice-draft, Sales Order-draft, security, audit, and data-integrity behavior.

## Scope and exclusions

This plan exercises real PHP pages and POST controllers through an isolated PHP development server backed by the empty MariaDB `test` schema. Fixtures are synthetic. The harness imports the current initial schema while skipping database selection and sample inserts, applies the additive Sales Order table migration, posts through the regular authentication/CSRF routes, verifies persisted values, and removes only the tables it created.

Included: sign-in/out and session behavior, withdrawal create/reopen, invoice draft create/save/reload, Sales Order draft create/save/reload, local QB Code/legacy-ID separation, backend required-field and mapping checks, amount calculations, audit records, source-record preservation, CSV export, current FK rules, and previously remediated isolated cases.

Excluded from automated execution: QuickBooks posting, production/shared-database writes, verified company-file field mappings, deployed HTTPS/proxy behavior, staff-role CRUD paths, visual/browser layout and print-preview checks, and network-level security controls. No QuickBooks transaction is created by this suite.

## Environment requirements

- PHP 8.2+ with `pdo_mysql`, `curl`, and `mbstring`.
- MariaDB/MySQL and a disposable schema named exactly `test`.
- The `test` schema must be empty before either test suite starts.
- A loopback PHP development server configured with `WQ_DB_NAME=test`; never point it at `withdrawal_qb`.
- Do not put production passwords, real client information, or QuickBooks credentials in fixtures.
- `tests/qa_regression.php` and `tests/e2e_http_regression.php` both fail closed if the test schema is not empty.

## Test database setup

Confirm that the connection resolves to `test` and has zero tables:

```powershell
$env:WQ_DB_HOST = '127.0.0.1'
$env:WQ_DB_NAME = 'test'
$env:WQ_DB_USER = 'root'
$env:WQ_DB_PASS = ''
@'
<?php
$p = new PDO('mysql:host=127.0.0.1;dbname=test;charset=utf8mb4', 'root', '');
echo 'schema=', $p->query('SELECT DATABASE()')->fetchColumn(), PHP_EOL;
echo 'tables=', $p->query("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='test'")->fetchColumn(), PHP_EOL;
'@ | & 'C:\xampp\php\php.exe'
```

The current configured operational database is `withdrawal_qb`. Do not use it as the test target. The local live schema was inspected read-only during this run.

## Fixtures

The HTTP suite generates a temporary Admin employee with a synthetic password, one synthetic client with no stored QuickBooks ListID, one site, and two products with distinct HT Code, QB Code, QB description and legacy code; both product ListIDs remain NULL. It creates a two-line withdrawal, one invoice draft, and one local Sales Order draft. The QB Code mapping is temporarily blanked in the isolated schema for the missing-mapping case and restored before cleanup. This verifies only local preflight behavior; it does not simulate a live QuickBooks name lookup.

The suite uses a formula-leading withdrawal remark containing comma, quote, and newline characters to check CSV escaping and formula protection. It does not use operational customer or product records.

## Test cases

| ID | Priority | Prerequisites | Execution | Expected result |
|---|---|---|---|---|
| AUTH-HTTP-01 | P1 | Anonymous test session | Request dashboard before login | Redirect to sign-in; no protected page content |
| AUTH-HTTP-02 | P1 | Synthetic employee | Submit invalid credentials, then valid credentials | Generic invalid-login message; successful login; session ID rotates |
| AUTH-HTTP-03 | P1 | Local HTTP server | Inspect authenticated session `Set-Cookie` | `HttpOnly` and `SameSite=Lax`; `Secure` depends on HTTPS |
| AUTH-HTTP-04A | P1 | Authenticated synthetic user | POST logout without token | HTTP 403 |
| AUTH-HTTP-04 | P1 | Authenticated synthetic user | POST logout with CSRF, then replay old session on dashboard | Logout redirects; replay redirects to sign-in |
| WITHDRAWAL-HTTP-01 | P1 | Synthetic client/products/site | Load form; POST two valid lines; query DB; reopen form | One header and two correct source lines persist and reload |
| CSV-HTTP-01 | P2 | Saved synthetic withdrawal | Download CSV and parse with CSV reader | Correct response type; formula-leading text prefixed safely; commas, quotes, newline preserved |
| INVOICE-HTTP-01 | P1 | Saved withdrawal and local QB Codes/descriptions; no stored customer/product ListIDs | Open preparation; save header/memo/two lines; reload | Separate invoice draft; QB codes and QB descriptions; amounts 250.00 and 81.00; memo persists; local checks are separate from unresolved live FullName lookup |
| SALES-ORDER-HTTP-01 | P1 | Saved withdrawal and two distinct QB Codes; no stored customer/product ListIDs | Open preparation; check exact headers; save and reload two lines | `S.O. NO.`; 13 columns in order; item code is QB Code; legacy ListID snapshots may remain NULL; amounts 250.00 and 81.00 |
| SALES-ORDER-HTTP-02 | P1 | Existing saved draft | Submit directly with missing SITE | Backend rejects line 1; previously saved draft remains intact |
| SALES-ORDER-HTTP-03 | P1 | Existing saved draft | Temporarily remove product 2 QB Code and submit | Backend reports missing line 2 mapping; no substitution; saved draft unchanged |
| SALES-ORDER-HTTP-04 | P1 | Existing saved draft | Submit invalid comma grouping in RATE | Backend rejects the malformed rate; saved draft unchanged |
| INTEGRITY-HTTP-01 | P1 | Withdrawal, invoice, Sales Order saved | Compare source and separate transaction records | Withdrawal item codes/HT codes/quantities unchanged; invoice and SO remain separate; audit records present |
| F02-DB | P1 | Empty `test` schema | Apply historical-reference migration to minimal synthetic FK schema and try product/site deletes | Referenced records protected; unused master records deletable; SO-only and mixed references counted |
| F03-CSV | P2 | PHP CLI | Exercise formula prefixes, controls, ordinary text, CSV quoting | Text neutralization; numeric values unaffected |
| F06-DB | P1 | Empty `test` schema | Simulate activity insert failure inside a transaction | Business write rolls back with audit failure |
| F08-DB | P2 | Empty `test` schema | Exercise IP throttle, threshold, aging, generic log details | Threshold applies per IP and expires after the rolling window |
| F04/F05/F09-SRC | P2 | Source available | Check retry loader, subtotal label/API, logout method/CSRF | Relevant expected code paths and wording present; this is a source-level check, not a browser test |
| UI-BROWSER | P2 | Installed Microsoft Edge | Desktop and 768 px rendering, withdrawal create/reopen, invoice/Sales Order draft save/reload, line mapping, print media and PDFs | Phase 2 run executed using Edge DevTools Protocol against the guarded `test` schema; evidence is in `tests/evidence/phase2/`. |
| QB-POST | P0 | Dedicated QB test company and verified connector | Add and reconcile invoice/SO through QBXML | No transaction sent in this environment; blocked |

## Execution instructions

Run the isolated source/database suite while `test` is empty:

```powershell
& 'C:\xampp\php\php.exe' tests/qa_regression.php
```

Start a separate local PHP server against `test` (use a second terminal for the tests):

```powershell
New-Item -ItemType Directory -Path 'tests/.e2e_sessions' -Force | Out-Null
$env:WQ_DB_HOST = '127.0.0.1'
$env:WQ_DB_NAME = 'test'
$env:WQ_DB_USER = 'root'
$env:WQ_DB_PASS = ''
$env:WQ_BASE_URL = '/'
& 'C:\xampp\php\php.exe' -d 'session.save_path=C:\xampp\htdocs\MFC-Operations\tests\.e2e_sessions' -d 'auto_prepend_file=C:\xampp\htdocs\MFC-Operations\tests\e2e_db_guard.php' -S 127.0.0.1:18765 -t 'C:\xampp\htdocs\MFC-Operations'
```

In another terminal:

```powershell
$env:MFC_E2E_BASE_URL = 'http://127.0.0.1:18765'
$env:WQ_DB_HOST = '127.0.0.1'
$env:WQ_DB_NAME = 'test'
$env:WQ_DB_USER = 'root'
$env:WQ_DB_PASS = ''
& 'C:\xampp\php\php.exe' tests/e2e_http_regression.php
```

The harness refuses non-loopback URLs and nonempty schemas. The server-side `e2e_db_guard.php` verifies the application connection is exactly `test` before a page/controller executes and returns HTTP 503 otherwise. The harness drops only tables created from its schema setup, then reports the remaining test-table count. Stop the separate PHP server with Ctrl+C. Remove only the test session files under `tests/.e2e_sessions` afterward. Confirm `test` has zero tables before another run.

## Manual cases still required

- Remaining browser work: use the target environment to test role/permission paths, validation recovery, invoice-history retry/pagination, and the dedicated `withdrawal_print.php` route. Phase 2 exercised transaction screens at 1440×1000 and 768×1024 and generated invoice/Sales Order print PDFs.
- The local Edge run could not load external Bootstrap/SweetAlert CDN resources. The confirmation fallback was exercised; visual styling that depends on those CDNs was not verified in this offline browser.
- Exercise withdrawal editing, invalid client/product/quantity/date values, duplicate withdrawal number, and failed line inserts on isolated fixtures.
- Exercise invoice duplicate number, invalid tax/date/amount, detail API client scoping, history pagination/retry, and audit-failure rollback through HTTP.
- Verify role/permission boundaries for product/site/employee/settings CRUD using synthetic employee roles.
- Test repeated login failures and recovery over HTTP and validate controls at the actual network edge.
- Confirm the production HTTPS proxy supplies the expected HTTPS indicator and resulting Secure session cookies.
- Before production, compare migration DDL and actual FK names on the target; the configured database inspected for this run already has the target `RESTRICT` relationships and should not receive the migration blindly.
- Test QBXML only with an approved QuickBooks Enterprise test company, a verified Web Connector service, verified customer/item references, and reconciliation procedures.
