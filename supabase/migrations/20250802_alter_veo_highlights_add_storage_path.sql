-- ON_ERROR_STOP is not supported by supabase db push runner; remove meta commands
-- 2025-08-02  Add storage_path column to veo_highlights for local Storage object reference

alter table if exists veo_highlights
  add column if not exists storage_path text;

-- No NOT NULL; will be populated lazily by ingest/sync edge functions.
