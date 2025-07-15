import { serve } from "https://deno.land/std@0.202.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.5";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY, {
  auth: { persistSession: false },
});

serve(async () => {
  try {
    const cutoff = Date.now() - 1000 * 60 * 60 * 48; // 48 h

    // Fetch tmp objects under videos/tmp/
    const { data: objects, error } = await supabase.storage
      .from("videos")
      .list("tmp", { limit: 1000 });
    if (error) throw error;

    const toDelete = objects
      .filter((o) => new Date(o.created_at).getTime() < cutoff)
      .map((o) => `tmp/${o.name}`);

    if (toDelete.length) {
      await supabase.storage.from("videos").remove(toDelete);
      console.log(`Cleaned ${toDelete.length} tmp files`);
    }

    return new Response(JSON.stringify({ removed: toDelete.length }), {
      status: 200,
    });
  } catch (err) {
    console.error(err);
    return new Response(JSON.stringify({ error: `${err}` }), { status: 500 });
  }
});