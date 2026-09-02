const CACHE='bd-pwa-v0.9-l1.4';
const ASSETS=['./','./index.html','./manifest.json','./src/v08.css','./src/v08-patch.js','./src/v09.css','./src/v09-patch.js','./assets/icon.svg','./assets/brick-decor-central.jpeg','./assets/bd-werks.png','./assets/brick-decor-north.png','./assets/arc-brush.jpg'];
self.addEventListener('install',e=>{e.waitUntil(caches.open(CACHE).then(c=>c.addAll(ASSETS)));self.skipWaiting()});
self.addEventListener('activate',e=>{e.waitUntil(caches.keys().then(keys=>Promise.all(keys.filter(k=>k!==CACHE).map(k=>caches.delete(k)))));self.clients.claim()});
self.addEventListener('fetch',e=>{if(e.request.method!=='GET')return;e.respondWith(fetch(e.request).then(r=>{const copy=r.clone();caches.open(CACHE).then(c=>c.put(e.request,copy));return r}).catch(()=>caches.match(e.request).then(r=>r||caches.match('./index.html'))))});
self.addEventListener('notificationclick',event=>{
  event.notification.close();
  event.waitUntil(clients.matchAll({type:'window',includeUncontrolled:true}).then(list=>{
    if(list.length)return list[0].focus();
    return clients.openWindow('./index.html');
  }));
});
