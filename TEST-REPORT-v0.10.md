# Brick & Decor PWA v0.10 — Test Report

Build: **v0.10 L1.4 Workflow Patch**
Base: **v0.9 L1.4 UX + Document Template Patch**

## Static checks

- `index.html` inline JavaScript syntax: PASS
- `src/app.js` syntax: PASS
- `src/v08-patch.js` syntax: PASS
- `src/v09-patch.js` syntax: PASS
- `src/v10-patch.js` syntax: PASS
- `sw.js` syntax: PASS
- Service-worker asset list: PASS — all referenced files exist

## v0.10 runtime regression harness

**16 / 16 PASS**

1. BD Werks UEN / OCBC / PayNow details retained
2. v0.9 stale document snapshot removed for unlocked documents
3. Unlocked invoice follows edited Company Master template
4. Explicitly issued/locked invoice retains template snapshot
5. Manual approval cannot complete without evidence upload
6. Customer E-sign link token generates for a sent quotation
7. Accepted quotation items are available for supplier matching
8. Multiple supplier invoices sum into the same Project Cost row
9. Supplier approval posts multiple line costs once only
10. Duplicate logic remains same supplier + same invoice number only
11. Supplier list sorts latest first
12. Supplier Excel export action renders
13. Project Cost reconciliation fields render
14. All 10 Case tabs render repeatedly without blank output
15. All top-level pages render without runtime exception
16. Quotation revision history displays newest revision first

## Case tabs repeatedly checked

- Overview
- Quotation
- Supplier Cost
- Project Cost
- VO
- Customer Invoice
- Payment
- DO / Handover
- Profit
- Activity Log

## Known frontend-only limitations

The test environment uses GitHub Pages + LocalStorage. Therefore:

- generated E-sign link can demonstrate the workflow in the same LocalStorage/browser environment;
- a true customer-phone link that securely retrieves the quotation and returns the signed submission requires backend/database storage;
- uploaded private files are not yet production-grade persistent private storage;
- production should save immutable signed/generated document versions server-side.

## Delivery status

- Source patched: YES
- Database changed: NO
- GitHub changed: NO
- Published live: NO
- Ready for GitHub Pages upload/test: YES
