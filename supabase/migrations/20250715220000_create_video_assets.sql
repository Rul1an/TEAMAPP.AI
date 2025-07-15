-- Up: create video_assets table for video processing metadata
create table if not exists public.video_assets (
  id uuid primary key default gen_random_uuid(),
  bucket text not null,
  path text not null unique,
  duration int4 not null default 0, -- seconds
  width int4 not null default 0,
  height int4 not null default 0,
  codec text,
  thumbnail1 text,
  thumbnail2 text,
  thumbnail3 text,
  created_at timestamptz not null default now()
);

create index if not exists video_assets_path_idx on public.video_assets (path);

-- Down
 drop table if exists public.video_assets;