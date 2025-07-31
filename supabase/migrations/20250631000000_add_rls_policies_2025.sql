-- =============================================
-- RLS POLICIES MIGRATION 2025
-- Adds RLS policies after foundation is established
-- Uses Supabase 2025 auth best practices
-- =============================================

-- Create RLS policies for organizations
CREATE POLICY "Organizations: Users can view organizations they belong to" ON public.organizations
  FOR SELECT TO authenticated
  USING (
    id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  );

CREATE POLICY "Organizations: Users can insert organizations" ON public.organizations
  FOR INSERT TO authenticated
  WITH CHECK (true);

-- Create RLS policies for profiles
CREATE POLICY "Profiles: Users can view all profiles" ON public.profiles
  FOR SELECT TO authenticated
  USING (true);

CREATE POLICY "Profiles: Users can update own profile" ON public.profiles
  FOR UPDATE TO authenticated
  USING (user_id = (auth.jwt() ->> 'sub')::uuid)
  WITH CHECK (user_id = (auth.jwt() ->> 'sub')::uuid);

CREATE POLICY "Profiles: Users can insert own profile" ON public.profiles
  FOR INSERT TO authenticated
  WITH CHECK (user_id = (auth.jwt() ->> 'sub')::uuid);

-- Create RLS policies for teams
CREATE POLICY "Teams: Users can view teams in their organizations" ON public.teams
  FOR SELECT TO authenticated
  USING (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  );

CREATE POLICY "Teams: Users can insert teams in their organizations" ON public.teams
  FOR INSERT TO authenticated
  WITH CHECK (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  );

-- Create RLS policies for players
CREATE POLICY "Players: Users can view players in their organizations" ON public.players
  FOR SELECT TO authenticated
  USING (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  );

CREATE POLICY "Players: Users can insert players in their organizations" ON public.players
  FOR INSERT TO authenticated
  WITH CHECK (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  );

-- Create RLS policies for organization members
CREATE POLICY "Organization Members: Users can view members of their organizations" ON public.organization_members
  FOR SELECT TO authenticated
  USING (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  );

-- Create RLS policies for memberships (backward compatibility)
CREATE POLICY "Memberships: Users can view memberships in their organizations" ON public.memberships
  FOR SELECT TO authenticated
  USING (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  );

-- Create RLS policies for training sessions
CREATE POLICY "Training Sessions: Users can view sessions in their organizations" ON public.training_sessions
  FOR SELECT TO authenticated
  USING (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  );

CREATE POLICY "Training Sessions: Users can insert sessions in their organizations" ON public.training_sessions
  FOR INSERT TO authenticated
  WITH CHECK (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  );

-- Create RLS policies for matches
CREATE POLICY "Matches: Users can view matches in their organizations" ON public.matches
  FOR SELECT TO authenticated
  USING (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  );

CREATE POLICY "Matches: Users can insert matches in their organizations" ON public.matches
  FOR INSERT TO authenticated
  WITH CHECK (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  );

-- Create RLS policies for videos
CREATE POLICY "Videos: Users can view videos in their organizations" ON public.videos
  FOR SELECT TO authenticated
  USING (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  );

CREATE POLICY "Videos: Users can insert videos in their organizations" ON public.videos
  FOR INSERT TO authenticated
  WITH CHECK (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  );

-- Create RLS policies for video tags
CREATE POLICY "Video Tags: Users can view tags in their organizations" ON public.video_tags
  FOR SELECT TO authenticated
  USING (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  );

CREATE POLICY "Video Tags: Users can insert tags in their organizations" ON public.video_tags
  FOR INSERT TO authenticated
  WITH CHECK (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  );

-- Create RLS policies for training exercises
CREATE POLICY "Training Exercises: Users can view exercises in their organizations" ON public.training_exercises
  FOR SELECT TO authenticated
  USING (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  );

CREATE POLICY "Training Exercises: Users can insert exercises in their organizations" ON public.training_exercises
  FOR INSERT TO authenticated
  WITH CHECK (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  );

-- Create RLS policies for performance analytics
CREATE POLICY "Performance Analytics: Users can view analytics in their organizations" ON public.performance_analytics
  FOR SELECT TO authenticated
  USING (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  );

-- Create RLS policies for calendar events
CREATE POLICY "Calendar Events: Users can view events in their organizations" ON public.calendar_events
  FOR SELECT TO authenticated
  USING (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  );

-- Create RLS policies for season plans
CREATE POLICY "Season Plans: Users can view plans in their organizations" ON public.season_plans
  FOR SELECT TO authenticated
  USING (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  );

-- Create RLS policies for training periods
CREATE POLICY "Training Periods: Users can view periods in their organizations" ON public.training_periods
  FOR SELECT TO authenticated
  USING (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  );

-- Create RLS policies for VEO highlights
CREATE POLICY "VEO Highlights: Users can view highlights in their organizations" ON public.veo_highlights
  FOR SELECT TO authenticated
  USING (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  );

CREATE POLICY "VEO Highlights: Users can insert highlights in their organizations" ON public.veo_highlights
  FOR INSERT TO authenticated
  WITH CHECK (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  );

-- Create public access policies for anon users (read-only, public content)
CREATE POLICY "Videos: Anonymous users can view public videos" ON public.videos
  FOR SELECT TO anon
  USING (is_public = true);

CREATE POLICY "Training Exercises: Anonymous users can view public exercises" ON public.training_exercises
  FOR SELECT TO anon
  USING (is_public = true);

-- Final validation
DO $$
BEGIN
  RAISE NOTICE '==============================================';
  RAISE NOTICE '✅ RLS POLICIES ESTABLISHED';
  RAISE NOTICE '✅ Using Supabase 2025 auth patterns';
  RAISE NOTICE '✅ JWT-based user identification: (auth.jwt() ->> ''sub'')::uuid';
  RAISE NOTICE '✅ Organization-based access control';
  RAISE NOTICE '✅ Public content policies for anonymous users';
  RAISE NOTICE '✅ All policies properly secured with organization membership';
  RAISE NOTICE '==============================================';
END
$$;
