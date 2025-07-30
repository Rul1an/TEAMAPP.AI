-- =====================================================================================
-- CREATE TRAINING EXERCISES TABLE - 2025 Exercise Library Integration
-- =====================================================================================
-- Purpose: Create dedicated training_exercises table for exercise library functionality
-- Created: Juli 30, 2025 - 19:55
-- Priority: HIGH - Enables exercise library database integration
-- =====================================================================================

-- Phase 1: Create Training Exercises Table
-- =====================================================================================

CREATE TABLE IF NOT EXISTS public.training_exercises (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID REFERENCES public.organizations(id) ON DELETE CASCADE,

    -- Basic exercise information
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    duration_minutes DOUBLE PRECISION NOT NULL,
    player_count INTEGER NOT NULL,
    equipment TEXT DEFAULT '',
    intensity_level DOUBLE PRECISION DEFAULT 5.0 CHECK (intensity_level >= 0 AND intensity_level <= 10),

    -- Exercise categorization
    type TEXT NOT NULL CHECK (type IN (
        'technical', 'tactical', 'physical', 'goalkeeping', 'psychological',
        'warmUp', 'coolDown', 'smallSidedGames', 'conditioning', 'warmup',
        'cooldown', 'smallSidedGame', 'possession', 'finishing', 'defending', 'transition'
    )),
    category TEXT DEFAULT 'technical' CHECK (category IN (
        'warmup', 'technical', 'tactical', 'physical', 'finishing',
        'defending', 'goalkeeping', 'smallSided', 'cooldown'
    )),
    complexity TEXT DEFAULT 'basic' CHECK (complexity IN (
        'basic', 'intermediate', 'advanced', 'expert'
    )),

    -- Training session integration
    training_session_id UUID REFERENCES public.training_sessions(id) ON DELETE SET NULL,
    session_phase_id UUID, -- References session phases (to be created later)
    order_index INTEGER DEFAULT 0,

    -- Coaching information
    coaching_points TEXT[] DEFAULT '{}',
    key_focus TEXT,
    objectives TEXT[] DEFAULT '{}',

    -- Physical requirements
    min_players INTEGER DEFAULT 1,
    max_players INTEGER DEFAULT 22,
    space_required TEXT DEFAULT 'Half field',

    -- Performance metrics
    estimated_rpe DOUBLE PRECISION DEFAULT 5.0 CHECK (estimated_rpe >= 0 AND estimated_rpe <= 10),
    average_rating DOUBLE PRECISION DEFAULT 0.0 CHECK (average_rating >= 0 AND average_rating <= 10),
    primary_intensity DOUBLE PRECISION DEFAULT 5.0 CHECK (primary_intensity >= 0 AND primary_intensity <= 10),

    -- Tactical focus (morphocycle integration)
    tactical_focus TEXT CHECK (tactical_focus IN (
        'gameModel', 'possession', 'pressing', 'transition', 'setPlays',
        'defensiveShape', 'offensiveShape', 'counterAttack', 'buildUp'
    )),

    -- Field diagram (stored as JSONB for flexibility)
    field_diagram JSONB DEFAULT '{}',

    -- Status and metadata
    is_active BOOLEAN DEFAULT true,
    is_template BOOLEAN DEFAULT false, -- Template exercises for organization
    usage_count INTEGER DEFAULT 0, -- Track popular exercises

    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Phase 2: Create Performance Indexes
-- =====================================================================================

-- Primary indexes for queries
CREATE INDEX IF NOT EXISTS idx_training_exercises_org_id ON public.training_exercises (organization_id);
CREATE INDEX IF NOT EXISTS idx_training_exercises_session_id ON public.training_exercises (training_session_id);
CREATE INDEX IF NOT EXISTS idx_training_exercises_type ON public.training_exercises (type);
CREATE INDEX IF NOT EXISTS idx_training_exercises_category ON public.training_exercises (category);
CREATE INDEX IF NOT EXISTS idx_training_exercises_intensity ON public.training_exercises (intensity_level);

-- Composite indexes for common queries
CREATE INDEX IF NOT EXISTS idx_training_exercises_org_active ON public.training_exercises (organization_id, is_active);
CREATE INDEX IF NOT EXISTS idx_training_exercises_org_template ON public.training_exercises (organization_id, is_template);
CREATE INDEX IF NOT EXISTS idx_training_exercises_tactical_focus ON public.training_exercises (tactical_focus, intensity_level);

-- Performance optimization indexes
CREATE INDEX IF NOT EXISTS idx_training_exercises_duration ON public.training_exercises (duration_minutes);
CREATE INDEX IF NOT EXISTS idx_training_exercises_player_count ON public.training_exercises (player_count);
CREATE INDEX IF NOT EXISTS idx_training_exercises_usage ON public.training_exercises (usage_count DESC);

-- Phase 3: Enable Row Level Security
-- =====================================================================================

ALTER TABLE public.training_exercises ENABLE ROW LEVEL SECURITY;

-- Organization-based access policy
CREATE POLICY "training_exercises_org_access" ON public.training_exercises
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

-- Service role bypass policy
CREATE POLICY "training_exercises_service_access" ON public.training_exercises
    FOR ALL TO service_role USING (true) WITH CHECK (true);

-- Phase 4: Grant Permissions
-- =====================================================================================

-- Grant table permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON public.training_exercises TO authenticated;
GRANT SELECT ON public.training_exercises TO anon;
GRANT ALL ON public.training_exercises TO service_role;

-- Phase 5: Create Updated_at Trigger
-- =====================================================================================

CREATE TRIGGER handle_training_exercises_updated_at
    BEFORE UPDATE ON public.training_exercises
    FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- Phase 6: Insert Sample/Template Exercises
-- =====================================================================================

-- Insert template exercises (these will be available to all organizations)
INSERT INTO public.training_exercises (
    organization_id, name, description, duration_minutes, player_count, equipment,
    intensity_level, type, category, coaching_points, tactical_focus, primary_intensity,
    is_template, is_active
) VALUES
    -- Recovery/Technical exercises (intensity 1-3)
    (
        (SELECT id FROM public.organizations LIMIT 1), -- Use first org as template owner
        'Passing Diamond',
        'Short passing drill in diamond formation to improve first touch and passing accuracy',
        15.0, 8, 'Cones, footballs',
        2.5, 'technical', 'technical',
        ARRAY['Focus on first touch', 'Use both feet', 'Keep head up', 'Weight of pass'],
        'possession', 2.5, true, true
    ),
    (
        (SELECT id FROM public.organizations LIMIT 1),
        'Recovery Jogging',
        'Light jogging with dynamic stretching for active recovery',
        10.0, 18, 'None',
        2.0, 'warmUp', 'warmup',
        ARRAY['Light pace', 'Focus on breathing', 'Dynamic movements'],
        'gameModel', 2.0, true, true
    ),

    -- Activation exercises (intensity 4-6)
    (
        (SELECT id FROM public.organizations LIMIT 1),
        'Tactical Shape Work',
        'Practice defensive and offensive shape in structured 11v11 format',
        30.0, 18, 'Cones, bibs',
        6.0, 'tactical', 'tactical',
        ARRAY['Maintain distances', 'Communication', 'Trigger movements', 'Pressing signals'],
        'defensiveShape', 6.0, true, true
    ),
    (
        (SELECT id FROM public.organizations LIMIT 1),
        'Small Sided Game 4v4',
        '4v4 possession game in small area to develop quick decision making',
        20.0, 8, 'Goals, bibs',
        5.5, 'smallSidedGames', 'smallSided',
        ARRAY['Quick passing', 'Movement off ball', 'Compact defending'],
        'possession', 5.5, true, true
    ),

    -- Development exercises (intensity 5-7)
    (
        (SELECT id FROM public.organizations LIMIT 1),
        'Finishing Circuit',
        'Multi-station finishing practice with various angles and situations',
        25.0, 12, 'Goals, cones, footballs',
        7.0, 'finishing', 'finishing',
        ARRAY['Strike through ball', 'Low and hard', 'Pick corners', 'Follow through'],
        'offensiveShape', 7.0, true, true
    ),

    -- Acquisition exercises (intensity 8-10)
    (
        (SELECT id FROM public.organizations LIMIT 1),
        'High Intensity Pressing',
        'High tempo pressing drills with quick transitions and counter-pressing',
        15.0, 16, 'Bibs, cones',
        9.0, 'tactical', 'tactical',
        ARRAY['Immediate pressure', 'Cut passing lanes', 'Aggressive approach', 'Quick recovery'],
        'pressing', 9.0, true, true
    ),
    (
        (SELECT id FROM public.organizations LIMIT 1),
        'Sprint Intervals',
        'High intensity sprint training with ball work integration',
        25.0, 18, 'Cones, footballs',
        9.5, 'physical', 'physical',
        ARRAY['Maximum effort', 'Explosive starts', 'Maintain form', 'Full recovery'],
        'transition', 9.5, true, true
    );

-- Phase 7: Create Helper Functions
-- =====================================================================================

-- Function to get exercises by intensity range
CREATE OR REPLACE FUNCTION get_exercises_by_intensity(
    org_id UUID,
    min_intensity DOUBLE PRECISION DEFAULT 0,
    max_intensity DOUBLE PRECISION DEFAULT 10
)
RETURNS TABLE (
    id UUID,
    name TEXT,
    description TEXT,
    duration_minutes DOUBLE PRECISION,
    intensity_level DOUBLE PRECISION,
    type TEXT,
    category TEXT
)
LANGUAGE sql
SECURITY DEFINER
AS $$
    SELECT e.id, e.name, e.description, e.duration_minutes,
           e.intensity_level, e.type, e.category
    FROM training_exercises e
    WHERE e.organization_id = org_id
      AND e.is_active = true
      AND e.intensity_level >= min_intensity
      AND e.intensity_level <= max_intensity
    ORDER BY e.intensity_level, e.name;
$$;

-- Function to get exercises by tactical focus
CREATE OR REPLACE FUNCTION get_exercises_by_tactical_focus(
    org_id UUID,
    focus TEXT
)
RETURNS TABLE (
    id UUID,
    name TEXT,
    description TEXT,
    tactical_focus TEXT,
    intensity_level DOUBLE PRECISION
)
LANGUAGE sql
SECURITY DEFINER
AS $$
    SELECT e.id, e.name, e.description, e.tactical_focus, e.intensity_level
    FROM training_exercises e
    WHERE e.organization_id = org_id
      AND e.is_active = true
      AND e.tactical_focus = focus
    ORDER BY e.intensity_level, e.name;
$$;

-- Phase 8: Validation & Health Check
-- =====================================================================================

DO $$
DECLARE
    table_exists BOOLEAN := false;
    sample_count INTEGER := 0;
    policy_count INTEGER := 0;
BEGIN
    -- Check if table was created
    SELECT EXISTS (
        SELECT 1 FROM information_schema.tables
        WHERE table_schema = 'public' AND table_name = 'training_exercises'
    ) INTO table_exists;

    -- Check sample data
    SELECT COUNT(*) INTO sample_count FROM public.training_exercises;

    -- Check policies
    SELECT COUNT(*) INTO policy_count FROM pg_policies
    WHERE tablename = 'training_exercises';

    -- Validation
    IF NOT table_exists THEN
        RAISE EXCEPTION 'CRITICAL: training_exercises table was not created';
    END IF;

    IF policy_count < 2 THEN
        RAISE WARNING 'WARNING: Expected at least 2 RLS policies, found %', policy_count;
    END IF;

    -- Success notification
    RAISE NOTICE '==============================================';
    RAISE NOTICE '✅ TRAINING EXERCISES TABLE CREATED';
    RAISE NOTICE '✅ Table exists: %', table_exists;
    RAISE NOTICE '✅ Sample exercises: %', sample_count;
    RAISE NOTICE '✅ RLS policies: %', policy_count;
    RAISE NOTICE '✅ Indexes created for performance';
    RAISE NOTICE '✅ Helper functions created';
    RAISE NOTICE '==============================================';
END $$;

-- =====================================================================================
-- MIGRATION COMPLETED - TRAINING EXERCISES TABLE READY FOR USE
-- =====================================================================================
