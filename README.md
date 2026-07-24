# Brick & Decor PWA v0.2 Test

This is the second-tier testing version for Brick & Decor.

It is a static frontend demo with test data only. It does not have a real backend yet.

## Included tabs

- Dashboard
- Clients / Case Opening
- Quotation Builder with 30%–40% pricing validation
- Projects / Real Cost
- VO
- PO
- DO / Handover
- Invoices & Payments
- Warranty & Media
- Profit & Commission
- Master Data

## How to test locally

Open `index.html` directly in your browser.

Or run:

```bash
python3 -m http.server 5173
```

Then open:

```text
http://localhost:5173
```

## GitHub Pages testing

1. Create a new GitHub repository, for example `brick-decor-pwa-test`.
2. Upload all files from this ZIP to the repository root.
3. Go to Settings > Pages.
4. Source: Deploy from a branch.
5. Branch: main, folder: /root.
6. Save and wait for the GitHub Pages URL.

## Important note

This is for UI and workflow testing only. The next stage should connect database, login, file storage, PDF generation, and real role permissions.
