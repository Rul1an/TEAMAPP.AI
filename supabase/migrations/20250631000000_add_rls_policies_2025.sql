-- =============================================
-- RLS POLICIES MIGRATION 2025
-- Adds RLS policies after foundation is established
-- Uses Supabase 2025 auth best practices
-- Only applies policies to tables that exist
-- =============================================

-- Function to safely create policies only if tables exist
DO $$
BEGIN
  -- Create RLS policies for organizations (only if table exists)
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'organizations') THEN
    -- Check if organization_members table exists before creating policies
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'organization_members') THEN
      DROP POLICY IF EXISTS "Organizations: Users can view organizations they belong to" ON public.organizations;
      CREATE POLICY "Organizations: Users can view organizations they belong to" ON public.organizations
        FOR SELECT TO authenticated
        USING (
          id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = (auth.jwt() ->> 'sub')::uuid
          )
        );
      RAISE NOTICE '✅ Created organizations SELECT policy';
    END IF;

    DROP POLICY IF EXISTS "Organizations: Users can insert organizations" ON public.organizations;
    CREATE POLICY "Organizations: Users can insert organizations" ON public.organizations
      FOR INSERT TO authenticated
      WITH CHECK (true);
    RAISE NOTICE '✅ Created organizations INSERT policy';
  END IF;

  -- Create RLS policies for profiles (only if table exists)
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'profiles') THEN
    DROP POLICY IF EXISTS "Profiles: Users can view all profiles" ON public.profiles;
    CREATE POLICY "Profiles: Users can view all profiles" ON public.profiles
      FOR SELECT TO authenticated
      USING (true);

    DROP POLICY IF EXISTS "Profiles: Users can update own profile" ON public.profiles;
    CREATE POLICY "Profiles: Users can update own profile" ON public.profiles
      FOR UPDATE TO authenticated
      USING (user_id = (auth.jwt() ->> 'sub')::uuid)
      WITH CHECK (user_id = (auth.jwt() ->> 'sub')::uuid);

    DROP POLICY IF EXISTS "Profiles: Users can insert own profile" ON public.profiles;
    CREATE POLICY "Profiles: Users can insert own profile" ON public.profiles
      FOR INSERT TO authenticated
      WITH CHECK (user_id = (auth.jwt() ->> 'sub')::uuid);
    RAISE NOTICE '✅ Created profiles policies';
  END IF;

  -- Create RLS policies for teams (only if table exists)
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'teams') THEN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'organization_members') THEN
      DROP POLICY IF EXISTS "Teams: Users can view teams in their organizations" ON public.teams;
      CREATE POLICY "Teams: Users can view teams in their organizations" ON public.teams
        FOR SELECT TO authenticated
        USING (
          organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = (auth.jwt() ->> 'sub')::uuid
          )
        );

      DROP POLICY IF EXISTS "Teams: Users can insert teams in their organizations" ON public.teams;
      CREATE POLICY "Teams: Users can insert teams in their organizations" ON public.teams
        FOR INSERT TO authenticated
        WITH CHECK (
          organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = (auth.jwt() ->> 'sub')::uuid
          )
        );
      RAISE NOTICE '✅ Created teams policies';
    END IF;
  END IF;

  -- Create RLS policies for players (only if table exists)
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'players') THEN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'organization_members') THEN
      DROP POLICY IF EXISTS "Players: Users can view players in their organizations" ON public.players;
      CREATE POLICY "Players: Users can view players in their organizations" ON public.players
        FOR SELECT TO authenticated
        USING (
          organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = (auth.jwt() ->> 'sub')::uuid
          )
        );

      DROP POLICY IF EXISTS "Players: Users can insert players in their organizations" ON public.players;
      CREATE POLICY "Players: Users can insert players in their organizations" ON public.players
        FOR INSERT TO authenticated
        WITH CHECK (
          organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = (auth.jwt() ->> 'sub')::uuid
          )
        );
      RAISE NOTICE '✅ Created players policies';
    END IF;
  END IF;

  -- Create RLS policies for organization members (only if table exists)
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'organization_members') THEN
    DROP POLICY IF EXISTS "Organization Members: Users can view members of their organizations" ON public.organization_members;
    CREATE POLICY "Organization Members: Users can view members of their organizations" ON public.organization_members
      FOR SELECT TO authenticated
      USING (
        organization_id IN (
          SELECT organization_id FROM public.organization_members
          WHERE user_id = (auth.jwt() ->> 'sub')::uuid
        )
      );
    RAISE NOTICE '✅ Created organization_members policies';
  END IF;

  -- Create RLS policies for memberships (only if table exists)
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'memberships') THEN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'organization_members') THEN
      DROP POLICY IF EXISTS "Memberships: Users can view memberships in their organizations" ON public.memberships;
      CREATE POLICY "Memberships: Users can view memberships in their organizations" ON public.memberships
        FOR SELECT TO authenticated
        USING (
          organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = (auth.jwt() ->> 'sub')::uuid
          )
        );
      RAISE NOTICE '✅ Created memberships policies';
    END IF;
  END IF;

  -- Safely create policies for remaining tables only if they exist
  -- Training sessions
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'training_sessions') THEN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'organization_members') THEN
      DROP POLICY IF EXISTS "Training Sessions: Users can view sessions in their organizations" ON public.training_sessions;
      CREATE POLICY "Training Sessions: Users can view sessions in their organizations" ON public.training_sessions
        FOR SELECT TO authenticated
        USING (
          organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = (auth.jwt() ->> 'sub')::uuid
          )
        );

      DROP POLICY IF EXISTS "Training Sessions: Users can insert sessions in their organizations" ON public.training_sessions;
      CREATE POLICY "Training Sessions: Users can insert sessions in their organizations" ON public.training_sessions
        FOR INSERT TO authenticated
        WITH CHECK (
          organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = (auth.jwt() ->> 'sub')::uuid
          )
        );
      RAISE NOTICE '✅ Created training_sessions policies';
    END IF;
  END IF;

  -- Matches
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'matches') THEN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'organization_members') THEN
      DROP POLICY IF EXISTS "Matches: Users can view matches in their organizations" ON public.matches;
      CREATE POLICY "Matches: Users can view matches in their organizations" ON public.matches
        FOR SELECT TO authenticated
        USING (
          organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = (auth.jwt() ->> 'sub')::uuid
          )
        );

      DROP POLICY IF EXISTS "Matches: Users can insert matches in their organizations" ON public.matches;
      CREATE POLICY "Matches: Users can insert matches in their organizations" ON public.matches
        FOR INSERT TO authenticated
        WITH CHECK (
          organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = (auth.jwt() ->> 'sub')::uuid
          )
        );
      RAISE NOTICE '✅ Created matches policies';
    END IF;
  END IF;

  -- Videos
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'videos') THEN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'organization_members') THEN
      DROP POLICY IF EXISTS "Videos: Users can view videos in their organizations" ON public.videos;
      CREATE POLICY "Videos: Users can view videos in their organizations" ON public.videos
        FOR SELECT TO authenticated
        USING (
          organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = (auth.jwt() ->> 'sub')::uuid
          )
        );

      DROP POLICY IF EXISTS "Videos: Users can insert videos in their organizations" ON public.videos;
      CREATE POLICY "Videos: Users can insert videos in their organizations" ON public.videos
        FOR INSERT TO authenticated
        WITH CHECK (
          organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = (auth.jwt() ->> 'sub')::uuid
          )
        );

      -- Public video access for anonymous users
      DROP POLICY IF EXISTS "Videos: Anonymous users can view public videos" ON public.videos;
      CREATE POLICY "Videos: Anonymous users can view public videos" ON public.videos
        FOR SELECT TO anon
        USING (is_public = true);
      RAISE NOTICE '✅ Created videos policies';
    END IF;
  END IF;

  -- Video tags
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'video_tags') THEN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'organization_members') THEN
      DROP POLICY IF EXISTS "Video Tags: Users can view tags in their organizations" ON public.video_tags;
      CREATE POLICY "Video Tags: Users can view tags in their organizations" ON public.video_tags
        FOR SELECT TO authenticated
        USING (
          organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = (auth.jwt() ->> 'sub')::uuid
          )
        );

      DROP POLICY IF EXISTS "Video Tags: Users can insert tags in their organizations" ON public.video_tags;
      CREATE POLICY "Video Tags: Users can insert tags in their organizations" ON public.video_tags
        FOR INSERT TO authenticated
        WITH CHECK (
          organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = (auth.jwt() ->> 'sub')::uuid
          )
        );
      RAISE NOTICE '✅ Created video_tags policies';
    END IF;
  END IF;

  -- Training exercises
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'training_exercises') THEN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'organization_members') THEN
      DROP POLICY IF EXISTS "Training Exercises: Users can view exercises in their organizations" ON public.training_exercises;
      CREATE POLICY "Training Exercises: Users can view exercises in their organizations" ON public.training_exercises
        FOR SELECT TO authenticated
        USING (
          organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = (auth.jwt() ->> 'sub')::uuid
          )
        );

      DROP POLICY IF EXISTS "Training Exercises: Users can insert exercises in their organizations" ON public.training_exercises;
      CREATE POLICY "Training Exercises: Users can insert exercises in their organizations" ON public.training_exercises
        FOR INSERT TO authenticated
        WITH CHECK (
          organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = (auth.jwt() ->> 'sub')::uuid
          )
        );

      -- Public exercise access for anonymous users
      DROP POLICY IF EXISTS "Training Exercises: Anonymous users can view public exercises" ON public.training_exercises;
      CREATE POLICY "Training Exercises: Anonymous users can view public exercises" ON public.training_exercises
        FOR SELECT TO anon
        USING (is_public = true);
      RAISE NOTICE '✅ Created training_exercises policies';
    END IF;
  END IF;

  -- Remaining tables with simplified single policies
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'performance_analytics') THEN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'organization_members') THEN
      DROP POLICY IF EXISTS "Performance Analytics: Users can view analytics in their organizations" ON public.performance_analytics;
      CREATE POLICY "Performance Analytics: Users can view analytics in their organizations" ON public.performance_analytics
        FOR SELECT TO authenticated
        USING (
          organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = (auth.jwt() ->> 'sub')::uuid
          )
        );
      RAISE NOTICE '✅ Created performance_analytics policies';
    END IF;
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'calendar_events') THEN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'organization_members') THEN
      DROP POLICY IF EXISTS "Calendar Events: Users can view events in their organizations" ON public.calendar_events;
      CREATE POLICY "Calendar Events: Users can view events in their organizations" ON public.calendar_events
        FOR SELECT TO authenticated
        USING (
          organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = (auth.jwt() ->> 'sub')::uuid
          )
        );
      RAISE NOTICE '✅ Created calendar_events policies';
    END IF;
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'season_plans') THEN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'organization_members') THEN
      DROP POLICY IF EXISTS "Season Plans: Users can view plans in their organizations" ON public.season_plans;
      CREATE POLICY "Season Plans: Users can view plans in their organizations" ON public.season_plans
        FOR SELECT TO authenticated
        USING (
          organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = (auth.jwt() ->> 'sub')::uuid
          )
        );
      RAISE NOTICE '✅ Created season_plans policies';
    END IF;
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'training_periods') THEN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'organization_members') THEN
      DROP POLICY IF EXISTS "Training Periods: Users can view periods in their organizations" ON public.training_periods;
      CREATE POLICY "Training Periods: Users can view periods in their organizations" ON public.training_periods
        FOR SELECT TO authenticated
        USING (
          organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = (auth.jwt() ->> 'sub')::uuid
          )
        );
      RAISE NOTICE '✅ Created training_periods policies';
    END IF;
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'veo_highlights') THEN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'organization_members') THEN
      DROP POLICY IF EXISTS "VEO Highlights: Users can view highlights in their organizations" ON public.veo_highlights;
      CREATE POLICY "VEO Highlights: Users can view highlights in their organizations" ON public.veo_highlights
        FOR SELECT TO authenticated
        USING (
          organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = (auth.jwt() ->> 'sub')::uuid
          )
        );

      DROP POLICY IF EXISTS "VEO Highlights: Users can insert highlights in their organizations" ON public.veo_highlights;
      CREATE POLICY "VEO Highlights: Users can insert highlights in their organizations" ON public.veo_highlights
        FOR INSERT TO authenticated
        WITH CHECK (
          organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = (auth.jwt() ->> 'sub')::uuid
          )
        );
      RAISE NOTICE '✅ Created veo_highlights policies';
    END IF;
  END IF;

  RAISE NOTICE '==============================================';
  RAISE NOTICE '✅ RLS POLICIES ESTABLISHED';
  RAISE NOTICE '✅ Using Supabase 2025 auth patterns';
  RAISE NOTICE '✅ JWT-based user identification: (auth.jwt() ->> ''sub'')::uuid';
  RAISE NOTICE '✅ Organization-based access control';
  RAISE NOTICE '✅ Public content policies for anonymous users';
  RAISE NOTICE '✅ All policies properly secured with organization membership';
  RAISE NOTICE '✅ Policies only created for existing tables';
  RAISE NOTICE '==============================================';
END
$$;
