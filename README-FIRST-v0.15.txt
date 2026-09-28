BRICK & DECOR PWA v0.15 — L1.6 UX + E-SIGN REPAIR

IMPORTANT ORDER
1. Supabase Dashboard -> SQL Editor -> New query.
2. Open 05_v0.15_esign_repair.sql from this package.
3. Paste the whole SQL file and RUN once.
4. The final verification should show these 4 routines:
   create_document_esign_request_v15
   get_document_esign_request_v15
   list_my_document_esign_requests_v15
   submit_document_esign_v15
5. Then replace/upload the v0.15 web files to the GitHub Pages repo root.
6. Test with a cache-busting URL such as ?v=0151 and hard refresh once.

L1.6 CHANGES
- Repairs generic document E-sign (LOA / VO / Handover) using new v0.15 RPC names plus PostgREST schema reload.
- Rebuilds ID/customer signature pads using Pointer Events, including repeated desktop strokes and touch input.
- Quotation signature status now shows the assigned ID(s), not only the currently logged-in user.
- Professional Services hide Qty / 1 Lot / Internal Cost and are editable per quotation while defaulting to Complimentary.
- Professional Services can be reset to the standard list or removed/restored for the quotation.
- Quotation descriptions preserve vertical line breaks in the PWA and print output.
- Work Section Library and Property Type Library use visual managed lists instead of raw text areas.
- Print uses a hidden iframe rather than opening an about:blank tab; cancel/print returns to the PWA.
- LOA / quotation / VO / handover print CSS preserves left/right staff and client signature columns.
- A4 quotation layout is slightly narrower for safer print margins.

NO DESTRUCTIVE DATABASE RESET IS REQUIRED.
The new SQL is idempotent and can be run even if 04_v0.14_document_esign.sql was previously run.
