-- Migration: create videos table & policies (2025-07-15)
-- NOTE: Run via `supabase db push` in dev/staging.

create table if not exists public.videos (
  id uuid primary key default gen_random_uuid(),
  org_id uuid not null references public.organisations(id) on delete cascade,
  title text not null,
  description text,
  type text check (type in ('match','training','highlight','tutorial')),
  uploaded_by uuid not null references auth.users(id),
  uploaded_at timestamptz default now(),
  video_url text not null,
  thumbnail_url text,
  file_size bigint not null,
  duration integer not null,
  status text check (status in ('uploading','ready','failed','transcoding')) default 'uploading',
  metadata jsonb,
  match_id uuid references public.matches(id) on delete set null,
  training_id uuid references public.trainings(id) on delete set null
);

alter table public.videos enable row level security;

-- Tenant isolation & ownership
create policy "org_isolation_videos" on public.videos
  for all using (org_id = auth.jwt()->>'org_id')
  with check (org_id = auth.jwt()->>'org_id');

-- Allow the uploader to update status/metadata
create policy "video_uploader_update" on public.videos
  for update using (uploaded_by = auth.uid());

-- Read-only access for members of same org (coach, player, etc.)
create policy "video_select_same_org" on public.videos
  for select using (org_id = auth.jwt()->>'org_id');

-- Indexes for performance
create index if not exists idx_videos_org_id on public.videos (org_id);
create index if not exists idx_videos_uploaded_at on public.videos (uploaded_at desc);