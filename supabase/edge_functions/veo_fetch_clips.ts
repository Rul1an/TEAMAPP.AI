import { serve } from "https://deno.land/x/supabase_functions@v1.0.3/mod.ts";
import { veoGraphQL } from "./_shared/veo_client.ts";
import { tracer } from "./_shared/tracing.ts";
import { SpanStatusCode } from "npm:@opentelemetry/api@1";

// Edge Function: VEO-101 – Fetch highlights/clip list from Veo GraphQL API.
// 
// POST /veo_fetch_clips
// Body: { "matchId": "<VEO_MATCH_ID>" } OR { "teamId": "<VEO_TEAM_ID>", "seasonId": "<OPTIONAL_SEASON_ID>" }
// Returns: { clips: [ { id, title, startMs, endMs, videoUrl } ] }
//
// Authentication is handled via client-credentials (see _shared/veo_client.ts).
// The caller must include a valid `org_id` JWT claim so that downstream
// ingestion can map the clips to the tenant. (Supabase RLS enforced at a later step.)

interface RequestPayload {
  matchId?: string;
  teamId?: string;
  seasonId?: string;
}

interface Clip {
  id: string;
  title: string | null;
  startMs: number;
  endMs: number;
  videoUrl: string | null;
}

serve(async (req) => {
  return await tracer.startActiveSpan("veo_fetch_clips", async (span) => {
    if (req.method !== "POST") {
      span.setStatus({ code: SpanStatusCode.ERROR, message: "405" });
      span.end();
      return new Response("Method Not Allowed", { status: 405 });
    }

    let payload: RequestPayload;
    try {
      payload = await req.json();
    } catch (_e) {
      span.setStatus({ code: SpanStatusCode.ERROR, message: "Invalid JSON" });
      span.end();
      return new Response("Invalid JSON", { status: 400 });
    }

    const { matchId, teamId, seasonId } = payload;
    if (!matchId && !teamId) {
      span.setStatus({ code: SpanStatusCode.ERROR, message: "Missing params" });
      span.end();
      return new Response("matchId or teamId required", { status: 400 });
    }

    try {
      let clips: Clip[] = [];

      if (matchId) {
        span.setAttribute("matchId", matchId);
        clips = await fetchMatchHighlights(matchId);
      } else if (teamId) {
        span.setAttribute("teamId", teamId);
        clips = await fetchTeamHighlights(teamId, seasonId);
      }

      span.end();
      return new Response(JSON.stringify({ clips }), {
        status: 200,
        headers: { "Content-Type": "application/json" },
      });
    } catch (e) {
      span.setStatus({ code: SpanStatusCode.ERROR, message: String(e) });
      span.recordException(e as Error);
      span.end();
      console.error("veo_fetch_clips error", e);
      return new Response("Error fetching clips", { status: 500 });
    }
  });
});

async function fetchMatchHighlights(matchId: string): Promise<Clip[]> {
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
  type ResponseType = {
    match: {
      id: string;
      highlights: Array<{
        id: string;
        title: string | null;
        start: number;
        end: number;
        videoUrl: string | null;
      }>;
    } | null;
  };

  const data = await veoGraphQL<ResponseType>({ query, variables: { matchId } });
  const highlights = data.match?.highlights ?? [];
  return highlights.map((h) => ({
    id: h.id,
    title: h.title,
    startMs: h.start,
    endMs: h.end,
    videoUrl: h.videoUrl,
  }));
}

async function fetchTeamHighlights(teamId: string, seasonId?: string): Promise<Clip[]> {
  const query = `
    query TeamHighlights($teamId: ID!, $seasonId: ID) {
      team(id: $teamId) {
        id
        matches(seasonId: $seasonId) {
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
    }
  `;
  type Resp = {
    team: {
      matches: Array<{
        id: string;
        highlights: Array<{
          id: string;
          title: string | null;
          start: number;
          end: number;
          videoUrl: string | null;
        }>;
      }>;
    } | null;
  };

  const data = await veoGraphQL<Resp>({ query, variables: { teamId, seasonId } });
  const matches = data.team?.matches ?? [];
  const clips: Clip[] = [];
  for (const m of matches) {
    for (const h of m.highlights) {
      clips.push({
        id: h.id,
        title: h.title,
        startMs: h.start,
        endMs: h.end,
        videoUrl: h.videoUrl,
      });
    }
  }
  return clips;
}