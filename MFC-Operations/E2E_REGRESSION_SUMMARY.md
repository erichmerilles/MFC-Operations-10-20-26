# MFC Operations Regression Summary

**Date:** 2026-10-20  
**Local acceptance decision:** **CONDITIONAL GO for continued supervised testing in an isolated local database.**  
**Production QuickBooks decision:** **NO-GO.**

## Verified

- Fourteen authenticated HTTP/database end-to-end cases passed against synthetic fixtures in the guarded `test` schema.
- `php tests/qa_regression.php` passed all six groups, including historical FK behavior, CSV sanitization, audit rollback, throttling, source guards, login asset, and confirmation fallback checks.
- All 34 PHP files passed `php -l`.
- Edge 155 browser acceptance covered a two-line withdrawal create/save/reopen, invoice draft save/reload, Sales Order draft save/reload, exact 13-column order, QB item codes separate from descriptions, and narrow table scrolling.
- Edge print media hid transaction screen controls. Invoice and Sales Order PDFs each fit on one landscape page with line subtotals; screenshots and PDFs are under [`tests/evidence/phase2/`](tests/evidence/phase2/).
- The guarded test schema returned to zero tables. Operational database checks were read-only; no migration or production-data write occurred.

## Open items

- QuickBooks posting and dedicated company-file reconciliation are unavailable and untested.
- The current active product master has 92 products, 18 missing QB Codes/descriptions, and all 92 missing QB ListIDs. See [`PRODUCT_MAPPING_RECONCILIATION.md`](PRODUCT_MAPPING_RECONCILIATION.md).
- Role-specific CRUD/permission coverage, invoice-history retry/pagination, remaining negative cases, deployed HTTPS/proxy behavior, and the dedicated `withdrawal_print.php` route remain unverified.
- The local Edge browser could not load external Bootstrap/SweetAlert CDN resources. Native confirmation fallback worked; CDN-styled dialogs and the Bootstrap-dependent login appearance need verification in the target network environment.
- Git executable was unavailable, so branch, commit, and full working-tree baseline could not be recorded.

## Before production

1. Resolve every required mapping from an approved product crosswalk and verified QuickBooks Enterprise item list; never infer ListIDs.
2. Approve an integration method and implement/test Invoice and Sales Order transactions in a dedicated QuickBooks test company, including duplicate and uncertain-response reconciliation.
3. Complete the role matrix, remaining validation/history cases, dedicated withdrawal print verification, and target HTTPS/proxy checks.
4. Inspect each target database's current foreign-key definitions and migration history before applying any migration.

See [`E2E_REGRESSION_RESULTS.md`](E2E_REGRESSION_RESULTS.md) for case-level evidence and [`E2E_REGRESSION_TEST_PLAN.md`](E2E_REGRESSION_TEST_PLAN.md) for safe reproduction steps.
