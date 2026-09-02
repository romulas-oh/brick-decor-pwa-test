# Brick & Decor PWA v0.9 — L1.4 UX + Document Template Patch

Built directly on the full v0.8 L1.3 UX + Stability source. The Case-centric workflow and previous modules are retained.

## L1.4 changes

- **Customer payment proof upload** added inside Record Customer Payment.
  - Accepts PDF or image proof in the frontend test.
  - File name remains in the payment record.
  - Local preview is available during the browser session; real private persistent storage comes with the backend.
- **BD Werks payment details corrected**:
  - UEN: 202411448N
  - Bank: OCBC : 596-503052-001
  - PayNow UEN: 202411448N
  - The previous PayNow/UEN mismatch warning no longer appears for BD Werks.
- **Company Master redesigned** into clean full-width company cards instead of a compressed wide table.
- **PO / Supplier Invoice Aging split into two sub-tabs** so each gets the full page width:
  - Purchase Orders
  - Supplier Invoice Aging

## Document Template behaviour clarified

Document templates are optional Superadmin customization — they are not a setup requirement.

For every company:

- **System Default** = the built-in B&D wording/payment schedule is active automatically.
- **Customized** = Superadmin has saved company-specific wording.
- **Preview** = view the saved template before use.
- **Edit** = edit only the relevant template section using tabs.
- **Restore Default** = return that company to the built-in B&D template.

The editor is split into:

- Quotation
- Letter of Appointment (LOA)
- Invoice / Official Receipt
- Variation Order (VO)
- DO / Handover
- Payment Schedule

Built-in payment schedule remains:

1. 10% down payment or S$1,000 minimum, whichever is greater
2. 45% upon commencement
3. 40% upon measurement of carpentry works
4. 5% upon completion / handover

The built-in wording was also changed from development-placeholder text to cleaner business-ready B&D defaults.

## Historical document protection in this frontend test

- Sent quotation revisions continue to use their immutable revision/company snapshot.
- Invoice, VO, DO/Handover and PO records receive a document-template snapshot so later template changes do not silently rewrite the wording used by already-created records in this test build.
- The production backend should still store immutable generated PDFs/document versions for accounting and audit.

## Retained v0.8 controls

- Case-centric workflow and all Case tabs
- human-readable company/staff selectors
- Property Type library
- Work Section Library in quotation item editor
- quotation revision View / Preview / Print
- supplier duplicate rule = same supplier + same invoice number only
- supplier approval -> one AUTO Actual Project Cost posting
- Add Manual Cost
- row-level customer payment action
- A4 portrait Invoice / Official Receipt
- responsive Notifications
- VO and DO/Handover render/print flows
- browser/mobile Back history
- closure snapshot and permissions
- embedded company logos

Frontend-only GitHub Pages test using LocalStorage. Authentication, database, private persistent attachments, immutable PDF archive, real multi-user sync and remote Web Push remain backend-phase work.
