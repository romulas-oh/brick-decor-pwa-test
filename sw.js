const CACHE='bd-pwa-v0.18-secure-user-admin';
const CORE=['./index.html','./manifest.json','./assets/icon.svg','./assets/brick-decor-central.jpeg','./assets/bd-werks.png','./assets/brick-decor-north.png','./assets/arc-brush.jpg','./assets/excel-mola-fermi-upgrade.png','./assets/nippon-anti-mould-upgrade.png'];
self.addEventListener('install',event=>{event.waitUntil(caches.open(CACHE).then(c=>c.addAll(CORE)).catch(()=>{}));self.skipWaiting();});
self.addEventListener('activate',event=>{event.waitUntil(caches.keys().then(keys=>Promise.all(keys.filter(k=>k!==CACHE).map(k=>caches.delete(k)))));self.clients.claim();});
function timeout(ms){return new Promise((_,reject)=>setTimeout(()=>reject(new Error('network timeout')),ms));}
self.addEventListener('fetch',event=>{
  if(event.request.method!=='GET')return;
  const url=new URL(event.request.url);if(url.origin!==self.location.origin)return;
  if(event.request.mode==='navigate'){
    event.respondWith(Promise.race([fetch(event.request),timeout(8000)]).then(r=>r).catch(()=>caches.match('./index.html')));
    return;
  }
  event.respondWith(caches.match(event.request).then(cached=>cached||Promise.race([fetch(event.request),timeout(8000)]).then(r=>{if(r&&r.ok){const copy=r.clone();caches.open(CACHE).then(c=>c.put(event.request,copy));}return r;}).catch(()=>cached)));
});
self.addEventListener('notificationclick',event=>{event.notification.close();event.waitUntil(clients.matchAll({type:'window',includeUncontrolled:true}).then(list=>list.length?list[0].focus():clients.openWindow('./index.html')));});
