-- Add demo organization for SaaS demo mode
-- This allows the demo UUID to work properly with RLS policies

INSERT INTO public.organizations (
  id,
  name,
  slug,
  subscription_tier,
  subscription_status,
  max_players,
  max_teams,
  max_coaches
) 
VALUES (
  '123e4567-e89b-12d3-a456-426614174000'::uuid,
  'VOAB JO17 Demo',
  'voab-jo17-demo',
  'pro',
  'active',
  50,
  3,
  10
)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  slug = EXCLUDED.slug,
  subscription_tier = EXCLUDED.subscription_tier,
  subscription_status = EXCLUDED.subscription_status,
  max_players = EXCLUDED.max_players,
  max_teams = EXCLUDED.max_teams,
  max_coaches = EXCLUDED.max_coaches;

-- Create a default team for the demo organization
INSERT INTO public.teams (
  id,
  organization_id,
  name,
  category,
  season
)
VALUES (
  'demo-team-123e4567-e89b-12d3-a456-426614174001'::uuid,
  '123e4567-e89b-12d3-a456-426614174000'::uuid,
  'JO17-1',
  'JO17',
  '2025-2026'
)
ON CONFLICT (id) DO UPDATE SET
  organization_id = EXCLUDED.organization_id,
  name = EXCLUDED.name,
  category = EXCLUDED.category,
  season = EXCLUDED.season;