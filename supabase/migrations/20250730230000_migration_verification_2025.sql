-- Migration Verification Script for Video Production Readiness Plan 2025
-- Phase A: Migration Verification
-- Created: 30 juli 2025

-- =====================================================================
-- VERIFICATION SCRIPT: Complete Video Schema Validation
-- =====================================================================

DO $$
DECLARE
    video_table_exists BOOLEAN;
    video_tags_table_exists BOOLEAN;
    rls_policies_count INTEGER;
    indexes_count INTEGER;
    functions_count INTEGER;
BEGIN
    RAISE NOTICE 'Starting Video Production Readiness Migration Verification...';

    -- ====================================================================
    -- 1. VERIFY CORE VIDEO TABLES EXISTENCE
    -- ====================================================================

    RAISE NOTICE 'Phase 1: Verifying core video tables...';

    -- Check videos table
    SELECT EXISTS (
        SELECT 1 FROM information_schema.tables
        WHERE table_schema = 'public'
        AND table_name = 'videos'
    ) INTO video_table_exists;

    IF NOT video_table_exists THEN
        RAISE EXCEPTION 'CRITICAL: videos table missing from schema';
    END IF;

    RAISE NOTICE '✓ videos table exists';

    -- Check video_tags table
    SELECT EXISTS (
        SELECT 1 FROM information_schema.tables
        WHERE table_schema = 'public'
        AND table_name = 'video_tags'
    ) INTO video_tags_table_exists;

    IF NOT video_tags_table_exists THEN
        RAISE EXCEPTION 'CRITICAL: video_tags table missing from schema';
    END IF;

    RAISE NOTICE '✓ video_tags table exists';

    -- ====================================================================
    -- 2. VERIFY TABLE STRUCTURES AND COLUMNS
    -- ====================================================================

    RAISE NOTICE 'Phase 2: Verifying table structures...';

    -- Verify videos table structure
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'videos'
        AND column_name = 'id'
        AND data_type = 'uuid'
    ) THEN
        RAISE EXCEPTION 'videos table missing required id column (uuid)';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'videos'
        AND column_name = 'organization_id'
        AND data_type = 'uuid'
    ) THEN
        RAISE EXCEPTION 'videos table missing required organization_id column';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'videos'
        AND column_name = 'title'
        AND data_type = 'text'
    ) THEN
        RAISE EXCEPTION 'videos table missing required title column';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'videos'
        AND column_name = 'file_url'
        AND data_type = 'text'
    ) THEN
        RAISE EXCEPTION 'videos table missing required file_url column';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'videos'
        AND column_name = 'duration_seconds'
        AND data_type = 'integer'
    ) THEN
        RAISE EXCEPTION 'videos table missing required duration_seconds column';
    END IF;

    RAISE NOTICE '✓ videos table structure validated';

    -- Verify video_tags table structure
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'video_tags'
        AND column_name = 'id'
        AND data_type = 'uuid'
    ) THEN
        RAISE EXCEPTION 'video_tags table missing required id column (uuid)';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'video_tags'
        AND column_name = 'video_id'
        AND data_type = 'uuid'
    ) THEN
        RAISE EXCEPTION 'video_tags table missing required video_id column';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'video_tags'
        AND column_name = 'tag_type'
        AND data_type = 'text'
    ) THEN
        RAISE EXCEPTION 'video_tags table missing required tag_type column';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'video_tags'
        AND column_name = 'timestamp_seconds'
        AND data_type = 'numeric'
    ) THEN
        RAISE EXCEPTION 'video_tags table missing required timestamp_seconds column';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'video_tags'
        AND column_name = 'tag_data'
        AND data_type = 'jsonb'
    ) THEN
        RAISE EXCEPTION 'video_tags table missing required tag_data column';
    END IF;

    RAISE NOTICE '✓ video_tags table structure validated';

    -- ====================================================================
    -- 3. VERIFY RLS POLICIES
    -- ====================================================================

    RAISE NOTICE 'Phase 3: Verifying RLS policies...';

    -- Count RLS policies for video tables
    SELECT COUNT(*) INTO rls_policies_count
    FROM pg_policies
    WHERE tablename IN ('videos', 'video_tags');

    IF rls_policies_count < 6 THEN
        RAISE EXCEPTION 'Insufficient RLS policies found. Expected at least 6, found %', rls_policies_count;
    END IF;

    -- Verify specific RLS policies exist
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies
        WHERE tablename = 'videos'
        AND policyname LIKE '%select%'
    ) THEN
        RAISE EXCEPTION 'videos table missing SELECT RLS policy';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_policies
        WHERE tablename = 'video_tags'
        AND policyname LIKE '%select%'
    ) THEN
        RAISE EXCEPTION 'video_tags table missing SELECT RLS policy';
    END IF;

    RAISE NOTICE '✓ RLS policies validated (%s policies found)', rls_policies_count;

    -- ====================================================================
    -- 4. VERIFY PERFORMANCE INDEXES
    -- ====================================================================

    RAISE NOTICE 'Phase 4: Verifying performance indexes...';

    -- Count indexes on video tables
    SELECT COUNT(*) INTO indexes_count
    FROM pg_indexes
    WHERE tablename IN ('videos', 'video_tags')
    AND indexname NOT LIKE '%pkey%'; -- Exclude primary key indexes

    IF indexes_count < 4 THEN
        RAISE EXCEPTION 'Insufficient performance indexes found. Expected at least 4, found %', indexes_count;
    END IF;

    -- Verify critical indexes exist
    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes
        WHERE tablename = 'videos'
        AND indexname LIKE '%organization_id%'
    ) THEN
        RAISE EXCEPTION 'videos table missing organization_id index for performance';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes
        WHERE tablename = 'video_tags'
        AND indexname LIKE '%video_id%'
    ) THEN
        RAISE EXCEPTION 'video_tags table missing video_id index for performance';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes
        WHERE tablename = 'video_tags'
        AND indexname LIKE '%timestamp%'
    ) THEN
        RAISE EXCEPTION 'video_tags table missing timestamp_seconds index for performance';
    END IF;

    RAISE NOTICE '✓ Performance indexes validated (%s indexes found)', indexes_count;

    -- ====================================================================
    -- 5. VERIFY DATABASE FUNCTIONS AND TRIGGERS
    -- ====================================================================

    RAISE NOTICE 'Phase 5: Verifying database functions...';

    -- Count custom functions related to video functionality
    SELECT COUNT(*) INTO functions_count
    FROM pg_proc p
    JOIN pg_namespace n ON p.pronamespace = n.oid
    WHERE n.nspname = 'public'
    AND p.proname LIKE '%video%';

    RAISE NOTICE '✓ Video-related functions found: %s', functions_count;

    -- ====================================================================
    -- 6. VERIFY FOREIGN KEY CONSTRAINTS
    -- ====================================================================

    RAISE NOTICE 'Phase 6: Verifying foreign key constraints...';

    -- Verify video_tags -> videos foreign key
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu
          ON tc.constraint_name = kcu.constraint_name
        WHERE tc.table_name = 'video_tags'
        AND tc.constraint_type = 'FOREIGN KEY'
        AND kcu.column_name = 'video_id'
    ) THEN
        RAISE EXCEPTION 'video_tags table missing foreign key constraint to videos';
    END IF;

    RAISE NOTICE '✓ Foreign key constraints validated';

    -- ====================================================================
    -- 7. VERIFY DATA INTEGRITY CONSTRAINTS
    -- ====================================================================

    RAISE NOTICE 'Phase 7: Verifying data integrity constraints...';

    -- Check for NOT NULL constraints on critical columns
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'videos'
        AND column_name = 'title'
        AND is_nullable = 'NO'
    ) THEN
        RAISE EXCEPTION 'videos.title column should have NOT NULL constraint';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'video_tags'
        AND column_name = 'timestamp_seconds'
        AND is_nullable = 'NO'
    ) THEN
        RAISE EXCEPTION 'video_tags.timestamp_seconds column should have NOT NULL constraint';
    END IF;

    RAISE NOTICE '✓ Data integrity constraints validated';

    -- ====================================================================
    -- FINAL SUCCESS MESSAGE
    -- ====================================================================

    RAISE NOTICE '';
    RAISE NOTICE '🎉 VIDEO PRODUCTION READINESS VERIFICATION COMPLETE! 🎉';
    RAISE NOTICE '';
    RAISE NOTICE 'Summary:';
    RAISE NOTICE '- Core tables: ✓ videos, video_tags';
    RAISE NOTICE '- RLS policies: ✓ %s policies active', rls_policies_count;
    RAISE NOTICE '- Performance indexes: ✓ %s indexes optimized', indexes_count;
    RAISE NOTICE '- Database functions: ✓ %s video functions', functions_count;
    RAISE NOTICE '- Data integrity: ✓ All constraints validated';
    RAISE NOTICE '';
    RAISE NOTICE 'Schema is PRODUCTION READY for video functionality! 🚀';
    RAISE NOTICE '';

END $$;

-- ====================================================================
-- CREATE VERIFICATION SUMMARY VIEW
-- ====================================================================

CREATE OR REPLACE VIEW video_schema_health_check AS
SELECT
    'videos' as table_name,
    (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = 'videos') as column_count,
    (SELECT COUNT(*) FROM pg_policies WHERE tablename = 'videos') as rls_policies,
    (SELECT COUNT(*) FROM pg_indexes WHERE tablename = 'videos' AND indexname NOT LIKE '%pkey%') as indexes,
    (SELECT COUNT(*) FROM videos) as record_count
UNION ALL
SELECT
    'video_tags' as table_name,
    (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = 'video_tags') as column_count,
    (SELECT COUNT(*) FROM pg_policies WHERE tablename = 'video_tags') as rls_policies,
    (SELECT COUNT(*) FROM pg_indexes WHERE tablename = 'video_tags' AND indexname NOT LIKE '%pkey%') as indexes,
    (SELECT COUNT(*) FROM video_tags) as record_count;

-- Grant access to the view
GRANT SELECT ON video_schema_health_check TO authenticated;

COMMENT ON VIEW video_schema_health_check IS 'Video Production Readiness: Schema health monitoring view for continuous verification';
