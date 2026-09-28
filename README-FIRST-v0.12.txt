BRICK & DECOR PWA v0.12 — SUPABASE HOTFIX + MULTI-ID / COSTING PATCH

IMPORTANT ORDER
1. Supabase Dashboard -> SQL Editor -> New query.
2. Open 03_v0.12_backend_hotfix_and_workflow.sql.
3. Paste the whole SQL file and RUN it once.
4. Expected final verification rows include:
   create_esign_request
   submit_esign
   sync_local_quotation_for_esign
5. Only after SQL succeeds, upload/replace the v0.12 web files in the GitHub Pages repo root.
6. Test with a cache-busting URL such as ?v=0121 and hard refresh once.

WHY THE SQL HOTFIX IS NEEDED
v0.11 tried to create/sync a Case directly through PostgREST before making an E-sign link. Supabase RLS correctly blocked that write in the live test. v0.12 moves this sync into an authenticated SECURITY DEFINER RPC that validates staff/company/case access server-side. Do NOT disable RLS.

v0.12 WORKFLOW CHANGES
- Case can have multiple assigned IDs.
- Assigned IDs can be added/changed later inside the Case.
- Primary / Served By ID remains selectable for document reference.
- Normal ID default commission starts at 40%.
- Senior ID / Salesperson role added; commission default is editable (e.g. 50% or 55%).
- When multiple IDs are assigned, each staff default is divided by the number of assigned IDs.
  Example: 2 normal IDs -> 20% each.
  Example: 2 senior IDs on 50% defaults -> 25% each.
- Superadmin can override commission percentage OR final dollar amount before approval.
- Customer invoice 10/45/40/5 remains a suggested schedule; actual invoice amount can be overwritten.
- Supplier invoice now selects one or more approved Work Sections.
- Supplier invoice item rows are no longer mandatory.
- Normal supplier invoice actual cost is spread evenly across selected Work Sections.
- Optional Special Split supports arrangements such as 5% / 95%.
- Project Cost groups approved quotation/VO items by Work Section and compares Estimated Cost, Charge Amount and Supplier Actual Cost.
- Quotation preview/revision layout follows the supplied B&D reference: Name/NRIC/Address/H-P/Fax-Email on the left; Quotation No/Date/Served By/Mobile/Page on the right; then QUOTATION FOR THE INTERIOR DESIGN WORKS and the thank-you paragraph.

MIXED COMMISSION NOTE
Current frontend default rule applies each assigned staff member's own configured default rate divided by the total number of assigned IDs. Superadmin remains the final approver and can change either % or amount.

CURRENT BACKEND PHASE
- Supabase Auth: real
- Cross-device E-sign: real after v0.12 SQL hotfix
- Most operational records remain in the existing frontend/local test store and will migrate to Supabase in later phases.
