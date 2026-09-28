# Brick & Decor PWA v0.17 Test Report

## Static / package checks
- PASS — v0.17 title
- PASS — combined multiline renderer
- PASS — customer E-sign A4 renderer
- PASS — revision_snapshot docs
- PASS — revision_snapshot payment schedule
- PASS — revision_snapshot staff signatures
- PASS — signed quotation action
- PASS — signed generic document action
- PASS — actual customer signature image
- PASS — SQL 06 quote RPC
- PASS — SQL 06 doc RPC
- PASS — service worker v0.17 cache
- PASS — service-worker asset paths

## JavaScript syntax
- PASS — all embedded script blocks were extracted and checked with `node --check`.

## Scope covered
- Builder descriptions retain entered line breaks, including Combined Amount members.
- Customer E-sign page uses the immutable sent revision snapshot and mirrors the quotation document structure.
- Company document wording, payment schedule and staff signatures are read from `revision_snapshot`.
- Signed quotation preview/print retrieves actual customer signature evidence through authenticated SQL 06 RPC.
- Signed LOA / VO / Handover retrieval foundation uses the same access-controlled pattern.

## Manual browser checks still required after deployment
- Open one customer E-sign link on desktop and phone; confirm A4-like quotation layout and line wrapping.
- Sign one quotation and then use Preview Signed Copy / Print Signed PDF from staff PWA.
- Test one Combined Amount group with 2 multiline descriptions.
- Test Signed Documents for LOA/VO/Handover after at least one such document is signed.

Missing service worker assets: None