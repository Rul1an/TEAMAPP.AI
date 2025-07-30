-- =====================================================================================
-- VIDEO FEATURES EXTENSION - Phase 1 Implementation
-- =====================================================================================
-- Created: 30 July 2025
-- Purpose: Extend existing video_tags table for full video functionality
-- Based on: Video Features Implementation Plan 2025
-- =====================================================================================

-- Phase 1: Extend Video_Tags Table for Full Video Management
-- =====================================================================================

-- Add missing video metadata fields to existing video_tags table
ALTER TABLE public.video_tags ADD COLUMN IF NOT EXISTS
  title TEXT NOT NULL DEFAULT 'Untitled Video';

ALTER TABLE public.video_tags ADD COLUMN IF NOT EXISTS
  description TEXT;

ALTER TABLE public.video_tags ADD COLUMN IF NOT EXISTS
  duration_seconds INTEGER DEFAULT 0;

ALTER TABLE public.video_tags ADD COLUMN IF NOT EXISTS
  file_size_bytes BIGINT DEFAULT 0;

ALTER TABLE public.video_tags ADD COLUMN IF NOT EXISTS
  resolution_width INTEGER DEFAULT 0;

ALTER TABLE public.video_tags ADD COLUMN IF NOT EXISTS
  resolution_height INTEGER DEFAULT 0;

ALTER TABLE public.video_tags ADD COLUMN IF NOT EXISTS
  encoding_format TEXT DEFAULT 'mp4';

ALTER TABLE public.video_tags ADD COLUMN IF NOT EXISTS
  processing_status TEXT DEFAULT 'pending'
  CHECK (processing_status IN ('pending', 'processing', 'ready', 'error', 'archived'));

ALTER TABLE public.video_tags ADD COLUMN IF NOT EXISTS
  processing_error TEXT;

ALTER TABLE public.video_tags ADD COLUMN IF NOT EXISTS
  thumbnail_url TEXT;

ALTER TABLE public.video_tags ADD COLUMN IF NOT EXISTS
  file_url TEXT; -- For consistency with plan naming

-- Update video_url to be nullable (we'll use file_url going forward)
ALTER TABLE public.video_tags ALTER COLUMN video_url DROP NOT NULL;

-- Phase 2: Enhanced Storage Bucket Configuration
-- =====================================================================================

-- Update videos bucket with enhanced configuration
UPDATE storage.buckets
SET
  file_size_limit = 524288000, -- 500MB limit for training videos
  allowed_mime_types = ARRAY['video/mp4', 'video/quicktime', 'video/x-msvideo', 'video/webm']
WHERE id = 'videos';

-- Create training-videos bucket for better organization
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'training-videos',
  'training-videos',
  false, -- Private for security
  524288000, -- 500MB max per video
  ARRAY['video/mp4', 'video/quicktime', 'video/x-msvideo', 'video/webm']
) ON CONFLICT (id) DO UPDATE SET
  file_size_limit = EXCLUDED.file_size_limit,
  allowed_mime_types = EXCLUDED.allowed_mime_types;

-- Create thumbnails bucket for video thumbnails
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'video-thumbnails',
  'video-thumbnails',
  true, -- Public for fast loading
  5242880, -- 5MB limit for thumbnails
  ARRAY['image/jpeg', 'image/png', 'image/webp']
) ON CONFLICT (id) DO NOTHING;

-- Phase 3: Enhanced Performance Indexes
-- =====================================================================================

-- Add indexes for new video fields
CREATE INDEX IF NOT EXISTS idx_video_tags_title ON public.video_tags (title);
CREATE INDEX IF NOT EXISTS idx_video_tags_processing_status ON public.video_tags (processing_status);
CREATE INDEX IF NOT EXISTS idx_video_tags_duration ON public.video_tags (duration_seconds);
CREATE INDEX IF NOT EXISTS idx_video_tags_file_size ON public.video_tags (file_size_bytes);

-- Composite indexes for common queries
CREATE INDEX IF NOT EXISTS idx_video_tags_org_status ON public.video_tags (organization_id, processing_status);
CREATE INDEX IF NOT EXISTS idx_video_tags_org_created ON public.video_tags (organization_id, created_at DESC);

-- Phase 4: Storage Policies for New Buckets
-- =====================================================================================

-- Training Videos Storage Policies (Organization-based access)
CREATE POLICY "training_videos_org_read" ON storage.objects
  FOR SELECT TO authenticated
  USING (
    bucket_id = 'training-videos' AND
    (storage.foldername(name))[1] IN (
      SELECT organization_id::text
      FROM organization_members
      WHERE user_id = (SELECT auth.uid())
    )
  );

CREATE POLICY "training_videos_org_upload" ON storage.objects
  FOR INSERT TO authenticated
  WITH CHECK (
    bucket_id = 'training-videos' AND
    (storage.foldername(name))[1] IN (
      SELECT organization_id::text
      FROM organization_members
      WHERE user_id = (SELECT auth.uid())
    )
  );

CREATE POLICY "training_videos_org_update" ON storage.objects
  FOR UPDATE TO authenticated
  USING (
    bucket_id = 'training-videos' AND
    (storage.foldername(name))[1] IN (
      SELECT organization_id::text
      FROM organization_members
      WHERE user_id = (SELECT auth.uid())
    )
  )
  WITH CHECK (
    bucket_id = 'training-videos' AND
    (storage.foldername(name))[1] IN (
      SELECT organization_id::text
      FROM organization_members
      WHERE user_id = (SELECT auth.uid())
    )
  );

CREATE POLICY "training_videos_org_delete" ON storage.objects
  FOR DELETE TO authenticated
  USING (
    bucket_id = 'training-videos' AND
    (storage.foldername(name))[1] IN (
      SELECT organization_id::text
      FROM organization_members
      WHERE user_id = (SELECT auth.uid())
    )
  );

-- Video Thumbnails Storage Policies (Public read, org write)
CREATE POLICY "thumbnails_public_read" ON storage.objects
  FOR SELECT TO anon, authenticated
  USING (bucket_id = 'video-thumbnails');

CREATE POLICY "thumbnails_org_upload" ON storage.objects
  FOR INSERT TO authenticated
  WITH CHECK (
    bucket_id = 'video-thumbnails' AND
    (storage.foldername(name))[1] IN (
      SELECT organization_id::text
      FROM organization_members
      WHERE user_id = (SELECT auth.uid())
    )
  );

-- Phase 5: Video Processing Functions
-- =====================================================================================

-- CRITICAL FIX: Missing RPC function that's used in repositories
CREATE OR REPLACE FUNCTION public.get_user_organization_id()
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  org_id UUID;
BEGIN
  -- Get the organization_id for the current authenticated user
  SELECT organization_id INTO org_id
  FROM organization_members
  WHERE user_id = (SELECT auth.uid())
  LIMIT 1;

  -- Return the organization_id or raise exception if not found
  IF org_id IS NULL THEN
    RAISE EXCEPTION 'User is not a member of any organization';
  END IF;

  RETURN org_id;
END;
$$;

-- Function to update video processing status
CREATE OR REPLACE FUNCTION public.update_video_processing_status(
  video_id UUID,
  new_status TEXT,
  error_message TEXT DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE public.video_tags
  SET
    processing_status = new_status,
    processing_error = CASE
      WHEN new_status = 'error' THEN error_message
      ELSE NULL
    END,
    updated_at = NOW()
  WHERE id = video_id;
END;
$$;

-- Function to get videos by organization with filtering
CREATE OR REPLACE FUNCTION public.get_organization_videos(
  org_id UUID,
  status_filter TEXT DEFAULT NULL,
  limit_count INTEGER DEFAULT 50,
  offset_count INTEGER DEFAULT 0
)
RETURNS TABLE (
  id UUID,
  title TEXT,
  description TEXT,
  file_url TEXT,
  thumbnail_url TEXT,
  duration_seconds INTEGER,
  processing_status TEXT,
  created_at TIMESTAMPTZ,
  tag_count INTEGER
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    vt.id,
    vt.title,
    vt.description,
    COALESCE(vt.file_url, vt.video_url) as file_url,
    vt.thumbnail_url,
    vt.duration_seconds,
    vt.processing_status,
    vt.created_at,
    array_length(vt.tags, 1) as tag_count
  FROM public.video_tags vt
  WHERE
    vt.organization_id = org_id
    AND (status_filter IS NULL OR vt.processing_status = status_filter)
  ORDER BY vt.created_at DESC
  LIMIT limit_count
  OFFSET offset_count;
END;
$$;

-- Phase 6: Video Analytics and Monitoring
-- =====================================================================================

-- View for video analytics dashboard
CREATE OR REPLACE VIEW public.video_analytics AS
SELECT
  organization_id,
  COUNT(*) as total_videos,
  COUNT(*) FILTER (WHERE processing_status = 'ready') as ready_videos,
  COUNT(*) FILTER (WHERE processing_status = 'processing') as processing_videos,
  COUNT(*) FILTER (WHERE processing_status = 'error') as error_videos,
  SUM(file_size_bytes) as total_storage_bytes,
  SUM(duration_seconds) as total_duration_seconds,
  AVG(duration_seconds) as avg_duration_seconds,
  COUNT(*) FILTER (WHERE created_at > NOW() - INTERVAL '30 days') as videos_last_30_days,
  COUNT(*) FILTER (WHERE created_at > NOW() - INTERVAL '7 days') as videos_last_7_days
FROM public.video_tags
GROUP BY organization_id;

-- Grant permissions for new functions and views
GRANT SELECT ON public.video_analytics TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_user_organization_id() TO authenticated;
GRANT EXECUTE ON FUNCTION public.update_video_processing_status(UUID, TEXT, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_organization_videos(UUID, TEXT, INTEGER, INTEGER) TO authenticated;

-- Phase 7: Data Migration and Cleanup
-- =====================================================================================

-- Update existing records to have default values for new fields
UPDATE public.video_tags
SET
  title = COALESCE(title, 'Imported Video'),
  file_url = COALESCE(file_url, video_url),
  processing_status = COALESCE(processing_status, 'ready')
WHERE title IS NULL OR file_url IS NULL OR processing_status IS NULL;

-- Phase 8: Validation and Health Checks
-- =====================================================================================

DO $$
BEGIN
  -- Verify new columns exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'video_tags'
    AND column_name = 'title'
    AND table_schema = 'public'
  ) THEN
    RAISE EXCEPTION 'CRITICAL: video_tags.title column creation failed';
  END IF;

  -- Verify new indexes exist
  IF NOT EXISTS (
    SELECT 1 FROM pg_indexes
    WHERE tablename = 'video_tags'
    AND indexname = 'idx_video_tags_processing_status'
  ) THEN
    RAISE EXCEPTION 'CRITICAL: processing_status index creation failed';
  END IF;

  -- Verify new storage buckets exist
  IF NOT EXISTS (
    SELECT 1 FROM storage.buckets
    WHERE id = 'training-videos'
  ) THEN
    RAISE EXCEPTION 'CRITICAL: training-videos bucket creation failed';
  END IF;

  RAISE NOTICE '✅ VIDEO FUNCTIONALITY EXTENSION COMPLETED SUCCESSFULLY';
  RAISE NOTICE '📊 Ready for Phase 1 video implementation';
END $$;

-- =====================================================================================
-- MIGRATION COMPLETED - VIDEO FOUNDATION READY
-- =====================================================================================
--
-- ✅ ENHANCEMENTS IMPLEMENTED:
-- - Extended video_tags table with all required fields for video management
-- - Enhanced storage bucket configuration with proper limits and mime types
-- - Performance indexes for video queries
-- - Organization-based security policies for video storage
-- - Video processing status management functions
-- - Analytics views for video dashboard
-- - Data migration for existing records
--
-- 🎬 VIDEO FEATURES NOW SUPPORTED:
-- - Full video metadata management (title, description, duration, etc.)
-- - Processing status tracking (pending → processing → ready)
-- - File size and resolution tracking
-- - Thumbnail URL management
-- - Organization-based multi-tenant access
-- - Video analytics and monitoring
--
-- 📈 PERFORMANCE OPTIMIZATIONS:
-- - Strategic indexes for common video queries
-- - Composite indexes for organization + status filtering
-- - Efficient storage policies with proper access control
-- - Analytics views for dashboard performance
--
-- Next Steps for Implementation:
-- 1. Create video model classes in Flutter
-- 2. Implement video repository pattern
-- 3. Build video player widget
-- 4. Add video upload functionality
-- =====================================================================================
