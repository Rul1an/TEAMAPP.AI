-- Retention policies and purge functions (2025)
-- Creates a generic retention policy table and purge routines with dry-run support.

create table if not exists public.retention_policies (
  entity text primary key,
  table_name text not null,
  timestamp_column text not null,
  tenant_scoped boolean not null default true,
  tenant_column text not null default 'organization_id',
  ttl_days integer not null check (ttl_days > 0),
  enabled boolean not null default true
);

comment on table public.retention_policies is 'Configures data retention per entity/table. Purge functions read from here.';

-- Helper: check if table exists
create or replace function public.__table_exists(tbl text)
returns boolean
language sql
stable
as $$
  select to_regclass(tbl) is not null;
$$;

-- Purge function (all tenants), with dry-run support
create or replace function public.purge_expired_data(dry_run boolean default true)
returns jsonb
language plpgsql
security definer
as $$
declare
  pol record;
  affected bigint;
  results jsonb := '[]'::jsonb;
  cutoff timestamp with time zone;
  del_sql text;
  count_sql text;
begin
  for pol in select * from public.retention_policies where enabled loop
    if not public.__table_exists(pol.table_name) then
      continue;
    end if;
    cutoff := now() - (pol.ttl_days || ' days')::interval;

    if dry_run then
      count_sql := format('select count(*) from %I where %I < $1', pol.table_name, pol.timestamp_column);
      execute count_sql using cutoff into affected;
    else
      del_sql := format('delete from %I where %I < $1', pol.table_name, pol.timestamp_column);
      execute del_sql using cutoff;
      get diagnostics affected = row_count;
    end if;

    results := results || jsonb_build_array(jsonb_build_object(
      'entity', pol.entity,
      'table', pol.table_name,
      'ttl_days', pol.ttl_days,
      'dry_run', dry_run,
      'affected', affected
    ));
  end loop;

  return jsonb_build_object('ok', true, 'items', results);
end;
$$;

revoke all on function public.purge_expired_data(boolean) from public;
grant execute on function public.purge_expired_data(boolean) to anon, authenticated, service_role;

-- Optional seed policies (adjust as needed). Only include safe log-like tables here.
-- insert into public.retention_policies(entity, table_name, timestamp_column, tenant_scoped, ttl_days) values
--   ('analytics_events', 'analytics_events', 'created_at', true, 30)
-- on conflict (entity) do nothing;


