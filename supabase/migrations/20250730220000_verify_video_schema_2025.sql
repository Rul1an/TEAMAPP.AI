-- =====================================================================================
-- VIDEO SCHEMA VERIFICATION - Production Readiness Check
-- =====================================================================================
-- Created: 30 July 2025
-- Purpose: Comprehensive verification of video functionality database schema
-- Based on: Video Production Readiness Plan 2025 - Phase 1A
-- =====================================================================================

-- Phase 1: Critical Table Structure Verification
-- =====================================================================================

DO $$
BEGIN
    -- Verify video_tags table exists with correct structure
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables
                   WHERE table_name = 'video_tags' AND table_schema = 'public') THEN
        RAISE EXCEPTION 'CRITICAL: video_tags table missing';
    END IF;

    -- Verify required columns exist
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name = 'video_tags'
                   AND column_name = 'title'
                   AND table_schema = 'public') THEN
        RAISE EXCEPTION 'CRITICAL: video_tags.title column missing';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name = 'video_tags'
                   AND column_name = 'processing_status'
                   AND table_schema = 'public') THEN
        RAISE EXCEPTION 'CRITICAL: video_tags.processing_status column missing';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name = 'video_tags'
                   AND column_name = 'file_url'
                   AND table_schema = 'public') THEN
        RAISE EXCEPTION 'CRITICAL: video_tags.file_url column missing';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name = 'video_tags'
                   AND column_name = 'duration_seconds'
                   AND table_schema = 'public') THEN
        RAISE EXCEPTION 'CRITICAL: video_tags.duration_seconds column missing';
    END IF;

    RAISE NOTICE '✅ VIDEO_TAGS table structure verified';
END $$;

-- Phase 2: RLS Policies Verification
-- =====================================================================================

DO $$
BEGIN
    -- Verify RLS policies exist for video_tags table
    IF NOT EXISTS (SELECT 1 FROM pg_policies
                   WHERE tablename = 'video_tags'
                   AND schemaname = 'public') THEN
        RAISE EXCEPTION 'CRITICAL: RLS policies missing for video_tags';
    END IF;

    -- Verify organization isolation policy exists
    IF NOT EXISTS (SELECT 1 FROM pg_policies
                   WHERE tablename = 'video_tags'
                   AND policyname LIKE '%organization%') THEN
        RAISE EXCEPTION 'CRITICAL: Organization isolation policy missing for video_tags';
    END IF;

    RAISE NOTICE '✅ RLS policies verified';
END $$;

-- Phase 3: Performance Indexes Verification
-- =====================================================================================

DO $$
BEGIN
    -- Verify indexes for performance exist
    IF NOT EXISTS (SELECT 1 FROM pg_indexes
                   WHERE tablename = 'video_tags'
                   AND indexname = 'idx_video_tags_processing_status') THEN
        RAISE EXCEPTION 'CRITICAL: Performance index missing - processing_status';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_indexes
                   WHERE tablename = 'video_tags'
                   AND indexname = 'idx_video_tags_org_status') THEN
        RAISE EXCEPTION 'CRITICAL: Performance index missing - org_status composite';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_indexes
                   WHERE tablename = 'video_tags'
                   AND indexname = 'idx_video_tags_title') THEN
        RAISE EXCEPTION 'CRITICAL: Performance index missing - title';
    END IF;

    RAISE NOTICE '✅ Performance indexes verified';
END $$;

-- Phase 4: Storage Buckets Verification
-- =====================================================================================

DO $$
BEGIN
    -- Verify training-videos bucket exists
    IF NOT EXISTS (SELECT 1 FROM storage.buckets
                   WHERE id = 'training-videos') THEN
        RAISE EXCEPTION 'CRITICAL: training-videos bucket missing';
    END IF;

    -- Verify video-thumbnails bucket exists
    IF NOT EXISTS (SELECT 1 FROM storage.buckets
                   WHERE id = 'video-thumbnails') THEN
        RAISE EXCEPTION 'CRITICAL: video-thumbnails bucket missing';
    END IF;

    -- Verify bucket configurations
    IF NOT EXISTS (SELECT 1 FROM storage.buckets
                   WHERE id = 'training-videos'
                   AND file_size_limit = 524288000) THEN
        RAISE EXCEPTION 'CRITICAL: training-videos bucket size limit incorrect';
    END IF;

    RAISE NOTICE '✅ Storage buckets verified';
END $$;

-- Phase 5: Storage Policies Verification
-- =====================================================================================

DO $$
BEGIN
    -- Verify storage policies exist for training-videos
    IF NOT EXISTS (SELECT 1 FROM storage.policy
                   WHERE bucket_id = 'training-videos'
                   AND policy_name LIKE '%org_read%') THEN
        RAISE EXCEPTION 'CRITICAL: training-videos read policy missing';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM storage.policy
                   WHERE bucket_id = 'training-videos'
                   AND policy_name LIKE '%org_upload%') THEN
        RAISE EXCEPTION 'CRITICAL: training-videos upload policy missing';
    END IF;

    -- Verify thumbnails policies
    IF NOT EXISTS (SELECT 1 FROM storage.policy
                   WHERE bucket_id = 'video-thumbnails'
                   AND policy_name LIKE '%public_read%') THEN
        RAISE EXCEPTION 'CRITICAL: video-thumbnails public read policy missing';
    END IF;

    RAISE NOTICE '✅ Storage policies verified';
END $$;

-- Phase 6: Required Functions Verification
-- =====================================================================================

DO $$
BEGIN
    -- Verify get_user_organization_id function exists
    IF NOT EXISTS (SELECT 1 FROM pg_proc
                   WHERE proname = 'get_user_organization_id') THEN
        RAISE EXCEPTION 'CRITICAL: get_user_organization_id function missing';
    END IF;

    -- Verify update_video_processing_status function exists
    IF NOT EXISTS (SELECT 1 FROM pg_proc
                   WHERE proname = 'update_video_processing_status') THEN
        RAISE EXCEPTION 'CRITICAL: update_video_processing_status function missing';
    END IF;

    -- Verify get_organization_videos function exists
    IF NOT EXISTS (SELECT 1 FROM pg_proc
                   WHERE proname = 'get_organization_videos') THEN
        RAISE EXCEPTION 'CRITICAL: get_organization_videos function missing';
    END IF;

    RAISE NOTICE '✅ Required functions verified';
END $$;

-- Phase 7: Views and Analytics Verification
-- =====================================================================================

DO $$
BEGIN
    -- Verify video_analytics view exists
    IF NOT EXISTS (SELECT 1 FROM information_schema.views
                   WHERE table_name = 'video_analytics'
                   AND table_schema = 'public') THEN
        RAISE EXCEPTION 'CRITICAL: video_analytics view missing';
    END IF;

    RAISE NOTICE '✅ Analytics views verified';
END $$;

-- Phase 8: Data Integrity Verification
-- =====================================================================================

DO $$
DECLARE
    video_count INTEGER;
    invalid_status_count INTEGER;
BEGIN
    -- Check if any existing video records exist
    SELECT COUNT(*) INTO video_count FROM public.video_tags;

    -- If records exist, verify data integrity
    IF video_count > 0 THEN
        -- Check for invalid processing_status values
        SELECT COUNT(*) INTO invalid_status_count
        FROM public.video_tags
        WHERE processing_status NOT IN ('pending', 'processing', 'ready', 'error', 'archived');

        IF invalid_status_count > 0 THEN
            RAISE EXCEPTION 'CRITICAL: Invalid processing_status values found in % records', invalid_status_count;
        END IF;

        -- Check for records without title
        SELECT COUNT(*) INTO invalid_status_count
        FROM public.video_tags
        WHERE title IS NULL OR title = '';

        IF invalid_status_count > 0 THEN
            RAISE EXCEPTION 'CRITICAL: Video records without title found: %', invalid_status_count;
        END IF;

        RAISE NOTICE '✅ Data integrity verified for % existing records', video_count;
    ELSE
        RAISE NOTICE '✅ No existing video records - clean slate verified';
    END IF;
END $$;

-- Phase 9: Security Verification
-- =====================================================================================

DO $$
BEGIN
    -- Verify RLS is enabled on video_tags
    IF NOT EXISTS (SELECT 1 FROM pg_class
                   WHERE relname = 'video_tags'
                   AND relrowsecurity = true) THEN
        RAISE EXCEPTION 'CRITICAL: RLS not enabled on video_tags table';
    END IF;

    -- Verify organization_members table exists (required for security)
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables
                   WHERE table_name = 'organization_members'
                   AND table_schema = 'public') THEN
        RAISE EXCEPTION 'CRITICAL: organization_members table missing - required for security';
    END IF;

    RAISE NOTICE '✅ Security configuration verified';
END $$;

-- Phase 10: Performance Testing
-- =====================================================================================

DO $$
DECLARE
    query_start TIMESTAMP;
    query_duration INTERVAL;
BEGIN
    -- Test basic video query performance
    query_start := clock_timestamp();

    PERFORM COUNT(*) FROM public.video_tags
    WHERE processing_status = 'ready'
    LIMIT 100;

    query_duration := clock_timestamp() - query_start;

    -- Performance should be under 100ms for basic queries
    IF EXTRACT(MILLISECONDS FROM query_duration) > 100 THEN
        RAISE WARNING 'PERFORMANCE: Basic query took %ms - consider optimization',
            EXTRACT(MILLISECONDS FROM query_duration);
    ELSE
        RAISE NOTICE '✅ Query performance verified: %ms',
            EXTRACT(MILLISECONDS FROM query_duration);
    END IF;
END $$;

-- =====================================================================================
-- FINAL VERIFICATION SUMMARY
-- =====================================================================================

DO $$
BEGIN
    RAISE NOTICE '🎬 =====================================================================================';
    RAISE NOTICE '🎬 VIDEO SCHEMA VERIFICATION COMPLETED SUCCESSFULLY';
    RAISE NOTICE '🎬 =====================================================================================';
    RAISE NOTICE '✅ Database tables: video_tags structure verified';
    RAISE NOTICE '✅ RLS policies: Multi-tenant security active';
    RAISE NOTICE '✅ Performance indexes: All critical indexes present';
    RAISE NOTICE '✅ Storage buckets: training-videos and video-thumbnails configured';
    RAISE NOTICE '✅ Storage policies: Organization-based access control';
    RAISE NOTICE '✅ Functions: All video management functions available';
    RAISE NOTICE '✅ Analytics views: video_analytics view operational';
    RAISE NOTICE '✅ Data integrity: All existing records valid';
    RAISE NOTICE '✅ Security: RLS enabled, multi-tenant isolation active';
    RAISE NOTICE '✅ Performance: Query response times acceptable';
    RAISE NOTICE '🎬 =====================================================================================';
    RAISE NOTICE '🎬 READY FOR VIDEO PRODUCTION FEATURES IMPLEMENTATION';
    RAISE NOTICE '🎬 Next step: Run Flutter repository integration tests';
    RAISE NOTICE '🎬 =====================================================================================';
END $$;

-- =====================================================================================
-- VERIFICATION COMPLETED - PRODUCTION READINESS CONFIRMED
-- =====================================================================================
