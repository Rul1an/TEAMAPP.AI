import { serve } from "https://deno.land/std@0.202.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.5";
import ffprobe from "https://esm.sh/ffprobe-wasm@0.10.4";

// ---------------------------------------------------------------------------
// Runtime Env & Clients
// ---------------------------------------------------------------------------

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!; // service role for Storage & DB

const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY, {
  auth: { persistSession: false },
});

// Helper to create signed playback URL (24 h)
async function createSignedUrl(bucket: string, path: string): Promise<string> {
  const { data, error } = await supabase.storage
    .from(bucket)
    .createSignedUrl(path, 60 * 60 * 24, { transform: { /* ABR renditions later */ } });
  if (error) throw error;
  return data.signedUrl;
}

// Generate three thumbnails via ffprobe-wasm (fast) – in real usage switch to ffmpeg-wasm for RGB frames
async function generateThumbnails(localFile: ArrayBuffer): Promise<string[]> {
  // Best-practice 2025: use inline WebAssembly to avoid cold-start penalty (~70 ms)
  // Here we just return empty placeholders; real impl would push output to Supabase Storage.
  return ["thumb1.png", "thumb2.png", "thumb3.png"];
}

// Extract basic metadata via ffprobe-wasm
async function extractMetadata(localFile: ArrayBuffer) {
  const info = await ffprobe(localFile);
  return {
    duration: info.format.duration ?? 0,
    width: info.streams[0]?.width ?? 0,
    height: info.streams[0]?.height ?? 0,
    codec: info.streams[0]?.codec_name ?? "",
  };
}

serve(async (req) => {
  // -----------------------------------------------------------------------
  // 1. Validate & parse hook (Supabase Storage Hooks v0.7 – object.created)
  // -----------------------------------------------------------------------
  try {
    const payload = await req.json();
    if (payload?.type !== "object.created") {
      return new Response("ignored", { status: 202 });
    }

    const { bucketId, name: path } = payload.record ?? {};

    // ---------------------------------------------------------------------
    // 2. Download object to memory (Edge runtime, < 100 MB best-practice)
    // ---------------------------------------------------------------------
    const { data: fileData, error: dlErr } = await supabase.storage
      .from(bucketId)
      .download(path);
    if (dlErr || !fileData) throw dlErr;

    const arrayBuf = await fileData.arrayBuffer();

    // ---------------------------------------------------------------------
    // 3. Analyse & optimise (wasm-ffmpeg/ffprobe) – 2025 fully edge-native
    // ---------------------------------------------------------------------
    const metadata = await extractMetadata(arrayBuf);
    const thumbs = await generateThumbnails(arrayBuf);

    // ---------------------------------------------------------------------
    // 4. Store metadata in Postgres (video_assets table)
    // ---------------------------------------------------------------------
    await supabase.from("video_assets").insert({
      path,
      bucket: bucketId,
      duration: metadata.duration,
      width: metadata.width,
      height: metadata.height,
      codec: metadata.codec,
      thumbnail1: thumbs[0],
      thumbnail2: thumbs[1],
      thumbnail3: thumbs[2],
    });

    // ---------------------------------------------------------------------
    // 5. Create signed playback URL (LL-HLS to be generated later)
    // ---------------------------------------------------------------------
    const signedUrl = await createSignedUrl(bucketId, path);

    // ---------------------------------------------------------------------
    // 6. Broadcast processing_done event with enriched payload
    // ---------------------------------------------------------------------
    await supabase.channel("video_processing").send({
      type: "broadcast",
      event: "processing_done",
      payload: {
        path,
        signedUrl,
        duration: metadata.duration,
        thumbs,
      },
    });

    return new Response(JSON.stringify({ ok: true }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error(err);
    return new Response(JSON.stringify({ error: `${err}` }), { status: 500 });
  }
});