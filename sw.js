const CACHE_NAME = "brick-decor-pwa-v0-4-starter";
const FILES = ["./", "./index.html", "./src/styles.css", "./src/app.js", "./manifest.json", "./assets/icon.svg"];
self.addEventListener("install", event => { self.skipWaiting(); event.waitUntil(caches.open(CACHE_NAME).then(cache => cache.addAll(FILES))); });
self.addEventListener("activate", event => { event.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(key => key !== CACHE_NAME).map(key => caches.delete(key)))).then(() => self.clients.claim())); });
self.addEventListener("fetch", event => { event.respondWith(fetch(event.request).catch(() => caches.match(event.request))); });
