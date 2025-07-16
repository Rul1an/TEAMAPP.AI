import { serve } from "https://deno.land/x/supabase_functions@v1.0.3/mod.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// Edge Function: VEO-103 – Provide presigned playback URL for a highlight.
//
// Workflow:
// 1. Look up highlight row within RLS context.
// 2. If storage_path exists ➜ return signed URL (60 min).
// 3. Else download remote `video_url` to Storage bucket `veo_highlights/<org>/<match>/<highlight>.mp4`.
//    Then update row.storage_path and return signed URL.
//
// POST /veo_get_clip_url
// Body: { "highlightId": "<H_ID>" }
// Returns: { "url": "https://…signed" }

interface Req {
  highlightId: string;
}

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response("Method Not Allowed", { status: 405 });
  }

  let body: Req;
  try {
    body = await req.json();
  } catch (_e) {
    return new Response("Invalid JSON", { status: 400 });
  }

  const highlightId = body.highlightId;
  if (!highlightId) {
    return new Response("highlightId required", { status: 400 });
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const anonKey = Deno.env.get("SUPABASE_ANON_KEY");
  const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!supabaseUrl || !serviceKey || !anonKey) {
    return new Response("Missing Supabase env vars", { status: 500 });
  }

  const supabaseSvc = createClient(supabaseUrl, serviceKey, {
    auth: { persistSession: false },
  });

  // Fetch highlight row (bypass RLS using service key to get organization_id & match_id)
  const { data: row, error } = await supabaseSvc
    .from("veo_highlights")
    .select("highlight_id, match_id, organization_id, storage_path, video_url")
    .eq("highlight_id", highlightId)
    .single();

  if (error || !row) {
    console.error("Highlight fetch error", error);
    return new Response("Not found", { status: 404 });
  }

  const bucket = "veo_highlights";
  const storagePath = row.storage_path ?? `${row.organization_id}/${row.match_id}/${row.highlight_id}.mp4`;

  const supabaseAnon = createClient(supabaseUrl, anonKey, {
    auth: { persistSession: false },
  });

  async function signUrl(): Promise<string> {
    const { data, error: signErr } = await supabaseAnon.storage
      .from(bucket)
      .createSignedUrl(storagePath, 60 * 60); // 60 min

    if (signErr || !data) {
      console.error("SignedUrl error", signErr);
      throw new Error("Cannot create signed URL");
    }
    return data.signedUrl;
  }

  // If file is already in storage ➜ sign directly
  const headRes = await supabaseSvc.storage.from(bucket).list(storagePath, {
    limit: 1,
  });
  const exists = headRes.data?.length === 1;

  if (exists) {
    // Ensure storage_path stored
    if (!row.storage_path) {
      await supabaseSvc
        .from("veo_highlights")
        .update({ storage_path: storagePath })
        .eq("highlight_id", highlightId);
    }
    const url = await signUrl();
    return new Response(JSON.stringify({ url }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  }

  // Otherwise: download remote asset and upload
  if (!row.video_url) {
    return new Response("No source video", { status: 422 });
  }

  try {
    const fetchResp = await fetch(row.video_url);
    if (!fetchResp.ok) {
      throw new Error(`download failed ${fetchResp.status}`);
    }
    const blob = await fetchResp.blob();
    const arrayBuffer = await blob.arrayBuffer();

    const { error: uploadErr } = await supabaseSvc.storage
      .from(bucket)
      .upload(storagePath, new Uint8Array(arrayBuffer), {
        contentType: "video/mp4",
        upsert: true,
      });
    if (uploadErr) {
      console.error("Upload error", uploadErr);
      return new Response("Upload failed", { status: 500 });
    }

    // Update row
    await supabaseSvc
      .from("veo_highlights")
      .update({ storage_path: storagePath })
      .eq("highlight_id", highlightId);

    const signed = await signUrl();
    return new Response(JSON.stringify({ url: signed }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (e) {
    console.error("sync video error", e);
    return new Response("Error syncing asset", { status: 500 });
  }
});