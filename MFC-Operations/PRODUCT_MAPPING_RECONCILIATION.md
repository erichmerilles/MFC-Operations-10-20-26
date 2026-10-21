# Active Product Mapping Reconciliation

**Observed:** 2026-10-20 (Asia/Taipei)
**Source:** Read-only query of `withdrawal_qb.products` (`active = 1`).
**Changes to company data:** None.

## Summary

- Active products reviewed: 92 of 94 total products (2 inactive).
- Missing HT Code: 1.
- Missing QuickBooks Item Code (`qb_code`): 18.
- Missing QuickBooks description: 18.
- Missing QuickBooks ListID: 92 (all active products).
- Products with HT Code, QB Code, and QB description present: 74.
- Products with a verified QB ListID: 0.

All invoices and Sales Orders remain local drafts; no QuickBooks posting path is implemented. The invoice product selector omits products without QB Codes and its backend validates codes; Sales Order save explicitly rejects missing or ambiguous QB Code mappings. The displayed ListID column below is a legacy stored value snapshot. Its absence does not by itself block supported FullName-based references or local draft readiness. The authoritative QuickBooks FullName and its association with each business QB Code still must be verified against the intended company before posting.

## Duplicate and conflict checks

Read-only grouping of active records found no duplicate nonblank HT Codes, QB Codes, or QuickBooks ListIDs. There are no duplicate/conflicting references in those mapping columns in this snapshot. This does not establish that the existing descriptions or codes match the current company file.

## Authoritative sources

- **HT Code:** approved company product master or controlled HT-to-QB crosswalk.
- **QB Code and QB description:** approved company product/QuickBooks item crosswalk, reviewed by the mapping owner.
- **QuickBooks ListID:** item-list export or verified lookup from the intended QuickBooks Enterprise company file through the approved integration method. A business code, product name, or description is not a substitute for ListID.

## Active product inventory

| Product ID | Product name | HT Code | QB Item Code | QB description | QuickBooks ListID | Missing fields | Mapping status | Authoritative source needed |
|---:|---|---|---|---|---|---|---|---|
| 472 | POTATO NOISETTES | HSC045-003 | LUTBENOIS0254 | Lutosa Potato Noisettes 2.5kg | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 474 | 10/10 STRAIGHTCUT XTRA CRISPY | HSC045-009 | LUTBEFX1010FX0206 | Lutosa Finest 10/10 Xtra Xrispy 2kg | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 475 | 7/7 FINEST SHOESTRING XTRA CRISPY | HSC045-010 | — | — | — | QB Code, QB description, QuickBooks ListID | BLOCKED: QB Code missing; invoice/SO line cannot be saved | approved QB item crosswalk; intended QB Enterprise item-list lookup |
| 476 | 10/10 STRAIGHTCUT SKIN-ON | HSC045-012 | LUTBE1010SO02504 | Lutosa Finest 10/10 Straight Cut Skin on 2.5 kg | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 477 | 14/14 THICK CUT FRIES | HSC045-013 | LUTBE1414SO02504 | Lutosa Finest 14/14 Straight Cut Skin On 2.5kg | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 478 | 5/5 SKINNY SKIN-ON | HSC045-015 | LUTBE0505FS02504 | Lutosa Skinny Fries Xtra Crispy Food services 2.5kg | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 479 | CRUNCHY HASH BROWN | HSC045-018 | LUTBEHBTRI250 | Lutosa Hashbrown Traingle 2.5kg | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 480 | CRUNCHY OVAL HASH BROWN | HSC045-019 | — | — | — | QB Code, QB description, QuickBooks ListID | BLOCKED: QB Code missing; invoice/SO line cannot be saved | approved QB item crosswalk; intended QB Enterprise item-list lookup |
| 481 | MASHED POTATO | HSC045-020 | LUTBEMASH250 | Lutosa Mash Potato 2.5 kg | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 482 | SPICY WEDGES | HSC045-022 | LUTBEWDGTEX2504 | Lutosa Tex Mex Wedges 2.5 x 4 | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 483 | POTATO WEDGES | HSC045-023 | LUTBEWDGQTR2504 | Lutosa Quarter Wedges 2.5 x 4 | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 484 | CRINKLE CUT | HSC045-025 | LUTBECRKL2504 | Lutosa Crinkle Cut 2.5 x 4 | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 485 | FROZEN KERNEL CORN | HSC045-026 | CMDCK100 | Starmax Frozen  Kernel Corn 1 kg | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 486 | 7/7 THIN CUT SHOESTRING | HSC045-027 | — | — | — | QB Code, QB description, QuickBooks ListID | BLOCKED: QB Code missing; invoice/SO line cannot be saved | approved QB item crosswalk; intended QB Enterprise item-list lookup |
| 487 | 7/7 SHOESTRING 2 KILO CHINA | HSC045-028 | LUTCN77ORG20006 | Lutosa Orange Pack 2 kg | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 488 | SAMPLE ITEM | HSC045-029 | — | — | — | QB Code, QB description, QuickBooks ListID | BLOCKED: QB Code missing; invoice/SO line cannot be saved | approved QB item crosswalk; intended QB Enterprise item-list lookup |
| 489 | KDHY 7/7 SHOESTRING 2KG | HSC045-030 | KDHY0707200 | KDHY 7/7 Shoe strings  2 kg | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 490 | POTATO CRUNCHIES | HSC045-031 | RPLUTCRU0750 | Lutosa Crunchies 750grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 491 | SPICY WEDGES 750G | HSC045-032 | RPLUTWDGTEX0750 | Lutosa Spicy Wedges 750 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 492 | SEA URCHIN 190G X 40 | HSC045-034 | CB0010190G | CB Sea Urchin Falvored Balls 190 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 493 | SALMON FLAVOURED 175G X 40 | HSC045-035 | CB0080175G | Salmon Ball falvored with Cheese 175 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 494 | WHITE FISHBALL 500gx24 | HSC045-036 | CB0090500G | White Fishball 500 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 495 | LUCKY COMBO 5IN1 500gx24 | HSC045-037 | — | — | — | QB Code, QB description, QuickBooks ListID | BLOCKED: QB Code missing; invoice/SO line cannot be saved | approved QB item crosswalk; intended QB Enterprise item-list lookup |
| 496 | FRIED FISH BALL 500gx24 | HSC045-038 | — | — | — | QB Code, QB description, QuickBooks ListID | BLOCKED: QB Code missing; invoice/SO line cannot be saved | approved QB item crosswalk; intended QB Enterprise item-list lookup |
| 497 | JAPANESE FISH TOFU 160gx40 | HSC045-039 | CB0040160G | Japanese Fish Tofu 160 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 498 | CUTTLE FISH BALL W/ SQUID INK 1KGX10 | HSC045-040 | — | — | — | QB Code, QB description, QuickBooks ListID | BLOCKED: QB Code missing; invoice/SO line cannot be saved | approved QB item crosswalk; intended QB Enterprise item-list lookup |
| 499 | CUTTLE FISH BALL W/ SQUID INK 160GX40 | HSC045-041 | — | — | — | QB Code, QB description, QuickBooks ListID | BLOCKED: QB Code missing; invoice/SO line cannot be saved | approved QB item crosswalk; intended QB Enterprise item-list lookup |
| 500 | 7/7 FINEST SHOESTRING 1034137-71 | 1034137-71 | — | — | — | QB Code, QB description, QuickBooks ListID | BLOCKED: QB Code missing; invoice/SO line cannot be saved | approved QB item crosswalk; intended QB Enterprise item-list lookup |
| 501 | 7/7 THINCUT SHOESTRING RUSSET | HSC045-043 | — | — | — | QB Code, QB description, QuickBooks ListID | BLOCKED: QB Code missing; invoice/SO line cannot be saved | approved QB item crosswalk; intended QB Enterprise item-list lookup |
| 502 | 10/18 STEAK FRIES 2.5KG | HSC045-042 | LUTBE10182504 | Lutosa Steak Fries 10-18 2.5 x 4 | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 503 | KRISSPY CRINKLE CUT 1KG | HSC045-044 | RPLUTCRK100 | Lutosa Crinkle Cut 1 x 10RPLUTCRK100 | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 504 | 10/10 CLASSIC CUT FRIES 1KG | HSC045-45 | RPLUT1010100 | RP Lutosa Classic Cut 10/101kg | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 505 | 10/10 CLASSIC CUT FRIES 2.5KG | HSC045-046 | — | — | — | QB Code, QB description, QuickBooks ListID | BLOCKED: QB Code missing; invoice/SO line cannot be saved | approved QB item crosswalk; intended QB Enterprise item-list lookup |
| 506 | SAVEMORE 1KG | HSC045-047 | SVCHN770110 | Savemore 7/7 Fries 1 kg | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 507 | SAVEMORE 2KG | HSC045-048 | SVCHN770206 | Savemore 7/7 Fries 2kg | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 508 | MIXED VEGGIES 20x500g | HSC045-049 | IQFMIX3340500 | Mixed Vegetables Corn, carrots & peas 334 500 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 509 | CALIFORNIA MIXED | HSC045-050 | IQFCALI050020 | Yummy California Mix 500 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 510 | MIXED BERRIES | HSC045-051 | IQFMBRS0500 | Mixed Berries 500 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 511 | SWEET POTATO | HSC045-052 | LUTCNSP10102504 | Lutosa Sweet Potato 2.5 kg | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 512 | 10/10 STRAIGHTCUT 2KG CHINA | HSC045-053 | LUTCN1010ST20006 | Lutosa CN 10/10 Stright Cut 2 kg | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 513 | POTATO NOISETTES 750G | HSC045-054 | RPLUTNOIS75012 | Lutosa Noisettes 750 grams Retail Pack | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 514 | POTATO CROQUETTES 750G | HSC045-055 | RPLUTCROQ75012 | Lutosa Croquette 750 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 515 | HASH BROWN MINI 4 X 2.5 KG | HSC045-056 | LUTBEHBMNTRI250 | Lutosa Mini Triangle HAshbrown 2.5kg | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 516 | 7/7 THINCUT SHOESTRING 24x400g | HSC045-058 | RPSLUT070740024 | Lutosa Shoes Strings 400 | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 517 | CLASSIC CUT FRENCH FRIES 20x450g | — | — | — | — | HT Code, QB Code, QB description, QuickBooks ListID | BLOCKED: QB Code missing; invoice/SO line cannot be saved | approved product master / HT crosswalk; approved QB item crosswalk; intended QB Enterprise item-list lookup |
| 518 | FROZEN STRAWBERRY | HSC045-060 | IQFSTRW0500 | Frozen Strawberry 500 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 519 | BEEF BALL W/ MOZZA 300g | HSC045-061 | CB0120300G | Beef ball with Cheese 300 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 520 | PRAWN FLAVOURED BALL | HSC045-062 | CB0070190G | Prawn Flavor Ball with Fish roe 190 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 521 | JUMBO FISH BEAN CURD 350g | HSC045-063 | CB010350 | CB Jumbo Fish Bean Curd 350 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 522 | REUNION COMBO W/ BROWN SAUCE | HSC045-064 | — | — | — | QB Code, QB description, QuickBooks ListID | BLOCKED: QB Code missing; invoice/SO line cannot be saved | approved QB item crosswalk; intended QB Enterprise item-list lookup |
| 523 | MINI COMBO W/ GOLDEN SAUCE | HSC045-065 | — | — | — | QB Code, QB description, QuickBooks ListID | BLOCKED: QB Code missing; invoice/SO line cannot be saved | approved QB item crosswalk; intended QB Enterprise item-list lookup |
| 524 | CHRISTMAS BUNDLE 066 | HSC045-066 | — | — | — | QB Code, QB description, QuickBooks ListID | BLOCKED: QB Code missing; invoice/SO line cannot be saved | approved QB item crosswalk; intended QB Enterprise item-list lookup |
| 525 | BLUEBERRY 20 X 500G | HSC045-067 | IQFBLUE050020 | Yummy Blueberries 500 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 526 | SPINACH BALL 20 X 500G | HSC045-068 | IQFSPIBLL050020 | Yummy Spinach Balls 500 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 527 | ROSTIS WITH ONION TASTE 1 KG | HSC045-069 | RPLUTROS10010 | Lutosa ROSTI 1 KG | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 528 | RUSTIC POTATO SLICES 2.5KG | HSC045-70 | LUTBESLRUS25004 | Lutosa Rustic Slices 2.5 kg | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 529 | KOREAN STYLE FISHCAKE | HSC045-071 | CBFCKR0320 | CB korean Style Fish Cake 320 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 530 | FUZHOU | HSC045-072 | — | — | — | QB Code, QB description, QuickBooks ListID | BLOCKED: QB Code missing; invoice/SO line cannot be saved | approved QB item crosswalk; intended QB Enterprise item-list lookup |
| 531 | FISHBALL WITH SALTED EGG | HSC045-073 | — | — | — | QB Code, QB description, QuickBooks ListID | BLOCKED: QB Code missing; invoice/SO line cannot be saved | approved QB item crosswalk; intended QB Enterprise item-list lookup |
| 532 | PARTY COMBO | HSC045-074 | — | — | — | QB Code, QB description, QuickBooks ListID | BLOCKED: QB Code missing; invoice/SO line cannot be saved | approved QB item crosswalk; intended QB Enterprise item-list lookup |
| 533 | 7/7 SHOESTRING 1 KILO NEW PACK | HSC045-075 | LUTCN77ORG10010 | Lutosa Red Pack 1 x 10 New packaging | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 534 | POTATO FLAKES 10X1KG | HSC045-076 | LUBETFLK01006 | Lutosa Potato Flakes 5 mm 1 kg | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 535 | NATURAL CUT ONION RING | HSC045-077 | BSQORBR0500 | Onion Ring Natural Cut (Beer flavor) | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 536 | BREADED JALAPENO WITH CHEESE | HSC045-078 | BSQJAL0500 | Baby Star Jalapeno Stick 500 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 537 | BATTERED ONION RING | HSC045-079 | BSQORBAT0500 | Onion Ring Battered Formed 500 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 538 | BREADER MOZZARELLA CHEESE | HSC045-080 | BSQMOZ0500 | Baby Star Mozarella Stick 500 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 539 | SQUID INK CALAMARI RING | HSC045-081 | BSQCALSI0500 | Baby Star Squid IIn Calamari Ring 500 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 540 | 13/13 STRAIGHTCUT | HSC045-082 | LUTCN13132006 | Lutosa 13/13 2 kg | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 541 | CHICKEN POPPIN' BITES 500G | HSC045-083 | BTSPOP0500 | Best tasting Snacks Chicken Poppers 500 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 542 | CHICKEN BREAST CHUNKS 1KG | HSC045-084 | BTSCCHK1000 | BTS Coated Chicken Breast Chunk 1kg | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 543 | SHREDDED CHICKEN 1KG | HSC045-085 | BTSSHC01000 | BTS Shredded Chicken Breast 1 kg | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 544 | MIXED VEGGIES 10X1KG | HSC045-086 | IQFMIX33401000 | Mixed Vegetables Corn, carrots & peas 334  1Kg | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 545 | 12/12 CRINKLE CUT CHINA 10X1KG | HSC045-087 | LUTCNCKL10010 | Lutosa Crinkle Cut 1kg | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 546 | CHICKEN SHREDDED 250G X 40 | HSC045-088 | BTSSHC00250 | BTS Shredded Chicken Breast 250 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 547 | CHICKEN CHUNKS 250G X 40 | HSC045-089 | BTSCCHK0250 | BTS Coated Chicken Breast Chunk 250 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 548 | CHICKEN POPPIN' BITES 200G X 25 | HSC045-090 | BTSPOP0200 | Best tasting Snacks Chicken Poppers 200 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 549 | CLASSIC FRIED CHICKEN 600G X 16 | HSC045-091 | BTSBIC006 | BTS Classic Crispy Chicken 6's | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 550 | GRILLED TENDER CHUNKS 200GX25 | HSC045-092 | BTSGTC0200G | BTS Grill Tender Chunks 200 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 551 | 7/7 CRISPY COATED 6X2KG | HSC045-093 | LUTCNCT070720006 | Lutosa Coated Fries 7/7 Shoestring 2 kg | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 552 | 10/10 CRISPY COATED 6X2KG | HSC045-094 | LUTCNCT101020006 | Lutosa  Coated Fries 10/10 straight cut  2 kg | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 553 | GC GARLICKY ADOBO 200GX40 | HSC045-095 | GCGAR20040 | Grill Choice Garlicky Adobo Chicken 200 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 554 | GC HERB SALAD 100GX50 | HSC045-096 | GCHTOM10050 | Grill Choice Herb Salad (Tom Kha) 100 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 555 | GC HERITAGE CHICKEN 200X40 | HSC045-097 | GCHERBBQ20040 | Grill Choice Heritage Barbeque Chicken 200 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 556 | GC PANDAN CHICKEN 240GX40 | HSC045-098 | GCPAN24040 | Grill Choice Pandan Chicken 240grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 557 | GC PAPER WRAPPED CHICKEN 240GX40 | HSC045-099 | GCPAP24040 | Grill Choice Paper Wrapped Chicken 240grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 558 | GC HAINANESE 190g x48 | HSC045-0100 | GCHAI19048 | Grill Choice Singapore Hainanese Chicken 190 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 559 | BTS BUFFALO MIDDLE WINGS 24X300G | HSC045-0101 | BTSMIDBUF30024 | Best Tasting Snacks Buffalo MIddle Wings 300grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 560 | BTS NEW ORLEANS MIDDLE WING 24X300G | HSC045-0102 | BTSMIDNO30024 | Best Tasting Snack New Orleans MIddle wings 300 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 561 | GC GRILLED BBQ MD 300GX24 | HSC045-0103 | GCMIDSBBQ30024 | Grill Choice Smokey BBQ Middle Wing 300 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 562 | GC GARLICKY ADOBO MD 300G X 24 | HSC045-0104 | GCMIDGA30024 | Grill Choice Garlicky Adobo Middle Wing 300 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 563 | BTS CRISPY CHICKEN SKIN 24X300G | HSC045-0105 | BTSSK30025 | Best Tasting Snacks Crispy Chicken Skin 300 grams | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |
| 564 | MIXED VEGGIES 2WAY | HSC045-0106 | IQFMIX21101000 | Mixed Vegetables Corn & carrots 1:1 1kg | — | QuickBooks ListID | LOCAL DRAFT ONLY: QB ListID missing; not integration-ready | intended QB Enterprise item-list lookup |

## Database and integration safety

The source query was read-only. No mappings were edited and no migration was run. Do not infer ListIDs or authoritative FullNames from display values. Re-query the product master and reconcile a fresh QuickBooks item-list export before an integration milestone.
