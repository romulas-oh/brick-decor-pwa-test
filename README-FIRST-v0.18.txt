BRICK & DECOR PWA v0.18 — SECURE SUPERADMIN USER ADMINISTRATION
=================================================================

PURPOSE
-------
This patch turns Users & Access into real Supabase Auth staff administration.
The browser never receives or stores the Supabase service-role key.
Only an authenticated, active Superadmin can call the user-admin Edge Function.

WHAT IS INCLUDED
----------------
- Create real staff accounts from B&D Users & Access.
- Account setup choice:
  1) Send invitation email (recommended), or
  2) Create with a temporary password for immediate testing.
- Roles: Superadmin, Admin, Senior ID / Salesperson, ID / Salesperson,
  Project Manager, Accounts, Viewer.
- Per-user company access.
- Per-user permission matrix.
- Default commission percentage for ID / Senior ID.
- Edit staff access.
- Deactivate / Reactivate.
- Generate password reset link.
- Permanent Delete only for unused accounts with no historical references.
- Self-protection: Superadmin cannot deactivate/delete/demote own account.
- Last-active-Superadmin protection.
- User administration audit log.
- Login now loads real company access and permissions for non-Superadmins.
- Active-account guard signs out a deactivated staff session on the next check.

DEPLOYMENT ORDER
----------------
1. If you still need v0.17 signed-copy support, run 06_v0.17_signed_copy.sql first.
2. Run 07_v0.18_user_admin.sql in Supabase SQL Editor.
3. Deploy the Edge Function at:
   supabase/functions/user-admin/index.ts
   Function name: user-admin
4. Upload/replace the v0.18 frontend files in GitHub Pages and push main.
5. Test with ?v=0181.

SECURITY
--------
- Never put SUPABASE_SERVICE_ROLE_KEY in index.html, GitHub Pages or browser code.
- Supabase supplies the service-role secret to the Edge Function runtime.
- The Edge Function independently verifies the caller's JWT and checks that the
  caller's profile is active and role=Superadmin for every action.
- Deactivate is recommended for real former staff so historical records remain intact.
- Permanent Delete is blocked when public tables still reference that staff profile.

FIRST TEST
----------
1. Sign in as existing Superadmin.
2. Users & Access -> + Create Staff Account.
3. Create one test Viewer or ID using temporary password mode.
4. Sign out and sign in with the test account.
5. Confirm its company/project permissions are limited.
6. Sign back in as Superadmin, deactivate test account.
7. Confirm test account cannot continue after refresh / next account check.
