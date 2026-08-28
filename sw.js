const CACHE_NAME='brick-decor-v062-full-integrated';
const FILES=['./','./index.html','./manifest.json','./assets/icon.svg','./assets/brick-decor-central.jpeg','./assets/bd-werks.png','./assets/brick-decor-north.png','./assets/arc-brush.jpg'];
self.addEventListener('install',e=>{self.skipWaiting();e.waitUntil(caches.open(CACHE_NAME).then(c=>c.addAll(FILES)))});
self.addEventListener('activate',e=>{e.waitUntil(caches.keys().then(keys=>Promise.all(keys.filter(k=>k!==CACHE_NAME).map(k=>caches.delete(k)))).then(()=>self.clients.claim()))});
self.addEventListener('fetch',e=>{e.respondWith(fetch(e.request).catch(()=>caches.match(e.request)))});
