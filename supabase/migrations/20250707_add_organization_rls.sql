\set ON_ERROR_STOP on
-- 2025-07-07  Add organization_id column + RLS policies
-- NOTE: Replace <PLACEHOLDER_ORG_UUID> with a real UUID for production back-fill.

-- 1. Add column & back-fill for existing tables
alter table if exists players   add column if not exists organization_id uuid;
alter table if exists matches   add column if not exists organization_id uuid;
-- Skip trainings - it's a view, not a table (handled by training_sessions)
-- alter table if exists trainings add column if not exists organization_id uuid;
alter table if exists exercises add column if not exists organization_id uuid;
alter table if exists sessions  add column if not exists organization_id uuid;
alter table if exists statistics add column if not exists organization_id uuid;

-- Temporary back-fill so NOT NULL can be enforced later

do $$
begin
  if exists (select 1 from information_schema.tables where table_name = 'players') then
    update players set organization_id = coalesce(organization_id, '00000000-0000-0000-0000-000000000000');
  end if;
  if exists (select 1 from information_schema.tables where table_name = 'matches') then
    update matches set organization_id = coalesce(organization_id, '00000000-0000-0000-0000-000000000000');
  end if;
  -- Skip trainings - it's a view, not a table (handled by training_sessions)
  -- if exists (select 1 from information_schema.tables where table_name = 'trainings') then
  --   update trainings set organization_id = coalesce(organization_id, '00000000-0000-0000-0000-000000000000');
  -- end if;
  if exists (select 1 from information_schema.tables where table_name = 'exercises') then
    update exercises set organization_id = coalesce(organization_id, '00000000-0000-0000-0000-000000000000');
  end if;
  if exists (select 1 from information_schema.tables where table_name = 'sessions') then
    update sessions set organization_id = coalesce(organization_id, '00000000-0000-0000-0000-000000000000');
  end if;
  if exists (select 1 from information_schema.tables where table_name = 'statistics') then
    update statistics set organization_id = coalesce(organization_id, '00000000-0000-0000-0000-000000000000');
  end if;
end$$;

-- Enforce NOT NULL (can be relaxed if needed)
alter table if exists players      alter column organization_id set not null;
alter table if exists matches      alter column organization_id set not null;
-- Skip trainings - it's a view, not a table (handled by training_sessions)
-- alter table if exists trainings    alter column organization_id set not null;
alter table if exists exercises    alter column organization_id set not null;
alter table if exists sessions     alter column organization_id set not null;
alter table if exists statistics   alter column organization_id set not null;

-- 2. Indexes for performance
do $$
begin
  -- 2. Indexes for performance (only if table exists)
  if exists (select 1 from information_schema.tables where table_name = 'players') then
    execute 'create index if not exists players_org_idx on players(organization_id, id)';
  end if;
  if exists (select 1 from information_schema.tables where table_name = 'matches') then
    execute 'create index if not exists matches_org_idx on matches(organization_id, id)';
  end if;
  -- Skip trainings - it's a view, not a table (handled by training_sessions)
  -- trainings is a view - cannot create indexes on views
  -- if exists (select 1 from information_schema.tables where table_name = 'trainings') then
  --   execute 'create index if not exists trainings_org_idx on trainings(organization_id, id)';
  -- end if;
  if exists (select 1 from information_schema.tables where table_name = 'exercises') then
    execute 'create index if not exists exercises_org_idx on exercises(organization_id, id)';
  end if;
  if exists (select 1 from information_schema.tables where table_name = 'sessions') then
    execute 'create index if not exists sessions_org_idx on sessions(organization_id, id)';
  end if;
  if exists (select 1 from information_schema.tables where table_name = 'statistics') then
    execute 'create index if not exists statistics_org_idx on statistics(organization_id, id)';
  end if;

  -- 3. Enable RLS & create policies only if table exists
  if exists (select 1 from information_schema.tables where table_name = 'players') then
    execute 'alter table players enable row level security';
  end if;
  if exists (select 1 from information_schema.tables where table_name = 'matches') then
    execute 'alter table matches enable row level security';
  end if;
  -- Skip trainings - it's a view, cannot enable RLS on views
  -- if exists (select 1 from information_schema.tables where table_name = 'trainings') then
  --   execute 'alter table trainings enable row level security';
  -- end if;
  if exists (select 1 from information_schema.tables where table_name = 'exercises') then
    execute 'alter table exercises enable row level security';
  end if;
  if exists (select 1 from information_schema.tables where table_name = 'sessions') then
    execute 'alter table sessions enable row level security';
  end if;
  if exists (select 1 from information_schema.tables where table_name = 'statistics') then
    execute 'alter table statistics enable row level security';
  end if;

  -- Utility function to fetch org claim (if not already created)
  execute 'create or replace function current_org_id() returns uuid as $func$ select current_setting(''request.jwt.claim.org_id'', true)::uuid; $func$ language sql stable';

  -- Policy helper macro (creates isolated policy for any table)
  execute 'create or replace function create_rls_policy(table_name text) returns void language plpgsql as $pl$ begin execute format(''create policy "%I_isolated" on %I for all using (organization_id = current_org_id()) with check (organization_id = current_org_id());'', table_name, table_name); end; $pl$';

  if exists (select 1 from information_schema.tables where table_name = 'players') then
    perform create_rls_policy('players');
  end if;
  if exists (select 1 from information_schema.tables where table_name = 'matches') then
    perform create_rls_policy('matches');
  end if;
  -- Skip trainings - it's a view, cannot create RLS policies on views
  -- if exists (select 1 from information_schema.tables where table_name = 'trainings') then
  --   perform create_rls_policy('trainings');
  -- end if;
  if exists (select 1 from information_schema.tables where table_name = 'exercises') then
    perform create_rls_policy('exercises');
  end if;
  if exists (select 1 from information_schema.tables where table_name = 'sessions') then
    perform create_rls_policy('sessions');
  end if;
  if exists (select 1 from information_schema.tables where table_name = 'statistics') then
    perform create_rls_policy('statistics');
  end if;
end$$;

-- Done
