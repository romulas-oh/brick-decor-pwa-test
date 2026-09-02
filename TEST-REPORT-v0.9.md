# Brick & Decor PWA v0.9 — L1.4 UX + Document Template Test Report

Build basis: full v0.8 L1.3 UX + Stability build.

## L1.4 verification

PASS

- Customer Record Payment modal includes optional PDF/image payment proof upload.
- BD Werks UEN = 202411448N.
- BD Werks bank = OCBC : 596-503052-001.
- BD Werks PayNow UEN = 202411448N.
- BD Werks is treated as payment-detail verified after the corrected matching UEN is applied.
- Company Master uses full-width structured company cards.
- Purchase Orders and Supplier Invoice Aging are separated into two sub-tabs.
- Supplier Invoice Aging receives the full available content width instead of sharing a compressed two-column layout.

## Document template behaviour

PASS

- Existing old generic defaults migrate to the new B&D System Default.
- All four companies initially show **System Default** when not customized.
- System Default contains business-ready wording instead of development placeholder instructions.
- Default payment schedule = 10% (minimum S$1,000) / 45% / 40% / 5%.
- Company Master shows Preview + Edit controls.
- Customized templates show **Customized** and a Restore Default control.
- Template editor is split into Quotation / LOA / Invoice-Receipt / VO / Handover / Payment Schedule tabs.
- Saved template preview works by company and template section.
- Restore Default returns the company to B&D System Default.
- Invoice / VO / DO-Handover / PO records receive a document-template snapshot for safer historical rendering in the frontend test.

## JavaScript / package checks

PASS

- Base inline JavaScript: `node --check`
- `src/v08-patch.js`: `node --check`
- `src/v09-patch.js`: `node --check`
- `sw.js`: `node --check`
- Every local asset listed by the v0.9 service worker exists.
- Load-time v0.9 VM evaluation completed successfully after correcting the invoice print wrapper to the existing `printInv` function.

## v0.9 runtime regression harness

28 / 28 passed.

Covered:

- BD Werks UEN / bank / PayNow correction
- System Default migration for all companies
- 10 / 45 / 40 / 5 payment schedule
- polished default quotation wording
- human-readable Company Master rendering
- System Default and Customized statuses
- BD Werks mismatch warning removal
- template Preview / Edit controls
- tabbed template editor
- saved Invoice / Receipt template preview
- Restore Default behaviour
- customer payment proof upload control
- Purchase Order sub-tab
- Supplier Invoice Aging sub-tab
- document-template snapshots
- Case Overview
- Case Quotation
- Case Supplier Cost
- Case Project Cost
- Case VO
- Case Customer Invoice
- Case Payment
- Case DO / Handover
- Case Profit
- Case Activity Log

## Existing v0.8 regression status retained

The v0.8 build previously passed its coordinated renderer and workflow harnesses covering quotation revisions, supplier duplicate control, supplier approval posting, manual cost, VO, handover, invoice/payment, closure, permissions and browser history. v0.9 changes are layered on top without removing those modules.

## Browser environment note

The execution environment blocks localhost pages in Chromium with an administrator policy, so a real visual browser screenshot test cannot be completed here. JavaScript syntax, load-time evaluation and DOM-stub runtime rendering were tested instead. After GitHub Pages upload, perform a short visual smoke test of Company Master, template modal, Record Payment upload and the two PO/Supplier sub-tabs.
