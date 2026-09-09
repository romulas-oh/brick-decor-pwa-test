# Brick & Decor PWA v0.10 — L1.4 Workflow Patch

Built directly on the full v0.9 source, preserving the v0.8 Case-centric workflow and all earlier modules.

## L1.4 changes carried forward

- Customer payment proof/document upload remains available.
- BD Werks payment details remain corrected:
  - UEN: 202411448N
  - Bank: OCBC : 596-503052-001
  - PayNow UEN: 202411448N
- Company Master remains in the cleaner v0.9 layout.
- PO and Supplier Invoice Aging remain split into separate full-width sub-tabs.
- Latest/newest operational records now appear at the top of lists wherever date/order information is available.

## New v0.10 — Client approval / E-sign workflow

### Manual/offline approval

Manual client approval now **requires at least one signed approval evidence file** before confirmation:

- signed quotation
- signed document
- photo
- PDF/image supporting approval evidence

The approval record stores the approval method, date, remark, approved revision and evidence information.

### Customer view + E-sign link

A sent quotation now has **Customer E-sign Link** in the Case → Quotation screen.

The frontend test can:

1. generate a customer link token;
2. display the latest sent quotation revision in a simplified customer view;
3. capture customer full name + drawn signature;
4. record E-sign approval evidence against the quotation;
5. move the Case according to the configured client-approval workflow.

**Frontend-only limitation:** GitHub Pages + LocalStorage cannot make a real cross-device customer link return data into the staff PWA. The production backend must provide secure link/token lookup, persistent document storage and signed submission sync. The UI/workflow in v0.10 is prepared for that backend connection.

Recommended production controls later:

- single-use/expiring signing token
- immutable signed quotation snapshot
- customer name + signature + timestamp
- signer IP/device/user-agent audit where legally appropriate
- private evidence storage
- audit trail for regenerated/revoked links

## Supplier invoice line-item workflow

Supplier Invoice entry now captures:

- Supplier / Vendor
- Supplier Invoice No.
- Invoice Date
- Case / Project
- GST Yes/No
- GST Rate
- Due Date
- Attachment
- one or more invoice line items

Each invoice line captures:

- Item
- Description
- Unit Cost
- Quantity
- Match to Approved Quotation / VO Item

After Case / Project selection, the match dropdown combines items from **all accepted quotations** for the Case plus approved additional VO items. This supports projects with more than one approved quotation.

Duplicate warning remains exactly:

**same Supplier + same Supplier Invoice Number**

The same supplier may continue to submit many different invoices normally.

## Supplier approval → Actual Project Cost

When Assigned ID approves the supplier invoice:

- each supplier invoice line posts to Actual Project Cost once;
- the quotation/VO match is retained on the cost line;
- multiple supplier invoices can match the same approved quotation/VO item;
- re-approving does not duplicate the cost posting.

If supplier GST is enabled, GST is proportionally allocated across invoice lines so matched actual-cost rows reconcile to the supplier invoice total.

## Project Cost Reconciliation

Case → Project Cost now includes a row-by-row comparison:

- Location
- Item
- Estimated Cost (Quotation)
- Charge Amount
- Actual Cost from Supplier
- Cost Variance
- Actual Margin

Actual Cost from Supplier sums **all approved supplier invoice lines** matched to that item.

Manual Cost remains separate and available through **+ Add Manual Cost**.

Legacy/unmatched AUTO supplier costs remain visible so historical cost does not disappear during migration.

## Supplier Invoice filtering + Excel export

Supplier Invoice Aging can now filter by:

- Company
- Supplier
- Case / Project
- Date From
- Date To
- Status tabs

**Export Excel** downloads the currently filtered supplier invoice line-item data in Excel-compatible SpreadsheetML `.xls` format.

## Document-template v0.9 hotfix

v0.9 snapshotted Invoice / VO / DO / PO wording too early. v0.10 corrects that behaviour:

- Draft/unissued document → uses latest Company Master template.
- Company Master edit → draft output changes immediately.
- Explicitly **Issue / Lock Current Template** → saves an immutable wording snapshot.
- Later Company Master edits do not alter that issued document.
- Sent quotation revisions remain immutable as before.

## Retained previous features

- Case-centric workflow
- all 10 Case tabs
- full company/staff names instead of technical IDs
- Property Type library
- Work Section Library in quotation Add/Edit Item
- quotation revision View / Print
- payment-proof upload
- row-level customer payment action
- A4 portrait Invoice / Official Receipt
- responsive Notifications
- VO / DO / Handover flows
- browser/mobile Back history
- closure snapshot
- flexible permissions
- embedded company logos
- Company Master template defaults/customization/restore

## Current platform

Frontend-only GitHub Pages test using LocalStorage.

Still backend-phase work:

- real authentication
- database / multi-user sync
- private persistent files
- real cross-device E-sign submission
- immutable generated PDF archive
- remote Web Push
- server-side audit logs
- secure public signing tokens
