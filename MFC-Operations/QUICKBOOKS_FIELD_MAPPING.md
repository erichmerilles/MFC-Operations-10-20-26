# QuickBooks Field Mapping Specification

**Status:** Candidate mapping only. No transaction field has been verified against the intended company file. Local persistence does not imply a QB mapping.

## Mapping legend

- **Local verified:** actual source column is present in reviewed schema/controller.
- **Candidate QB target:** conventional field suggested by the Desktop API operation; must be checked against the OSR for selected qbXML version and test company.
- **Blocked:** no valid mapping/reference or company-file decision currently exists.

QuickBooks Desktop qbXML references may use `FullName` where the transaction request supports it. The official SDK guide examples show `CustomerRef.FullName` for InvoiceAdd and `CustomerRef.FullName` plus `ItemRef.FullName` for SalesOrderAdd. This removes the need to store a ListID locally for those references, but the exact authoritative FullName must first be resolved in the intended company file. Local primary keys, display names, and QB Codes are not proof of a corresponding FullName. See [Intuit QBSDK Programmer's Guide](https://static.developer.intuit.com/qbSDK-current/doc/pdf/QBSDK_ProGuide.pdf) and the transaction-specific [InvoiceAdd](https://developer.intuit.com/app/developer/qbdesktop/docs/api-reference/qbdesktop/invoiceadd) / [SalesOrderAdd](https://developer.intuit.com/app/developer/qbdesktop/docs/api-reference/qbdesktop/salesorderadd) references. Exact members/order/version still require the matching OSR.

## Shared header and line values

| Local source | Candidate QB destination | Required? | Local validation / transformation | Evidence status |
|---|---|---:|---|---|
| `clients.client_name` | Header `CustomerRef.FullName` (candidate) | Yes | Query/resolve exact, active customer name in the intended company; require exactly one correct match. A unique local client name does not prove its QuickBooks name. | SDK example supports FullName; no live lookup implemented or run. |
| `products.qb_code` | Item lookup key candidate; final `ItemRef.FullName` | Yes | Query the actual company item list by an appropriate exact field; verify actual FullName and code association. Do not assume the code is the item's FullName. | No authoritative export/live lookup; item-name mapping unknown. |
| `products.qb_list_id`, `clients.qb_list_id`, saved SO ListID snapshots | Optional legacy internal references | No for supported FullName references | Retain for compatibility/reconciliation. Do not synthesize values or require staff maintenance. | Columns exist; current values are absent, but that alone is no longer a blocker. |
| Local product description (`products.qb_description`, saved line `description`) | Line `Desc` | Candidate, normally optional | Preserve actual description; escape XML; respect target length/encoding. No mapping/debug text. | Local source known; QB member/version and actual form behavior require verification. |
| Line quantity (`invoice_items.quantity`, `sales_order_items.ordered_quantity`) | `Quantity` | Required for item line | Positive whole units under current local business rule; never substitute fulfilled quantity. | Local validation known; QB precision/type support must be verified. |
| Rate (`invoice_items.price_each`, `sales_order_items.rate`) | `Rate` or supported line amount/price representation | Invoice required by local UI; SO required locally | Nonnegative, max 2 decimals, currency parsing with grouping, server recalculate amount. | Local rule known; QB item/rate semantics and currency need verification. |
| Amount (`invoice_items.amount`, `sales_order_items.amount`) | Calculated QB line subtotal, not trusted client input | Derived | Backend `ROUND(quantity × rate, 2, HALF_UP)`; QB may calculate totals/tax differently. | Local behavior verified; reconciliation/tax semantics not. |
| Transaction type | `InvoiceAdd` or `SalesOrderAdd` | Yes | Dispatch strictly by local transaction type. Never convert SO to Invoice. | Required operation names documented by Intuit; no operation implemented. |
| Document number (`invoices.invoice_number`, `sales_orders.so_number`) | Transaction `RefNumber` (candidate) | Business decision; local number required | Preserve as entered; unique locally per type. Confirm max length, duplicate policy and QB numbering preference. | Candidate only; selected company preference unverified. |
| Transaction date (`invoices.invoice_date`, `sales_orders.sales_order_date`) | `TxnDate` | Yes | Strict `YYYY-MM-DD` local date. | Source/validation known; OSR/version/company acceptance pending. |
| PO (`invoices.po_no`, `sales_orders.po_no`) | Header `PONumber` (candidate) | Optional | Trim; current local limit 100 chars. Verify target max length/visibility; truncate never silently. | Candidate only; local length may exceed supported field limit. |
| Invoice Memo (`invoices.memo`) | Header `Memo` | Optional | Preserve local text, XML escape; local field max 65,535 bytes is not evidence of QB capacity. | Candidate footer Memo intent only; check OSR maximum, footer placement and invoice template in test file. |
| SO Memo (`sales_orders.memo`) | Header `Memo` | Optional | Preserve local text; test round trip and UI placement. | Candidate only; no SO request exists. |
| Currency | Company file transaction currency/default | Required implicitly | No explicit currency field/source in local schema inspected. Confirm company home currency and transaction currency settings. | Blocked / operator decision. |
| Bill/ship addresses, terms, sales rep, due date | No current selected source for these records | Conditional | Do not fabricate or silently add defaults; verify whether company defaults can safely supply them. | Not mapped. |

## Invoice line field specification

| App field/source | Candidate `InvoiceAdd` meaning | Required? | Rules and unresolved decision |
|---|---|---:|---|
| Product reference: `invoice_items.product_id` → authoritative item FullName resolved from Product Master QB Code | `InvoiceLineAdd.ItemRef.FullName` candidate | Yes | Verify exact code-to-item association, active item and item type in approved company. QB Code itself is not sent until it is proven identical to FullName. |
| `invoice_items.description` (saved by controller from `products.qb_description`) | `InvoiceLineAdd.Desc` | Conditional | Preserve real product text. Empty QB Description is a readiness blocker today. |
| `invoice_items.quantity` | `InvoiceLineAdd.Quantity` | Yes | Positive whole quantity locally; confirm item-specific unit behavior. |
| `invoice_items.price_each` | `InvoiceLineAdd.Rate` candidate | Yes under local invoice workflow | Nonnegative 2-place money. Verify price level/U/M and rounding. |
| `invoice_items.amount` | Calculated line amount / QB-calculated amount | Derived | Recompute; compare returned/calculated total; do not send untrusted client amount. |
| `invoice_items.site_id` | None established | Optional locally | No generic site-to-QB mapping assumed. Confirm company-specific custom field/list and intended semantics. |
| `invoice_items.lot_number` | None established | Optional locally | Do not map to serial or lot without supported item type/feature and exact OSR member. |
| `invoice_items.u_m` | None established | Optional locally | Confirm U/M feature and valid unit list/format. |
| `invoice_items.tax_code` (`Non`, `Tax`, `Exempt`) | Possibly transaction tax code/item reference, not a display string | Currently required locally | Existing labels are not proof of QB tax identifiers. Require approved mapping and tax settings. |
| `invoice_items.expiration_date` | None established | Optional locally | Verify item type and supported custom field; do not silently discard. |
| Footer Memo intent | Header `Memo` | Optional | Verify InvoiceAdd `Memo` member and output location with the intended invoice template; not a line description or customer message. |

## Sales Order line field specification (the 13 app columns)

The required app display order remains `ITEM, DESCRIPTION, SITE, ORDERED, LOT NUMBER, U/M, RATE, CLASS, AMOUNT, STATUS, FULFILLED QUANTITY, EXPIRATION DATE, TAX`.

| Column / local source | Candidate QB meaning | Required? | Rule / current status |
|---|---|---:|---|
| ITEM: `sales_order_items.item_code` (from `products.qb_code`) | Display/business code; request reference is verified `ItemRef.FullName` candidate | Yes | Resolve independently; never use QB Code as FullName until the company lookup proves it is identical. No separate target item-name field has been added because the authoritative names are not available. |
| DESCRIPTION: `sales_order_items.description` | SalesOrder line description (`Desc`, candidate) | Yes | Actual product description only; no technical code. Local field is required; exact OSR member pending. |
| SITE: `site_id` → `sites.site_name` | No generic field established | Yes in app | Preserve locally. Require company-approved custom/standard field before transfer; block or obtain explicit non-transfer decision. |
| ORDERED: `ordered_quantity` | SalesOrder line `Quantity` (candidate) | Yes | Positive whole value; distinct from fulfilled quantity. |
| LOT NUMBER: `lot_number` | No generic mapping established | Optional | Verify company configuration/item type and exact supported member/custom field. |
| U/M: `u_m` | Potential U/M field/feature | Optional | Do not invent a unit; verify supported version and item U/M setup. |
| RATE: `rate` | SalesOrder line `Rate` (candidate) | Yes | Nonnegative, two decimals locally; verify item/rate/tax semantics. |
| CLASS: `class_name` | Line/header `ClassRef` (candidate) | Optional | Resolve against actual company class list. Arbitrary text cannot be submitted as verified mapping. |
| AMOUNT: `amount` | Calculated subtotal (candidate) | Derived | Backend calculates ordered × rate; never manually override. QuickBooks computes authoritative transaction totals. |
| STATUS: `line_status` | No app/QuickBooks status meaning verified | Optional | Keep local until business meaning and actual QB field are agreed. Do not claim it is Sales Order status. |
| FULFILLED QUANTITY: `fulfilled_quantity` | No add-time mapping established | Optional | Do not send or mark fulfilled without verified QB workflow. It must remain distinct from ordered. |
| EXPIRATION DATE: `expiration_date` | No generic transaction-line target established | Optional | Verify supported custom field/feature for target item type; otherwise explicit disposition needed. |
| TAX: `tax_code` | Potential valid tax item/code reference | Optional in local SO | Resolve actual QB tax item/list ref and confirm SO tax rules. The three Invoice local labels are not QB IDs. |

Intuit's SDK guide notes that Sales Orders are non-posting and that sales tax information may be optional for SalesOrderAdd while required for later invoice creation in applicable flow. This must be checked for the actual target/version/company rather than generalized to the local labels. Reference: [QBSDK Programmer's Guide, linking Invoices to Sales Orders](https://static.developer.intuit.com/qbSDK-current/doc/pdf/QBSDK_ProGuide.pdf).

## Mapping release gate

Before an operation is enabled, resolve every customer and product against the intended company file using a supported exact name query/reference. Produce an operator-approved crosswalk containing local primary key, local business code/name, returned QB FullName, record type, active state, source company and export timestamp. Keep returned ListID as optional diagnostic/compatibility data if available; it is not a staff-maintained requirement. Reconcile duplicates and used historical lines. Separate business-facing code from the authoritative QuickBooks name in persistence/logs. No current live mapping is marked complete.
