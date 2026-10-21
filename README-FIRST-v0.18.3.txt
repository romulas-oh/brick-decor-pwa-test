Brick & Decor PWA v0.18.3 — Quotation Editing Stability

1. Supabase SQL Editor: run 09_v0.18.3_restore_signed_copy_rpc.sql once.
   Expected verification rows:
   - get_my_document_esign_request_v17
   - get_my_esign_request_v17
   - list_my_esign_requests_v182

2. Replace the website files with this package and push to GitHub Pages.

3. Test URL:
   https://romulas-oh.github.io/brick-decor-pwa-test/?v=0184

Changes:
- Fixes Preview Signed Copy when get_my_esign_request_v17 was missing.
- Quotation editor is now a compact floating drawer, not a huge block at page top.
- Clicking Edit keeps the current quotation scroll position.
- Save/Cancel returns to the same place in the quotation.
- Floating + Add Work Section / Area remains available while scrolling long quotations.
- Existing v0.18.2 signed revision history, service filtering, 11pt document print rules and user admin remain.
