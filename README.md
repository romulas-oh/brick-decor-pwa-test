# Brick & Decor PWA v0.5 Overview & Approval Test

Updated based on B&D L 1.1 amendment comments.

## Confirmed rules included

- Quotation follow-up reminder counts from last sent date.
- Reminder triggers after 10 days by default.
- Supplier invoice attachment is local file-name preview only for frontend testing.
- Normal worker can create own case.
- Normal worker sees only quotations/cases/projects created by them or assigned to them.
- Closed cases/projects are hidden from normal worker unless Superadmin grants closed-project access.
- Staff commission is visible only after Superadmin approval.
- Warranty and photo/video/media upload are removed.

## New testable features

- Quotation Overview with company / ID / project / date / status filters.
- Quotation detail builder with editable custom items and descriptions.
- Quotation version history and last sent date.
- Notifications tab for quotation follow-up and supplier verification.
- Project Costing Overview with filters.
- VO and DO moved under Project Costing detail.
- Invoice Overview with filters and sub-tabs.
- Payment trigger percentage warning.
- PO / Supplier Aging sub-tabs.
- Supplier invoice project link, local attachment field, verification approval, payment status and duplicate warning.
- Profit & Commission filter by worker with Superadmin approval logic.
- Users & Flexible Access permission matrix, company access and project visibility control.
- 5 dummy companies in Company Master.

## Important

This is frontend-only using browser LocalStorage. Real login, backend database, real file storage, server PDF generation and real permissions must be added in the backend stage.
