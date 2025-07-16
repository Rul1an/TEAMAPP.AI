import { serve } from "https://deno.land/x/supabase_functions@v1.0.3/mod.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { veoGraphQL } from "./_shared/veo_client.ts";

// Edge Function: VEO-102 – Ingest Veo highlights for a given match into the
// tenant’s database. This reuses the fetch logic from VEO-101 but additionally
// stores the highlights into the `veo_highlights` table for later use in the
// app’s video pipeline.
//
// POST /veo_ingest_highlights
// Body: { "matchId": "<VEO_MATCH_ID>", "organizationId": "<ORG_UUID>" }
// Returns: { inserted: number }

interface ReqBody {
  matchId: string;
  organizationId: string;
}

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response("Method Not Allowed", { status: 405 });
  }

  let body: ReqBody;
  try {
    body = await req.json();
  } catch (_e) {
    return new Response("Invalid JSON", { status: 400 });
  }

  if (!body.matchId || !body.organizationId) {
    return new Response("matchId and organizationId required", { status: 400 });
  }

  try {
    const clips = await fetchHighlights(body.matchId);

    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    if (!supabaseUrl || !serviceKey) {
      return new Response("Missing Supabase env vars", { status: 500 });
    }

    const supabase = createClient(supabaseUrl, serviceKey, {
      auth: { persistSession: false },
    });

    const rows = clips.map((c) => ({
      highlight_id: c.id,
      match_id: body.matchId,
      organization_id: body.organizationId,
      title: c.title,
      start_ms: c.startMs,
      end_ms: c.endMs,
      video_url: c.videoUrl,
      ingested_at: new Date().toISOString(),
    }));

    const { error } = await supabase.from("veo_highlights").upsert(rows, {
      onConflict: "highlight_id",
    });
    if (error) {
      console.error("DB upsert error", error);
      return new Response("DB error", { status: 500 });
    }

    return new Response(JSON.stringify({ inserted: rows.length }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (e) {
    console.error("veo_ingest_highlights error", e);
    return new Response("Internal error", { status: 500 });
  }
});

interface Clip {
  id: string;
  title: string | null;
  startMs: number;
  endMs: number;
  videoUrl: string | null;
}

async function fetchHighlights(matchId: string): Promise<Clip[]> {
  const query = `
    query MatchHighlights($matchId: ID!) {
      match(id: $matchId) {
        id
        highlights {
          id
          title
          start
          end
          videoUrl
        }
      }
    }
  `;
  type Resp = {
    match: {
      highlights: Array<{
        id: string;
        title: string | null;
        start: number;
        end: number;
        videoUrl: string | null;
      }>;
    } | null;
  };

  const data = await veoGraphQL<Resp>({ query, variables: { matchId } });
  const highlights = data.match?.highlights ?? [];
  return highlights.map((h) => ({
    id: h.id,
    title: h.title,
    startMs: h.start,
    endMs: h.end,
    videoUrl: h.videoUrl,
  }));
}