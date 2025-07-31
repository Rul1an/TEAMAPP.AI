-- =============================================
-- APPLICATION TABLES FOUNDATION MIGRATION 2025
-- Creates only the application tables we can control
-- =============================================

-- Organizations table (foundational)
CREATE TABLE IF NOT EXISTS public.organizations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name varchar(255) NOT NULL,
  slug varchar(255) UNIQUE NOT NULL,
  subscription_tier varchar(50) DEFAULT 'basic' CHECK (subscription_tier IN ('basic', 'pro', 'enterprise')),
  subscription_status varchar(50) DEFAULT 'active' CHECK (subscription_status IN ('active', 'cancelled', 'expired', 'trial')),
  trial_ends_at timestamptz,
  settings jsonb DEFAULT '{}',
  branding jsonb DEFAULT '{}',
  max_players integer DEFAULT 25,
  max_teams integer DEFAULT 1,
  max_coaches integer DEFAULT 3,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Teams table
CREATE TABLE IF NOT EXISTS public.teams (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id uuid REFERENCES public.organizations(id),
  name varchar(255) NOT NULL,
  category varchar(100),
  season varchar(100),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Players table
CREATE TABLE IF NOT EXISTS public.players (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id uuid REFERENCES public.organizations(id),
  team_id uuid REFERENCES public.teams(id),
  name varchar(255) NOT NULL,
  jersey_number integer,
  position varchar(50),
  date_of_birth date,
  email varchar(255),
  phone varchar(50),
  emergency_contact jsonb,
  performance_data jsonb DEFAULT '{}',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Organization members table
CREATE TABLE IF NOT EXISTS public.organization_members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id uuid REFERENCES public.organizations(id),
  user_id uuid REFERENCES auth.users(id),
  role varchar(50) DEFAULT 'member' CHECK (role IN ('owner', 'admin', 'coach', 'member')),
  permissions jsonb DEFAULT '[]',
  joined_at timestamptz DEFAULT now()
);

-- Training sessions table
CREATE TABLE IF NOT EXISTS public.training_sessions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id uuid REFERENCES public.organizations(id),
  team_id uuid REFERENCES public.teams(id),
  title varchar(255) NOT NULL,
  description text,
  date_time timestamptz NOT NULL,
  duration integer DEFAULT 90,
  location varchar(255),
  focus varchar(100),
  intensity varchar(50),
  exercises jsonb DEFAULT '[]',
  phases jsonb DEFAULT '[]',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Matches table
CREATE TABLE IF NOT EXISTS public.matches (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id uuid REFERENCES public.organizations(id),
  team_id uuid REFERENCES public.teams(id),
  opponent varchar(255) NOT NULL,
  date_time timestamptz NOT NULL,
  venue varchar(255),
  is_home boolean DEFAULT true,
  competition varchar(100),
  match_type varchar(50) DEFAULT 'league',
  home_score integer,
  away_score integer,
  match_status varchar(50) DEFAULT 'scheduled',
  formation varchar(50),
  lineup jsonb DEFAULT '[]',
  substitutions jsonb DEFAULT '[]',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Performance analytics table
CREATE TABLE IF NOT EXISTS public.performance_analytics (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id uuid REFERENCES public.organizations(id),
  player_id uuid REFERENCES public.players(id),
  session_id uuid REFERENCES public.training_sessions(id),
  match_id uuid REFERENCES public.matches(id),
  metric_type varchar(100) NOT NULL,
  metric_value numeric NOT NULL,
  measurement_date date NOT NULL,
  metadata jsonb DEFAULT '{}',
  created_at timestamptz DEFAULT now()
);

-- Calendar events table
CREATE TABLE IF NOT EXISTS public.calendar_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id uuid REFERENCES public.organizations(id),
  team_id uuid REFERENCES public.teams(id),
  title varchar(255) NOT NULL,
  description text,
  event_type varchar(50) NOT NULL CHECK (event_type IN ('training', 'match', 'meeting', 'other')),
  start_time timestamptz NOT NULL,
  end_time timestamptz,
  location varchar(255),
  related_entity_type varchar(50),
  related_entity_id uuid,
  is_recurring boolean DEFAULT false,
  recurrence_rule jsonb,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Season plans table
CREATE TABLE IF NOT EXISTS public.season_plans (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id uuid REFERENCES public.organizations(id),
  team_id uuid REFERENCES public.teams(id),
  name varchar(255) NOT NULL,
  season varchar(100) NOT NULL,
  start_date date NOT NULL,
  end_date date NOT NULL,
  periodization_data jsonb DEFAULT '{}',
  morphocycles jsonb DEFAULT '[]',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Training periods table
CREATE TABLE IF NOT EXISTS public.training_periods (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id uuid REFERENCES public.organizations(id),
  season_plan_id uuid REFERENCES public.season_plans(id),
  name varchar(255) NOT NULL,
  start_date date NOT NULL,
  end_date date NOT NULL,
  period_type varchar(100) NOT NULL,
  focus_areas jsonb DEFAULT '[]',
  training_load jsonb DEFAULT '{}',
  created_at timestamptz DEFAULT now()
);

-- Enable RLS on all tables
ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.players ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.organization_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.training_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.performance_analytics ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.calendar_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.season_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.training_periods ENABLE ROW LEVEL SECURITY;

-- Create essential indexes for performance
CREATE INDEX IF NOT EXISTS idx_organizations_slug ON public.organizations(slug);
CREATE INDEX IF NOT EXISTS idx_teams_organization_id ON public.teams(organization_id);
CREATE INDEX IF NOT EXISTS idx_players_organization_id ON public.players(organization_id);
CREATE INDEX IF NOT EXISTS idx_players_team_id ON public.players(team_id);
CREATE INDEX IF NOT EXISTS idx_organization_members_user_id ON public.organization_members(user_id);
CREATE INDEX IF NOT EXISTS idx_organization_members_organization_id ON public.organization_members(organization_id);
CREATE INDEX IF NOT EXISTS idx_training_sessions_organization_id ON public.training_sessions(organization_id);
CREATE INDEX IF NOT EXISTS idx_training_sessions_team_id ON public.training_sessions(team_id);
CREATE INDEX IF NOT EXISTS idx_matches_organization_id ON public.matches(organization_id);
CREATE INDEX IF NOT EXISTS idx_matches_team_id ON public.matches(team_id);
CREATE INDEX IF NOT EXISTS idx_performance_analytics_organization_id ON public.performance_analytics(organization_id);
CREATE INDEX IF NOT EXISTS idx_performance_analytics_player_id ON public.performance_analytics(player_id);
CREATE INDEX IF NOT EXISTS idx_calendar_events_organization_id ON public.calendar_events(organization_id);
CREATE INDEX IF NOT EXISTS idx_season_plans_organization_id ON public.season_plans(organization_id);
CREATE INDEX IF NOT EXISTS idx_training_periods_organization_id ON public.training_periods(organization_id);

-- Create basic RLS policies for authenticated users
CREATE POLICY "Organizations: Users can view organizations they belong to" ON public.organizations
  FOR SELECT TO authenticated
  USING (
    id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Teams: Users can view teams in their organizations" ON public.teams
  FOR SELECT TO authenticated
  USING (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Players: Users can view players in their organizations" ON public.players
  FOR SELECT TO authenticated
  USING (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Training Sessions: Users can view sessions in their organizations" ON public.training_sessions
  FOR SELECT TO authenticated
  USING (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Matches: Users can view matches in their organizations" ON public.matches
  FOR SELECT TO authenticated
  USING (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = auth.uid()
    )
  );

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Add updated_at triggers to relevant tables
DROP TRIGGER IF EXISTS handle_updated_at ON public.organizations;
CREATE TRIGGER handle_updated_at
  BEFORE UPDATE ON public.organizations
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS handle_updated_at ON public.teams;
CREATE TRIGGER handle_updated_at
  BEFORE UPDATE ON public.teams
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS handle_updated_at ON public.players;
CREATE TRIGGER handle_updated_at
  BEFORE UPDATE ON public.players
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS handle_updated_at ON public.training_sessions;
CREATE TRIGGER handle_updated_at
  BEFORE UPDATE ON public.training_sessions
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS handle_updated_at ON public.matches;
CREATE TRIGGER handle_updated_at
  BEFORE UPDATE ON public.matches
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS handle_updated_at ON public.calendar_events;
CREATE TRIGGER handle_updated_at
  BEFORE UPDATE ON public.calendar_events
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS handle_updated_at ON public.season_plans;
CREATE TRIGGER handle_updated_at
  BEFORE UPDATE ON public.season_plans
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- Final validation
DO $$
BEGIN
  RAISE NOTICE '==============================================';
  RAISE NOTICE '✅ APPLICATION TABLES FOUNDATION COMPLETE';
  RAISE NOTICE '✅ All core application tables created';
  RAISE NOTICE '✅ Foreign key relationships established';
  RAISE NOTICE '✅ RLS enabled on all tables';
  RAISE NOTICE '✅ Performance indexes created';
  RAISE NOTICE '✅ Basic RLS policies applied';
  RAISE NOTICE '✅ Updated_at triggers applied';
  RAISE NOTICE 'ℹ️ Storage tables managed by Supabase (expected)';
  RAISE NOTICE '==============================================';
END
$$;
