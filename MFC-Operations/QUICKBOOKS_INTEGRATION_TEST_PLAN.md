# QuickBooks Integration Test Plan

**Phase:** preparation, non-posting. No QuickBooks transaction was created during this Phase 1 review.

## Test environment and guardrails

- Use a dedicated QuickBooks Desktop test company, never the production company file.
- Use an isolated application test database (`test`) through `tests/e2e_db_guard.php`; confirm it is empty before execution. Never point test harness or sample credentials at `withdrawal_qb`.
- Seed synthetic customers/items with conspicuously synthetic names/codes in the test company. Resolve their authoritative FullNames from actual query results; do not make up names or identifiers. Local ListIDs should remain NULL in tests that confirm local preflight does not require staff-maintained IDs.
- Restrict connector user and transactions to the test company. Verify target company identity at each session start.
- Capture sanitized test evidence; do not include passwords, Web Connector tickets, customer PII, or secrets.
- Use the exact selected QBWC/QuickBooks/SDK build and supported qbXML version; validate requests against the matching OSR before running.
- Run Invoice and Sales Order cases separately, with transaction type asserted from request and response. Confirm Sales Order is non-posting and never generated through InvoiceAdd.
- Reconcile/delete test transactions only under the test company’s approved procedure; never apply production cleanup instructions.

## Local non-posting tests

| Case | Expected result |
|---|---|
| Existing local QA regression | `php tests/qa_regression.php` passes; no external call. |
| Guarded HTTP regression | `php tests/e2e_http_regression.php` uses only clean isolated test schema and reports the recorded 14 passing cases. |
| PHP syntax | `php -l` for changed PHP (this Phase 1 change is Markdown-only). |
| Read-only readiness | Missing/ambiguous customer or item references block; connector/company-file blocker remains present. No queue/job or external request is created. |
| Draft separation | Saving/reloading Invoice and SO persists local records; source withdrawal is unchanged; no QB result/status is implied. |
| Mapping tests | Two or more synthetic products have distinct business `qb_code` values and authoritative item FullNames. Local ListIDs remain NULL. Exact query resolves one item; mismatch/none/ambiguous/inactive result blocks. Serializer uses verified FullName where supported. |
| Required field / calculations | Independently omit each required field; whitespace-only text; invalid dates; zero/negative quantities; malformed/grouped money; client amount tampering; multiple lines and rounding. Backend rejects/recalculates as documented. |
| Optional SO fields | Leave LOT, U/M, CLASS, STATUS, FULFILLED, EXPIRATION and TAX blank; no unnecessary required error. For nonblank values test only verified mappings. |

## QuickBooks test-company matrix (future gated phase)

| Scenario | Test/assertion | Pass evidence |
|---|---|---|
| Connectivity/auth | QBWC authenticates, selects intended test file, reports expected service state | Sanitized handshake log and operator-confirmed company identity. |
| Invoice success | Valid customer/item/date/number/lines; operation is `InvoiceAdd` | QuickBooks response success with matching response type and returned TxnID/TxnNumber; transaction manually inspected. |
| SO success | Separate valid SO request using `SalesOrderAdd` | Response is SalesOrderAdd success; inspected transaction type is Sales Order; not an Invoice. |
| Customer/item resolution | Exact FullName resolution succeeds for one correct record without a local ListID; no match, ambiguous result, wrong type, inactive, or foreign-company identity rejects safely | Exact test-company identity and expected result; no approximate fallback and no automatic creation. |
| Field support | Memo/footer, PO, Desc, quantity/rate, class, U/M, site, lot, expiration, fulfilled/status, tax each tested individually | OSR-supported member and observed saved/displayed value, or documented local-only/disposition approval. |
| QuickBooks validation rejection | Invalid test value/list ref | Definitive error saved and sanitized; no false Posted state. |
| Duplicate local submit | Double-click/concurrent workers same transaction | One claim; one request handed to QBWC. |
| Duplicate QB reference | Pre-existing test transaction/reference | Application surfaces conflict/reconciliation; no blind second add. |
| Connector disconnect before request | Stop QBWC before handing off qbXML | Proven no send; safe return to Ready only when evidence supports. |
| Timeout after handoff | Drop/interrupt response after QB may accept request | Outcome Unknown, locked; no automatic retry; reconcile test company. |
| Response lost then reconcile | QB accepted, local response unavailable | Query/inspect by supported criteria; attach verified TxnID, mark Posted exactly once locally. |
| No transaction after uncertain attempt | Controlled test where non-acceptance is verified | Record operator/evidence; authorized retry succeeds as a new attempt. |
| Response mismatch/parser failure | Wrong response type or malformed response fixture | Unknown/review state; no success claim or blind retry. |
| Tax/rounding | Taxed/non-taxable configurations and multi-line precision | QuickBooks subtotal/tax/total match approved policy and local preview or documented differences. |
| Role/security | Unauthorized user, CSRF failure, invalid local ID, replayed request, secrets in logs | Requests denied; no send; secret redaction verified. |
| Restart/stale worker | Restart service at each state transition | Durable attempt/state recovery with no duplicate handoff. |

## Existing evidence (not QuickBooks integration evidence)

The project records a 2026-10-20 run: `php tests/qa_regression.php` PASS; guarded `php tests/e2e_http_regression.php` PASS for 14 cases; PHP syntax PASS for 34 files; read-only mapping inventory PASS. Browser check of the confirmation click/cancel flow was blocked by an Edge GPU-process fatal error. QuickBooks connectivity/posting/reconciliation was NOT RUN because no connector/test company is available. See [QUICKBOOKS_INTEGRATION_TEST_RESULTS.md](QUICKBOOKS_INTEGRATION_TEST_RESULTS.md) and [E2E_REGRESSION_SUMMARY.md](E2E_REGRESSION_SUMMARY.md).

## Exit criteria for later integration testing

All local cases pass; environment and mapping gates are approved; exact qbXML version/schema checked; each transaction type passes positive, rejection, duplicate and uncertain-outcome scenarios; manual QuickBooks inspection confirms field values; reconciliation is demonstrated; no test touches production data; operator signs off before any production release. Passing local syntax/HTTP tests is not proof of QBWC or QuickBooks compatibility.
