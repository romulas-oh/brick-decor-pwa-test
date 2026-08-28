const CACHE_NAME = "brick-decor-pwa-v0-6-doc-structure";
const FILES = ["./", "./index.html", "./manifest.json", "./assets/icon.svg", "./assets/logo-central.jpeg", "./assets/logo-bdwerks.png", "./assets/logo-north.png", "./assets/logo-arcbrush.jpg"];
self.addEventListener("install", event => { self.skipWaiting(); event.waitUntil(caches.open(CACHE_NAME).then(cache => cache.addAll(FILES))); });
self.addEventListener("activate", event => { event.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(k => k !== CACHE_NAME).map(k => caches.delete(k)))).then(() => self.clients.claim())); });
self.addEventListener("fetch", event => { event.respondWith(fetch(event.request).catch(() => caches.match(event.request))); });
