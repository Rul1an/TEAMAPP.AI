-- Minimal core tables foundation (idempotent)
-- Creates only the essential tables if missing. Avoids duplicating existing schema.

create table if not exists public.organizations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text unique,
  subscription_tier text default 'basic',
  subscription_status text default 'active',
  settings jsonb default '{}'::jsonb,
  branding jsonb default '{}'::jsonb,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.organization_members (
  organization_id uuid not null references public.organizations(id) on delete cascade,
  user_id uuid not null,
  role text default 'member',
  primary key (organization_id, user_id)
);

create table if not exists public.players (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  first_name text,
  last_name text,
  jersey_number int default 0,
  birth_date date,
  position text,
  preferred_foot text,
  height_cm double precision default 0,
  weight_kg double precision default 0,
  phone text,
  email text,
  parent_contact text,
  matches_played int default 0,
  matches_in_selection int default 0,
  minutes_played int default 0,
  goals int default 0,
  assists int default 0,
  yellow_cards int default 0,
  red_cards int default 0,
  trainings_attended int default 0,
  trainings_total int default 0,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.training_sessions (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  team_id text,
  date timestamptz,
  training_number int,
  type text,
  phases jsonb default '[]'::jsonb,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.matches (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  opponent text,
  date timestamptz,
  location text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.videos (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  title text,
  description text,
  player_id uuid,
  file_url text,
  video_url text,
  thumbnail_url text,
  duration_seconds int default 0,
  file_size_bytes bigint default 0,
  resolution_width int default 0,
  resolution_height int default 0,
  encoding_format text default 'mp4',
  processing_status text default 'ready',
  processing_error text,
  video_metadata jsonb default '{}'::jsonb,
  tag_data jsonb default '[]'::jsonb,
  created_by uuid,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.video_tags (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  video_id uuid not null references public.videos(id) on delete cascade,
  player_id uuid,
  type text,
  timestamp_seconds int,
  title text,
  description text,
  tag_data jsonb default '{}'::jsonb,
  created_by uuid,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
