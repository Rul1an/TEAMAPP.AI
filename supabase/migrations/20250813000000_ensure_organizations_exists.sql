-- Ensure organizations table exists and aligns with app schema (idempotent)
create extension if not exists "pgcrypto";

create table if not exists public.organizations (
  id uuid primary key default gen_random_uuid(),
  name varchar(255) not null,
  slug varchar(255) unique,
  subscription_tier varchar(50) default 'basic',
  subscription_status varchar(50) default 'active',
  max_players int default 25,
  max_teams int default 1,
  max_coaches int default 3,
  settings jsonb default '{}'::jsonb,
  branding jsonb default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Backfill/align columns if table already existed with a different shape
do $$ begin
  if not exists (select 1 from information_schema.columns where table_schema='public' and table_name='organizations' and column_name='slug') then
    alter table public.organizations add column slug varchar(255);
  end if;
  if not exists (select 1 from information_schema.columns where table_schema='public' and table_name='organizations' and column_name='subscription_tier') then
    alter table public.organizations add column subscription_tier varchar(50) default 'basic';
  end if;
  if not exists (select 1 from information_schema.columns where table_schema='public' and table_name='organizations' and column_name='subscription_status') then
    alter table public.organizations add column subscription_status varchar(50) default 'active';
  end if;
  if not exists (select 1 from information_schema.columns where table_schema='public' and table_name='organizations' and column_name='max_players') then
    alter table public.organizations add column max_players int default 25;
  end if;
  if not exists (select 1 from information_schema.columns where table_schema='public' and table_name='organizations' and column_name='max_teams') then
    alter table public.organizations add column max_teams int default 1;
  end if;
  if not exists (select 1 from information_schema.columns where table_schema='public' and table_name='organizations' and column_name='max_coaches') then
    alter table public.organizations add column max_coaches int default 3;
  end if;
  if not exists (select 1 from information_schema.columns where table_schema='public' and table_name='organizations' and column_name='settings') then
    alter table public.organizations add column settings jsonb default '{}'::jsonb;
  end if;
  if not exists (select 1 from information_schema.columns where table_schema='public' and table_name='organizations' and column_name='branding') then
    alter table public.organizations add column branding jsonb default '{}'::jsonb;
  end if;
  if not exists (select 1 from information_schema.columns where table_schema='public' and table_name='organizations' and column_name='created_at') then
    alter table public.organizations add column created_at timestamptz not null default now();
  end if;
  if not exists (select 1 from information_schema.columns where table_schema='public' and table_name='organizations' and column_name='updated_at') then
    alter table public.organizations add column updated_at timestamptz not null default now();
  end if;
end $$;

-- Indexes
create index if not exists idx_organizations_slug on public.organizations(slug);
