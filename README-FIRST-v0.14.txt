BRICK & DECOR PWA v0.14 — L1.5 QUOTATION / SIGNING / UPGRADE MEDIA PATCH

BUILT ON
- Full v0.13 quotation-structure/company-document build.
- Existing v0.12 Supabase, multi-ID, commission, flexible invoice and supplier-cost functions retained.

IMPORTANT SUPABASE STEP
Run this once before testing cross-device E-sign for Letter of Appointment / VO / Handover:
  04_v0.14_document_esign.sql

Supabase Dashboard -> SQL Editor -> New query -> paste the whole file -> Run.

This migration does NOT replace quotation E-sign. Existing quotation E-sign continues using the previously-installed quotation E-sign RPCs.

V0.14 MAIN CHANGES
1. Larger/aligned Add Quotation Scope modal.
2. Work Section -> Area / Location -> many Item / Service rows retained.
3. Customer-facing wording uses "Combined Amount" workflow; final quotation never displays the system wording "Lump Sum".
4. Standard Professional Services block is automatically included on quotations unless the ID explicitly removes it; it can be restored.
5. Quotation print layout uses repeating header/customer-info area and signature footer on normal quotation pages.
6. Terms & Conditions starts on a separate print page and has its own left/right company/customer signature area.
7. ID / staff can save their own signature for use on documents.
8. Quotation customer E-sign link requires at least one assigned ID signature to be saved first.
9. Letter of Appointment, VO and Handover support ID-side signature + secure customer cross-device E-sign link after the v0.14 SQL migration is installed.
10. Selecting the exact EXCEL free-upgrade item auto-inserts the supplied EXCEL product image into the quotation.
11. Selecting the NIPPON PAINT Anti Mould Kitchen & Bathrooms Ceiling free-upgrade item auto-inserts the supplied Nippon/bathroom image into the quotation. Extra spaces in the item wording are normalized for matching.
12. Upgrade images are shown once per quotation even if the same upgrade item is repeated.
13. Company selected on the Case continues to control the company logo/details/document wording.

STANDARD PROFESSIONAL SERVICES DEFAULT
- Space Planning & Furniture Layout
- Design Consultation
- Home styling Consultation
- Materials & Colour Proposal
- 7 Perspective Drawings
- Project Management & Site Supervision & Audit
- 12 Mths Warranty With Guaranteed After Sales Service on Water Proofing
- 24 Months Warranty With Guaranteed After Sales Service on Workmanship

DEPLOYMENT
1. Run 04_v0.14_document_esign.sql in Supabase once.
2. Copy all files from this ZIP into the ROOT of the existing brick-decor-pwa-test repository, replacing the v0.13 web files.
3. Commit and push to main.
4. Wait for GitHub Pages deployment.
5. Test with:
   https://romulas-oh.github.io/brick-decor-pwa-test/?v=0141
6. Hard refresh once (Ctrl+Shift+R) if needed.

DO NOT run old migration files again unless specifically instructed.
