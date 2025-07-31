-- 2025-08-01  Create table to store Veo highlights fetched via Edge Functions
-- RLS isolates data per organization.

create table if not exists veo_highlights (
  highlight_id text primary key,
  match_id text not null,
  organization_id uuid not null,
  title text,
  start_ms integer not null,
  end_ms integer not null,
  video_url text,
  ingested_at timestamptz not null default now()
);

-- Index to speed up match queries per org
create index if not exists veo_highlights_match_idx on veo_highlights(organization_id, match_id);

-- Enable RLS
alter table veo_highlights enable row level security;

-- Policy: tenant isolation using current_org_id() helper function.
create policy "veo_highlights_isolated" on veo_highlights
for all
using (organization_id = current_org_id())
with check (organization_id = current_org_id());
