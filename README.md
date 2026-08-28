# Brick & Decor PWA v0.7 Case-Centric Test

Built on v0.6.2. Previous features are retained; this version reorganises the workflow around the Case File.

## Confirmed v0.7 workflow
- Case File is the centre of the project.
- Fixed client/company/site data is entered once at Case creation.
- Quotations and revisions inherit Case data.
- Sent revisions save a snapshot.
- Client approval can auto-change the Case to Project Confirmed; this rule is configurable in Master Data.
- Supplier invoice is linked to a readable Case/Project.
- Assigned ID is notified and is the default person allowed to approve/reject supplier invoice.
- Approved supplier invoice posts once into Actual Project Cost as AUTO cost.
- Superadmin/Accounts receives approved supplier invoice for payment.
- ID submits Case Closure Request.
- Only Superadmin can finalise Closed.
- Closing saves a final financial snapshot.
- Closed cases remain hidden from normal ID unless Superadmin grants closed-case access.
- Commission remains subject to Superadmin approval.

## UI improvements
- Quotation builder uses clean presentation rows instead of showing every field as a thick input box.
- Edit Item opens a focused modal.
- Work Section Library is selectable from Master Data, with Custom/New option.
- Direct quotation creation shows client + site + company instead of internal P1/P2.
- User company access displays full company names, not BDC/BDW/BDN/AB codes.
- PayNow mismatch warning is explained and Superadmin can mark the payment detail verified.
- Company logos use absolute URLs in generated print previews.

## Notifications
- In-app workflow notifications are included.
- Browser/PWA notification permission and local test notification are included.
- For iPhone/iPad, install to Home Screen before enabling notifications.
- True remote push from backend events will be added when authentication/backend is connected.

Frontend-only test using browser LocalStorage. Real database, authentication, private attachments, remote push subscriptions and immutable PDF archive come later.
