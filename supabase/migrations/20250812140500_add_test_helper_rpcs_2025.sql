-- Test helper RPCs used by integration tests
-- These are created in public schema and can be restricted further if needed

-- set_claim: set a JWT claim for testing RLS behavior
create or replace function public.set_claim(claim text, value text)
returns void
language sql
security definer
set search_path = public
as $$
  select set_config('request.jwt.claim.' || claim, value, true);
$$;

grant execute on function public.set_claim(text, text) to anon, authenticated;

-- set_organization_context: convenience to set org_id claim
create or replace function public.set_organization_context(org_id uuid)
returns void
language sql
security definer
set search_path = public
as $$
  perform set_config('request.jwt.claim.organization_id', org_id::text, true);
$$;

grant execute on function public.set_organization_context(uuid) to anon, authenticated;

-- get_organization_stats: sample aggregate for tests
create or replace function public.get_organization_stats(organization_id uuid)
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select jsonb_build_object(
    'players', (select count(*) from public.players p where p.organization_id = get_organization_stats.organization_id),
    'trainings', (select count(*) from public.training_sessions t where t.organization_id = get_organization_stats.organization_id),
    'matches', (select count(*) from public.matches m where m.organization_id = get_organization_stats.organization_id)
  );
$$;

grant execute on function public.get_organization_stats(uuid) to anon, authenticated;
