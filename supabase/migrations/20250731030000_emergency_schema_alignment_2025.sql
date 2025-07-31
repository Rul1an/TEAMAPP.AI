-- 2025-07-31 Emergency Schema Alignment - Critical Production Fix
-- Aligns database schema with Video and VideoTag model expectations

-- Fix video table schema to match Video model expectations
ALTER TABLE videos
  ADD COLUMN IF NOT EXISTS file_url TEXT,
  ADD COLUMN IF NOT EXISTS file_size_bytes BIGINT,
  ADD COLUMN IF NOT EXISTS duration_seconds INTEGER,
  ADD COLUMN IF NOT EXISTS resolution_width INTEGER,
  ADD COLUMN IF NOT EXISTS resolution_height INTEGER,
  ADD COLUMN IF NOT EXISTS encoding_format TEXT DEFAULT 'mp4',
  ADD COLUMN IF NOT EXISTS processing_status TEXT DEFAULT 'pending',
  ADD COLUMN IF NOT EXISTS processing_error TEXT,
  ADD COLUMN IF NOT EXISTS video_metadata JSONB DEFAULT '{}',
  ADD COLUMN IF NOT EXISTS tag_data JSONB DEFAULT '{}',
  ADD COLUMN IF NOT EXISTS tags TEXT[] DEFAULT '{}',
  ADD COLUMN IF NOT EXISTS time_codes JSONB DEFAULT '[]',
  ADD COLUMN IF NOT EXISTS coordinates JSONB DEFAULT '[]',
  ADD COLUMN IF NOT EXISTS ai_confidence DECIMAL DEFAULT 0.0,
  ADD COLUMN IF NOT EXISTS ai_processed BOOLEAN DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS ai_processed_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS created_by TEXT,
  ADD COLUMN IF NOT EXISTS player_id UUID REFERENCES players(id) ON DELETE SET NULL;

-- Update existing video records to use new field names
UPDATE videos SET
  file_url = COALESCE(file_url, url, storage_path, ''),
  file_size_bytes = COALESCE(file_size_bytes, file_size, 0),
  duration_seconds = COALESCE(duration_seconds, duration_seconds, 0)
WHERE file_url IS NULL OR file_size_bytes IS NULL OR duration_seconds IS NULL;

-- Fix video_tags table schema to match VideoTag model expectations
ALTER TABLE video_tags
  ADD COLUMN IF NOT EXISTS title TEXT,
  ADD COLUMN IF NOT EXISTS tag_data JSONB DEFAULT '{}';

-- Ensure timestamp_seconds is DECIMAL not INTEGER for proper model mapping
ALTER TABLE video_tags
  ALTER COLUMN timestamp_seconds TYPE DECIMAL USING timestamp_seconds::DECIMAL;

-- Map existing data to new structure
UPDATE video_tags SET
  title = COALESCE(title, description),
  tag_data = COALESCE(tag_data, '{}')
WHERE title IS NULL OR tag_data IS NULL;

-- Ensure event_type matches tag_type if not set
UPDATE video_tags SET event_type = tag_type WHERE event_type IS NULL;

-- Create missing indexes for performance
CREATE INDEX IF NOT EXISTS idx_videos_file_url ON videos(file_url);
CREATE INDEX IF NOT EXISTS idx_videos_processing_status ON videos(processing_status);
CREATE INDEX IF NOT EXISTS idx_videos_ai_processed ON videos(ai_processed);
CREATE INDEX IF NOT EXISTS idx_videos_player_id ON videos(player_id);
CREATE INDEX IF NOT EXISTS idx_video_tags_title ON video_tags(title);
CREATE INDEX IF NOT EXISTS idx_video_tags_tag_type ON video_tags(tag_type);
CREATE INDEX IF NOT EXISTS idx_video_tags_event_type ON video_tags(event_type);

-- Create composite indexes for common queries
CREATE INDEX IF NOT EXISTS idx_videos_org_status ON videos(organization_id, processing_status);
CREATE INDEX IF NOT EXISTS idx_video_tags_video_timestamp ON video_tags(video_id, timestamp_seconds);
CREATE INDEX IF NOT EXISTS idx_video_tags_org_type ON video_tags(organization_id, tag_type);

-- Add constraints for data integrity
ALTER TABLE videos
  ADD CONSTRAINT IF NOT EXISTS check_file_size_non_negative
    CHECK (file_size_bytes >= 0);

ALTER TABLE videos
  ADD CONSTRAINT IF NOT EXISTS check_duration_non_negative
    CHECK (duration_seconds >= 0);

ALTER TABLE videos
  ADD CONSTRAINT IF NOT EXISTS check_resolution_positive
    CHECK (resolution_width > 0 AND resolution_height > 0 OR (resolution_width IS NULL AND resolution_height IS NULL));

ALTER TABLE video_tags
  ADD CONSTRAINT IF NOT EXISTS check_timestamp_non_negative
    CHECK (timestamp_seconds >= 0);

-- Ensure processing_status has valid values
ALTER TABLE videos
  ADD CONSTRAINT IF NOT EXISTS check_valid_processing_status
    CHECK (processing_status IN ('pending', 'processing', 'ready', 'error', 'archived'));

-- Ensure tag_type has valid values
ALTER TABLE video_tags
  ADD CONSTRAINT IF NOT EXISTS check_valid_tag_type
    CHECK (tag_type IN ('drill', 'moment', 'player', 'tactic', 'mistake', 'skill'));

-- Create function to sync event_type with tag_type
CREATE OR REPLACE FUNCTION sync_tag_event_type()
RETURNS TRIGGER AS $$
BEGIN
    -- Ensure event_type matches tag_type for consistency
    NEW.event_type = NEW.tag_type;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to keep event_type in sync with tag_type
DROP TRIGGER IF EXISTS sync_video_tag_event_type ON video_tags;
CREATE TRIGGER sync_video_tag_event_type
    BEFORE INSERT OR UPDATE ON video_tags
    FOR EACH ROW EXECUTE FUNCTION sync_tag_event_type();

-- Update RLS policies to work with new schema
DROP POLICY IF EXISTS "organization_isolation" ON videos;
CREATE POLICY "organization_isolation" ON videos
    FOR ALL USING (organization_id = current_org_id());

DROP POLICY IF EXISTS "authenticated_access" ON videos;
CREATE POLICY "authenticated_access" ON videos
    FOR ALL TO authenticated USING (organization_id = current_org_id());

-- Grant permissions on new columns
GRANT SELECT, UPDATE ON videos TO authenticated;
GRANT SELECT, UPDATE ON video_tags TO authenticated;

-- Refresh materialized views if any exist
-- (Add here if you have materialized views that need refreshing)

-- Verify schema alignment
DO $$
DECLARE
    missing_video_column text;
    missing_tag_column text;
    video_columns text[] := ARRAY[
        'id', 'organization_id', 'title', 'description', 'player_id',
        'file_url', 'url', 'thumbnail_url', 'duration_seconds', 'file_size_bytes',
        'resolution_width', 'resolution_height', 'encoding_format',
        'processing_status', 'processing_error', 'video_metadata', 'tag_data',
        'tags', 'time_codes', 'coordinates', 'ai_confidence', 'ai_processed',
        'ai_processed_at', 'created_at', 'updated_at', 'created_by'
    ];
    tag_columns text[] := ARRAY[
        'id', 'organization_id', 'video_id', 'tag_type', 'event_type',
        'timestamp_seconds', 'title', 'description', 'notes', 'tag_data',
        'player_id', 'created_at', 'updated_at'
    ];
BEGIN
    -- Check videos table
    FOR missing_video_column IN
        SELECT unnest(video_columns)
        EXCEPT
        SELECT column_name FROM information_schema.columns
        WHERE table_schema = 'public' AND table_name = 'videos'
    LOOP
        RAISE WARNING 'Missing column in videos table: %', missing_video_column;
    END LOOP;

    -- Check video_tags table
    FOR missing_tag_column IN
        SELECT unnest(tag_columns)
        EXCEPT
        SELECT column_name FROM information_schema.columns
        WHERE table_schema = 'public' AND table_name = 'video_tags'
    LOOP
        RAISE WARNING 'Missing column in video_tags table: %', missing_tag_column;
    END LOOP;

    RAISE NOTICE 'Schema alignment verification complete';
END$$;

-- Insert sample data for testing if tables are empty
INSERT INTO organizations (id, name) VALUES
    ('11111111-1111-1111-1111-111111111111', 'Sample Organization')
ON CONFLICT (id) DO NOTHING;

-- Ensure storage buckets exist with proper configuration
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types) VALUES
    ('training-videos', 'training-videos', false, 1073741824, ARRAY['video/mp4', 'video/webm', 'video/quicktime']),
    ('video-thumbnails', 'video-thumbnails', true, 10485760, ARRAY['image/jpeg', 'image/png', 'image/webp'])
ON CONFLICT (id) DO UPDATE SET
    file_size_limit = EXCLUDED.file_size_limit,
    allowed_mime_types = EXCLUDED.allowed_mime_types;

-- Final verification and cleanup
ANALYZE videos;
ANALYZE video_tags;
ANALYZE organizations;
ANALYZE players;

RAISE NOTICE 'Emergency schema alignment completed successfully';
