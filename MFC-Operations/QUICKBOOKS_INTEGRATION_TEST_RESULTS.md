# QuickBooks Integration Test Results

**Run date:** 2026-10-20  
**Environment:** Local PHP/MariaDB application. `withdrawal_qb` was queried read-only for mapping counts.  
**QuickBooks company file:** Not connected. No QuickBooks transaction was created.

## Executed

| Check | Result | Evidence / limitation |
|---|---|---|
| `php tests/qa_regression.php` | PASS | F02/F03/F06/F08/F04-F05-F09/F10/F11 assertions passed, including new invoice source, Sales Order confirmation/description, and readiness source guards. |
| `php tests/e2e_http_regression.php` | PASS — 14 cases | Used empty `test` schema through loopback PHP server with `e2e_db_guard.php`; all test tables were removed afterward. Negative invoice missing/invalid/mismatched source IDs rejected; explicit ADDITIONAL line accepted. |
| PHP syntax | PASS | Full 33-file PHP syntax scan passed after implementation. |
| Operational DB mapping inventory | PASS (read-only) | 92 active / 2 inactive products; all 92 active lack ListID; 18 active lack QB Code and description; all 816 active clients lack ListID. |
| Product lifecycle classification | BLOCKED | No stock/lifecycle field or per-product business crosswalk. No classification or bulk updates were made. |
| Central readiness checks | PASS (isolated HTTP) | Both draft pages rendered the read-only readiness panel. Temporarily missing synthetic client and item ListIDs each produced the corresponding blocking message; fixtures were restored before remaining assertions. No posting endpoint was invoked; no postable/verified state is claimed. |
| Invoice source-line validation | PASS (isolated HTTP) | Missing, invalid, and product-mismatched references rejected without changing prior saved rows; valid `ADDITIONAL` row saved with NULL source. Existing source ownership is checked against the correct withdrawal. |
| Sales Order confirmation and QB description | PASS (HTTP/source); browser interaction BLOCKED | Shared `data-confirm-submit` is present and the generic shared handler supports native fallback. New Sales Order copy leaves missing QB Description empty; no HT/product fallback occurs. A headless Edge check could not run: Edge terminated with a GPU-process fatal error in this environment, so actual Sales Order confirm/cancel click behavior remains unverified. |
| Web Connector/qbXML connection | NOT RUN / BLOCKED | No configured connector, selected company file, or isolated QB test company was available. |
| Invoice/Sales Order QuickBooks posting and duplicate reconciliation | NOT RUN / BLOCKED | No live or sandbox request was attempted. No transaction was created. |
| Role matrix / production HTTPS | NOT RUN | Requires test roles and deployed HTTPS/proxy environment. |

## Safety

No migrations were run and no `withdrawal_qb` data was changed. HTTP tests used `tests/e2e_db_guard.php`, `WQ_DB_NAME=test`, and an empty isolated `test` schema. The configured `withdrawal_qb` schema was only queried in a read-only transaction for mapping counts. No QuickBooks request was made and no QuickBooks transaction was created. Never point the HTTP runner or any future connector test at `withdrawal_qb` or the real company file.

Final test status should be updated after execution; do not infer QuickBooks success from local draft persistence or PHP syntax results.
