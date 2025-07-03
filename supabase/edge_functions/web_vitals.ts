import { serve } from "https://deno.land/x/supabase_functions@v1.0.3/mod.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// Edge Function: Collects web-vitals RUM beacons from the Flutter web app.
// Expected JSON payload:
// {
//   "name": "LCP",      // Metric name (CLS, FID, LCP, INP)
//   "value": 1234.56,    // Metric value (ms for latency, unitless for CLS)
//   "id": "v3-123...",  // Unique metric id from web-vitals lib
//   "url": "https://app.example.com/#/dashboard", // (optional) page url
//   "ts": 1693501923123   // Unix epoch millis timestamp
// }
serve(async (req) => {
    if (req.method !== "POST") {
        return new Response("Method Not Allowed", { status: 405 });
    }

    let payload: Record<string, unknown>;
    try {
        payload = await req.json();
    } catch (_e) {
        return new Response("Bad Request", { status: 400 });
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    if (!supabaseUrl || !serviceRoleKey) {
        return new Response("Missing env vars", { status: 500 });
    }

    const supabase = createClient(supabaseUrl, serviceRoleKey, {
        auth: { persistSession: false },
    });

    const row = {
        metric: (payload.name as string) ?? null,
        value: (payload.value as number) ?? null,
        metric_id: (payload.id as string) ?? null,
        url: (payload.url as string) ?? null,
        captured_at: new Date(
            typeof payload.ts === "number" ? (payload.ts as number) : Date.now(),
        ).toISOString(),
    };

    const { error } = await supabase.from("web_vitals").insert(row);
    if (error) {
        console.error("web_vitals insert error", error);
        return new Response("DB Error", { status: 500 });
    }

    return new Response("OK", { status: 200 });
});
