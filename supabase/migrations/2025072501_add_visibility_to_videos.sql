-- Add visibility & allowed_roles columns to videos (Sprint 2)
alter table public.videos
  add column if not exists visibility text default 'org' check (visibility in ('private','org','public_highlight')),
  add column if not exists allowed_roles text[];

-- Default existing rows to org visibility
update public.videos set visibility = 'org' where visibility is null;

-- Update RLS: allow select public highlights without auth
create policy if not exists "video_public_highlights" on public.videos
  for select using (visibility = 'public_highlight');