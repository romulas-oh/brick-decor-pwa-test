# Brick & Decor PWA v0.13 Test Report

## Build basis
- Built directly on the full v0.12 standalone/Supabase build.
- No modules intentionally removed.
- No new Supabase schema migration required for v0.13.

## JavaScript / package checks
- Extracted all 7 inline JavaScript blocks from final `index.html`.
- `node --check`: **PASS for all 7 blocks**.
- Service worker cache: `bd-pwa-v0.13-quotation-companydocs`.
- Every file listed in the service worker precache exists: **PASS**.
- Standalone packaging: no external `src/v09`, `src/v10`, `src/v11`, `src/v12` or `src/v13` runtime dependency: **PASS**.

## v0.13 static feature assertions
21/21 checks passed, including:
- Work Section -> Area / Location -> multiple Item / Service structure.
- Active v0.13 quotation modal no longer contains Item Source.
- Active v0.13 quotation modal no longer contains Client-facing Item Name.
- Active v0.13 quotation modal no longer contains Internal Category.
- Individual pricing and Lump Sum pricing both present.
- Multiple Item / Service rows can be added in one Area action.
- PWA List master Areas / Work Sections / services embedded.
- Company-specific default document generator present.
- BD Werks / Arc & Brush company-specific Stage 2 wording retained.
- Quotation customer information table present.
- Company-specific quotation introduction present.
- 23 Contract/T&C clauses retained in reference default.
- Company-reference LOA structure present.
- Company-reference Handover structure present.
- Lump Sum group identity encoded for Supabase sync.
- Project Cost excludes synthetic charge row and reconciles real members.
- E-sign customer renderer reconstructs Lump Sum groups.
- v0.12 secure E-sign RPC retained.
- v0.12 multi-ID logic retained.
- v0.12 commission logic retained.

## Mocked quotation pricing/group test
Test data:
- Work Section: Carpentry Works
- Area: Kitchen
- Lump Sum group with 2 real items, internal cost $8,000, customer amount $11,000
- Separate Master Bedroom individual item, internal cost $1,000, customer amount $1,350

Results:
- Internal quotation cost = $9,000: **PASS**
- Customer subtotal = $12,350: **PASS**
- Lump Sum amount counted once only: **PASS**
- Both Lump Sum member items remain visible: **PASS**
- Individual item remains visible/priced separately: **PASS**
- Price validation passes for configured 30–40% range: **PASS**

## Regression protections retained
- Existing v0.12 Supabase `sync_local_quotation_for_esign` flow remains in source.
- Existing multi-ID Case assignment remains in source.
- Existing commission default / Superadmin override remains in source.
- Existing flexible customer invoice amount behaviour remains in source.
- Existing supplier Work Section allocation / Project Cost flow remains in source.
- Sent quotation revision snapshots remain immutable.
- DO/Handover uses the issued-template snapshot wrapper instead of bypassing it.

## Browser-render limitation
A local headless Chromium smoke test was attempted, but the container Chromium process does not complete page rendering in this environment (DBus/zygote process limitation). Therefore final GitHub Pages visual behaviour still requires the normal live smoke test after upload.

Recommended live checks:
1. Open an existing/new quotation.
2. Add `Carpentry Works` -> `Kitchen` -> 3 items as Individual pricing.
3. Add a second Kitchen group as Lump Sum with 2+ items.
4. Preview quotation and confirm only one Lump Sum amount is shown for that group.
5. Send/save a revision and view/print historical revision.
6. Create/open a Case under each company and preview quotation/LOA/Handover to verify company logo/details/content.
7. Generate an E-sign link and confirm the customer view preserves Work Section / Area / Lump Sum presentation.
