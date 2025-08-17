-- Ensure trainings view runs with INVOKER security and proper privileges
-- Context: Avoid SECURITY DEFINER behavior that could bypass RLS
-- Date: 2025-08-17

begin;

-- Verify the view exists
do $$
begin
  if not exists (
    select 1 from information_schema.views
    where table_schema = 'public' and table_name = 'trainings'
  ) then
    raise exception 'View public.trainings does not exist';
  end if;
end $$;

-- Enforce invoker security (respects RLS of the querying user)
alter view public.trainings set (security_invoker = true);

-- Tighten permissions: no default PUBLIC access; only authenticated may SELECT
revoke all on public.trainings from public;
grant select on public.trainings to authenticated;

commit;

-- Optional verification (manual):
-- select table_schema, table_name, security_type
-- from information_schema.views
-- where table_schema='public' and table_name='trainings';


