# Brick & Decor PWA v0.14 Test Report

## Build basis
- Built directly on the full v0.13 quotation-structure/company-document build.
- Existing v0.12/v0.13 modules are retained.
- New Supabase migration `04_v0.14_document_esign.sql` adds secure cross-device E-sign for LOA / VO / Handover.
- Existing quotation E-sign remains on the previously installed quotation E-sign backend.

## JavaScript checks
- Extracted all 8 inline JavaScript blocks from the final `index.html`.
- `node --check`: **PASS for all 8 blocks**.

## Service worker / standalone package checks
- Cache version: `bd-pwa-v0.14-l1.5-signing-media`.
- Every file listed in the service-worker precache exists: **PASS**.
- New EXCEL upgrade image is present in `assets/`: **PASS**.
- New Nippon upgrade image is present in `assets/`: **PASS**.
- No external `src/v08` through `src/v13` runtime dependency: **PASS**.

## v0.14 static feature assertions
**19/19 PASS**, including:
- v0.14 title/version marker.
- Combined Amount quotation-entry workflow.
- Standard Professional Services default block.
- EXCEL automatic media rule.
- NIPPON automatic media rule.
- Whitespace normalization for upgrade-item matching.
- T&C separate-page implementation.
- Repeating print header/footer implementation.
- Two-party signature sections.
- Staff signature pad/save flow.
- Quotation E-sign requires an assigned ID signature first.
- Generic document E-sign frontend functions.
- `document_esign_requests` migration table.
- create/get/submit/list generic E-sign RPCs.
- anonymous access limited to token-based get/submit RPCs.

## Mocked quotation output test
Test quotation included:
- fixed Professional Services defaults;
- EXCEL free upgrade;
- Nippon free upgrade using extra spaces before `&`;
- a two-item Combined Amount group;
- separate T&C section and signature blocks.

Results:
- 8 fixed Professional Services items auto-injected: **PASS**.
- Professional Services visible in customer quotation: **PASS**.
- Customer quotation does not display the words `Lump Sum`: **PASS**.
- Combined amount displays once: **PASS**.
- EXCEL image auto-inserts: **PASS**.
- Nippon image auto-inserts even with spacing variation: **PASS**.
- T&C separate-page marker present: **PASS**.
- quotation print-frame/repeating header-footer structure present: **PASS**.
- normal quotation + T&C signature sections present: **PASS**.

## Security / E-sign design
- Generic document signing token is generated server-side with pgcrypto.
- Only authenticated staff with company access can create/list document-signing requests.
- Customer public access is limited to token-based get/sign RPCs.
- Direct browser table writes remain blocked by RLS.
- A newer pending signing link revokes an older pending link for the same document.
- ID/staff signature is required before LOA/VO/Handover customer E-sign link creation.

## Regression protections retained
- v0.12 Supabase quotation sync / real quotation E-sign.
- multi-ID Case assignment.
- commission defaults + Superadmin override.
- flexible customer invoice amounts.
- supplier Work Section allocation / Project Cost reconciliation.
- v0.13 Work Section -> Area -> many Item / Service quotation builder.
- company-specific document identity/content selection.
- historical sent quotation revision snapshots.

## Environment limitation
Final browser print pagination and real cross-device Supabase calls cannot be fully executed inside this container. Live GitHub Pages smoke testing is still required after deployment.

Recommended live smoke test:
1. Open quotation and save My ID Signature.
2. Confirm the larger Add Quotation Scope modal is aligned.
3. Add Individual Amount items under one Work Section / Area.
4. Add a Combined Amount group and confirm the final quotation does not display `Lump Sum`.
5. Add each free-upgrade item and confirm the correct supplied image appears.
6. Preview/print a long quotation and confirm repeated header/sign footer on normal quotation pages.
7. Confirm T&C starts on a new page with left/right signatures.
8. Send/save revision -> generate quotation E-sign link -> sign from another device.
9. After running `04_v0.14_document_esign.sql`, test LOA, VO and Handover customer E-sign links.
