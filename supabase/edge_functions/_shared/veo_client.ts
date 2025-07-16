import "https://deno.land/std@0.203.0/dotenv/load.ts";

interface TokenCache {
  accessToken: string | null;
  // Unix epoch seconds when the token expires
  expiresAt: number;
}

const tokenCache: TokenCache = {
  accessToken: null,
  expiresAt: 0,
};

/**
 * Fetch a client-credentials access token from Veo’s OAuth2 endpoint.
 * The result is cached in memory for subsequent invocations so that
 * multiple GraphQL requests during a single Edge Function execution
 * reuse the same token, minimising latency and rate-limit pressure.
 */
export async function getVeoAccessToken(): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  if (tokenCache.accessToken && tokenCache.expiresAt - 30 > now) {
    // Return cached token if still valid (30s buffer)
    return tokenCache.accessToken;
  }

  const clientId = Deno.env.get("VEO_CLIENT_ID");
  const clientSecret = Deno.env.get("VEO_CLIENT_SECRET");
  const tokenUrl = Deno.env.get("VEO_OAUTH_TOKEN_URL") ?? "https://auth.veo.co/oauth/token";

  if (!clientId || !clientSecret) {
    throw new Error("Missing VEO_CLIENT_ID / VEO_CLIENT_SECRET env vars");
  }

  const body = new URLSearchParams({
    grant_type: "client_credentials",
    client_id: clientId,
    client_secret: clientSecret,
    audience: "https://api.veo.co",
  });

  const resp = await fetch(tokenUrl, {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: body.toString(),
  });

  if (!resp.ok) {
    const errText = await resp.text();
    throw new Error(`Veo token request failed: ${resp.status} – ${errText}`);
  }

  const json = await resp.json() as { access_token: string; expires_in: number };
  tokenCache.accessToken = json.access_token;
  tokenCache.expiresAt = now + json.expires_in;
  return json.access_token;
}

export interface GraphQLRequestOptions {
  query: string;
  variables?: Record<string, unknown>;
}

/**
 * Perform a POST request against the Veo GraphQL API with automatic
 * authentication using the client-credentials token.
 */
export async function veoGraphQL<T>({ query, variables }: GraphQLRequestOptions): Promise<T> {
  const token = await getVeoAccessToken();
  const gqlUrl = Deno.env.get("VEO_GRAPHQL_URL") ?? "https://graphql.veo.co";

  const resp = await fetch(gqlUrl, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": `Bearer ${token}`,
    },
    body: JSON.stringify({ query, variables }),
  });

  if (!resp.ok) {
    const errText = await resp.text();
    throw new Error(`GraphQL request failed: ${resp.status} – ${errText}`);
  }

  const json = await resp.json();
  if (json.errors?.length) {
    throw new Error(`GraphQL errors: ${JSON.stringify(json.errors)}`);
  }
  return json.data as T;
}