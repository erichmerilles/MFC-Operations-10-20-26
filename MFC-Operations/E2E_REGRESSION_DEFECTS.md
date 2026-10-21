# MFC Operations E2E Regression Defects

**Reviewed:** 2026-10-20

## Confirmed defects and fixes

| ID | Area | Reproduction and actual behavior | Fix | Regression evidence |
|---|---|---|---|---|
| UI-01 | Login background | Edge loaded `frontend/login.php`; the `assets/images/.png` URL returned 404 even though the project contains `assets/images/login.png`. | Corrected the image path. The browser computed background URL now resolves to the existing image. | Edge login screenshot and F10 source/asset guard. |
| UI-02 | Confirmed form submissions without SweetAlert2 | In the local browser the SweetAlert2 CDN resource was unavailable (`window.Swal` undefined). Submitting withdrawal/invoice forms raised an uncaught reference and did not proceed. | Shared `confirmAction()` uses SweetAlert2 when present and falls back to native `window.confirm`; covers confirmation forms and links. | Browser accepted native confirmation and verified withdrawal, invoice, and Sales Order save/reload flows. F10 guards both paths. |
| PRINT-01 | Invoice/Sales Order print layout | Edge print media showed the sidebar, topbar, save actions, horizontal table clipping, and a subtotal separated onto page 2; the 13-column Sales Order needed landscape. | Added scoped transaction print rules: hide screen controls, allow table overflow, compact the header/columns, avoid row breaks, and set landscape pages with 10 mm margins. Withdrawal print styling was not changed. | Edge print-media checks passed; invoice and Sales Order each fit one 792×612 pt page with lines and subtotal. Dedicated `withdrawal_print.php` was not exercised. |

| INVOICE-01 | Invoice source-line integrity | A `WITHDRAWAL` invoice line could omit `withdrawal_item_id`; source ownership/product checks only ran when the ID was truthy. | Require a valid withdrawal item owned by the invoice's source withdrawal and matching the selected product. Accept only explicit `WITHDRAWAL`/`ADDITIONAL` source types; preserve source-free `ADDITIONAL` rows. | Isolated HTTP regression rejected missing, invalid, and mismatched source references without changing the saved draft and accepted an explicit additional line. |
| SALES-ORDER-01 | Confirmation consistency | Sales Order did not opt into the shared draft confirmation handler. | Added shared confirmation attributes. The shared handler supports SweetAlert and native fallback; cancel/confirm click interaction itself was not repeated in a browser in this task. | QA source guard and HTTP page assertion. |
| SALES-ORDER-02 | Missing QB Description fallback | New Sales Order lines substituted HT Description/product name when QB Description was blank. | Preserve the QB Description (including blank) without substituting another value. Local draft remains editable; readiness blocks while the master description is missing. | Isolated HTTP test cleared a synthetic QB Description and verified the initial saved description stayed blank. |
| QB-READINESS-01 | No shared draft readiness detail | No central preflight identified mapping blockers in both preparation workflows. | Added a read-only backend preflight used by both pages. It checks customer/item references and basic line values, and always blocks while connector/company file are unverified; it cannot post or queue. | Isolated HTTP page loads and F11 source guard. |

## Data and environment issues (not confirmed application defects)

| ID | Severity | Area | Evidence / impact | Status / next step |
|---|---|---|---|---|
| DATA-01 | P1 for QB integration | Product/customer mappings and lifecycle | 92 active products: 18 missing QB Codes/descriptions; all 92 and all 816 active clients lack stored legacy ListIDs. These are not themselves blockers for supported FullName references, but authoritative FullNames/code associations and lifecycle are unverified. | Review [`PRODUCT_MAPPING_READINESS.md`](PRODUCT_MAPPING_READINESS.md) and the product crosswalk. Resolve exact names/code associations and statuses from authorized records; do not infer or bulk-update. |
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
