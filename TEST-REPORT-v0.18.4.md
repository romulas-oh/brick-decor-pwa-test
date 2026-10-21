# Brick & Decor PWA v0.18.4 Test Report

## Scope
No-jump quotation editing patch on top of v0.18.3.

## Automated/static checks
- PASS — 15/15 embedded JavaScript blocks parse with `node --check`.
- PASS — old forced `scrollIntoView(... block: 'start')` behaviour removed.
- PASS — opening Add/Edit Scope injects `v182_scope_host` directly into the current page.
- PASS — Add/Edit Scope no longer calls `show('quotation')` just to open the editor.
- PASS — Cancel closes the editor without rebuilding the quotation page.
- PASS — Save restores previous scroll position after quotation re-render.
- PASS — floating Add Work Section / Area control retained.
- PASS — v0.18.4 version markers present.

## Database
No new SQL is required for v0.18.4.
Latest backend migration remains SQL 09 from v0.18.3.

## Manual regression test required
1. Scroll to a quotation item near the bottom and click Edit.
2. Confirm current page position remains unchanged while editor opens.
3. Cancel and verify the same position remains visible.
4. Edit again, save, and verify the page returns to approximately the same position.
5. Test floating Add Scope from the middle/bottom of a long quotation.
6. Test Preview Signed Copy after SQL 09 is installed.
