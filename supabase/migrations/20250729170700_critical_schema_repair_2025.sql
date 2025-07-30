-- =====================================================================================
-- CRITICAL PRODUCTION DATABASE SCHEMA REPAIR - 2025 MODERN STANDARDS
-- =====================================================================================
-- Based on: 2025 Database Migration Best Practices & Supabase RLS Patterns
-- Created: 29 July 2025
-- Purpose: Emergency production fixes for ontbrekende tabellen en schema mismatches
-- Migration Strategy: Phased rollout with zero-downtime approach
-- =====================================================================================

-- Phase 1: Emergency Stabilization - Create Missing Core Tables
-- =====================================================================================

-- 1.1 CREATE PROFILES TABLE (CRITICAL FOR SAAS USER MANAGEMENT)
-- Modern 2025 approach: Optimized for performance with proper indexing
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  username TEXT,
  full_name TEXT,
  avatar_url TEXT,
  website TEXT,
  bio TEXT,
  -- SaaS-specific fields (2025 standard)
  organization_id UUID,
  subscription_tier TEXT DEFAULT 'basic' CHECK (subscription_tier IN ('basic', 'pro', 'enterprise')),
  subscription_status TEXT DEFAULT 'active' CHECK (subscription_status IN ('active', 'inactive', 'trial', 'cancelled')),
  -- Audit fields (modern standard)
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  last_seen_at TIMESTAMPTZ DEFAULT NOW(),
  -- Compliance fields (GDPR 2025)
  data_processing_consent BOOLEAN DEFAULT FALSE,
  marketing_consent BOOLEAN DEFAULT FALSE,
  consent_updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Performance indexes (2025 optimized patterns)
CREATE INDEX IF NOT EXISTS idx_profiles_user_id ON public.profiles (user_id);
CREATE INDEX IF NOT EXISTS idx_profiles_organization_id ON public.profiles (organization_id);
CREATE INDEX IF NOT EXISTS idx_profiles_subscription_tier ON public.profiles (subscription_tier);
CREATE INDEX IF NOT EXISTS idx_profiles_updated_at ON public.profiles (updated_at);

-- 1.2 CREATE VIDEO_TAGS TABLE (FOR VIDEO TAGGING FUNCTIONALITY)
-- Modern approach: JSONB for flexible data structure
CREATE TABLE IF NOT EXISTS public.video_tags (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID NOT NULL,
  player_id UUID,
  video_url TEXT NOT NULL,
  video_metadata JSONB DEFAULT '{}',
  -- Tag data structure (2025 flexible approach)
  tag_data JSONB NOT NULL DEFAULT '{}',
  tags TEXT[] DEFAULT '{}', -- Searchable tag array
  -- Spatial/temporal data for video analysis
  time_codes JSONB DEFAULT '[]', -- [{"start": 10.5, "end": 15.2, "tag": "pass"}]
  coordinates JSONB DEFAULT '[]', -- [{"x": 100, "y": 200, "time": 12.3}]
  -- AI/ML fields (2025 standard)
  ai_confidence NUMERIC(4,3) DEFAULT 0.000,
  ai_processed BOOLEAN DEFAULT FALSE,
  ai_processed_at TIMESTAMPTZ,
  -- Audit trail
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  created_by UUID,
  -- Performance optimization (2025 trigger-based approach)
  search_vector tsvector
);

-- Performance indexes for video_tags (2025 optimized)
CREATE INDEX IF NOT EXISTS idx_video_tags_organization_id ON public.video_tags (organization_id);
CREATE INDEX IF NOT EXISTS idx_video_tags_player_id ON public.video_tags (player_id);
CREATE INDEX IF NOT EXISTS idx_video_tags_created_at ON public.video_tags (created_at);
CREATE INDEX IF NOT EXISTS idx_video_tags_search ON public.video_tags USING GIN (search_vector);
CREATE INDEX IF NOT EXISTS idx_video_tags_tags ON public.video_tags USING GIN (tags);
CREATE INDEX IF NOT EXISTS idx_video_tags_metadata ON public.video_tags USING GIN (tag_data);

-- Phase 2: Schema Compatibility Layer - Create TRAININGS View
-- =====================================================================================
-- Modern 2025 approach: Backward compatible view with full feature mapping

CREATE OR REPLACE VIEW public.trainings AS
SELECT
  ts.id,
  ts.date_time as date,
  ts.duration,
  ts.focus,
  ts.intensity,
  COALESCE(ts.status, 'planned'::TEXT) as status,
  ts.location,
  ts.description,
  ts.title as objectives,
  COALESCE(ts.exercises, '[]'::jsonb) as drills,
  COALESCE(ts.attendance->>'present', '[]')::jsonb as present,
  COALESCE(ts.attendance->>'absent', '[]')::jsonb as absent,
  COALESCE(ts.attendance->>'injured', '[]')::jsonb as injured,
  COALESCE(ts.attendance->>'late', '[]')::jsonb as late,
  ts.description as coach_notes,
  COALESCE(ts.performance_notes, ''::TEXT) as performance_notes,
  ts.created_at,
  ts.updated_at,
  ts.organization_id,
  ts.team_id,
  -- 2025 additions: Enhanced metadata
  ts.weather_conditions,
  ts.field_conditions,
  ts.competition_context,
  -- Performance metrics
  COALESCE(ts.metrics, '{}'::jsonb) as session_metrics
FROM training_sessions ts;

-- Phase 3: Row Level Security - 2025 Multi-Tenant Standards
-- =====================================================================================

-- 3.1 ENABLE RLS ON ALL TABLES (2025 Security Standard)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.video_tags ENABLE ROW LEVEL SECURITY;

-- 3.2 PROFILES RLS POLICIES (Modern 2025 Performance Patterns)
-- Using optimized patterns from research: indexed predicates, security definer functions

-- Users can view and update their own profile
CREATE POLICY "profiles_own_access" ON public.profiles
  FOR ALL TO authenticated
  USING ((SELECT auth.uid()) = user_id)
  WITH CHECK ((SELECT auth.uid()) = user_id);

-- Organization members can view profiles in their org (2025 SaaS pattern)
CREATE POLICY "profiles_org_read" ON public.profiles
  FOR SELECT TO authenticated
  USING (
    organization_id IN (
      SELECT organization_id
      FROM organization_members
      WHERE user_id = (SELECT auth.uid())
    )
  );

-- Service role bypass for admin operations (2025 best practice)
CREATE POLICY "profiles_service_access" ON public.profiles
  FOR ALL TO service_role
  USING (true)
  WITH CHECK (true);

-- 3.3 VIDEO_TAGS RLS POLICIES (2025 Multi-tenant Pattern)
-- Organization-level isolation with performance optimization

CREATE POLICY "video_tags_org_access" ON public.video_tags
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
      WHERE user_id = (SELECT auth.uid())
    )
  );

-- Service role bypass for system operations
CREATE POLICY "video_tags_service_access" ON public.video_tags
  FOR ALL TO service_role
  USING (true)
  WITH CHECK (true);

-- 3.4 TRAININGS VIEW SECURITY (2025 Standard)
-- Views inherit RLS from underlying tables automatically in modern Postgres
ALTER VIEW public.trainings SET (security_invoker = true);

-- Phase 4: Storage Bucket Configuration - 2025 Standards
-- =====================================================================================

-- 4.1 AVATARS BUCKET (Modern approach with proper policies)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types, avif_autodetection)
VALUES (
  'avatars',
  'avatars',
  true,
  5242880, -- 5MB limit (2025 standard)
  ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/avif'], -- Modern formats
  true
)
ON CONFLICT (id) DO UPDATE SET
  file_size_limit = EXCLUDED.file_size_limit,
  allowed_mime_types = EXCLUDED.allowed_mime_types,
  avif_autodetection = EXCLUDED.avif_autodetection;

-- 4.2 VIDEO STORAGE BUCKET (2025 Enhanced)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'videos',
  'videos',
  false, -- Private bucket for security
  104857600, -- 100MB limit for video files
  ARRAY['video/mp4', 'video/webm', 'video/mov', 'video/avi']
)
ON CONFLICT (id) DO NOTHING;

-- Phase 5: Storage Policies - 2025 Security Standards
-- =====================================================================================

-- 5.1 AVATAR STORAGE POLICIES (Modern multi-tenant approach)
-- Public read access for avatars
CREATE POLICY "avatar_public_read" ON storage.objects
  FOR SELECT TO anon, authenticated
  USING (bucket_id = 'avatars');

-- Users can upload their own avatars
CREATE POLICY "avatar_user_upload" ON storage.objects
  FOR INSERT TO authenticated
  WITH CHECK (
    bucket_id = 'avatars' AND
    (SELECT auth.uid())::text = (storage.foldername(name))[1]
  );

-- Users can update their own avatars
CREATE POLICY "avatar_user_update" ON storage.objects
  FOR UPDATE TO authenticated
  USING (
    bucket_id = 'avatars' AND
    (SELECT auth.uid())::text = (storage.foldername(name))[1]
  )
  WITH CHECK (
    bucket_id = 'avatars' AND
    (SELECT auth.uid())::text = (storage.foldername(name))[1]
  );

-- Users can delete their own avatars
CREATE POLICY "avatar_user_delete" ON storage.objects
  FOR DELETE TO authenticated
  USING (
    bucket_id = 'avatars' AND
    (SELECT auth.uid())::text = (storage.foldername(name))[1]
  );

-- 5.2 VIDEO STORAGE POLICIES (2025 Enterprise Grade)
-- Organization-based access control for videos
CREATE POLICY "video_org_access" ON storage.objects
  FOR ALL TO authenticated
  USING (
    bucket_id = 'videos' AND
    (storage.foldername(name))[1] IN (
      SELECT organization_id::text
      FROM organization_members
      WHERE user_id = (SELECT auth.uid())
    )
  )
  WITH CHECK (
    bucket_id = 'videos' AND
    (storage.foldername(name))[1] IN (
      SELECT organization_id::text
      FROM organization_members
      WHERE user_id = (SELECT auth.uid())
    )
  );

-- Phase 6: Performance Optimization Functions - 2025 Standards
-- =====================================================================================

-- 6.1 UPDATED_AT TRIGGER FUNCTION (Modern approach)
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

-- 6.1.1 SEARCH VECTOR UPDATE FUNCTION (2025 Trigger-based approach)
CREATE OR REPLACE FUNCTION public.update_video_tags_search_vector()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  NEW.search_vector := to_tsvector('english',
    COALESCE(NEW.tag_data->>'description', '') || ' ' ||
    COALESCE(array_to_string(NEW.tags, ' '), '')
  );
  RETURN NEW;
END;
$$;

-- Apply updated_at triggers to relevant tables
CREATE TRIGGER handle_profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

CREATE TRIGGER handle_video_tags_updated_at
  BEFORE UPDATE ON public.video_tags
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- Apply search vector trigger for video_tags
CREATE TRIGGER update_video_tags_search_vector_trigger
  BEFORE INSERT OR UPDATE ON public.video_tags
  FOR EACH ROW EXECUTE FUNCTION public.update_video_tags_search_vector();

-- 6.2 PERFORMANCE MONITORING FUNCTION (2025 DevOps Standard)
CREATE OR REPLACE FUNCTION public.get_table_stats()
RETURNS TABLE (
  table_name TEXT,
  row_count BIGINT,
  total_size TEXT,
  index_size TEXT,
  last_vacuum TIMESTAMPTZ,
  last_analyze TIMESTAMPTZ
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    schemaname||'.'||tablename as table_name,
    n_tup_ins + n_tup_upd - n_tup_del as row_count,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as total_size,
    pg_size_pretty(pg_indexes_size(schemaname||'.'||tablename)) as index_size,
    last_vacuum,
    last_analyze
  FROM pg_stat_user_tables
  WHERE schemaname = 'public'
  ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
END;
$$;

-- Phase 7: Data Validation & Health Checks - 2025 Quality Standards
-- =====================================================================================

-- 7.1 DATA INTEGRITY CHECKS
DO $$
BEGIN
  -- Verify profiles table exists and is properly configured
  IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'profiles' AND table_schema = 'public') THEN
    RAISE EXCEPTION 'CRITICAL: profiles table creation failed';
  END IF;

  -- Verify video_tags table exists
  IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'video_tags' AND table_schema = 'public') THEN
    RAISE EXCEPTION 'CRITICAL: video_tags table creation failed';
  END IF;

  -- Verify trainings view exists
  IF NOT EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = 'trainings' AND table_schema = 'public') THEN
    RAISE EXCEPTION 'CRITICAL: trainings view creation failed';
  END IF;

  -- Verify RLS is enabled
  IF NOT EXISTS (SELECT 1 FROM pg_tables WHERE tablename = 'profiles' AND rowsecurity = true) THEN
    RAISE EXCEPTION 'CRITICAL: RLS not enabled on profiles table';
  END IF;

  RAISE NOTICE '✅ SCHEMA REPAIR COMPLETED SUCCESSFULLY - 2025 STANDARDS APPLIED';
END $$;

-- Phase 8: Performance Analytics & Monitoring - 2025 DevOps
-- =====================================================================================

-- 8.1 CREATE MONITORING VIEW FOR PRODUCTION HEALTH
CREATE OR REPLACE VIEW public.system_health AS
SELECT
  'profiles' as table_name,
  (SELECT COUNT(*) FROM public.profiles) as row_count,
  (SELECT COUNT(*) FROM public.profiles WHERE created_at > NOW() - INTERVAL '24 hours') as recent_records,
  pg_size_pretty(pg_total_relation_size('public.profiles')) as size
UNION ALL
SELECT
  'video_tags' as table_name,
  (SELECT COUNT(*) FROM public.video_tags) as row_count,
  (SELECT COUNT(*) FROM public.video_tags WHERE created_at > NOW() - INTERVAL '24 hours') as recent_records,
  pg_size_pretty(pg_total_relation_size('public.video_tags')) as size
UNION ALL
SELECT
  'training_sessions' as table_name,
  (SELECT COUNT(*) FROM public.training_sessions) as row_count,
  (SELECT COUNT(*) FROM public.training_sessions WHERE created_at > NOW() - INTERVAL '24 hours') as recent_records,
  pg_size_pretty(pg_total_relation_size('public.training_sessions')) as size;

-- 8.2 GRANT PROPER PERMISSIONS (2025 Security Model)
GRANT SELECT ON public.system_health TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_table_stats() TO service_role;

-- =====================================================================================
-- MIGRATION COMPLETED - 2025 MODERN STANDARDS
-- =====================================================================================
--
-- ✅ FEATURES IMPLEMENTED:
-- - Emergency profiles table creation with modern schema
-- - Video tagging system with AI-ready structure
-- - Backward-compatible trainings view
-- - Multi-tenant RLS policies with 2025 performance patterns
-- - Modern storage bucket configuration
-- - Performance monitoring and health checks
-- - GDPR-compliant audit fields
-- - Production-ready indexing strategy
--
-- 🔒 SECURITY FEATURES:
-- - Row Level Security on all sensitive tables
-- - Organization-based data isolation
-- - Secure storage policies with proper file type validation
-- - Service role bypass for admin operations
--
-- ⚡ PERFORMANCE OPTIMIZATIONS:
-- - Strategic indexing for common query patterns
-- - JSONB for flexible metadata storage
-- - Full-text search capabilities
-- - Automatic updated_at triggers
--
-- 📊 MONITORING & OBSERVABILITY:
-- - System health view for production monitoring
-- - Table statistics function for performance analysis
-- - Data integrity validation checks
--
-- Next Steps:
-- 1. Test application connectivity
-- 2. Verify RLS policies work correctly
-- 3. Run integration tests
-- 4. Monitor performance metrics
-- =====================================================================================
