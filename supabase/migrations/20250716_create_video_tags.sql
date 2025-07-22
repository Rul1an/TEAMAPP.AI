-- Migration: create video_tags table, index, RLS & RPC insert_tag

-- Enable extensions
create extension if not exists "uuid-ossp";
create extension if not exists pg_trgm;

-- 1. Table
create table if not exists public.video_tags (
  id uuid primary key default uuid_generate_v4(),
  video_id uuid not null references public.videos(id) on delete cascade,
  timestamp int not null check (timestamp >= 0),
  label text not null,
  type text not null check (type in ('goal','assist','save','tactical','technique')),
  player_id uuid references public.players(id) on delete set null,
  description text,
  created_at timestamptz not null default now(),
  created_by uuid references auth.users(id)
);

comment on table public.video_tags is 'Tagging moments within videos';

-- 2. Indexes
create index if not exists idx_video_tags_video_ts on public.video_tags (video_id, timestamp);
create index if not exists gin_video_tags_label on public.video_tags using gin (label gin_trgm_ops);

-- 3. Row Level Security
alter table public.video_tags enable row level security;
-- allow owner access (assuming created_by = auth.uid())
create policy "Video tag owner can manage" on public.video_tags for all
  using (created_by = auth.uid())
  with check (created_by = auth.uid());

-- readers (team members)
create policy "Team members can read video tags" on public.video_tags for select
  using (exists (select 1 from public.memberships m where m.user_id = auth.uid() and m.team_id = (select team_id from public.videos v where v.id = video_id)));

-- 4. RPC: insert_tag(video_id, timestamp, label, type, player_id, description)
create or replace function public.insert_tag(
  p_video_id uuid,
  p_timestamp int,
  p_label text,
  p_type text,
  p_player_id uuid default null,
  p_description text default null
) returns public.video_tags as $$
declare
  v_tag public.video_tags;
begin
  insert into public.video_tags(video_id, timestamp, label, type, player_id, description, created_by)
    values (p_video_id, p_timestamp, p_label, p_type, p_player_id, p_description, auth.uid())
    returning * into v_tag;
  return v_tag;
end;
$$ language plpgsql security definer;

grant execute on function public.insert_tag(uuid,int,text,text,uuid,text) to anon, authenticated;

-- 5. GIN index for search on label & description
create index if not exists gin_video_tags_desc on public.video_tags using gin (description gin_trgm_ops);