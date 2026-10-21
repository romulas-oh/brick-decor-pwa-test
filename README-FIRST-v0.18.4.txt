Brick & Decor PWA v0.18.4 — No-Jump Quotation Editor

Purpose
- Fix the remaining quotation editing scroll-to-top problem.
- Keep all v0.18.3 signed-copy recovery and v0.18.2 quotation UX features.

What changed
1. Edit / Add Scope no longer rebuilds the quotation page just to open the editor.
2. The compact floating editor is injected directly into the current quotation view, so clicking Edit does not move the page to the top.
3. Cancel closes the editor without re-rendering the quotation page.
4. Save re-renders the quotation only after data is saved, then restores the previous scroll position repeatedly to prevent layout timing from moving the user.
5. Floating + Add Work Section / Area remains available while scrolling a long quotation.
6. No new Supabase SQL is required. SQL 09 from v0.18.3 remains the latest migration and should already have restored the signed-copy RPCs.

Test URL after deploy
https://romulas-oh.github.io/brick-decor-pwa-test/?v=0185

Recommended test
- Scroll to a work section near the bottom.
- Click Edit.
- Confirm the page does not jump to the top.
- Cancel and confirm you remain in the same position.
- Edit again, Save Changes, and confirm you return to approximately the same position.
- Test the floating + Add Work Section / Area button while far down the quotation.
