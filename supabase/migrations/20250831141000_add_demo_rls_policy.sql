-- Add RLS policy to allow demo organization access without authentication
-- This enables the SaaS demo mode to work properly

-- Allow unauthenticated access for demo organization
CREATE POLICY IF NOT EXISTS "demo_organization_access" ON public.players
  FOR ALL
  USING (organization_id = '123e4567-e89b-12d3-a456-426614174000'::uuid)
  WITH CHECK (organization_id = '123e4567-e89b-12d3-a456-426614174000'::uuid);

-- Also apply to other tables for consistency
CREATE POLICY IF NOT EXISTS "demo_organization_access_matches" ON public.matches
  FOR ALL
  USING (organization_id = '123e4567-e89b-12d3-a456-426614174000'::uuid)
  WITH CHECK (organization_id = '123e4567-e89b-12d3-a456-426614174000'::uuid);

CREATE POLICY IF NOT EXISTS "demo_organization_access_trainings" ON public.training_sessions
  FOR ALL
  USING (organization_id = '123e4567-e89b-12d3-a456-426614174000'::uuid)
  WITH CHECK (organization_id = '123e4567-e89b-12d3-a456-426614174000'::uuid);

CREATE POLICY IF NOT EXISTS "demo_organization_access_teams" ON public.teams
  FOR ALL
  USING (organization_id = '123e4567-e89b-12d3-a456-426614174000'::uuid)
  WITH CHECK (organization_id = '123e4567-e89b-12d3-a456-426614174000'::uuid);