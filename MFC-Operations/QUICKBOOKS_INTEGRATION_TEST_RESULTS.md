# QuickBooks Integration Test Results

**Latest run:** 2026-10-21  
**Environment:** Local PHP/MariaDB application. `withdrawal_qb` was queried read-only for mapping counts.  
**QuickBooks company file:** Not connected. No QuickBooks transaction was created.

## 2026-10-21 read-only QBWC implementation and security regression update

The local QBWC implementation is now present under `backend/integration/`: a local WSDL/SOAP endpoint, authenticated ticket lifecycle, a dedicated read-only Customer/Item query queue, and validated response classification. The server generates only `CustomerQueryRq` and `ItemQueryRq`; no QuickBooks write-request builder is enabled.

The in-memory test suite `tests/qbwc_readonly_mock_tests.php` passed after the callback error-handling and logging changes. It covers authentication sentinels/session creation, queued request selection, read-only XML validation, query/error/malformed responses, ticket cleanup, SOAP exception redaction, and active/expired/closed/unknown `getLastError()` tickets. A distinctive exception code and message are verified absent from diagnostic logs. PHP syntax checks passed for `backend/integration/qbwc.php`, `backend/integration/qbwc_service.php`, and the mock test file. The expected test diagnostic was sanitized to `[QBWC] Unexpected failure (RuntimeException).`

No Apache request, live database connection, migration, QBWC session, `.qwc` import, company-file access, or QuickBooks request was performed for these tests. Local WSDL/SoapServer and in-memory test coverage do not prove compatibility with a live QBWC installation. See [PROJECT_HANDOFF.md](PROJECT_HANDOFF.md) for implementation boundaries and outstanding verification.

## 2026-10-21 name-based preflight update

The isolated HTTP suite was rerun after changing readiness behavior. Synthetic customer and product rows were created with `qb_list_id` left NULL. Invoice and Sales Order drafts both saved; the pages did not report the absent stored IDs as blockers. They did report that exact customer/item FullName resolution and the connector/company file remain unverified. This confirms local behavior only; it is not a mocked or live QuickBooks lookup.

`php tests/qa_regression.php` was attempted and stopped at F10 before the new F11 guard ran because the current `frontend/login.php` contains `assets/images/.png`, while the assertion expects `assets/images/login.png`; the image asset exists. This unrelated mismatch was not changed. Full PHP syntax passed for 33 PHP files.

## Executed

| Check | Result | Evidence / limitation |
|---|---|---|
| `php tests/qa_regression.php` (latest) | FAIL at F10 | Current login page contains `assets/images/.png`, but assertion expects `assets/images/login.png`; asset exists. F11 did not run. Earlier groups passed. This is outside the QuickBooks code change. |
| `php tests/e2e_http_regression.php` | PASS — 14 cases | Used empty `test` schema through loopback PHP server with `e2e_db_guard.php`; all test tables were removed afterward. Negative invoice missing/invalid/mismatched source IDs rejected; explicit ADDITIONAL line accepted. |
| PHP syntax | PASS | Full 33-file PHP syntax scan passed after implementation. |
| Operational DB mapping inventory | PASS (read-only) | 92 active / 2 inactive products; all 92 active lack ListID; 18 active lack QB Code and description; all 816 active clients lack ListID. |
| Product lifecycle classification | BLOCKED | No stock/lifecycle field or per-product business crosswalk. No classification or bulk updates were made. |
| Central readiness checks | PASS (isolated HTTP) | Both draft pages separate local checks from live name-resolution blockers. NULL synthetic client/item ListIDs do not block local readiness; no QuickBooks query was invoked and no postable/verified state is claimed. |
| Invoice source-line validation | PASS (isolated HTTP) | Missing, invalid, and product-mismatched references rejected without changing prior saved rows; valid `ADDITIONAL` row saved with NULL source. Existing source ownership is checked against the correct withdrawal. |
| Sales Order confirmation and QB description | PASS (HTTP/source); browser interaction BLOCKED | Shared `data-confirm-submit` is present and the generic shared handler supports native fallback. New Sales Order copy leaves missing QB Description empty; no HT/product fallback occurs. A headless Edge check could not run: Edge terminated with a GPU-process fatal error in this environment, so actual Sales Order confirm/cancel click behavior remains unverified. |
| Web Connector/qbXML connection | NOT RUN / BLOCKED | No configured connector, selected company file, or isolated QB test company was available. |
| Invoice/Sales Order QuickBooks posting and duplicate reconciliation | NOT RUN / BLOCKED | No live or sandbox request was attempted. No transaction was created. |
| Role matrix / production HTTPS | NOT RUN | Requires test roles and deployed HTTPS/proxy environment. |

## Safety

No migrations were run and no `withdrawal_qb` data was changed. HTTP tests used `tests/e2e_db_guard.php`, `WQ_DB_NAME=test`, and an empty isolated `test` schema. The configured `withdrawal_qb` schema was only queried in a read-only transaction for mapping counts. No QuickBooks request was made and no QuickBooks transaction was created. Never point the HTTP runner or any future connector test at `withdrawal_qb` or the real company file.

Final test status should be updated after execution; do not infer QuickBooks success from local draft persistence or PHP syntax results.
