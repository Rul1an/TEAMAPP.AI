import { assertEquals } from "https://deno.land/std@0.203.0/assert/mod.ts";
import { stub } from "https://deno.land/std@0.203.0/testing/mock.ts";

import * as supabaseJs from "https://esm.sh/@supabase/supabase-js@2";
import { handler as fetchClips } from "../veo_fetch_clips.ts";
import { handler as ingest } from "../veo_ingest_highlights.ts";
import { highlightsInsertedCounter } from "../_shared/metrics.ts";

Deno.test("Full pipeline fetch → ingest increments metric", async () => {
  // Stubs
  const fakeFrom = () => ({
    upsert: (_rows: unknown) => Promise.resolve({ error: null }),
  });
  const createClientStub = stub(supabaseJs, "createClient", () => ({
    from: fakeFrom,
  }) as unknown);

  const metricAddCalls: Array<number> = [];
  const addStub = stub(highlightsInsertedCounter, "add", (value: number) => {
    metricAddCalls.push(value);
  });

  // Mock OAuth + GraphQL
  const originalFetch = globalThis.fetch;
  globalThis.fetch = async (input: Request | string, init?: RequestInit) => {
    const url = typeof input === "string" ? input : input.url;
    if (url.includes("auth.veo.co")) {
      return new Response(JSON.stringify({ access_token: "tok", expires_in: 3600 }), { status: 200 });
    }
    if (url.includes("graphql.veo.co")) {
      return new Response(
        JSON.stringify({
          data: {
            match: {
              highlights: [
                { id: "h1", title: "Goal 1", start: 0, end: 1000, videoUrl: "https://video" },
                { id: "h2", title: "Goal 2", start: 2000, end: 4000, videoUrl: "https://video" },
              ],
            },
          },
        }),
        { status: 200, headers: { "Content-Type": "application/json" } },
      );
    }
    return originalFetch(input, init);
  };

  // Env
  Deno.env.set("VEO_CLIENT_ID", "cid");
  Deno.env.set("VEO_CLIENT_SECRET", "csec");
  Deno.env.set("SUPABASE_URL", "http://localhost");
  Deno.env.set("SUPABASE_SERVICE_ROLE_KEY", "srv");

  // Step 1: fetch clips
  const fetchReq = new Request("https://edge/fetch", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ matchId: "m1" }),
  });
  const fetchResp = await fetchClips(fetchReq);
  const { clips } = await fetchResp.json();
  assertEquals(clips.length, 2);

  // Step 2: ingest
  const ingestReq = new Request("https://edge/ingest", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ matchId: "m1", organizationId: "org1" }),
  });
  const ingestResp = await ingest(ingestReq);
  const ingestJson = await ingestResp.json();
  assertEquals(ingestJson.inserted, 2);

  // Metrics asserted
  assertEquals(metricAddCalls.length > 0, true);
  assertEquals(metricAddCalls[0], 2);

  // Cleanup
  createClientStub.restore();
  addStub.restore();
  globalThis.fetch = originalFetch;
});