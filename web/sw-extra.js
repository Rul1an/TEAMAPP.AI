(function () {
    const VERSION = '__SHA__';
    const CORE_CACHE = `core-${VERSION}`;
    const ASSETS_CACHE = `assets-${VERSION}`;

    const isCanvasKitOrWasm = (url) => {
        try {
            const u = new URL(url);
            return u.pathname.startsWith('/canvaskit/') || u.pathname.endsWith('.wasm');
        } catch (_) { return false; }
    };

    const isAppAsset = (url) => {
        try {
            const u = new URL(url);
            if (!u.pathname.startsWith('/assets/') && !u.pathname.startsWith('/icons/')) {
                return false;
            }
            return [
                '.png', '.jpg', '.jpeg', '.webp', '.svg',
                '.json', '.ttf', '.otf', '.woff', '.woff2'
            ].some(ext => u.pathname.endsWith(ext));
        } catch (_) { return false; }
    };

    self.addEventListener('install', (event) => {
        event.waitUntil(self.skipWaiting());
    });

    self.addEventListener('activate', (event) => {
        event.waitUntil(self.clients.claim());
    });

    self.addEventListener('fetch', (event) => {
        const { request } = event;
        const url = request.url;

        // Cache-first for CanvasKit/wasm (large immutable assets)
        if (isCanvasKitOrWasm(url)) {
            event.respondWith(
                caches.open(CORE_CACHE).then(async (cache) => {
                    const cached = await cache.match(request, { ignoreSearch: true });
                    if (cached) return cached;
                    const response = await fetch(request, { credentials: 'same-origin' });
                    try { await cache.put(request, response.clone()); } catch (_) {}
                    return response;
                })
            );
            return;
        }

        // Stale-while-revalidate for app assets (images/fonts/manifests)
        if (isAppAsset(url)) {
            event.respondWith(
                caches.open(ASSETS_CACHE).then(async (cache) => {
                    const cached = await cache.match(request, { ignoreSearch: true });
                    const network = fetch(request, { credentials: 'same-origin' }).then((resp) => {
                        try { cache.put(request, resp.clone()); } catch (_) {}
                        return resp;
                    }).catch(() => undefined);
                    return cached || network || fetch(request);
                })
            );
        }
    });
})();


