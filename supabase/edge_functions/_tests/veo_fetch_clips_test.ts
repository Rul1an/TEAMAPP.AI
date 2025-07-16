import { assertEquals } from "https://deno.land/std@0.203.0/assert/mod.ts";
import { handler as fetchClipsHandler } from "../veo_fetch_clips.ts";

Deno.test("veo_fetch_clips returns sample highlights", async () => {
  // Arrange env vars for OAuth
  Deno.env.set("VEO_CLIENT_ID", "test-client");
  Deno.env.set("VEO_CLIENT_SECRET", "test-secret");

  // Create stub for global fetch
  const originalFetch = globalThis.fetch;
  globalThis.fetch = async (input: Request | string, init?: RequestInit) => {
    const url = typeof input === "string" ? input : input.url;

    // OAuth token endpoint stub
    if (url.includes("auth.veo.co")) {
      return new Response(
        JSON.stringify({ access_token: "fake-token", expires_in: 3600 }),
        { status: 200, headers: { "Content-Type": "application/json" } },
      );
    }
    // GraphQL endpoint stub
    if (url.includes("graphql.veo.co")) {
      const body = JSON.parse(init?.body as string);
      if (body.query.includes("MatchHighlights")) {
        return new Response(
          JSON.stringify({
            data: {
              match: {
                id: "m1",
                highlights: [
                  { id: "h1", title: "Goal", start: 1000, end: 5000, videoUrl: "https://video" },
                ],
              },
            },
          }),
          { status: 200, headers: { "Content-Type": "application/json" } },
        );
      }
    }
    return originalFetch(input, init);
  };

  // Act
  const req = new Request("https://edge/veo_fetch_clips", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ matchId: "m1" }),
  });
  const resp = await fetchClipsHandler(req);
  const json = await resp.json();

  // Assert
  assertEquals(resp.status, 200);
  assertEquals(Array.isArray(json.clips), true);
  assertEquals(json.clips.length, 1);
  assertEquals(json.clips[0].id, "h1");

  // Cleanup
  globalThis.fetch = originalFetch;
});