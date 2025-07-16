import { serve } from "https://deno.land/std@0.202.0/http/server.ts";

const VEO_CLIENT_ID = Deno.env.get("VEO_CLIENT_ID")!;
const VEO_CLIENT_SECRET = Deno.env.get("VEO_CLIENT_SECRET")!;
const VEO_API_BASE = "https://api.veo.co.uk/api";

async function getAccessToken(): Promise<string> {
  const resp = await fetch(`${VEO_API_BASE}/oauth2/token`, {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "client_credentials",
      client_id: VEO_CLIENT_ID,
      client_secret: VEO_CLIENT_SECRET,
    }),
  });
  const json = await resp.json();
  if (!resp.ok) throw new Error(`Auth failed: ${JSON.stringify(json)}`);
  return json.access_token as string;
}

serve(async (req) => {
  try {
    const { matchId, teamId } = await req.json();
    if (!matchId && !teamId) {
      return new Response("matchId or teamId required", { status: 400 });
    }

    const token = await getAccessToken();
    const url = matchId
      ? `${VEO_API_BASE}/videos/${matchId}/highlights`
      : `${VEO_API_BASE}/videos/v3/get-all?pageSize=50&pageNumber=1&teamId=${teamId}`;

    const resp = await fetch(url, {
      headers: { Authorization: `Bearer ${token}` },
    });
    const data = await resp.json();
    if (!resp.ok) throw data;

    return new Response(JSON.stringify(data), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    return new Response(JSON.stringify({ error: `${err}` }), { status: 500 });
  }
});