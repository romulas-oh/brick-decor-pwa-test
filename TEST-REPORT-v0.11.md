# Brick & Decor PWA v0.11 — Test Report

## Scope
Supabase staff authentication + first-Superadmin bootstrap + real cross-device quotation E-sign bridge on top of the full standalone v0.10.1 frontend. Existing v0.10 LocalStorage workflow is retained during phased migration.

## Safety status
- Source package created: YES
- Supabase schema changed by this package: NO (Phase 1 SQL was already run separately by user)
- GitHub repository changed by ChatGPT: NO
- Live GitHub Pages published by ChatGPT: NO
- service_role/secret key embedded: NO
- Browser key type: publishable key only

## Checks completed
- All inline JavaScript blocks: Node syntax PASS
- Service worker JavaScript syntax: PASS
- ZIP integrity: PASS
- Required 4 company logos present: PASS
- Manifest updated to v0.11: PASS
- Service worker caches same-origin files only (Supabase authenticated API responses are not cached): PASS
- Supabase RPC names wired: bootstrap_first_superadmin / create_esign_request / get_esign_request / submit_esign / list_my_esign_requests: PASS
- Local sent quotation -> Supabase case/client/quotation/revision/item sync mock: PASS
- Stable CO1..CO4 -> Supabase company UUID mapping: PASS
- Row item estimated cost and charge amount mapping: PASS
- Public signer route is available without staff login and uses token RPC only: PASS (static wiring)
- Staff E-sign status polling + manual refresh: PASS (static wiring)

## Not executable from this environment
The container cannot resolve the external Supabase hostname, so an actual live login/RPC call could not be performed here. The user has already confirmed the SQL setup succeeded in Supabase. Final end-to-end network validation must be done from the deployed GitHub Pages site.

## First live test
1. Create one confirmed Auth user in Supabase.
2. Deploy v0.11.
3. Sign in and run one-time First Superadmin activation.
4. Open a sent quotation and generate E-sign link.
5. Open link in incognito/another phone, sign, confirm.
6. Return to staff app; wait <=20 sec or click Refresh E-sign Status.
7. Confirm quotation becomes Accepted and case becomes Project Confirmed under current workflow setting.
