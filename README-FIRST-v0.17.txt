BRICK & DECOR PWA v0.17 — SIGNED COPY + E-SIGN LAYOUT
========================================================

WHAT CHANGED
- On-screen quotation builder preserves description line breaks exactly as entered.
- Combined Amount items show each description underneath its item, not collapsed onto one line.
- Customer E-sign page now mirrors the actual sent quotation structure instead of a simplified snapshot card.
- Customer E-sign reads company wording, payment schedule and staff signatures from the immutable sent revision snapshot.
- Staff can Preview Signed Copy for a signed quotation and Print / Save Signed PDF with the actual customer signature.
- Signed LOA / VO / Handover records can be retrieved and printed from the Signed Documents action when available.

SUPABASE
Run 06_v0.17_signed_copy.sql once. It adds read-only, access-controlled RPCs for signed-copy retrieval.
No existing tables or workflow statuses are changed by SQL 06.

TEST URL AFTER DEPLOY
https://romulas-oh.github.io/brick-decor-pwa-test/?v=0171
