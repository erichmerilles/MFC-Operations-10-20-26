# Product and Customer Mapping Readiness

**Snapshot:** 2026-10-20, configured `withdrawal_qb` database, read-only transaction. No identifiers or lifecycle values were inferred or edited.

## Products

| Local product state / mapping state | Count | Meaning for future QB transactions |
|---|---:|---|
| Database active (`active=1`) | 92 | Application selection flag only; it does not prove stock availability or lifecycle status. |
| Database inactive (`active=0`) | 2 | Not eligible for new local selections under current forms. This flag does not identify why a product is inactive. |
| Active with QB Code and QB Description | 74 | Business-facing local mapping fields exist; actual company-file item FullName/code association remains unverified. |
| Active missing QB Code and QB Description | 18 | Blocked from mapped selection/posting until authoritative values/status are reviewed. |
| Active missing stored QB ListID | 92 | Legacy IDs are absent; this is not by itself a blocker where a verified FullName reference is used. |
| Active fully verified against a current company file | 0 | No live QuickBooks name lookup or code-to-item association verification was performed. |
| Blocked by local inactive flag (`active=0`) | 2 | Not selectable as new products under the current forms; reason for deactivation is not stored. |
| Active products with stock/lifecycle unknown | 92 | Current `active=1` is not proof of availability, in-stock state, or non-discontinued status. |
| Confirmed out of stock / phased out / discontinued | Not determinable | No per-product status or stock table/column exists. |

The business stated that products with incomplete mappings are out of stock or phased out. That statement is not sufficiently specific to classify each product into one of those states, and no bulk updates were performed. Product IDs and individual mapping fields are listed in [PRODUCT_MAPPING_RECONCILIATION.md](PRODUCT_MAPPING_RECONCILIATION.md).

## Customers

| Client state / mapping state | Count | Meaning |
|---|---:|---|
| Total local clients | 819 | Local customer records. |
| Active local clients | 816 | Current local active flag. |
| Active clients missing stored QB ListID | 816 | Legacy IDs are absent; this is not by itself a blocker where a verified FullName reference is used. |
| Active clients verified against current company file | 0 | No current company-file name lookup was performed. |

Do not fuzzy-match on customer display name or create QuickBooks customers automatically. Obtain authoritative customer FullNames from the correct company file and verify exact name-based resolution. Do not require staff to populate ListIDs when the selected qbXML request supports FullName.

## Required business/data work

1. Provide an authorized product lifecycle/availability crosswalk identifying available, out-of-stock, phased-out/discontinued, or blocked products individually.
2. Preserve all historical product and transaction references when recording those statuses. Do not infer stock deductions or availability from withdrawals.
3. Reconcile QB Code and QB Description for the 18 active incomplete products from approved source material.
4. Export current customer and item identities, including authoritative FullName and item code/type/status, from the approved QuickBooks company file. Verify each local name/code association with exact live lookup; never infer FullName from QB Code or a local display name.
5. Re-run the report after approved mappings/statuses are verified. A local name or nonempty legacy ListID is not a live verification result.
