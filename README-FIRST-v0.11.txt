BRICK & DECOR PWA v0.11 — SUPABASE AUTH + REAL CROSS-DEVICE E-SIGN
==================================================================

STATUS
------
Database Phase 1 SQL has already been run by the user.
This frontend connects to that Supabase project with the publishable key.
No service_role / secret key is used in the browser.

WHAT IS REAL IN v0.11
---------------------
- Staff email/password session via Supabase Auth.
- One-time bootstrap_first_superadmin flow.
- Sent quotation revision is synced to Supabase when an E-sign link is generated.
- E-sign token is created by the database and stored only as SHA-256 hash server-side.
- Customer link works from another phone/computer.
- Customer views a server-side quotation snapshot and signs on screen.
- Signature is submitted to Supabase.
- Database marks revision/quotation Accepted and updates Case workflow.
- Staff app polls E-sign status while open and updates the current LocalStorage UI automatically.

CURRENT MIGRATION BOUNDARY
--------------------------
The existing v0.10 operational modules still use LocalStorage for the working demo UI.
Only Auth + E-sign bridge are moved to Supabase in this phase. This avoids a risky all-at-once rewrite.
Next phases can migrate Case/Quotation master data, supplier invoices/files, payments, and permissions fully to Supabase.

FIRST LOGIN
-----------
1. Supabase Dashboard -> Authentication -> Users -> Add user.
2. Create your first B&D staff account with email + password. Use Auto Confirm / confirmed user for testing.
3. Upload this package to GitHub Pages.
4. Open the test site. Sign in with that account.
5. The app will show Activate First Superadmin. Enter your display name and click it once.
6. Dashboard opens with a green Supabase badge.

E-SIGN TEST
-----------
1. Open a Case -> Quotation.
2. Use a quotation that has already been Sent.
3. Click Customer E-sign Link.
4. Copy the generated secure link.
5. Open it in an incognito window or another phone.
6. Sign and confirm.
7. Within about 20 seconds the staff page will detect SIGNED while it is open, or click Refresh E-sign Status.

SECURITY
--------
- The service worker only caches same-origin static files. It does NOT cache Supabase API responses.
- Public customer requests use only the token-based get_esign_request / submit_esign RPCs.
- The customer never receives direct table access.
- Raw signing tokens are not stored in the database.
