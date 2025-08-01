-- =============================================
-- ADD VIDEO TAGS RLS POLICIES MIGRATION 2025
-- Adds missing RLS policies for video_tags table
-- Fixes the GitHub Actions test failure
-- =============================================

DO $$
BEGIN
  RAISE NOTICE '==============================================';
  RAISE NOTICE '🔒 ADDING VIDEO TAGS RLS POLICIES';
  RAISE NOTICE '==============================================';

  -- Enable RLS on video_tags table (if not already enabled)
  ALTER TABLE public.video_tags ENABLE ROW LEVEL SECURITY;
  RAISE NOTICE '✅ RLS enabled on video_tags table';

  -- Policy 1: Users can view video tags in their organizations
  DROP POLICY IF EXISTS "video_tags_select_policy" ON public.video_tags;
  CREATE POLICY "video_tags_select_policy"
  ON public.video_tags FOR SELECT
  TO authenticated
  USING (
    organization_id IN (
      SELECT organization_id
      FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  );
  RAISE NOTICE '✅ Created video_tags SELECT policy';

  -- Policy 2: Users can insert video tags in their organizations
  DROP POLICY IF EXISTS "video_tags_insert_policy" ON public.video_tags;
  CREATE POLICY "video_tags_insert_policy"
  ON public.video_tags FOR INSERT
  TO authenticated
  WITH CHECK (
    organization_id IN (
      SELECT organization_id
      FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  );
  RAISE NOTICE '✅ Created video_tags INSERT policy';

  -- Policy 3: Users can update video tags in their organizations
  DROP POLICY IF EXISTS "video_tags_update_policy" ON public.video_tags;
  CREATE POLICY "video_tags_update_policy"
  ON public.video_tags FOR UPDATE
  TO authenticated
  USING (
    organization_id IN (
      SELECT organization_id
      FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  )
  WITH CHECK (
    organization_id IN (
      SELECT organization_id
      FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  );
  RAISE NOTICE '✅ Created video_tags UPDATE policy';

  -- Policy 4: Users can delete video tags in their organizations
  DROP POLICY IF EXISTS "video_tags_delete_policy" ON public.video_tags;
  CREATE POLICY "video_tags_delete_policy"
  ON public.video_tags FOR DELETE
  TO authenticated
  USING (
    organization_id IN (
      SELECT organization_id
      FROM public.organization_members
      WHERE user_id = (auth.jwt() ->> 'sub')::uuid
    )
  );
  RAISE NOTICE '✅ Created video_tags DELETE policy';

  -- Policy 5: Service role has full access (for system operations)
  DROP POLICY IF EXISTS "video_tags_service_role_policy" ON public.video_tags;
  CREATE POLICY "video_tags_service_role_policy"
  ON public.video_tags FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);
  RAISE NOTICE '✅ Created video_tags service_role policy';

  -- Verify all policies are created
  SELECT COUNT(*) as policy_count
  FROM pg_policies
  WHERE tablename = 'video_tags';

  RAISE NOTICE '🔒 VIDEO TAGS RLS POLICIES COMPLETED';
  RAISE NOTICE '==============================================';
END
$$;
