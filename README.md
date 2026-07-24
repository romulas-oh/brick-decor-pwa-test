# Brick & Decor PWA v0.3.1 Usable Test

This is the fixed usable testing version.

## Fixed

- Fixed the blank white screen caused by a JavaScript quote escaping issue.
- Updated service worker cache to v0.3.1.
- Added cache cleanup so the old broken cached version can be replaced.

## What is usable now

- Create new client/case
- Add/delete quotation items
- Quotation price validation based on 30%–40% markup
- Generate printable quotation
- Add/delete project real cost
- Add and approve VO
- Add and approve PO
- Tick DO handover checklist and record handover
- Record invoice payments
- Add warranty cases
- Upload local image previews for warranty media
- Edit master pricing settings and item master
- Dashboard and Profit report update from test data
- Export JSON demo data
- Reset demo data

## Important

This version uses browser LocalStorage only. Data is saved in the same browser, not in a real database.

If the live GitHub Pages site still shows white after upload, clear the browser cache or open in incognito mode because the previous service worker may have cached the broken file.
