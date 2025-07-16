// HTTP utility with keep-alive / HTTP2 pooled client (Deno >=1.41)
// Best practice 2025: reuse a single HttpClient per isolate to remove TLS handshake latency.

const httpClient = Deno.createHttpClient({
  keepAlive: true,
  // enable http2 where supported by origin (Veo GraphQL endpoint supports h2)
  http2: true,
});

export function fetchWithClient(input: Request | URL | string, init?: RequestInit) {
  assertHostAllowed(typeof input === "string" || input instanceof URL ? input : input.url);
  return fetch(input, { client: httpClient, ...init });
}