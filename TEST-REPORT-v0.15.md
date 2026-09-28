# Brick & Decor PWA v0.15 — Test Report

## Scope
Built on the v0.14.1 startup-hotfix package. v0.14 quotation hierarchy, company-specific documents, upgrade media, Supabase authentication, multi-ID and costing functions are retained.

## L1.6 changes checked

- ID/customer signature drawing now uses Pointer Events with pointer capture and pointer-up/cancel handling.
- Quotation signature status reports assigned ID signature state rather than only the logged-in account.
- Standard Professional Services are editable per quotation and resettable.
- Standard Professional Services hide Qty / 1 Lot / Internal Cost in the builder and omit quantity from customer output.
- Quotation descriptions preserve vertical line breaks in builder and print styles.
- Work Section Library and Property Type Library use managed visual lists with add / rename / reorder / delete controls.
- Printing uses a hidden iframe instead of opening an `about:blank` tab.
- Print CSS forces quotation/LOA/VO/Handover staff and client signatures into left/right columns.
- A4 print width is constrained to a safer 185 mm document width.
- Generic LOA / VO / Handover E-sign uses new v0.15 RPC names.
- `05_v0.15_esign_repair.sql` creates/repairs the document E-sign table and v0.15 RPCs and sends `NOTIFY pgrst, 'reload schema'`.

## Automated/static checks

- Embedded JavaScript blocks parsed by Node.js: **9 / 9 PASS**
- v0.15 feature/integrity assertions: **21 / 21 PASS**
- Service-worker referenced assets exist: **PASS**
- Manifest parses and reports B&D v0.15: **PASS**
- New document E-sign SQL contains all 4 v0.15 RPCs: **PASS**
- SQL includes PostgREST schema-cache reload notification: **PASS**
- v0.15 print override is the final active `printDoc` definition: **PASS**

## Live browser checks still required after deployment

The container's headless Chromium environment does not complete the app bootstrap reliably, so these must be visually tested in the deployed GitHub Pages build:

1. Reopen **My ID Signature**, draw at least three separate strokes, and confirm the ink stops after every mouse/touch release.
2. Verify the quote shows the correct assigned ID signature status.
3. Edit and reset the fixed Professional Services section.
4. Enter a multi-line description and verify the same vertical line breaks in the PWA and print preview.
5. Print/Cancel a quotation and LOA and confirm no `about:blank` tab remains.
6. Verify LOA signatures are left/right in Chrome print preview.
7. After running SQL 05, create an LOA/VO/Handover customer E-sign link and sign from Incognito or another device.

## Database note

Run `05_v0.15_esign_repair.sql` once before testing generic document E-sign. It is designed to be safe even if `04_v0.14_document_esign.sql` was previously run.
