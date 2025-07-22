import { serve } from "https://deno.land/x/supabase_functions@v1.0.3/mod.ts";
import { getVeoAccessToken } from "./_shared/veo_client.ts";
import { tracer } from "./_shared/tracing.ts";

// Scheduled Edge Function (every 5 min via Supabase schedule)
// Purpose: pre-fetch & cache Veo OAuth2 token to avoid cold latency.
// No payload, returns 204.

serve(async () => {
  return await tracer.startActiveSpan("veo_pre_warm_token", async (span) => {
    try {
      await getVeoAccessToken();
      span.end();
      return new Response(null, { status: 204 });
    } catch (e) {
      span.recordException(e as Error);
      span.end();
      return new Response("fail", { status: 500 });
    }
  });
});