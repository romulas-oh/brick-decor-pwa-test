BRICK & DECOR PWA v0.14.1 STARTUP HOTFIX

Purpose:
- Prevent blank/never-ending refresh caused by a stale service worker navigation or a hanging Supabase request.
- Preserve all v0.14 L1.5 quotation/signing/media features.

Deploy:
1. Replace the repository contents with this package (or at minimum index.html, sw.js, manifest.json).
2. Commit + push.
3. First recovery test: open in an Incognito window using ?v=0142.
4. If the normal Chrome profile is still stuck, unregister the old service worker / delete Cache Storage only. Do not clear Local Storage.

No new Supabase SQL is required beyond 04_v0.14_document_esign.sql already required by v0.14.
