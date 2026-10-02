# Brick & Decor PWA v0.18 Test Report

Automated checks: **42/42 PASS**

- PASS — JavaScript block 1
- PASS — JavaScript block 2
- PASS — JavaScript block 3
- PASS — JavaScript block 4
- PASS — JavaScript block 5
- PASS — JavaScript block 6
- PASS — JavaScript block 7
- PASS — JavaScript block 8
- PASS — JavaScript block 9
- PASS — JavaScript block 10
- PASS — JavaScript block 11
- PASS — JavaScript block 12
- PASS — v0.18 version marker
- PASS — Superadmin user API
- PASS — Create Staff Account
- PASS — Deactivate staff action
- PASS — Reactivate staff action
- PASS — Permanent Delete safeguard
- PASS — Self account protection UI
- PASS — Password reset link
- PASS — Real company access on login
- PASS — Commission default field
- PASS — Non-superadmin Users page denied
- PASS — Account active guard
- PASS — Package file 07_v0.18_user_admin.sql
- PASS — Package file supabase/functions/user-admin/index.ts
- PASS — Package file 06_v0.17_signed_copy.sql
- PASS — Package file index.html
- PASS — Package file manifest.json
- PASS — Package file sw.js
- PASS — Edge Function TypeScript syntax
- PASS — Edge verifies bearer token
- PASS — Edge requires active Superadmin
- PASS — Service role only server-side
- PASS — Cannot deactivate own account
- PASS — Cannot delete own account
- PASS — Protects last Superadmin
- PASS — Delete reference check
- PASS — Admin audit RLS
- PASS — Admin audit Superadmin read
- PASS — Reference helper service-role only
- PASS — PostgREST reload

## Scope
- Frontend static/syntax validation.
- Edge Function TypeScript parse/transpile validation.
- SQL/security contract static validation.
- Package file presence validation.

## Live checks still required
- SQL 07 must be run in the user's Supabase project.
- `user-admin` Edge Function must be deployed in that project.
- Create/invite/deactivate/delete must be tested against live Supabase Auth.
- Invitation email delivery depends on the project's Supabase Auth email configuration.
