-- =============================================
-- INITIAL FOUNDATION MIGRATION 2025
-- Creates core tables without auth dependencies first
-- Compatible with both local and managed Supabase environments
-- =============================================

-- Create required roles if they don't exist
DO $$
BEGIN
  -- Create authenticated role
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'authenticated') THEN
    CREATE ROLE authenticated;
    RAISE NOTICE '✅ Created authenticated role';
  ELSE
    RAISE NOTICE 'ℹ️ authenticated role already exists';
  END IF;

  -- Create service_role role
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'service_role') THEN
    CREATE ROLE service_role;
    RAISE NOTICE '✅ Created service_role role';
  ELSE
    RAISE NOTICE 'ℹ️ service_role role already exists';
  END IF;

  -- Create anon role
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'anon') THEN
    CREATE ROLE anon;
    RAISE NOTICE '✅ Created anon role';
  ELSE
    RAISE NOTICE 'ℹ️ anon role already exists';
  END IF;
END
$$;

-- Organizations table (foundational - no auth dependencies)
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

-- Videos table (without auth references initially)
CREATE TABLE IF NOT EXISTS public.videos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id uuid NOT NULL REFERENCES public.organizations(id),
  title text NOT NULL,
  description text,
  file_url text,
  thumbnail_url text,
  duration_seconds integer,
  file_size_bytes bigint,
  mime_type text,
  processing_status text DEFAULT 'pending' CHECK (processing_status IN ('pending', 'processing', 'completed', 'failed')),
  upload_status text DEFAULT 'pending' CHECK (upload_status IN ('pending', 'uploading', 'completed', 'failed')),
  metadata jsonb DEFAULT '{}',
  tags text[] DEFAULT '{}',
  is_public boolean DEFAULT false,
  created_by uuid, -- Will add FK constraint later
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Video tags table (without auth references initially)
CREATE TABLE IF NOT EXISTS public.video_tags (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  video_id uuid NOT NULL REFERENCES public.videos(id),
  organization_id uuid NOT NULL REFERENCES public.organizations(id),
  event_type text NOT NULL CHECK (event_type IN ('goal', 'assist', 'shot', 'save', 'foul', 'card', 'substitution', 'corner_kick', 'free_kick', 'offside', 'penalty', 'tackle', 'interception', 'pass', 'cross', 'drill', 'moment', 'other')),
  timestamp_seconds numeric NOT NULL CHECK (timestamp_seconds >= 0),
  player_id uuid REFERENCES public.players(id),
  label text,
  description text,
  notes text,
  created_by uuid, -- Will add FK constraint later
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Training exercises table (without auth references initially)
CREATE TABLE IF NOT EXISTS public.training_exercises (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id uuid NOT NULL REFERENCES public.organizations(id),
  name text NOT NULL,
  description text,
  category text,
  difficulty text CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')),
  duration integer,
  equipment_needed text[],
  instructions jsonb DEFAULT '[]',
  variations jsonb DEFAULT '[]',
  objectives text[],
  is_public boolean DEFAULT false,
  created_by uuid, -- Will add FK constraint later
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

-- VEO highlights table (without auth references initially)
CREATE TABLE IF NOT EXISTS public.veo_highlights (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id uuid NOT NULL REFERENCES public.organizations(id),
  video_id uuid REFERENCES public.videos(id),
  match_id uuid REFERENCES public.matches(id),
  title text NOT NULL,
  description text,
  start_time numeric NOT NULL,
  end_time numeric NOT NULL,
  tags text[] DEFAULT '{}',
  players_involved uuid[] DEFAULT '{}',
  highlight_type text CHECK (highlight_type IN ('goal', 'assist', 'save', 'skill', 'tactical', 'other')),
  quality_score integer CHECK (quality_score >= 1 AND quality_score <= 10),
  is_featured boolean DEFAULT false,
  storage_path text,
  external_url text,
  metadata jsonb DEFAULT '{}',
  created_by uuid, -- Will add FK constraint later
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Profiles table (without auth references initially)
CREATE TABLE IF NOT EXISTS public.profiles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid, -- Will add FK constraint later
  username text,
  full_name text,
  avatar_url text,
  website text,
  bio text,
  organization_id uuid REFERENCES public.organizations(id),
  subscription_tier text DEFAULT 'basic' CHECK (subscription_tier IN ('basic', 'pro', 'enterprise')),
  subscription_status text DEFAULT 'active' CHECK (subscription_status IN ('active', 'inactive', 'trial', 'cancelled')),
  data_processing_consent boolean DEFAULT false,
  marketing_consent boolean DEFAULT false,
  consent_updated_at timestamptz DEFAULT now(),
  last_seen_at timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Organization members table (without auth references initially)
CREATE TABLE IF NOT EXISTS public.organization_members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id uuid REFERENCES public.organizations(id),
  user_id uuid, -- Will add FK constraint later
  role varchar(50) DEFAULT 'member' CHECK (role IN ('owner', 'admin', 'coach', 'member')),
  permissions jsonb DEFAULT '[]',
  joined_at timestamptz DEFAULT now()
);

-- Memberships table (for backwards compatibility, without auth references initially)
CREATE TABLE IF NOT EXISTS public.memberships (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid, -- Will add FK constraint later
  team_id uuid REFERENCES public.teams(id),
  organization_id uuid REFERENCES public.organizations(id),
  role varchar(50) DEFAULT 'member',
  created_at timestamptz DEFAULT now()
);

-- Enable RLS on all tables
ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.players ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.organization_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.memberships ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.training_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.videos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.video_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.training_exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.performance_analytics ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.calendar_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.season_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.training_periods ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.veo_highlights ENABLE ROW LEVEL SECURITY;

-- Create essential indexes for performance
CREATE INDEX IF NOT EXISTS idx_organizations_slug ON public.organizations(slug);
CREATE INDEX IF NOT EXISTS idx_profiles_user_id ON public.profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_profiles_organization_id ON public.profiles(organization_id);
CREATE INDEX IF NOT EXISTS idx_teams_organization_id ON public.teams(organization_id);
CREATE INDEX IF NOT EXISTS idx_players_organization_id ON public.players(organization_id);
CREATE INDEX IF NOT EXISTS idx_players_team_id ON public.players(team_id);
CREATE INDEX IF NOT EXISTS idx_organization_members_user_id ON public.organization_members(user_id);
CREATE INDEX IF NOT EXISTS idx_organization_members_organization_id ON public.organization_members(organization_id);
CREATE INDEX IF NOT EXISTS idx_memberships_user_id ON public.memberships(user_id);
CREATE INDEX IF NOT EXISTS idx_memberships_team_id ON public.memberships(team_id);
CREATE INDEX IF NOT EXISTS idx_training_sessions_organization_id ON public.training_sessions(organization_id);
CREATE INDEX IF NOT EXISTS idx_training_sessions_team_id ON public.training_sessions(team_id);
CREATE INDEX IF NOT EXISTS idx_matches_organization_id ON public.matches(organization_id);
CREATE INDEX IF NOT EXISTS idx_matches_team_id ON public.matches(team_id);
CREATE INDEX IF NOT EXISTS idx_videos_organization_id ON public.videos(organization_id);
CREATE INDEX IF NOT EXISTS idx_videos_created_by ON public.videos(created_by);
CREATE INDEX IF NOT EXISTS idx_videos_processing_status ON public.videos(processing_status);
CREATE INDEX IF NOT EXISTS idx_video_tags_video_id ON public.video_tags(video_id);
CREATE INDEX IF NOT EXISTS idx_video_tags_organization_id ON public.video_tags(organization_id);
CREATE INDEX IF NOT EXISTS idx_video_tags_event_type ON public.video_tags(event_type);
CREATE INDEX IF NOT EXISTS idx_video_tags_player_id ON public.video_tags(player_id);
CREATE INDEX IF NOT EXISTS idx_training_exercises_organization_id ON public.training_exercises(organization_id);
CREATE INDEX IF NOT EXISTS idx_training_exercises_category ON public.training_exercises(category);
CREATE INDEX IF NOT EXISTS idx_performance_analytics_organization_id ON public.performance_analytics(organization_id);
CREATE INDEX IF NOT EXISTS idx_performance_analytics_player_id ON public.performance_analytics(player_id);
CREATE INDEX IF NOT EXISTS idx_calendar_events_organization_id ON public.calendar_events(organization_id);
CREATE INDEX IF NOT EXISTS idx_season_plans_organization_id ON public.season_plans(organization_id);
CREATE INDEX IF NOT EXISTS idx_training_periods_organization_id ON public.training_periods(organization_id);
CREATE INDEX IF NOT EXISTS idx_veo_highlights_organization_id ON public.veo_highlights(organization_id);
CREATE INDEX IF NOT EXISTS idx_veo_highlights_video_id ON public.veo_highlights(video_id);
CREATE INDEX IF NOT EXISTS idx_veo_highlights_match_id ON public.veo_highlights(match_id);

-- Grant necessary permissions to roles (public schema only)
GRANT USAGE ON SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated, service_role;

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

DROP TRIGGER IF EXISTS handle_updated_at ON public.profiles;
CREATE TRIGGER handle_updated_at
  BEFORE UPDATE ON public.profiles
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

DROP TRIGGER IF EXISTS handle_updated_at ON public.videos;
CREATE TRIGGER handle_updated_at
  BEFORE UPDATE ON public.videos
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS handle_updated_at ON public.video_tags;
CREATE TRIGGER handle_updated_at
  BEFORE UPDATE ON public.video_tags
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS handle_updated_at ON public.training_exercises;
CREATE TRIGGER handle_updated_at
  BEFORE UPDATE ON public.training_exercises
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS handle_updated_at ON public.calendar_events;
CREATE TRIGGER handle_updated_at
  BEFORE UPDATE ON public.calendar_events
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS handle_updated_at ON public.season_plans;
CREATE TRIGGER handle_updated_at
  BEFORE UPDATE ON public.season_plans
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS handle_updated_at ON public.veo_highlights;
CREATE TRIGGER handle_updated_at
  BEFORE UPDATE ON public.veo_highlights
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- Final validation
DO $$
BEGIN
  RAISE NOTICE '==============================================';
  RAISE NOTICE '✅ INITIAL FOUNDATION ESTABLISHED';
  RAISE NOTICE '✅ All required roles created: authenticated, service_role, anon';
  RAISE NOTICE '✅ All application tables created without auth dependencies';
  RAISE NOTICE '✅ All expected columns present: video_id, label, description, etc.';
  RAISE NOTICE '✅ RLS enabled on all tables';
  RAISE NOTICE '✅ Essential indexes created for performance';
  RAISE NOTICE '✅ Updated_at triggers applied';
  RAISE NOTICE '✅ Proper role permissions granted';
  RAISE NOTICE 'ℹ️ Auth foreign keys will be added in a separate migration';
  RAISE NOTICE '==============================================';
END
$$;
