BRICK & DECOR PWA v0.13 — HIERARCHICAL QUOTATION + COMPANY DOCUMENTS

BUILD BASIS
- Built directly on full v0.12.
- Keeps Supabase staff login / E-sign foundation, multi-ID Cases, commission defaults/override, flexible customer invoice amounts, supplier Work Section costing, Project Cost reconciliation and all earlier Case-centric modules.

NO NEW SQL MIGRATION FOR v0.13
- v0.13 stores lump-sum group identity inside the existing quotation item pricing_type used by the v0.12 Supabase E-sign sync.
- Keep the v0.12 Supabase migration already installed.

QUOTATION BUILDER
New structure:
  Work Section
    -> Area / Location
       -> multiple Item / Service rows

- Work Section is selected first.
- Area / Location is selected/entered next.
- Multiple Item / Service rows can be added in the same action.
- Item / Service wording is the same wording shown to the customer.
- Removed from the active v0.13 Add Quotation Scope UI:
  * Item Source
  * Client-facing Item Name
  * Internal Category
- Items/services are seeded from PWA List.xlsx and custom typing remains allowed.
- Areas and Work Sections are seeded from PWA List.xlsx.

PRICING
1. Individual
   - Amount / Inclusive / Complimentary / F.O.C / Optional per item.
2. Lump Sum
   - Multiple visible service items share one customer-facing lump-sum price.
   - Internal approximate cost remains per item for Project Cost / profit.
   - Multiple lump-sum groups may exist within the same Area.

PROJECT COST / SUPPLIER COST
- Lump Sum synthetic charge rows are excluded from internal cost.
- Customer charge is distributed across the real group members for internal reconciliation only, so Work Section totals remain correct.
- v0.12 supplier Work Section allocation is preserved.

QUOTATION DOCUMENT
- Uses company logo/details for the Case issuing company.
- Client information table follows supplied B&D reference:
  Name / NRIC / Address / H/P / Fax-Email
  Quotation No / Date / Served By / Mobile No / Page(s)
- Includes QUOTATION FOR THE INTERIOR DESIGN WORKS.
- Includes the company-specific “Thank you for engaging…” introduction.
- Scope is displayed Work Section -> Area -> Item/Service.
- Lump Sum groups show all included services but only one group amount.

COMPANY DOCUMENT CONTENT
The selected Case company remains authoritative.
- Brick & Decor (Central) Pte Ltd
- BD Werks Pte Ltd
- Brick & Decor (North) Pte Ltd
- Arc & Brush

Current Company Master supplies current logo, legal particulars, UEN, address, phone, bank and PayNow.
The supplied company PDF packs were used as the reference for Contract/T&C, Letter of Appointment and Handover wording/structure.
- Central/North Stage 2 default: Upon commencement of work.
- BD Werks/Arc & Brush Stage 2 default: Upon application of renovation permit / ordering of material.
- Existing Superadmin-customized company templates are preserved.
- Restore Default restores that company’s v0.13 reference default, not a generic template.

ISSUED DOCUMENT HISTORY
- Existing sent quotation revision snapshots remain immutable.
- DO/Handover retains v0.10 issued-template lock/snapshot behaviour.

DEPLOYMENT
1. Extract the ZIP.
2. Copy the contents directly into the root of the existing GitHub repository.
3. Replace the current files.
4. Commit and push to main.
5. Test with a cache-busting URL, e.g.:
   https://romulas-oh.github.io/brick-decor-pwa-test/?v=0131
6. Hard refresh once (Ctrl+Shift+R) if needed.

