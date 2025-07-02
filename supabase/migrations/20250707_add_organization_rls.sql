-- 2025-07-07  Add organization_id column + RLS policies
-- NOTE: Replace <PLACEHOLDER_ORG_UUID> with a real UUID for production back-fill.

\set ON_ERROR_STOP on

-- 1. Add column & back-fill for existing tables
alter table if exists players   add column if not exists organization_id uuid;
alter table if exists matches   add column if not exists organization_id uuid;
alter table if exists trainings add column if not exists organization_id uuid;
alter table if exists exercises add column if not exists organization_id uuid;
alter table if exists sessions  add column if not exists organization_id uuid;
alter table if exists statistics add column if not exists organization_id uuid;

-- Temporary back-fill so NOT NULL can be enforced later
update players      set organization_id = coalesce(organization_id, '<PLACEHOLDER_ORG_UUID>');
update matches      set organization_id = coalesce(organization_id, '<PLACEHOLDER_ORG_UUID>');
update trainings    set organization_id = coalesce(organization_id, '<PLACEHOLDER_ORG_UUID>');
update exercises    set organization_id = coalesce(organization_id, '<PLACEHOLDER_ORG_UUID>');
update sessions     set organization_id = coalesce(organization_id, '<PLACEHOLDER_ORG_UUID>');
update statistics   set organization_id = coalesce(organization_id, '<PLACEHOLDER_ORG_UUID>');

-- Enforce NOT NULL (can be relaxed if needed)
alter table players      alter column organization_id set not null;
alter table matches      alter column organization_id set not null;
alter table trainings    alter column organization_id set not null;
alter table exercises    alter column organization_id set not null;
alter table sessions     alter column organization_id set not null;
alter table statistics   alter column organization_id set not null;

-- 2. Indexes for performance
create index if not exists players_org_idx      on players(organization_id, id);
create index if not exists matches_org_idx      on matches(organization_id, id);
create index if not exists trainings_org_idx    on trainings(organization_id, id);
create index if not exists exercises_org_idx    on exercises(organization_id, id);
create index if not exists sessions_org_idx     on sessions(organization_id, id);
create index if not exists statistics_org_idx   on statistics(organization_id, id);

-- 3. Enable RLS & policies
alter table players      enable row level security;
alter table matches      enable row level security;
alter table trainings    enable row level security;
alter table exercises    enable row level security;
alter table sessions     enable row level security;
alter table statistics   enable row level security;

-- Utility function to fetch org claim (if not already provided by Supabase)
create or replace function current_org_id() returns uuid as $$
  select current_setting('request.jwt.claim.org_id', true)::uuid;
$$ language sql stable;

-- Policy helper macro
create or replace function create_rls_policy(table_name text) returns void language plpgsql as $$
begin
  execute format('create policy "%I_isolated" on %I for all using (organization_id = current_org_id()) with check (organization_id = current_org_id());', table_name, table_name) ;
end;
$$;

select create_rls_policy('players');
select create_rls_policy('matches');
select create_rls_policy('trainings');
select create_rls_policy('exercises');
select create_rls_policy('sessions');
select create_rls_policy('statistics');

-- Done
