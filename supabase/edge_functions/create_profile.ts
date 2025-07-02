import { serve } from "https://deno.land/x/supabase_functions@v1.0.3/mod.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// Edge Function: Runs on `auth.user_created` webhook to bootstrap profile.
// Requires env vars SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY.
serve(async (req) => {
    const payload = await req.json();
    const user = payload.record;

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabase = createClient(supabaseUrl, serviceRoleKey, {
        auth: { persistSession: false },
    });

    // Extract organization_id from user metadata if present; otherwise use first
    // organization membership (can be NULL until onboarding completes).
    const orgId = user.user_metadata?.organization_id ?? null;

    await supabase.from("profiles").insert({
        user_id: user.id,
        organization_id: orgId,
        username: user.email?.split("@")[0] ?? null,
        avatar_url: null,
        website: null,
    });

    return new Response("OK", { status: 200 });
});
