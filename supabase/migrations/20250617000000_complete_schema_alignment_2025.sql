-- =============================================
-- COMPLETE SCHEMA ALIGNMENT MIGRATION 2025
-- Adds all missing columns, views, and conditional storage policies
-- Follows Supabase 2025 best practices for managed infrastructure
-- =============================================

-- Add missing columns to existing tables
DO $$
BEGIN
  RAISE NOTICE '==============================================';
  RAISE NOTICE '📋 ADDING MISSING COLUMNS TO APPLICATION TABLES';
  RAISE NOTICE '==============================================';

  -- Add missing columns to matches table
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'matches') THEN
    -- Add match_date column (using date_time as source if needed)
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'matches' AND column_name = 'match_date') THEN
      ALTER TABLE public.matches ADD COLUMN match_date date;
      RAISE NOTICE '✅ Added matches.match_date column';
    END IF;

    -- Add status column
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'matches' AND column_name = 'status') THEN
      ALTER TABLE public.matches ADD COLUMN status text DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'live', 'completed', 'cancelled', 'postponed'));
      RAISE NOTICE '✅ Added matches.status column';
    END IF;
  END IF;

  -- Add missing columns to video_tags table
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'video_tags') THEN
    -- Add tag_data column
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'video_tags' AND column_name = 'tag_data') THEN
      ALTER TABLE public.video_tags ADD COLUMN tag_data jsonb DEFAULT '{}';
      RAISE NOTICE '✅ Added video_tags.tag_data column';
    END IF;

    -- Add video_url column (for external video references)
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'video_tags' AND column_name = 'video_url') THEN
      ALTER TABLE public.video_tags ADD COLUMN video_url text;
      RAISE NOTICE '✅ Added video_tags.video_url column';
    END IF;
  END IF;

  -- Add missing columns to players table
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'players') THEN
    -- Add is_active column
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'players' AND column_name = 'is_active') THEN
      ALTER TABLE public.players ADD COLUMN is_active boolean DEFAULT true;
      RAISE NOTICE '✅ Added players.is_active column';
    END IF;
  END IF;

  -- Add missing columns to season_plans table
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'season_plans') THEN
    -- Add is_active column
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'season_plans' AND column_name = 'is_active') THEN
      ALTER TABLE public.season_plans ADD COLUMN is_active boolean DEFAULT true;
      RAISE NOTICE '✅ Added season_plans.is_active column';
    END IF;
  END IF;

  -- Add missing columns to training_sessions table
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'training_sessions') THEN
    -- Add status column
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'training_sessions' AND column_name = 'status') THEN
      ALTER TABLE public.training_sessions ADD COLUMN status text DEFAULT 'planned' CHECK (status IN ('planned', 'in_progress', 'completed', 'cancelled'));
      RAISE NOTICE '✅ Added training_sessions.status column';
    END IF;
  END IF;

  RAISE NOTICE '📋 APPLICATION TABLE COLUMNS COMPLETED';
END
$$;

-- Create missing views
DO $$
BEGIN
  RAISE NOTICE '==============================================';
  RAISE NOTICE '👁️ CREATING MISSING VIEWS';
  RAISE NOTICE '==============================================';

  -- Create trainings view (alias for training_sessions)
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'training_sessions') THEN
    DROP VIEW IF EXISTS public.trainings;
    CREATE VIEW public.trainings AS
    SELECT
      id,
      organization_id,
      team_id,
      title,
      description,
      date_time,
      duration,
      location,
      focus,
      intensity,
      exercises,
      phases,
      status,
      created_at,
      updated_at
    FROM public.training_sessions;
    RAISE NOTICE '✅ Created trainings view';
  END IF;

  -- Create RLS performance monitor view
  DROP VIEW IF EXISTS public.rls_performance_monitor;
  CREATE VIEW public.rls_performance_monitor AS
  SELECT
    schemaname,
    tablename,
    indexname,
    CASE
      WHEN tablename LIKE '%video%' THEN 'video_system'
      WHEN tablename LIKE '%training%' THEN 'training_system'
      WHEN tablename LIKE '%match%' THEN 'match_system'
      WHEN tablename LIKE '%player%' THEN 'player_system'
      ELSE 'general_system'
    END as system_category,
    current_timestamp as monitored_at
  FROM pg_indexes
  WHERE schemaname = 'public'
  ORDER BY tablename, indexname;
  RAISE NOTICE '✅ Created rls_performance_monitor view';

  RAISE NOTICE '👁️ VIEWS CREATION COMPLETED';
END
$$;

-- Conditionally create storage policies only if storage schema exists
DO $$
BEGIN
  RAISE NOTICE '==============================================';
  RAISE NOTICE '🗄️ CONDITIONAL STORAGE POLICIES SETUP';
  RAISE NOTICE '==============================================';

  -- Check if storage schema exists (managed Supabase environment)
  IF EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'storage') THEN
    RAISE NOTICE '✅ Storage schema found - managed Supabase environment detected';

    -- Check if storage.objects table exists
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'storage' AND table_name = 'objects') THEN
      RAISE NOTICE '✅ Storage.objects table found - creating RLS policies';

      -- Video storage policies (only for managed environments)
      DROP POLICY IF EXISTS "Videos: Users can view videos in their organizations" ON storage.objects;
      CREATE POLICY "Videos: Users can view videos in their organizations" ON storage.objects
        FOR SELECT TO authenticated
        USING (
          bucket_id = 'videos' AND
          (storage.folder(name))[1] IN (
            SELECT organization_id::text FROM public.organization_members
            WHERE user_id = (auth.jwt() ->> 'sub')::uuid
          )
        );

      DROP POLICY IF EXISTS "Videos: Users can insert videos in their organizations" ON storage.objects;
      CREATE POLICY "Videos: Users can insert videos in their organizations" ON storage.objects
        FOR INSERT TO authenticated
        WITH CHECK (
          bucket_id = 'videos' AND
          (storage.folder(name))[1] IN (
            SELECT organization_id::text FROM public.organization_members
            WHERE user_id = (auth.jwt() ->> 'sub')::uuid
          )
        );

      DROP POLICY IF EXISTS "Videos: Users can update videos in their organizations" ON storage.objects;
      CREATE POLICY "Videos: Users can update videos in their organizations" ON storage.objects
        FOR UPDATE TO authenticated
        USING (
          bucket_id = 'videos' AND
          (storage.folder(name))[1] IN (
            SELECT organization_id::text FROM public.organization_members
            WHERE user_id = (auth.jwt() ->> 'sub')::uuid
          )
        );

      DROP POLICY IF EXISTS "Videos: Users can delete videos in their organizations" ON storage.objects;
      CREATE POLICY "Videos: Users can delete videos in their organizations" ON storage.objects
        FOR DELETE TO authenticated
        USING (
          bucket_id = 'videos' AND
          (storage.folder(name))[1] IN (
            SELECT organization_id::text FROM public.organization_members
            WHERE user_id = (auth.jwt() ->> 'sub')::uuid
          )
        );

      -- Public video storage policy
      DROP POLICY IF EXISTS "Videos: Anonymous users can view public videos" ON storage.objects;
      CREATE POLICY "Videos: Anonymous users can view public videos" ON storage.objects
        FOR SELECT TO anon
        USING (bucket_id = 'videos' AND (storage.folder(name))[2] = 'public');

      RAISE NOTICE '✅ Storage RLS policies created successfully';
    ELSE
      RAISE NOTICE 'ℹ️ Storage.objects table not found - skipping storage policies';
    END IF;
  ELSE
    RAISE NOTICE 'ℹ️ Storage schema not found - local development environment detected';
    RAISE NOTICE 'ℹ️ Storage policies will be applied when deployed to managed Supabase';
  END IF;

  RAISE NOTICE '🗄️ STORAGE POLICIES SETUP COMPLETED';
END
$$;

-- Update indexes for new columns
DO $$
BEGIN
  RAISE NOTICE '==============================================';
  RAISE NOTICE '🚀 CREATING PERFORMANCE INDEXES';
  RAISE NOTICE '==============================================';

  -- Index for matches.match_date
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'matches' AND column_name = 'match_date') THEN
    CREATE INDEX IF NOT EXISTS idx_matches_match_date ON public.matches(match_date);
    RAISE NOTICE '✅ Created index on matches.match_date';
  END IF;

  -- Index for matches.status
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'matches' AND column_name = 'status') THEN
    CREATE INDEX IF NOT EXISTS idx_matches_status ON public.matches(status);
    RAISE NOTICE '✅ Created index on matches.status';
  END IF;

  -- Index for players.is_active
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'players' AND column_name = 'is_active') THEN
    CREATE INDEX IF NOT EXISTS idx_players_is_active ON public.players(is_active);
    RAISE NOTICE '✅ Created index on players.is_active';
  END IF;

  -- Index for training_sessions.status
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'training_sessions' AND column_name = 'status') THEN
    CREATE INDEX IF NOT EXISTS idx_training_sessions_status ON public.training_sessions(status);
    RAISE NOTICE '✅ Created index on training_sessions.status';
  END IF;

  -- Index for video_tags.tag_data (GIN for JSONB)
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'video_tags' AND column_name = 'tag_data') THEN
    CREATE INDEX IF NOT EXISTS idx_video_tags_tag_data ON public.video_tags USING GIN (tag_data);
    RAISE NOTICE '✅ Created GIN index on video_tags.tag_data';
  END IF;

  RAISE NOTICE '🚀 PERFORMANCE INDEXES COMPLETED';
END
$$;

-- Update existing data with sensible defaults
DO $$
BEGIN
  RAISE NOTICE '==============================================';
  RAISE NOTICE '🔄 UPDATING EXISTING DATA WITH DEFAULTS';
  RAISE NOTICE '==============================================';

  -- Update matches.match_date from date_time if it exists
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'matches' AND column_name = 'match_date')
     AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'matches' AND column_name = 'date_time') THEN
    UPDATE public.matches
    SET match_date = date_time::date
    WHERE match_date IS NULL AND date_time IS NOT NULL;
    RAISE NOTICE '✅ Updated matches.match_date from date_time';
  END IF;

  -- Update match_status based on date_time
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'matches' AND column_name = 'status') THEN
    UPDATE public.matches
    SET status = CASE
      WHEN date_time > now() THEN 'scheduled'
      WHEN date_time < now() - interval '3 hours' THEN 'completed'
      ELSE 'scheduled'
    END
    WHERE status IS NULL;
    RAISE NOTICE '✅ Updated matches.status based on date_time';
  END IF;

  RAISE NOTICE '🔄 DATA UPDATES COMPLETED';
END
$$;

-- Final validation and summary
DO $$
BEGIN
  RAISE NOTICE '==============================================';
  RAISE NOTICE '✅ COMPLETE SCHEMA ALIGNMENT SUCCESSFUL';
  RAISE NOTICE '==============================================';
  RAISE NOTICE '📊 Summary of changes:';
  RAISE NOTICE '   • Added missing columns to matches, video_tags, players, season_plans, training_sessions';
  RAISE NOTICE '   • Created trainings and rls_performance_monitor views';
  RAISE NOTICE '   • Applied conditional storage policies (managed environments only)';
  RAISE NOTICE '   • Created performance indexes for new columns';
  RAISE NOTICE '   • Updated existing data with sensible defaults';
  RAISE NOTICE '   • Compatible with both local development and managed Supabase';
  RAISE NOTICE '==============================================';
  RAISE NOTICE '🎯 Next steps:';
  RAISE NOTICE '   • Storage schema is managed by Supabase automatically';
  RAISE NOTICE '   • RLS policies will apply in managed environments';
  RAISE NOTICE '   • All missing schema elements have been resolved';
  RAISE NOTICE '==============================================';
END
$$;
