# MFC Operations Regression Summary

**Date:** 2026-10-20  
**Local acceptance decision:** **CONDITIONAL GO for continued supervised testing in an isolated local database.**  
**Production QuickBooks decision:** **NO-GO.**

## Verified

- Fourteen authenticated HTTP/database end-to-end cases passed against synthetic fixtures in the guarded `test` schema.
- `php tests/qa_regression.php` passed all seven groups, including historical FK behavior, CSV sanitization, audit rollback, throttling, source guards, login asset/confirmation fallback, and new QuickBooks readiness/source validation guards.
- All 34 PHP files passed `php -l`.
- Edge 155 browser acceptance covered a two-line withdrawal create/save/reopen, invoice draft save/reload, Sales Order draft save/reload, exact 13-column order, QB item codes separate from descriptions, and narrow table scrolling.
- Edge print media hid transaction screen controls. Invoice and Sales Order PDFs each fit on one landscape page with line subtotals; screenshots and PDFs are under [`tests/evidence/phase2/`](tests/evidence/phase2/).
- The guarded test schema returned to zero tables. Operational database checks were read-only; no migration or production-data write occurred.

## Open items

- QuickBooks posting and dedicated company-file reconciliation are unavailable and untested.
- The current product master has 92 app-active and 2 inactive products. 18 active products lack QB Codes/descriptions, all 92 active products lack QB ListIDs, and all 816 active clients lack QB ListIDs. Per-product stock/lifecycle state is not stored. See [`PRODUCT_MAPPING_READINESS.md`](PRODUCT_MAPPING_READINESS.md) and [`PRODUCT_MAPPING_RECONCILIATION.md`](PRODUCT_MAPPING_RECONCILIATION.md).
- Role-specific CRUD/permission coverage, invoice-history retry/pagination, remaining negative cases, deployed HTTPS/proxy behavior, and the dedicated `withdrawal_print.php` route remain unverified.
- The local Edge browser could not load external Bootstrap/SweetAlert CDN resources. Native confirmation fallback worked in the earlier browser pass; this task's separate headless confirm/cancel interaction check was blocked by an Edge GPU-process fatal error. CDN-styled dialogs, current Sales Order click/cancel behavior, and the Bootstrap-dependent login appearance need verification in a working browser environment.
- Git executable was unavailable, so branch, commit, and full working-tree baseline could not be recorded.

## Before production

1. Resolve every required mapping from an approved product crosswalk and verified QuickBooks Enterprise item list; never infer ListIDs.
2. Approve an integration method and implement/test Invoice and Sales Order transactions in a dedicated QuickBooks test company, including duplicate and uncertain-response reconciliation.
3. Complete the role matrix, remaining validation/history cases, dedicated withdrawal print verification, and target HTTPS/proxy checks.
4. Inspect each target database's current foreign-key definitions and migration history before applying any migration.

See [`E2E_REGRESSION_RESULTS.md`](E2E_REGRESSION_RESULTS.md) for case-level evidence and [`E2E_REGRESSION_TEST_PLAN.md`](E2E_REGRESSION_TEST_PLAN.md) for safe reproduction steps.

QuickBooks mapping counts, readiness design, and this task's test statuses are in [`QUICKBOOKS_READINESS_AUDIT.md`](QUICKBOOKS_READINESS_AUDIT.md), [`PRODUCT_MAPPING_READINESS.md`](PRODUCT_MAPPING_READINESS.md), [`QUICKBOOKS_INTEGRATION_DESIGN.md`](QUICKBOOKS_INTEGRATION_DESIGN.md), and [`QUICKBOOKS_INTEGRATION_TEST_RESULTS.md`](QUICKBOOKS_INTEGRATION_TEST_RESULTS.md).
