# QuickBooks Integration Design (Preparation Only)

## Current boundary (reviewed 2026-10-21)

The intended product named in `frontend/settings.php` is QuickBooks Desktop Enterprise Solutions 24.0, and the README identifies Web Connector/qbXML as the intended integration route. The deployment itself is not verified. Do not assume QuickBooks is installed on the PHP host, that a company file is selected, or that Web Connector is available. Online API/OAuth configuration was not found. Do not select or implement an adapter until the administrator confirms the actual edition, company-file host, network/TLS arrangement, Web Connector/SDK versions, and permissions.

Intuit's QBSDK Programmer's Guide examples show `CustomerRef.FullName` and `ItemRef.FullName` in a `SalesOrderAdd`, and `CustomerRef.FullName` in an `InvoiceAdd`; QuickBooks list references also support `FullName`. Therefore a locally stored ListID is not inherently required when the chosen transaction supports and receives the exact authoritative full name. This is a protocol capability, not proof that local `client_name` or `qb_code` matches the intended company file. See [QBSDK Programmer's Guide](https://static.developer.intuit.com/qbSDK-current/doc/pdf/QBSDK_ProGuide.pdf), [InvoiceAdd](https://developer.intuit.com/app/developer/qbdesktop/docs/api-reference/qbdesktop/invoiceadd), [SalesOrderAdd](https://developer.intuit.com/app/developer/qbdesktop/docs/api-reference/qbdesktop/salesorderadd). The Web Connector/service/company file is absent or unverified, so no live name lookup or transaction was tested.

## Proposed boundary

Keep invoice and Sales Order controllers local-only. Add a distinct `backend/integrations/quickbooks/` service only after deployment prerequisites and test company are supplied. Its transport adapter should implement the selected QBWC WSDL methods and isolate qbXML generation/parsing. A separate coordinator should validate local transaction state, resolve identifiers, enqueue/lock a transaction, call the adapter, validate the response, and reconcile uncertain results. Controllers should call the coordinator; templates must not generate qbXML or access connector credentials.

Required operations, only after actual SDK/company-file verification:

- connection/health and company-file identity check;
- customer and item lookup against the actual file;
- Invoice Add and Sales Order Add as separate transaction operations;
- lookup/reconciliation by a reliable transaction reference before retry;
- normalized response/error handling with secrets and full sensitive payloads redacted.

The local schema keeps legacy optional client/product `qb_list_id` fields and business-facing product `qb_code`. Client maintenance and product maintenance do not ask staff to enter ListIDs. `backend/core/quickbooks_readiness.php` now separates local checks from unperformed live name resolution and does not make an empty ListID a local-preflight blocker. It still blocks posting because no connector/company-file verification or authoritative name resolution exists. For a future name-based path, use exact `CustomerRef.FullName` / `ItemRef.FullName` only after resolving the selected record against the intended company file; do not fuzzy-match, auto-create, or assume local name/code equals QuickBooks FullName. Preserve optional ListIDs for compatibility/reconciliation, not as a staff-maintained requirement.

## Data mapping decisions still required

| Local value | Candidate source | Required verification |
|---|---|---|
| Customer business identity | `clients.client_name` | Exact match to authoritative current-file customer FullName, unambiguous query/verification; local name alone is not proof. |
| Item business code | `products.qb_code` | Match to authoritative QuickBooks item code/name using company query; do not assume QB Code equals QuickBooks FullName. |
| Item reference | Returned/verified item `FullName` (or optional verified `qb_list_id` if operation chooses it) | Verify exact item, item type, active state, code association and intended company. No lookup currently exists. |
| Customer/item legacy IDs | `clients.qb_list_id`, `products.qb_list_id` | Optional compatibility values; never synthesize or require staff to maintain them for supported FullName references. |
| Description | `products.qb_description` | Required for a QB-bound line if confirmed by the selected request; never substitute HT text. Historical saved descriptions remain unchanged. |
| Quantity / rate / amount | Invoice or Sales Order saved lines | Validate positive whole quantity and local currency precision. Verify QB line semantics and tax behavior in the test company. |
| Site, lot, U/M, class, status, fulfilled quantity, expiry, tax | Local line fields | Each needs an actual supported transaction field, custom field, or explicit documented non-transfer decision; do not map by guess. |
| Invoice memo / Sales Order memo / PO | Local headers | Preserve locally; verify which field is supported and test actual round-trip. Local save is not evidence it was sent. |
| Document number | `invoice_number` / `so_number` | Verify correct QB reference field and uniqueness behavior per transaction type. |

## Posting state and duplicate/recovery model

The current `qb_jobs` table is invoice-only and does not implement a posting API. Before any posting is enabled, use durable local state per transaction type and local transaction ID, with a unique idempotency/posting key; states should distinguish Draft, Ready, Posting, Posted, Failed, and Outcome Unknown / Reconciliation Required. Store attempt timestamps, sanitized error, response identifiers, and verified QB transaction ID. A Sales Order must never be sent through the invoice operation.

Claim/lock the transaction in a short local DB transaction before sending; prevent another worker/user from claiming the same key. Never hold a database transaction open over network calls. On timeout/lost response, set Outcome Unknown and reconcile against QuickBooks using a supported stable reference before retry. Do not blind-retry or mark Posted because a request was sent. Mark Posted only after parsing and verifying the actual response and returned transaction identifier. Preserve attempt history. An administrator reconciliation path must be designed and tested before production.

## Security and operational prerequisites

- Restrict connector endpoints to authenticated Web Connector flows; validate SOAP method state/ticket transitions and protect secrets at rest/out of logs.
- Require role authorization and CSRF for any user-initiated posting/reconciliation action; server-side authorization is mandatory.
- Use TLS compatible with the verified Web Connector version, deployment secrets management, sanitized logs, prepared SQL, and audit events.
- Test the selected QBWC/SDK version, company-file permissions, transaction permissions, successful response, validation error, duplicate collision, timeout/unknown outcome, and recovery in an isolated QB test company.
- Get approved customer/item mapping crosswalks and tax/class/UOM/site/custom-field decisions before posting.

No database posting-state migration is included in this preparation task. Do not apply a speculative schema until the actual connector and required state transitions are approved and tested.
