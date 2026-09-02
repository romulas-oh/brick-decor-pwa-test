# Brick & Decor PWA v0.8 — L1.3 UX + Stability Test Report

Build basis: v0.7 Case-Centric Test from the user's current GitHub source archive.

## Implemented L1.3 fixes

- Human-readable company/staff labels instead of normal-user technical IDs.
- Property Type restored to Create Case and added to Master Data.
- Case VO / DO-Handover / Manpower blank-screen regressions repaired.
- Supplier duplicate rule: warning only for same Supplier + same Invoice Number.
- Project Cost now has explicit Add Manual Cost with AUTO/MANUAL origin labels.
- Customer invoice overview uses row-level Record Payment.
- Customer invoice / official receipt print preview uses an A4 portrait layout.
- Notification screen redesigned into compact responsive cards.
- Quotation historical revisions have View / Preview / Print actions.
- New sent revisions store immutable line-item/header/company snapshots.
- Work Section Library is selectable from quotation Add/Edit Item.
- Browser History API navigation added for in-app Back / swipe-back behavior.
- Company Master and generated documents use the selected company logo.
- Four company logos are embedded as data URLs and also bundled as static fallback assets.
- Closure snapshot expanded with final financial/commission state.
- Reset preserves v0.8 Master Data and embedded-logo migration.

## Syntax checks

PASS

- inline JavaScript extracted from index.html: `node --check`
- `src/v08-patch.js`: `node --check`
- `sw.js`: `node --check`

## Service worker cache-file check

PASS — every local path listed in the v0.8 service-worker cache exists in the package.

## Runtime renderer/regression harness

25 / 25 passed.

Covered:

- Dashboard
- all four embedded logos
- Company Master
- Create Case human-readable labels
- Property Type library
- every Case tab repeatedly rendering without exceptions
- VO renderer
- DO / Handover renderer
- Manpower renderer
- Manual Cost
- Quotation Builder
- Work Section Library
- historical revision View/Print
- revision preview
- supplier duplicate handling
- supplier approval -> one AUTO cost posting
- MANUAL cost posting
- row-level customer payment
- invoice preview/logo/A4 class
- responsive notifications
- filters/company names
- project table technical-ID hiding
- History API route pushes
- Master Data libraries

## Simulated end-to-end workflow harness

23 / 23 passed.

Covered:

- create Case with Property Type
- create quotation from Case
- add quotation line using Work Section Library
- send quotation and store immutable revision snapshot
- verify revision remains unchanged after current quotation edits
- client approval -> Project Confirmed
- create staged customer invoice
- row-level payment record
- supplier same-name/different-invoice accepted
- supplier same-name/same-invoice duplicate warning
- assigned-ID supplier approval and one-time AUTO cost posting
- supplier reject/dispute
- Manual Cost
- create/approve VO
- VO print preview
- create/complete DO/Handover
- DO print preview
- closure request and final Superadmin closing snapshot
- closed-case visibility rule
- Profit page
- Users & Access company-name display
- PO print selected-company logo
- reset migration preservation

## Environment note

A native Chromium test against localhost/file URLs could not be completed because this execution environment blocks those local browser URLs. The actual application JavaScript was therefore executed through a Node VM harness with DOM/localStorage/history stubs for regression and end-to-end flow checks. GitHub Pages should still receive a short visual smoke test after upload, especially print layout, mobile spacing, browser Back/swipe-back, and notification permission behavior.
