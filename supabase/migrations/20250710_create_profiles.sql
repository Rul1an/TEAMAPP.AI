-- 2025-07-10  Create profiles table with RLS + bucket policies
\set ON_ERROR_STOP on

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
