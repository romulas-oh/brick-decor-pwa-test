# Brick & Decor PWA v0.16 — L1.7 Test Report

## Scope
Coordinated L1.7 stability/UX patch on top of v0.15. No new Supabase migration is required; SQL 05 remains the latest migration.

## Automated checks
- JavaScript syntax: **10/10 PASS**
- Feature/static checks: **20/20 PASS**
- Service-worker asset existence: **9/9 PASS**

## L1.7 fixes covered
- My ID / Staff Signature modal now uses one self-contained pointer-safe state.
- Mouse/finger release is caught at window level and on browser blur, preventing stuck ink.
- Save Signature writes directly to the current local staff identity and refreshes the active page immediately.
- Customer quotation E-sign link creation no longer depends on the broken v0.15 wrapper; it calls the existing Supabase quotation E-sign backend directly.
- Document E-sign uses the SQL-05 v15 RPCs with the same repaired signature source.
- Professional Services default rows suppress Qty / 1 Lot / Internal Cost; manually keyed quotation items retain Qty and Unit.
- Professional Services can be edited/reset per quotation.
- Preview Close + Print / Save PDF controls move into a sticky action bar.
- Every standard modal receives a top-right × close button.
- Existing multiline descriptions and v0.14/v0.15 print/E-sign/company-document features are retained.

## Manual browser checks still required after GitHub Pages deploy
1. Open My ID Signature, draw 3 separate strokes with mouse, release after each, save, reopen.
2. Confirm quotation screen immediately recognises the saved signer.
3. Generate Customer E-sign Link and open it in Incognito/another phone.
4. Sign customer pad with multiple strokes and submit.
5. Open quotation preview and verify Close / Print buttons remain visible while scrolling.
6. Confirm fixed Professional Services do not show 1 Lot/Internal Cost, while a manually entered item still shows Qty/Unit.
7. Open several unrelated modals and confirm the × close control appears.

## Database
No `06_...sql` migration is required for v0.16. Keep the already-installed `05_v0.15_esign_repair.sql`.
