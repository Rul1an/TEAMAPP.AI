import { serve } from "https://deno.land/std@0.167.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// Environment variables injected by Supabase at deploy
const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY")!;

const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// Placeholder – future: invoke FFmpeg to create thumbnails & HLS renditions.

serve(async (req) => {
  // Parse storage webhook payload
  const payload = await req.json();
  const { name: path, bucketId } = payload?.record ?? {};

  console.log(`Storage hook received for ${bucketId}/${path}`);

  // TODO: run background FFmpeg job here...

  // For now, immediately broadcast processing_done
  await supabase.channel("video_processing").send({
    type: "broadcast",
    event: "processing_done",
    payload: { path },
  });

  return new Response(JSON.stringify({ ok: true }), {
    headers: { "Content-Type": "application/json" },
    status: 200,
  });
});