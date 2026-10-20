# MFC Operations E2E Regression Defects

**Reviewed:** 2026-10-20

## Confirmed defects and fixes

| ID | Area | Reproduction and actual behavior | Fix | Regression evidence |
|---|---|---|---|---|
| UI-01 | Login background | Edge loaded `frontend/login.php`; the `assets/images/.png` URL returned 404 even though the project contains `assets/images/login.png`. | Corrected the image path. The browser computed background URL now resolves to the existing image. | Edge login screenshot and F10 source/asset guard. |
| UI-02 | Confirmed form submissions without SweetAlert2 | In the local browser the SweetAlert2 CDN resource was unavailable (`window.Swal` undefined). Submitting withdrawal/invoice forms raised an uncaught reference and did not proceed. | Shared `confirmAction()` uses SweetAlert2 when present and falls back to native `window.confirm`; covers confirmation forms and links. | Browser accepted native confirmation and verified withdrawal, invoice, and Sales Order save/reload flows. F10 guards both paths. |
| PRINT-01 | Invoice/Sales Order print layout | Edge print media showed the sidebar, topbar, save actions, horizontal table clipping, and a subtotal separated onto page 2; the 13-column Sales Order needed landscape. | Added scoped transaction print rules: hide screen controls, allow table overflow, compact the header/columns, avoid row breaks, and set landscape pages with 10 mm margins. Withdrawal print styling was not changed. | Edge print-media checks passed; invoice and Sales Order each fit one 792×612 pt page with lines and subtotal. Dedicated `withdrawal_print.php` was not exercised. |

## Data and environment issues (not confirmed application defects)

| ID | Severity | Area | Evidence / impact | Status / next step |
|---|---|---|---|---|
| DATA-01 | P1 for QB integration | Active product mappings | 92 active products: 1 missing HT Code, 18 missing QB Codes/descriptions, all 92 missing ListIDs. No duplicate HT Codes, QB Codes, or nonblank ListIDs were found. | Use [`PRODUCT_MAPPING_RECONCILIATION.md`](PRODUCT_MAPPING_RECONCILIATION.md) and resolve values only from the listed authoritative sources. |
| DEPLOY-01 | P1 before QB use | QuickBooks integration | No Web Connector processor or verified invoice/Sales Order add flow is present. | Do not post/claim QB transactions. Requires approved method, dedicated company file, verified item/customer references, and transaction reconciliation. |
| DEPLOY-02 | P2 | Migration provenance | Configured `withdrawal_qb` has RESTRICT historical-reference FKs but no migration ledger. | Do not rerun the historical-reference migration without target-specific DDL review. |
| DEPLOY-03 | P2 | HTTPS/session deployment | Only local HTTP was exercised; reverse proxy and HTTPS cookie behavior are unknown. | Verify HTTPS indicators and Secure cookies in the actual deployment. |
| TEST-01 | P2 | Browser dependency coverage | The local Edge environment could not load Bootstrap/SweetAlert CDN resources. The native confirmation fallback was exercised; CDN-styled dialogs and login appearance are not verified. | Test with the deployed network/browser policy and localize assets separately if offline operation is required. |

## Remaining acceptance gaps

- Role-specific CRUD/permission matrix and destructive-operation paths were not exercised in the browser.
- Invoice-history retry/pagination and remaining invoice/withdrawal negative cases were not browser-tested.
- The dedicated `withdrawal_print.php` route was not opened; the form workflow and invoice/Sales Order print output were exercised.
- Production HTTPS/proxy, deployment firewall/rate limits, and QuickBooks integration remain unverified.

No operational data was changed. Browser and HTTP test fixtures were synthetic and isolated in the `test` schema, which was empty after cleanup.
