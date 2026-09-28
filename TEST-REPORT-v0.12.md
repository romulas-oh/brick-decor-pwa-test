# Brick & Decor PWA v0.12 Test Report

## Build basis
- Built on the full v0.11 Supabase + real E-sign standalone build.
- v0.8/v0.9/v0.10 functionality retained.

## Source / static checks
- All embedded JavaScript `<script>` blocks: **Node syntax PASS**.
- Service worker cache version updated to `bd-pwa-v0.12-supabase-esign`.
- Service worker caches only files that exist in the package.
- Package remains standalone; no `src/v09` / `src/v10` dependency is required.

## v0.12 implemented checks
- E-sign backend sync no longer relies on direct browser INSERT to `public.cases`; frontend now calls `sync_local_quotation_for_esign` RPC.
- SQL migration keeps RLS enabled and validates authenticated staff/company/case access server-side.
- Multiple assigned ID data upgrade retains existing primary ID.
- Create Case supports multi-ID checkbox selection plus Primary / Served By.
- Existing Case has Add / Change ID action.
- Case/project visibility and supplier verification recognise every assigned ID.
- Commission preview calculates each staff default divided by assigned-ID count.
- Superadmin Commission Review supports percentage and amount override.
- User master supports `Senior ID / Salesperson` and editable default commission %.
- Customer invoice amount is editable while retaining 10/45/40/5 as the suggested schedule.
- Case-level customer invoice flow has the same editable amount behaviour.
- Supplier invoice item entry is optional in normal mode.
- Supplier invoice requires approved Work Section selection; multiple sections allowed.
- Normal supplier allocation spreads total evenly across selected Work Sections.
- Special Split requires percentages totaling 100%.
- Project Cost groups commercial data by Work Section and compares estimated cost / charge / supplier actual.
- Supplier invoice Excel export follows Work Section allocation.
- Quotation preview and immutable revision preview use the requested B&D customer-information table layout.


## Final packaging checks
- Re-extracted all 6 inline JavaScript blocks from the final `index.html`: **Node syntax PASS for all 6**.
- Static feature assertions: **PASS** for secure E-sign RPC, multi-ID case assignment, commission defaults/override, custom invoice amount, multi-Work-Section supplier allocation, Special Split, Project Cost grouping and requested quotation header layout.
- Commission examples checked: 2 normal IDs = 20% each; 2 senior IDs at 50% = 25% each; 2 senior IDs at 55% = 27.5% each.
- Service-worker asset existence check: **PASS** for every cached file.
- The v0.11 direct `cases` browser insert path is replaced by the v0.12 authenticated sync RPC; RLS remains enabled.

## Important live test required
This environment cannot execute a live request against the user's Supabase project. After `03_v0.12_backend_hotfix_and_workflow.sql` is run, live-test:
1. Staff sign in.
2. Open a sent quotation.
3. Generate E-sign link.
4. Open link on another device/incognito.
5. Sign and confirm.
6. Return to staff app and refresh E-sign status.

The prior live RLS error should no longer occur because the Case/Quotation sync is done by the new authenticated RPC.
