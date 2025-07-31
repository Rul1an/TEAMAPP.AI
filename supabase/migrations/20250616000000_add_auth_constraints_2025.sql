-- =============================================
-- ADD AUTH CONSTRAINTS MIGRATION 2025
-- Adds foreign key constraints to auth.users after auth schema exists
-- Only runs if auth schema and auth.users table exist
-- =============================================

-- Check if auth schema exists and add constraints if it does
DO $$
BEGIN
  -- Check if auth schema exists
  IF EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'auth') THEN
    RAISE NOTICE '✅ Auth schema found, proceeding with constraint addition';

    -- Check if auth.users table exists
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'auth' AND table_name = 'users') THEN
      RAISE NOTICE '✅ Auth.users table found, adding foreign key constraints';

      -- Add foreign key constraints to tables that reference auth.users

      -- Profiles table
      IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints
                    WHERE constraint_name = 'profiles_user_id_fkey'
                    AND table_name = 'profiles') THEN
        ALTER TABLE public.profiles
        ADD CONSTRAINT profiles_user_id_fkey
        FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;
        RAISE NOTICE '✅ Added profiles.user_id foreign key constraint';
      END IF;

      -- Organization members table
      IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints
                    WHERE constraint_name = 'organization_members_user_id_fkey'
                    AND table_name = 'organization_members') THEN
        ALTER TABLE public.organization_members
        ADD CONSTRAINT organization_members_user_id_fkey
        FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;
        RAISE NOTICE '✅ Added organization_members.user_id foreign key constraint';
      END IF;

      -- Memberships table
      IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints
                    WHERE constraint_name = 'memberships_user_id_fkey'
                    AND table_name = 'memberships') THEN
        ALTER TABLE public.memberships
        ADD CONSTRAINT memberships_user_id_fkey
        FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;
        RAISE NOTICE '✅ Added memberships.user_id foreign key constraint';
      END IF;

      -- Videos table
      IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints
                    WHERE constraint_name = 'videos_created_by_fkey'
                    AND table_name = 'videos') THEN
        ALTER TABLE public.videos
        ADD CONSTRAINT videos_created_by_fkey
        FOREIGN KEY (created_by) REFERENCES auth.users(id) ON DELETE SET NULL;
        RAISE NOTICE '✅ Added videos.created_by foreign key constraint';
      END IF;

      -- Video tags table
      IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints
                    WHERE constraint_name = 'video_tags_created_by_fkey'
                    AND table_name = 'video_tags') THEN
        ALTER TABLE public.video_tags
        ADD CONSTRAINT video_tags_created_by_fkey
        FOREIGN KEY (created_by) REFERENCES auth.users(id) ON DELETE SET NULL;
        RAISE NOTICE '✅ Added video_tags.created_by foreign key constraint';
      END IF;

      -- Training exercises table
      IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints
                    WHERE constraint_name = 'training_exercises_created_by_fkey'
                    AND table_name = 'training_exercises') THEN
        ALTER TABLE public.training_exercises
        ADD CONSTRAINT training_exercises_created_by_fkey
        FOREIGN KEY (created_by) REFERENCES auth.users(id) ON DELETE SET NULL;
        RAISE NOTICE '✅ Added training_exercises.created_by foreign key constraint';
      END IF;

      -- VEO highlights table
      IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints
                    WHERE constraint_name = 'veo_highlights_created_by_fkey'
                    AND table_name = 'veo_highlights') THEN
        ALTER TABLE public.veo_highlights
        ADD CONSTRAINT veo_highlights_created_by_fkey
        FOREIGN KEY (created_by) REFERENCES auth.users(id) ON DELETE SET NULL;
        RAISE NOTICE '✅ Added veo_highlights.created_by foreign key constraint';
      END IF;

    ELSE
      RAISE NOTICE 'ℹ️ Auth.users table not found - foreign key constraints will be added later';
    END IF;

  ELSE
    RAISE NOTICE 'ℹ️ Auth schema not found - foreign key constraints will be added later';
  END IF;

  RAISE NOTICE '==============================================';
  RAISE NOTICE '✅ AUTH CONSTRAINTS MIGRATION COMPLETED';
  RAISE NOTICE 'ℹ️ Constraints added only if auth schema exists';
  RAISE NOTICE 'ℹ️ Safe to run multiple times';
  RAISE NOTICE '==============================================';
END
$$;
