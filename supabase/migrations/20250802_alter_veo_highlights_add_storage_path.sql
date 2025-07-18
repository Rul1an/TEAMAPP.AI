-- 2025-08-02  Add storage_path column to veo_highlights for local Storage object reference
\set ON_ERROR_STOP on

alter table if exists veo_highlights
  add column if not exists storage_path text;

-- No NOT NULL; will be populated lazily by ingest/sync edge functions.