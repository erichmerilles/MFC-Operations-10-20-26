# QuickBooks Integration Workflow and Recovery Specification

**Current state:** Preparation only. This is a target workflow, not implemented behavior.

## Existing local flow

Withdrawal saves to the local MariaDB database. Invoice preparation writes an Invoice draft to `invoices`/`invoice_items`; Sales Order preparation writes a separate draft to `sales_orders`/`sales_order_items`. The two local save controllers validate and commit local drafts but do not submit transactions to QuickBooks. Existing invoice `qb_jobs` schema is not an active processor and has no Sales Order relation.

## Proposed phase boundary (after environment and mappings pass)

1. **Draft:** Staff edits only the local transaction. Existing withdrawal and draft responsibilities stay separate.
2. **Preflight:** Backend reloads authoritative local header/lines, customer/item mappings and target environment identity. Check role permission, status, all required values, active/unique references, amount/tax policy, and unsupported field decisions. The frontend is informational; backend is authoritative.
3. **Claim:** In a short database transaction, atomically claim one transaction under a unique `(transaction_type, local_transaction_id)` key. Persist an attempt ID and `Processing` state before network work. A second request sees the claim and cannot initiate another send.
4. **Resolve and build:** Transaction-specific service resolves the exact selected customer and each item against the configured company file using supported query/name-reference mechanisms. It requires one correct active customer/item match, checks QB Code-to-item association and item type, then uses returned authoritative `FullName` references where supported. Optional legacy ListIDs may be cached but are not mandatory. It serializes separate InvoiceAdd/SalesOrderAdd qbXML, validates selected-version structure and escapes XML.
5. **Exchange:** QBWC polls the configured service using its WSDL flow and returns qbXML responses. Store request/response safely with redaction/data-minimization rules. Never expose credentials/tickets or raw sensitive payloads to ordinary users.
6. **Classify:** Parse response status by requestID and transaction type. On success, persist returned `TxnID`, `TxnNumber`/document reference where present, raw-safe diagnostic metadata, completion time and `Posted` state atomically. A request merely sent is not success.
7. **Reject:** A definitive QuickBooks validation rejection becomes `Failed`; preserve a sanitized error and allow corrected retry only after revalidation and new attempt record.
8. **Uncertain:** Timeout, connector loss, malformed/missing response after possible acceptance, or server restart after send becomes `Outcome Unknown / Reconciliation Required`. It is locked against automatic retry.
9. **Reconcile:** Authorized operator checks the intended company file using supported query/reconciliation criteria. Record who checked, when, evidence/reference and result. If found, attach verified transaction identifiers and resolve as posted. If not found with sufficient evidence, authorize a new attempt. If ambiguous, leave blocked and escalate.

## Durable state model (proposal)

`Draft → Ready → Processing → Posted`

`Processing → Failed` only for a definitive rejection/failure before acceptance.

`Processing → Outcome Unknown / Reconciliation Required` when acceptance cannot be ruled out.

`Outcome Unknown → Posted` only after verified lookup, or `Outcome Unknown → Ready` only after an authorized reconciliation establishes that no transaction exists. Preserve every attempt and state transition; never erase an uncertain attempt.

The existing invoice enum values (`Queued`, `Processing`, `Invoiced`, `Error`, `Uncertain Result`) are not a complete shared model and do not implement the transitions. Existing `qb_jobs` has a unique request key and invoice uniqueness constraint but no sending/reconciliation code; database presence alone does not prove duplicate safety. Exactly-once delivery must not be claimed.

## Required controls before implementation

- Unique durable posting key per local transaction type and ID; database constraint and atomic compare-and-set/row lock.
- Do not hold a DB transaction open while waiting for QBWC/network.
- Disallow deletion or edits while `Processing`, `Posted`, or outcome unknown; define controlled correction/void process with audit trail.
- Store attempt IDs, state timestamps, initiator, transaction type, request hash, sanitized error, response disposition and verified QB IDs.
- Separate Invoice and Sales Order queue/type constraints, serializers, response parsing and UI labels. An SO must never use InvoiceAdd.
- Pre-send duplicate check and post-timeout reconciliation query using a field that is actually searchable/unique enough in the target file; local number uniqueness does not prove QuickBooks uniqueness.
- Redact SOAP tickets/passwords and limit retained qbXML containing customer data; audit read access to sensitive logs.
- Rate-limit and authenticate QBWC methods according to the selected protocol; protect against replay, arbitrary transaction type and ID manipulation.
- Operational alerting for stale Processing/Unknown jobs and named reconciliation owner.

## Recovery decision table

| Observed event | State/action | Retry? |
|---|---|---|
| Preflight invalid before any request is released | Keep Draft/Failed validation; display actionable field errors | After correction and preflight. |
| QBWC returns definitive successful response with expected response type and TxnID | Persist Posted plus returned identifiers | No resubmit. |
| QBWC returns definitive QuickBooks validation error | Persist Failed and sanitized status code/message; correct source/master/configuration | Only as a new authorized attempt after correction. |
| No poll before request was issued | Return to Ready only if durable attempt proves no qbXML was handed off | Yes after lock/state verification. |
| Connection lost or timeout after request could have been accepted | Outcome Unknown; lock transaction; preserve attempt | **No automatic retry.** Reconcile first. |
| Response type/ID mismatch, duplicate warning, parser failure after send | Outcome Unknown / manual review | **No automatic retry.** Query target company. |
| Found candidate transaction during reconciliation | Verify customer, date, number, lines and transaction type; record returned IDs | Mark Posted only after identity is sufficiently established. |
| No candidate found | Record query scope/time/operator; retry only after authorized determination and safe state transition | Controlled new attempt. |

The proposed behavior must be adjusted to the actual QBWC WSDL and QuickBooks response semantics, then tested in the isolated test company. It is not a guarantee that QuickBooks enforces idempotency.
