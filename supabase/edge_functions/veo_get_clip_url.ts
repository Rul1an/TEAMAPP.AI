import { serve } from "https://deno.land/x/supabase_functions@v1.0.3/mod.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { tracer } from "./_shared/tracing.ts";
import { SpanStatusCode } from "npm:@opentelemetry/api@1";

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

const handler = async (req: Request) => {
  return await tracer.startActiveSpan("veo_get_clip_url", async (span) => {
    if (req.method !== "POST") {
      span.setStatus({ code: SpanStatusCode.ERROR, message: "405" });
      span.end();
      return new Response("Method Not Allowed", { status: 405 });
    }

    let body: Req;
    try {
      body = await req.json();
    } catch (_e) {
      span.setStatus({ code: SpanStatusCode.ERROR, message: "Invalid JSON" });
      span.end();
      return new Response("Invalid JSON", { status: 400 });
    }

    const highlightId = body.highlightId;
    if (!highlightId) {
      span.setStatus({ code: SpanStatusCode.ERROR, message: "Missing highlightId" });
      span.end();
      return new Response("highlightId required", { status: 400 });
    }

    span.setAttribute("highlightId", highlightId);

    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const anonKey = Deno.env.get("SUPABASE_ANON_KEY");
    const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    if (!supabaseUrl || !serviceKey || !anonKey) {
      span.setStatus({ code: SpanStatusCode.ERROR, message: "Missing Supabase env vars" });
      span.end();
      return new Response("Missing Supabase env vars", { status: 500 });
    }

    const supabaseSvc = createClient(supabaseUrl, serviceKey, {
      auth: { persistSession: false },
    });

    const { data: row, error } = await supabaseSvc
      .from("veo_highlights")
      .select("highlight_id, match_id, organization_id, storage_path, video_url")
      .eq("highlight_id", highlightId)
      .single();

    if (error || !row) {
      span.setStatus({ code: SpanStatusCode.ERROR, message: "Not found" });
      span.recordException(error ?? new Error("row null"));
      span.end();
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
        .createSignedUrl(storagePath, 60 * 60);

      if (signErr || !data) {
        span.setStatus({ code: SpanStatusCode.ERROR, message: "SignedUrl error" });
        span.recordException(signErr ?? new Error("signed url data null"));
        throw new Error("Cannot create signed URL");
      }
      return data.signedUrl;
    }

    const headRes = await supabaseSvc.storage.from(bucket).list(storagePath, { limit: 1 });
    const exists = headRes.data?.length === 1;

    if (exists) {
      if (!row.storage_path) {
        await supabaseSvc
          .from("veo_highlights")
          .update({ storage_path: storagePath })
          .eq("highlight_id", highlightId);
      }
      const url = await signUrl();
      span.end();
      return new Response(JSON.stringify({ url }), {
        status: 200,
        headers: { "Content-Type": "application/json" },
      });
    }

    if (!row.video_url) {
      span.setStatus({ code: SpanStatusCode.ERROR, message: "No source video" });
      span.end();
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
        span.setStatus({ code: SpanStatusCode.ERROR, message: "Upload failed" });
        span.recordException(uploadErr);
        span.end();
        console.error("Upload error", uploadErr);
        return new Response("Upload failed", { status: 500 });
      }

      await supabaseSvc
        .from("veo_highlights")
        .update({ storage_path: storagePath })
        .eq("highlight_id", highlightId);

      const signed = await signUrl();
      span.end();
      return new Response(JSON.stringify({ url: signed }), {
        status: 200,
        headers: { "Content-Type": "application/json" },
      });
    } catch (e) {
      span.setStatus({ code: SpanStatusCode.ERROR, message: String(e) });
      span.recordException(e as Error);
      span.end();
      console.error("sync video error", e);
      return new Response("Error syncing asset", { status: 500 });
    }
  });

};

serve(handler);

export { handler };