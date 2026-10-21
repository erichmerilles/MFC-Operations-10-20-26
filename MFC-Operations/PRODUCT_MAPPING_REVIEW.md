# Active Product Mapping Review

**Observed:** 2026-10-20 (Asia/Taipei)
**Source:** Read-only query of active rows in configured `withdrawal_qb.products`. No product records were changed.

## Summary

- 92 active products; 94 total products (2 inactive).
- Missing HT Code: 1.
- Missing QB Code: 18.
- Missing QB Description: 18.
- Missing QuickBooks ListID: 92.
- No duplicate active HT Codes, QB Codes, or nonblank ListIDs were found.
- 74 active products have HT Code, QB Code, and QB description; none has a QB ListID.

See [PRODUCT_MAPPING_RECONCILIATION.md](PRODUCT_MAPPING_RECONCILIATION.md) for the full 92-product inventory, completeness status, duplicate check, safe preparation behavior, and authoritative sources needed for each missing field.

## Products missing business mapping data

| Product ID | Product | HT Code | QB Code | QB Description | Missing fields | Authoritative source needed |
|---:|---|---|---|---|---|---|
| 475 | 7/7 FINEST SHOESTRING XTRA CRISPY | HSC045-010 | — | — | QB Code, QB Description | approved QB item crosswalk |
| 480 | CRUNCHY OVAL HASH BROWN | HSC045-019 | — | — | QB Code, QB Description | approved QB item crosswalk |
| 486 | 7/7 THIN CUT SHOESTRING | HSC045-027 | — | — | QB Code, QB Description | approved QB item crosswalk |
| 488 | SAMPLE ITEM | HSC045-029 | — | — | QB Code, QB Description | approved QB item crosswalk |
| 495 | LUCKY COMBO 5IN1 500gx24 | HSC045-037 | — | — | QB Code, QB Description | approved QB item crosswalk |
| 496 | FRIED FISH BALL 500gx24 | HSC045-038 | — | — | QB Code, QB Description | approved QB item crosswalk |
| 498 | CUTTLE FISH BALL W/ SQUID INK 1KGX10 | HSC045-040 | — | — | QB Code, QB Description | approved QB item crosswalk |
| 499 | CUTTLE FISH BALL W/ SQUID INK 160GX40 | HSC045-041 | — | — | QB Code, QB Description | approved QB item crosswalk |
| 500 | 7/7 FINEST SHOESTRING 1034137-71 | 1034137-71 | — | — | QB Code, QB Description | approved QB item crosswalk |
| 501 | 7/7 THINCUT SHOESTRING RUSSET | HSC045-043 | — | — | QB Code, QB Description | approved QB item crosswalk |
| 505 | 10/10 CLASSIC CUT FRIES 2.5KG | HSC045-046 | — | — | QB Code, QB Description | approved QB item crosswalk |
| 517 | CLASSIC CUT FRENCH FRIES 20x450g | — | — | — | HT Code, QB Code, QB Description | approved product master / HT crosswalk; approved QB item crosswalk |
| 522 | REUNION COMBO W/ BROWN SAUCE | HSC045-064 | — | — | QB Code, QB Description | approved QB item crosswalk |
| 523 | MINI COMBO W/ GOLDEN SAUCE | HSC045-065 | — | — | QB Code, QB Description | approved QB item crosswalk |
| 524 | CHRISTMAS BUNDLE 066 | HSC045-066 | — | — | QB Code, QB Description | approved QB item crosswalk |
| 530 | FUZHOU | HSC045-072 | — | — | QB Code, QB Description | approved QB item crosswalk |
| 531 | FISHBALL WITH SALTED EGG | HSC045-073 | — | — | QB Code, QB Description | approved QB item crosswalk |
| 532 | PARTY COMBO | HSC045-074 | — | — | QB Code, QB Description | approved QB item crosswalk |

The legacy QuickBooks ListID column is empty for every active product. This alone does not block use of supported `FullName` references and is not a staff-maintained prerequisite. However, actual QuickBooks item FullNames have not been retrieved or verified against QB Codes in the intended company. Do not infer a FullName from the local QB Code. Invoices and Sales Orders still save locally only; no QuickBooks submission or live name lookup is available. A product with a missing QB Code remains unavailable/blocked for invoice and Sales Order line saving.
