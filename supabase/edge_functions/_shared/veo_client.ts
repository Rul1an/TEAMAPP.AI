import "https://deno.land/std@0.203.0/dotenv/load.ts";
import { SpanStatusCode } from "npm:@opentelemetry/api@1";
import { tracer } from "./tracing.ts";
import { fetchWithClient } from "./http_client.ts";

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
  return await tracer.startActiveSpan("getVeoAccessToken", async (span) => {
    const now = Math.floor(Date.now() / 1000);
    if (tokenCache.accessToken && tokenCache.expiresAt - 30 > now) {
      span.setAttribute("cache_hit", true);
      span.end();
      return tokenCache.accessToken!;
    }

    span.setAttribute("cache_hit", false);
    const clientId = Deno.env.get("VEO_CLIENT_ID");
    const clientSecret = Deno.env.get("VEO_CLIENT_SECRET");
    const tokenUrl = Deno.env.get("VEO_OAUTH_TOKEN_URL") ?? "https://auth.veo.co/oauth/token";

    if (!clientId || !clientSecret) {
      span.setStatus({ code: SpanStatusCode.ERROR, message: "Missing env vars" });
      span.end();
      throw new Error("Missing VEO_CLIENT_ID / VEO_CLIENT_SECRET env vars");
    }

    const body = new URLSearchParams({
      grant_type: "client_credentials",
      client_id: clientId,
      client_secret: clientSecret,
      audience: "https://api.veo.co",
    });

    const resp = await fetchWithClient(tokenUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: body.toString(),
    });

    if (!resp.ok) {
      const errText = await resp.text();
      span.setStatus({ code: SpanStatusCode.ERROR, message: `HTTP ${resp.status}` });
      span.recordException(new Error(errText));
      span.end();
      throw new Error(`Veo token request failed: ${resp.status} – ${errText}`);
    }

    const json = await resp.json() as { access_token: string; expires_in: number };
    tokenCache.accessToken = json.access_token;
    tokenCache.expiresAt = now + json.expires_in;
    span.end();
    return json.access_token;
  });
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
  return await tracer.startActiveSpan("veoGraphQL", async (span) => {
    span.setAttribute("operation", query.trim().split(" ")[1] ?? "anonymous");
    const token = await getVeoAccessToken();
    const gqlUrl = Deno.env.get("VEO_GRAPHQL_URL") ?? "https://graphql.veo.co";

    const resp = await fetchWithClient(gqlUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`,
      },
      body: JSON.stringify({ query, variables }),
    });

    if (!resp.ok) {
      const errText = await resp.text();
      span.setStatus({ code: SpanStatusCode.ERROR, message: `HTTP ${resp.status}` });
      span.recordException(new Error(errText));
      span.end();
      throw new Error(`GraphQL request failed: ${resp.status} – ${errText}`);
    }

    const json = await resp.json();
    if (json.errors?.length) {
      span.setStatus({ code: SpanStatusCode.ERROR, message: "GraphQL errors" });
      span.recordException(new Error(JSON.stringify(json.errors)));
      span.end();
      throw new Error(`GraphQL errors: ${JSON.stringify(json.errors)}`);
    }
    span.end();
    return json.data as T;
  });
}