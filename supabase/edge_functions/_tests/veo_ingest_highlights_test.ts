import { assertEquals } from "https://deno.land/std@0.203.0/assert/mod.ts";
import { stub } from "https://deno.land/std@0.203.0/testing/mock.ts";

import * as supabaseJs from "https://esm.sh/@supabase/supabase-js@2";
import { handler as ingestHandler } from "../veo_ingest_highlights.ts";

Deno.test("veo_ingest_highlights upserts rows", async () => {
  // Stub createClient to avoid real network/db
  const fakeFrom = () => ({
    upsert: (_rows: unknown, _opts: unknown) => Promise.resolve({ error: null }),
  });
  const createClientStub = stub(supabaseJs, "createClient", () => ({
    from: fakeFrom,
  }) as unknown);

  // Mock fetch for Veo GraphQL + OAuth
  const originalFetch = globalThis.fetch;
  globalThis.fetch = async (input: Request | string) => {
    const url = typeof input === "string" ? input : input.url;
    if (url.includes("auth.veo.co")) {
      return new Response(JSON.stringify({ access_token: "tok", expires_in: 3600 }), { status: 200 });
    }
    if (url.includes("graphql.veo.co")) {
      return new Response(
        JSON.stringify({
          data: { match: { highlights: [{ id: "h1", title: "Foo", start: 0, end: 1000, videoUrl: null }] } },
        }),
        { status: 200, headers: { "Content-Type": "application/json" } },
      );
    }
    return originalFetch(input);
  };

  // Env vars
  Deno.env.set("VEO_CLIENT_ID", "client");
  Deno.env.set("VEO_CLIENT_SECRET", "secret");
  Deno.env.set("SUPABASE_URL", "http://localhost");
  Deno.env.set("SUPABASE_SERVICE_ROLE_KEY", "service-key");

  // Act
  const req = new Request("https://edge/veo_ingest_highlights", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ matchId: "m1", organizationId: "org1" }),
  });
  const resp = await ingestHandler(req);
  const data = await resp.json();

  // Assert
  assertEquals(resp.status, 200);
  assertEquals(data.inserted, 1);

  // Cleanup
  createClientStub.restore();
  globalThis.fetch = originalFetch;
});