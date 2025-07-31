-- Migration: Fix Video Tags Schema Mismatch
-- Fixes critical mismatch between database schema and Dart VideoTag model
-- Date: 2025-07-31

-- Step 1: Add missing tag_data column for structured data
ALTER TABLE video_tags
ADD COLUMN IF NOT EXISTS tag_data JSONB DEFAULT '{}' NOT NULL;

-- Step 2: Rename notes column to description to match Dart model
ALTER TABLE video_tags
RENAME COLUMN notes TO description;

-- Step 3: Add new tag_type column with correct enum values
ALTER TABLE video_tags
ADD COLUMN IF NOT EXISTS tag_type TEXT;

-- Step 4: Update tag_type values and map from old event_type values
UPDATE video_tags SET tag_type =
  CASE
    WHEN event_type IN ('goal', 'assist', 'shot', 'save') THEN 'skill'
    WHEN event_type IN ('foul', 'card', 'offside') THEN 'mistake'
    WHEN event_type IN ('substitution', 'corner_kick', 'free_kick', 'penalty') THEN 'tactic'
    WHEN event_type IN ('tackle', 'interception', 'pass', 'cross') THEN 'player'
    WHEN event_type = 'other' THEN 'moment'
    ELSE 'drill'
  END
WHERE tag_type IS NULL;

-- Step 5: Add proper constraint for tag_type
ALTER TABLE video_tags
ADD CONSTRAINT check_tag_type
CHECK (tag_type IN ('drill', 'moment', 'player', 'tactic', 'mistake', 'skill'));

-- Step 6: Make tag_type NOT NULL
ALTER TABLE video_tags
ALTER COLUMN tag_type SET NOT NULL;

-- Step 7: Drop old event_type column and constraint
ALTER TABLE video_tags DROP CONSTRAINT IF EXISTS video_tags_event_type_check;
ALTER TABLE video_tags DROP COLUMN IF EXISTS event_type;

-- Step 8: Update indexes to use new column names
DROP INDEX IF EXISTS idx_video_tags_event_type;
CREATE INDEX idx_video_tags_tag_type ON video_tags(tag_type);

DROP INDEX IF EXISTS idx_video_tags_video_event;
CREATE INDEX idx_video_tags_video_tag_type ON video_tags(video_id, tag_type);

-- Step 9: Add index for tag_data JSONB queries
CREATE INDEX idx_video_tags_tag_data_gin ON video_tags USING GIN(tag_data);

-- Step 10: Update the analytics view to use new column names
DROP VIEW IF EXISTS video_tag_analytics;
CREATE VIEW video_tag_analytics AS
SELECT
    v.id as video_id,
    v.title as video_title,
    v.organization_id,
    COUNT(vt.id) as total_tags,
    COUNT(DISTINCT vt.tag_type) as unique_tag_types,
    COUNT(DISTINCT vt.player_id) FILTER (WHERE vt.player_id IS NOT NULL) as tagged_players,
    ROUND(
        CASE
            WHEN v.duration_seconds > 0
            THEN (COUNT(vt.id)::DECIMAL / (v.duration_seconds / 60.0))
            ELSE 0
        END, 2
    ) as tags_per_minute,
    MIN(vt.timestamp_seconds) as first_tag_time,
    MAX(vt.timestamp_seconds) as last_tag_time,
    jsonb_object_agg(
        vt.tag_type,
        COUNT(vt.id)
    ) FILTER (WHERE vt.tag_type IS NOT NULL) as tag_type_counts
FROM videos v
LEFT JOIN video_tags vt ON v.id = vt.video_id
GROUP BY v.id, v.title, v.organization_id, v.duration_seconds;

-- Grant permissions on the updated view
GRANT SELECT ON video_tag_analytics TO authenticated;

-- Step 11: Update hotspots function to use new column name
CREATE OR REPLACE FUNCTION get_video_hotspots(
    p_video_id UUID,
    p_interval_seconds INTEGER DEFAULT 30
)
RETURNS TABLE (
    interval_start DECIMAL,
    interval_end DECIMAL,
    tag_count BIGINT,
    tag_types TEXT[]
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        (FLOOR(vt.timestamp_seconds / p_interval_seconds) * p_interval_seconds)::DECIMAL as interval_start,
        ((FLOOR(vt.timestamp_seconds / p_interval_seconds) + 1) * p_interval_seconds)::DECIMAL as interval_end,
        COUNT(*) as tag_count,
        array_agg(DISTINCT vt.tag_type) as tag_types
    FROM video_tags vt
    WHERE vt.video_id = p_video_id
    GROUP BY FLOOR(vt.timestamp_seconds / p_interval_seconds)
    ORDER BY interval_start;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Step 12: Update export function to use new column names
CREATE OR REPLACE FUNCTION export_video_tags(p_video_id UUID)
RETURNS JSON AS $$
DECLARE
    result JSON;
BEGIN
    -- Check if user has access to this video
    IF NOT EXISTS (
        SELECT 1 FROM videos v
        JOIN organization_memberships om ON v.organization_id = om.organization_id
        WHERE v.id = p_video_id AND om.user_id = auth.uid()
    ) THEN
        RAISE EXCEPTION 'Access denied to video tags';
    END IF;

    SELECT json_build_object(
        'video_id', v.id,
        'video_title', v.title,
        'export_timestamp', NOW(),
        'total_tags', COUNT(vt.id),
        'tags', json_agg(
            json_build_object(
                'id', vt.id,
                'tag_type', vt.tag_type,
                'timestamp_seconds', vt.timestamp_seconds,
                'description', vt.description,
                'tag_data', vt.tag_data,
                'player_id', vt.player_id,
                'created_at', vt.created_at
            ) ORDER BY vt.timestamp_seconds
        )
    ) INTO result
    FROM videos v
    LEFT JOIN video_tags vt ON v.id = vt.video_id
    WHERE v.id = p_video_id
    GROUP BY v.id, v.title;

    RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Step 13: Ensure players table exists (create minimal version if missing)
CREATE TABLE IF NOT EXISTS players (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    jersey_number INTEGER,
    position TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,

    -- Ensure unique jersey numbers per organization
    CONSTRAINT unique_jersey_per_org UNIQUE (organization_id, jersey_number)
);

-- Enable RLS on players table
ALTER TABLE players ENABLE ROW LEVEL SECURITY;

-- RLS Policy for players
CREATE POLICY IF NOT EXISTS "Users can view players from their organization"
    ON players FOR SELECT
    USING (
        organization_id IN (
            SELECT organization_id
            FROM organization_memberships
            WHERE user_id = auth.uid()
        )
    );

-- Step 14: Update demo data to use new schema
DO $$
DECLARE
    demo_org_id UUID;
    demo_video_id UUID;
BEGIN
    -- Get demo organization
    SELECT id INTO demo_org_id FROM organizations WHERE name = 'Demo Organization' LIMIT 1;

    IF demo_org_id IS NOT NULL THEN
        -- Get a demo video
        SELECT id INTO demo_video_id FROM videos WHERE organization_id = demo_org_id LIMIT 1;

        IF demo_video_id IS NOT NULL THEN
            -- Clear old demo data and insert new demo data with correct schema
            DELETE FROM video_tags WHERE video_id = demo_video_id;

            INSERT INTO video_tags (video_id, tag_type, timestamp_seconds, description, tag_data, organization_id) VALUES
            (demo_video_id, 'skill', 45.5, 'Excellent technical skill demonstration', '{"intensity": "high", "skill_type": "shooting"}', demo_org_id),
            (demo_video_id, 'tactic', 44.2, 'Perfect tactical execution', '{"phase": "attack", "formation": "4-3-3"}', demo_org_id),
            (demo_video_id, 'player', 12.3, 'Individual player focus moment', '{"action": "dribbling", "success": true}', demo_org_id),
            (demo_video_id, 'moment', 67.1, 'Key moment in the game', '{"importance": "high", "context": "decisive"}', demo_org_id),
            (demo_video_id, 'mistake', 23.4, 'Learning opportunity identified', '{"type": "positioning", "severity": "minor"}', demo_org_id),
            (demo_video_id, 'drill', 89.2, 'Training drill demonstration', '{"drill_type": "passing", "difficulty": "intermediate"}', demo_org_id);
        END IF;
    END IF;
END $$;

-- Step 15: Update table comments
COMMENT ON TABLE video_tags IS 'Video tags for tactical training analysis';
COMMENT ON COLUMN video_tags.tag_type IS 'Type of training tag (drill, moment, player, tactic, mistake, skill)';
COMMENT ON COLUMN video_tags.timestamp_seconds IS 'Time in video when event occurred (seconds)';
COMMENT ON COLUMN video_tags.description IS 'Description of the tagged event';
COMMENT ON COLUMN video_tags.tag_data IS 'Structured metadata for the tag (JSONB)';
COMMENT ON COLUMN video_tags.player_id IS 'Player involved in the event (nullable)';

-- Step 16: Add helpful functions for tag_data queries
CREATE OR REPLACE FUNCTION get_tags_by_data_key(
    p_video_id UUID,
    p_key TEXT,
    p_value TEXT
)
RETURNS TABLE (
    id UUID,
    tag_type TEXT,
    timestamp_seconds DECIMAL,
    description TEXT,
    tag_data JSONB
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        vt.id,
        vt.tag_type,
        vt.timestamp_seconds,
        vt.description,
        vt.tag_data
    FROM video_tags vt
    WHERE vt.video_id = p_video_id
    AND vt.tag_data ->> p_key = p_value
    ORDER BY vt.timestamp_seconds;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_tags_by_data_key(UUID, TEXT, TEXT) TO authenticated;

-- Final verification query (will be shown in logs)
DO $$
DECLARE
    column_count INTEGER;
    tag_count INTEGER;
BEGIN
    -- Verify schema changes
    SELECT COUNT(*) INTO column_count
    FROM information_schema.columns
    WHERE table_name = 'video_tags'
    AND column_name IN ('tag_type', 'description', 'tag_data');

    SELECT COUNT(*) INTO tag_count FROM video_tags;

    RAISE NOTICE 'Schema migration completed. Columns: %, Tags: %', column_count, tag_count;

    IF column_count != 3 THEN
        RAISE EXCEPTION 'Schema migration failed - missing columns';
    END IF;
END $$;
