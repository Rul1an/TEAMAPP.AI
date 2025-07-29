-- =====================================================================================
-- EMERGENCY FIX: Missing Tables and Roles - 2025 Production Repair
-- =====================================================================================
-- Purpose: Fix failing migration by ensuring all referenced tables and roles exist
-- Created: Juli 29, 2025 - 23:50
-- Priority: CRITICAL - Fixes CI/CD pipeline failures
-- =====================================================================================

-- Phase 1: Create Missing Roles (CRITICAL)
-- =====================================================================================

DO $$
BEGIN
    -- Create authenticated role if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated') THEN
        CREATE ROLE authenticated;
        RAISE NOTICE '✅ Created authenticated role';
    ELSE
        RAISE NOTICE '✅ authenticated role already exists';
    END IF;

    -- Create service_role if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'service_role') THEN
        CREATE ROLE service_role;
        RAISE NOTICE '✅ Created service_role role';
    ELSE
        RAISE NOTICE '✅ service_role already exists';
    END IF;

    -- Create anon role if it doesn't exist (needed for public access)
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'anon') THEN
        CREATE ROLE anon;
        RAISE NOTICE '✅ Created anon role';
    ELSE
        RAISE NOTICE '✅ anon role already exists';
    END IF;
END $$;

-- Phase 2: Create Missing Core Tables
-- =====================================================================================

-- 2.1 Organizations table (SaaS foundation)
CREATE TABLE IF NOT EXISTS public.organizations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    subscription_tier TEXT DEFAULT 'basic' CHECK (subscription_tier IN ('basic', 'pro', 'enterprise')),
    subscription_status TEXT DEFAULT 'active' CHECK (subscription_status IN ('active', 'inactive', 'trial', 'cancelled')),
    trial_ends_at TIMESTAMPTZ,
    max_players INTEGER DEFAULT 25,
    max_teams INTEGER DEFAULT 1,
    max_coaches INTEGER DEFAULT 3,
    settings JSONB DEFAULT '{}',
    branding JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2.2 Organization members table (multi-tenant access control)
CREATE TABLE IF NOT EXISTS public.organization_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES public.organizations(id) ON DELETE CASCADE,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT DEFAULT 'member' CHECK (role IN ('owner', 'admin', 'coach', 'member')),
    permissions JSONB DEFAULT '{}',
    invited_at TIMESTAMPTZ DEFAULT NOW(),
    joined_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(organization_id, user_id)
);

-- 2.3 Teams table
CREATE TABLE IF NOT EXISTS public.teams (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES public.organizations(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    age_group TEXT,
    division TEXT,
    season TEXT,
    formation TEXT DEFAULT '4-3-3',
    primary_color TEXT DEFAULT '#3B82F6',
    secondary_color TEXT DEFAULT '#EF4444',
    logo_url TEXT,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2.4 Players table
CREATE TABLE IF NOT EXISTS public.players (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES public.organizations(id) ON DELETE CASCADE,
    team_id UUID REFERENCES public.teams(id) ON DELETE SET NULL,
    name TEXT NOT NULL,
    jersey_number INTEGER,
    position TEXT,
    date_of_birth DATE,
    height INTEGER, -- in cm
    weight INTEGER, -- in kg
    dominant_foot TEXT CHECK (dominant_foot IN ('left', 'right', 'both')),
    nationality TEXT,
    contact_info JSONB DEFAULT '{}',
    medical_info JSONB DEFAULT '{}',
    performance_data JSONB DEFAULT '{}',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2.5 Training sessions table
CREATE TABLE IF NOT EXISTS public.training_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES public.organizations(id) ON DELETE CASCADE,
    team_id UUID REFERENCES public.teams(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    date_time TIMESTAMPTZ NOT NULL,
    duration INTEGER DEFAULT 90, -- minutes
    location TEXT,
    focus TEXT,
    intensity TEXT CHECK (intensity IN ('low', 'medium', 'high')),
    status TEXT DEFAULT 'planned' CHECK (status IN ('planned', 'ongoing', 'completed', 'cancelled')),
    weather_conditions JSONB DEFAULT '{}',
    field_conditions TEXT,
    competition_context TEXT,
    exercises JSONB DEFAULT '[]',
    attendance JSONB DEFAULT '{}',
    performance_notes TEXT,
    metrics JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2.6 Season plans table
CREATE TABLE IF NOT EXISTS public.season_plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES public.organizations(id) ON DELETE CASCADE,
    team_id UUID REFERENCES public.teams(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    objectives JSONB DEFAULT '[]',
    phases JSONB DEFAULT '[]',
    competitions JSONB DEFAULT '[]',
    training_schedule JSONB DEFAULT '{}',
    periodization JSONB DEFAULT '{}',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2.7 Matches table
CREATE TABLE IF NOT EXISTS public.matches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES public.organizations(id) ON DELETE CASCADE,
    team_id UUID REFERENCES public.teams(id) ON DELETE CASCADE,
    opponent_name TEXT NOT NULL,
    match_date TIMESTAMPTZ NOT NULL,
    location TEXT,
    is_home BOOLEAN DEFAULT true,
    competition TEXT,
    match_type TEXT CHECK (match_type IN ('friendly', 'league', 'cup', 'tournament')),
    result JSONB DEFAULT '{}', -- {home_score: 2, away_score: 1}
    lineup JSONB DEFAULT '{}',
    substitutions JSONB DEFAULT '[]',
    events JSONB DEFAULT '[]', -- goals, cards, etc.
    statistics JSONB DEFAULT '{}',
    match_report TEXT,
    status TEXT DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'ongoing', 'completed', 'cancelled')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Phase 3: Create Performance Indexes
-- =====================================================================================

-- Organizations indexes
CREATE INDEX IF NOT EXISTS idx_organizations_slug ON public.organizations (slug);
CREATE INDEX IF NOT EXISTS idx_organizations_subscription ON public.organizations (subscription_tier, subscription_status);

-- Organization members indexes
CREATE INDEX IF NOT EXISTS idx_org_members_org_id ON public.organization_members (organization_id);
CREATE INDEX IF NOT EXISTS idx_org_members_user_id ON public.organization_members (user_id);
CREATE INDEX IF NOT EXISTS idx_org_members_role ON public.organization_members (role);

-- Teams indexes
CREATE INDEX IF NOT EXISTS idx_teams_organization_id ON public.teams (organization_id);
CREATE INDEX IF NOT EXISTS idx_teams_season ON public.teams (season);

-- Players indexes
CREATE INDEX IF NOT EXISTS idx_players_organization_id ON public.players (organization_id);
CREATE INDEX IF NOT EXISTS idx_players_team_id ON public.players (team_id);
CREATE INDEX IF NOT EXISTS idx_players_position ON public.players (position);
CREATE INDEX IF NOT EXISTS idx_players_active ON public.players (is_active);

-- Training sessions indexes
CREATE INDEX IF NOT EXISTS idx_training_sessions_org_id ON public.training_sessions (organization_id);
CREATE INDEX IF NOT EXISTS idx_training_sessions_team_id ON public.training_sessions (team_id);
CREATE INDEX IF NOT EXISTS idx_training_sessions_date ON public.training_sessions (date_time);
CREATE INDEX IF NOT EXISTS idx_training_sessions_status ON public.training_sessions (status);

-- Season plans indexes
CREATE INDEX IF NOT EXISTS idx_season_plans_org_id ON public.season_plans (organization_id);
CREATE INDEX IF NOT EXISTS idx_season_plans_team_id ON public.season_plans (team_id);
CREATE INDEX IF NOT EXISTS idx_season_plans_active ON public.season_plans (is_active);

-- Matches indexes
CREATE INDEX IF NOT EXISTS idx_matches_organization_id ON public.matches (organization_id);
CREATE INDEX IF NOT EXISTS idx_matches_team_id ON public.matches (team_id);
CREATE INDEX IF NOT EXISTS idx_matches_date ON public.matches (match_date);
CREATE INDEX IF NOT EXISTS idx_matches_status ON public.matches (status);

-- Phase 4: Enable Row Level Security
-- =====================================================================================

-- Enable RLS on all tables
ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.organization_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.players ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.training_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.season_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.matches ENABLE ROW LEVEL SECURITY;

-- Phase 5: Create RLS Policies (2025 Optimized Patterns)
-- =====================================================================================

-- 5.1 Organizations policies
CREATE POLICY "organizations_member_access" ON public.organizations
    FOR ALL TO authenticated
    USING (
        id IN (
            SELECT organization_id
            FROM organization_members
            WHERE user_id = (SELECT auth.uid())
        )
    )
    WITH CHECK (
        id IN (
            SELECT organization_id
            FROM organization_members
            WHERE user_id = (SELECT auth.uid()) AND role IN ('owner', 'admin')
        )
    );

-- 5.2 Organization members policies
CREATE POLICY "org_members_own_access" ON public.organization_members
    FOR ALL TO authenticated
    USING (
        organization_id IN (
            SELECT organization_id
            FROM organization_members
            WHERE user_id = (SELECT auth.uid())
        )
    )
    WITH CHECK (
        organization_id IN (
            SELECT organization_id
            FROM organization_members
            WHERE user_id = (SELECT auth.uid()) AND role IN ('owner', 'admin')
        )
    );

-- 5.3 Teams policies
CREATE POLICY "teams_org_access" ON public.teams
    FOR ALL TO authenticated
    USING (
        organization_id IN (
            SELECT organization_id
            FROM organization_members
            WHERE user_id = (SELECT auth.uid())
        )
    )
    WITH CHECK (
        organization_id IN (
            SELECT organization_id
            FROM organization_members
            WHERE user_id = (SELECT auth.uid()) AND role IN ('owner', 'admin', 'coach')
        )
    );

-- 5.4 Players policies
CREATE POLICY "players_org_access" ON public.players
    FOR ALL TO authenticated
    USING (
        organization_id IN (
            SELECT organization_id
            FROM organization_members
            WHERE user_id = (SELECT auth.uid())
        )
    )
    WITH CHECK (
        organization_id IN (
            SELECT organization_id
            FROM organization_members
            WHERE user_id = (SELECT auth.uid()) AND role IN ('owner', 'admin', 'coach')
        )
    );

-- 5.5 Training sessions policies
CREATE POLICY "training_sessions_org_access" ON public.training_sessions
    FOR ALL TO authenticated
    USING (
        organization_id IN (
            SELECT organization_id
            FROM organization_members
            WHERE user_id = (SELECT auth.uid())
        )
    )
    WITH CHECK (
        organization_id IN (
            SELECT organization_id
            FROM organization_members
            WHERE user_id = (SELECT auth.uid()) AND role IN ('owner', 'admin', 'coach')
        )
    );

-- 5.6 Season plans policies
CREATE POLICY "season_plans_org_access" ON public.season_plans
    FOR ALL TO authenticated
    USING (
        organization_id IN (
            SELECT organization_id
            FROM organization_members
            WHERE user_id = (SELECT auth.uid())
        )
    )
    WITH CHECK (
        organization_id IN (
            SELECT organization_id
            FROM organization_members
            WHERE user_id = (SELECT auth.uid()) AND role IN ('owner', 'admin', 'coach')
        )
    );

-- 5.7 Matches policies
CREATE POLICY "matches_org_access" ON public.matches
    FOR ALL TO authenticated
    USING (
        organization_id IN (
            SELECT organization_id
            FROM organization_members
            WHERE user_id = (SELECT auth.uid())
        )
    )
    WITH CHECK (
        organization_id IN (
            SELECT organization_id
            FROM organization_members
            WHERE user_id = (SELECT auth.uid()) AND role IN ('owner', 'admin', 'coach')
        )
    );

-- Phase 6: Service Role Bypass Policies
-- =====================================================================================

-- Service role bypass for all tables (admin operations)
CREATE POLICY "organizations_service_access" ON public.organizations FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY "org_members_service_access" ON public.organization_members FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY "teams_service_access" ON public.teams FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY "players_service_access" ON public.players FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY "training_sessions_service_access" ON public.training_sessions FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY "season_plans_service_access" ON public.season_plans FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY "matches_service_access" ON public.matches FOR ALL TO service_role USING (true) WITH CHECK (true);

-- Phase 7: Grant Permissions
-- =====================================================================================

-- Grant usage on schema
GRANT USAGE ON SCHEMA public TO authenticated, anon, service_role;

-- Grant table permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO anon;
GRANT ALL ON ALL TABLES IN SCHEMA public TO service_role;

-- Grant sequence permissions
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO authenticated, service_role;

-- Phase 8: Create Updated_at Triggers
-- =====================================================================================

-- Create updated_at trigger function if it doesn't exist
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;

-- Apply updated_at triggers to all tables
CREATE TRIGGER handle_organizations_updated_at BEFORE UPDATE ON public.organizations FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();
CREATE TRIGGER handle_org_members_updated_at BEFORE UPDATE ON public.organization_members FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();
CREATE TRIGGER handle_teams_updated_at BEFORE UPDATE ON public.teams FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();
CREATE TRIGGER handle_players_updated_at BEFORE UPDATE ON public.players FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();
CREATE TRIGGER handle_training_sessions_updated_at BEFORE UPDATE ON public.training_sessions FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();
CREATE TRIGGER handle_season_plans_updated_at BEFORE UPDATE ON public.season_plans FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();
CREATE TRIGGER handle_matches_updated_at BEFORE UPDATE ON public.matches FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- Phase 9: Validation & Health Check
-- =====================================================================================

DO $$
DECLARE
    missing_tables TEXT[] := ARRAY[]::TEXT[];
    missing_roles TEXT[] := ARRAY[]::TEXT[];
    table_count INTEGER;
    role_count INTEGER;
BEGIN
    -- Check for missing tables
    SELECT COUNT(*) INTO table_count FROM information_schema.tables
    WHERE table_schema = 'public' AND table_name IN (
        'organizations', 'organization_members', 'teams', 'players',
        'training_sessions', 'season_plans', 'matches', 'profiles', 'video_tags'
    );

    -- Check for missing roles
    SELECT COUNT(*) INTO role_count FROM pg_roles
    WHERE rolname IN ('authenticated', 'service_role', 'anon');

    -- Validation
    IF table_count < 9 THEN
        RAISE EXCEPTION 'CRITICAL: Not all required tables were created. Found % of 9 tables', table_count;
    END IF;

    IF role_count < 3 THEN
        RAISE EXCEPTION 'CRITICAL: Not all required roles were created. Found % of 3 roles', role_count;
    END IF;

    -- Success notification
    RAISE NOTICE '==============================================';
    RAISE NOTICE '✅ MIGRATION COMPLETED SUCCESSFULLY';
    RAISE NOTICE '✅ All % required tables created', table_count;
    RAISE NOTICE '✅ All % required roles created', role_count;
    RAISE NOTICE '✅ RLS policies applied to all tables';
    RAISE NOTICE '✅ Performance indexes created';
    RAISE NOTICE '✅ Updated_at triggers applied';
    RAISE NOTICE '==============================================';
END $$;

-- =====================================================================================
-- MIGRATION COMPLETED - ALL MISSING TABLES AND ROLES FIXED
-- =====================================================================================
