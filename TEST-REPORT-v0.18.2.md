# Brick & Decor PWA v0.18.2 Test Report

## Automated/source checks

- PASS — all 14 embedded JavaScript blocks pass `node --check`.
- PASS — sidebar mutation moves `Companies` immediately after `Master Data`.
- PASS — `addQItem()` routes to the inline v0.18.2 scope editor instead of the quotation modal.
- PASS — inline editor includes Work Section, Area/Location, Individual/Combined Amount, multiple service rows and custom wording.
- PASS — custom service search renders wrapped full service names and filters from the persistent Work-Section service library.
- PASS — existing v0.18.1 Work-Section mapping is preserved as the initial Quotation Service Library.
- PASS — Master Data removes the legacy `Company Document Templates` shortcut card and old prototype `Item Master` display.
- PASS — Superadmin service-library controls include add/edit/move section/deactivate/reactivate/delete.
- PASS — normal and Combined Amount builder rows receive consistent card styling.
- PASS — v0.14 customer quotation scope sorts `Professional Services` before other work sections.
- PASS — v0.17 Customer E-sign / Signed Copy scope sorts `Professional Services` before other work sections.
- PASS — customer-facing Professional Services suppresses the `Unassigned Area` heading and lists Complimentary standards first.
- PASS — generated-document print CSS sets normal document text/tables/descriptions/T&C/signature labels to 11pt minimum.
- PASS — titles/section headings are larger than 11pt.
- PASS — hidden-iframe print flow is retained; no persistent about:blank print tab is reintroduced.
- PASS — signed-copy retrieval continues to use SQL 06 `get_my_esign_request_v17`, so the actual customer signature image is not stored in LocalStorage.
- PASS — v0.18.2 refreshes E-sign status when the B&D tab regains focus / visibility.
- PASS — returned signature thumbnail is loaded securely only for an authenticated staff user.
- PASS — Sent Revision History adds an E-sign / Signed Copy column and can open a specific historical request ID.
- PASS — SQL 08 only adds a read-only authorised revision-history RPC and reloads PostgREST schema.
- PASS — Service Worker cache key updated to v0.18.2.

## Manual browser checks required after GitHub deployment

1. Confirm inline quotation editor sizing on the user's Chrome/iPad viewport.
2. Confirm long service wording is comfortable to search/select.
3. Confirm A4 pagination at 11pt on Chrome Print Preview (long quotations may intentionally use more pages).
4. Sign a quotation from a second device/tab, return to B&D, and verify the returned signature thumbnail.
5. Verify signed Rev 01 remains viewable after creating/sending a later revision.
6. Verify Quotation Service Library changes affect only new selections and do not mutate existing quotation lines.

## Safety status

Source/package only. No Supabase data, GitHub branch, or live deployment was changed by this packaging step.
