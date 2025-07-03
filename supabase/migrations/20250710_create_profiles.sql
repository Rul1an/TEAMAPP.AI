-- 2025-07-10  Create profiles table with RLS + bucket policies
\set ON_ERROR_STOP on

-- 0. Ensure auth schema & users table for CI/local (noop on Supabase)
create schema if not exists auth;
create table if not exists auth.users (
  id uuid primary key
);

-- 1. Table creation
create table if not exists profiles (
  user_id uuid primary key references auth.users (id) on delete cascade,
  organization_id uuid not null,
  username text unique,
  avatar_url text,
  website text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Composite index for tenant queries
create index if not exists profiles_org_idx on profiles(organization_id, user_id);

-- 1b. Mock auth.uid() for local/CI Postgres (Supabase provides this in prod)
do $$
begin
  if not exists (
    select 1 from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where p.proname = 'uid' and n.nspname = 'auth'
  ) then
    execute 'create function auth.uid() returns uuid as $$ select ''00000000-0000-0000-0000-000000000000''::uuid; $$ language sql stable';
  end if;
exception when others then
  -- ignore if cannot create (e.g., permissions) – CI only
end$$;

-- 2. Enable RLS
alter table profiles enable row level security;

-- 3. Policy: users can view/update only their own profile within org
create policy "profiles_isolated" on profiles
for all
using (
  organization_id = current_org_id() and user_id = auth.uid()
) with check (
  organization_id = current_org_id() and user_id = auth.uid()
);

-- 4. Storage bucket for avatars
-- Create bucket if not exists via Supabase Storage API (cannot via SQL); ensure policy placeholder below.
-- Policy (run in storage settings):
-- insert, select, update: (auth.uid() = owner) and org_id match.

-- 5. Grant privileges (optional; Supabase handles via policies)
