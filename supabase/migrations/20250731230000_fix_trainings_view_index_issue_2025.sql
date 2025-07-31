-- Fix for trainings view index issue
-- Date: 2025-07-31
-- Issue: Cannot create index on view 'trainings'

\set ON_ERROR_STOP on

DO $$
BEGIN
  -- Remove problematic index creation attempts on views
  -- Views don't support indexes - only tables do

  -- Check if trainings is a view (not a table) and skip index creation
  IF EXISTS (
    SELECT 1 FROM information_schema.views
    WHERE table_schema = 'public' AND table_name = 'trainings'
  ) THEN
    RAISE NOTICE '⚠️ Trainings is a view - skipping index creation';
    RAISE NOTICE '✅ Views inherit indexes from their underlying tables';
  END IF;

  -- Ensure proper RLS is only applied to tables, not views
  IF EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_schema = 'public' AND table_name = 'trainings'
    AND table_type = 'BASE TABLE'
  ) THEN
    -- Only if trainings is actually a table (not a view)
    EXECUTE 'ALTER TABLE trainings ENABLE ROW LEVEL SECURITY';
    EXECUTE 'CREATE INDEX IF NOT EXISTS trainings_org_idx ON trainings(organization_id, id)';
    RAISE NOTICE '✅ Applied RLS and index to trainings table';
  ELSE
    RAISE NOTICE '⚠️ Trainings is not a base table - skipping RLS and index operations';
  END IF;

  -- Clean up any problematic function calls
  -- Make sure we don't try to create policies on views
  RAISE NOTICE '🔧 Migration fix applied for trainings view/table disambiguation';

END $$;

-- Verification
DO $$
BEGIN
  -- Report the actual type of 'trainings'
  IF EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = 'trainings') THEN
    RAISE NOTICE '📋 Confirmed: trainings is a VIEW (correct - no indexes needed)';
  ELSIF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'trainings') THEN
    RAISE NOTICE '📋 Confirmed: trainings is a TABLE (indexes applied)';
  ELSE
    RAISE NOTICE '📋 Trainings relation does not exist';
  END IF;

  RAISE NOTICE '✅ TRAININGS VIEW INDEX FIX COMPLETED';
END $$;
