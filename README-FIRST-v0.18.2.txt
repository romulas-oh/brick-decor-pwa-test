BRICK & DECOR PWA v0.18.2 — QUOTATION UX + SIGNED COPY
==========================================================

WHAT THIS PATCH DOES
--------------------
1. Quotation Add/Edit Scope is now inline on the Quotation Builder page.
   - No cramped quotation-item popup.
   - Full-width Work Section / Area / Pricing controls.
   - Readable searchable Item / Service picker with wrapped service names.
   - Service suggestions stay filtered by the selected Work Section.
   - Multiple items and Combined Amount remain supported.

2. Quotation builder display consistency.
   - Normal items and Combined Amount groups use the same card-style visual treatment.
   - Multiline descriptions remain line-by-line.

3. Customer-facing quotation order.
   - Inside the PWA, Professional Services stays below the editable work sections.
   - In Preview / Print / Customer E-sign / Signed Copy / historical revision output,
     Professional Services is moved to the TOP.
   - Professional Services no longer prints an unnecessary "Unassigned Area" heading.
   - Standard Complimentary services are listed before any custom Professional Service item.

4. Readable customer documents.
   - Generated quotation/signed-copy document body text is minimum 11pt.
   - Headings/titles are larger and bold.
   - Terms & Conditions body is minimum 11pt.
   - The document is allowed to use more A4 pages rather than shrinking text too small.

5. Returned customer signature.
   - Returning to the B&D tab automatically refreshes E-sign status.
   - A signed quotation shows the returned customer signature thumbnail in the Quotation Builder.
   - Preview Signed Copy retrieves the actual signature securely from Supabase.

6. Signed revision history.
   - Sent Revision History now shows E-sign status per revision.
   - Signed revisions get a View Signed Copy button.
   - Older signed revisions remain available after later revisions are created.

7. Master Data cleanup.
   - Removes the redundant Company Document Templates shortcut card.
   - Removes the old prototype Item Master display.
   - Adds Quotation Service Library grouped by Work Section.
   - Superadmin can add, edit, move, deactivate/reactivate or delete service presets.
   - Existing quotation wording is not changed when the service library changes.

8. Sidebar order.
   - Companies is moved to immediately below Master Data.

NEW SUPABASE STEP
-----------------
Run this ONCE in Supabase SQL Editor:

  08_v0.18.2_signed_revision_history.sql

Expected verification result:

  list_my_esign_requests_v182

This SQL is read-only for signed revision history. It does not modify quotation/case workflow data.
The existing SQL 06 signed-copy function and v0.18 user-admin Edge Function are still used.
No new Edge Function is required for v0.18.2.

DEPLOY
------
Replace the existing GitHub files with the contents of this package, commit, and push to main.

Suggested commit message:
  Deploy Brick Decor PWA v0.18.2 quotation UX and signed copy

Test URL after GitHub Pages finishes deploying:
  https://romulas-oh.github.io/brick-decor-pwa-test/?v=0183

RECOMMENDED TEST ORDER
----------------------
1. Quotation -> + Add Work Section / Area.
2. Confirm the editor expands inline instead of opening a popup.
3. Select Hacking / Carpentry / Plumbing / Paint and verify only matching services appear.
4. Search a long service name and confirm the complete wording wraps and is readable.
5. Add Individual Amount and Combined Amount items.
6. Preview Quotation: Professional Services should be first.
7. Print / Save PDF: normal text and T&C should be at least 11pt/readable.
8. Customer signs an E-sign link on another device/tab.
9. Return to B&D: status/signature should refresh automatically.
10. Open Sent Revision History -> View Signed Copy for the signed revision.
11. Master Data -> Quotation Service Library.
12. Confirm Companies menu appears below Master Data.
