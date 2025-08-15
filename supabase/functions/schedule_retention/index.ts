// Supabase Edge Function (Deno) - Scheduled Retention Purge (2025)
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { purgeExpiredData } from "../_shared/retention.ts";

serve(async (req) => {
    const url = new URL(req.url);
    const dry = url.searchParams.get("dry_run") !== "false"; // default true

    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const supabaseServiceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

    if (!supabaseUrl || !supabaseServiceRoleKey) {
        return new Response(JSON.stringify({ ok: false, error: "Missing env" }), {
            headers: { "content-type": "application/json" },
            status: 500,
        });
    }

    const supabase = createClient(supabaseUrl, supabaseServiceRoleKey, {
        auth: { persistSession: false },
    });

    try {
        const result = await purgeExpiredData(supabase, dry);
        return new Response(JSON.stringify(result), {
            headers: { "content-type": "application/json" },
        });
    } catch (e) {
        return new Response(JSON.stringify({ ok: false, error: String(e) }), {
            headers: { "content-type": "application/json" },
            status: 500,
        });
    }
});


