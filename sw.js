const BASE = new URL('./', self.registration.scope);
const CACHE = 'mesh-schools-local-v3';
const ASSETS = [
  new URL('./', BASE).href,
  new URL('index.html', BASE).href,
  new URL('manifest.json', BASE).href,
  new URL('icons/icon-192.png', BASE).href,
  new URL('icons/icon-512.png', BASE).href
];
self.addEventListener('install', event => {
  event.waitUntil(caches.open(CACHE).then(cache => cache.addAll(ASSETS)));
  self.skipWaiting();
});
self.addEventListener('activate', event => {
  event.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(key => key !== CACHE).map(key => caches.delete(key)))).then(() => self.clients.claim()));
});
self.addEventListener('fetch', event => {
  if (event.request.method !== 'GET') return;
  const url = new URL(event.request.url);
  if (url.origin !== self.location.origin) return;
  event.respondWith(caches.match(event.request).then(cached => cached || fetch(event.request).then(response => {
    if (response.ok) { const copy = response.clone(); caches.open(CACHE).then(cache => cache.put(event.request, copy)); }
    return response;
  }).catch(() => caches.match(new URL('index.html', BASE).href))));
});
