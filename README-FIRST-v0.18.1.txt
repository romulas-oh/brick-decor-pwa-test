BRICK & DECOR PWA v0.18.1 — WORK-SECTION SERVICE FILTER
============================================================

PURPOSE
-------
Quotation Item / Service suggestions are now filtered by the selected Work Section.
This avoids showing the entire quotation library for every section.

EXAMPLES
--------
- Hacking Works -> only hacking services are suggested.
- Carpentry Works -> carpentry services + EXCEL carpentry upgrade items.
- Plumbing works -> only plumbing services.
- Paint works -> paint services + NIPPON Anti Mould upgrade.
- Window Works -> only window services.

CUSTOM ITEMS
------------
The ID can still type a custom Item / Service even when it is not in the preset library.
For a custom Work Section with no mapped library items, the list is intentionally empty and the ID can type a custom service.

RETAINED
--------
All v0.18 secure user administration, Supabase E-sign, signed-copy, quotation, company-document, commission and costing features are retained.

DATABASE
--------
No new Supabase SQL is required for v0.18.1.

TEST URL AFTER PUSH
-------------------
https://romulas-oh.github.io/brick-decor-pwa-test/?v=0182
