-- Create/get_user_organization_id RPC for multi-tenant filtering
-- Ensures PostgREST RPC endpoint /rest/v1/rpc/get_user_organization_id exists
-- and is callable by anon/authenticated (depending on your flow).

create or replace function public.get_user_organization_id()
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select organization_id
  from public.organization_members
  where user_id = auth.uid()
  limit 1;
$$;

-- Grant execute to roles used by your app
grant execute on function public.get_user_organization_id() to anon, authenticated;
