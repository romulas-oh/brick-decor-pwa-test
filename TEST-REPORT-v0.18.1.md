# Brick & Decor PWA v0.18.1 Test Report

## Scope
Quotation Item / Service suggestions filtered by selected Work Section.

## Mapping verification
- Service master entries: **69**
- Entries mapped to a Work Section: **69/69**
- Every existing preset service mapped exactly once: **PASS**

- Hacking Works: 9 preset service(s)
- Carpentry / Misc Hacking Works: 2 preset service(s)
- Demolishing Works: 1 preset service(s)
- Ceiling works & Partition Works: 2 preset service(s)
- Masonry Works: 14 preset service(s)
- Vinyl Works: 6 preset service(s)
- Carpentry Works: 13 preset service(s)
- Sintered Surface Table Top: 2 preset service(s)
- Glass Works: 4 preset service(s)
- Plumbing works: 2 preset service(s)
- Paint works: 4 preset service(s)
- Window Works: 5 preset service(s)
- Door / Gate Works: 3 preset service(s)
- Aluminium Door Works: 1 preset service(s)
- Miscellaneous Works: 1 preset service(s)

## Static / syntax checks
- Embedded JavaScript syntax: **13/13 PASS**
- Filter patch static checks: **8/8 PASS**
- Service worker cache bumped to `bd-pwa-v0.18.1-work-section-service-filter`: **PASS**

## Regression boundary
- No SQL/database migration added.
- No user-admin Edge Function change.
- No quotation calculation change.
- No E-sign or signed-copy logic change.
- Custom service entry remains allowed.
