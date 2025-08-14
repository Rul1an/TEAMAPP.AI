(function () {
  const CACHE_NAME = 'canvaskit-__SHA__';
  const shouldHandle = (url) => {
    try {
      const u = new URL(url);
      return (
        u.pathname.startsWith('/canvaskit/') ||
        u.pathname.endsWith('.wasm')
      );
    } catch (_) {
      return false;
    }
  };

  self.addEventListener('install', (event) => {
    event.waitUntil(self.skipWaiting());
  });

  self.addEventListener('activate', (event) => {
    event.waitUntil(self.clients.claim());
  });

  self.addEventListener('fetch', (event) => {
    const { request } = event;
    if (!shouldHandle(request.url)) return;

    event.respondWith(
      caches.open(CACHE_NAME).then(async (cache) => {
        const cached = await cache.match(request, { ignoreSearch: true });
        if (cached) return cached;
        const response = await fetch(request, { credentials: 'same-origin' });
        try { await cache.put(request, response.clone()); } catch (_) {}
        return response;
      })
    );
  });
})();


