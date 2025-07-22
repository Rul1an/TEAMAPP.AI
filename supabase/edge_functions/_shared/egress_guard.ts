// Zero-trust egress policy helper (Best Practice 2025)
// Only allow outbound HTTP requests to explicit allow-list of hosts.

const ALLOW_HOSTS = new Set<string>([
  "auth.veo.co",
  "graphql.veo.co",
]);

export function assertHostAllowed(url: string | URL) {
  const host = typeof url === "string" ? new URL(url).host : url.host;
  if (!ALLOW_HOSTS.has(host)) {
    throw new Error(`Egress to host '${host}' is not permitted by policy`);
  }
}