\set ON_ERROR_STOP on
-- Migration: Create video tags functionality
-- Phase: Video Phase 3 - Tagging & Analysis
-- Date: 2025-07-30

-- Enable RLS
ALTER DATABASE postgres SET row_security = on;

-- Create video_tags table
CREATE TABLE IF NOT EXISTS video_tags (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    video_id UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE,
    event_type TEXT NOT NULL CHECK (event_type IN (
        'goal', 'assist', 'shot', 'save', 'foul', 'card', 'substitution',
        'corner_kick', 'free_kick', 'offside', 'penalty', 'tackle',
        'interception', 'pass', 'cross', 'other'
    )),
    timestamp_seconds DECIMAL(10,3) NOT NULL CHECK (timestamp_seconds >= 0),
    player_id UUID REFERENCES players(id) ON DELETE SET NULL,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_video_tags_video_id ON video_tags(video_id);
CREATE INDEX IF NOT EXISTS idx_video_tags_event_type ON video_tags(event_type);
CREATE INDEX IF NOT EXISTS idx_video_tags_timestamp ON video_tags(timestamp_seconds);
CREATE INDEX IF NOT EXISTS idx_video_tags_player_id ON video_tags(player_id) WHERE player_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_video_tags_organization_id ON video_tags(organization_id);
CREATE INDEX IF NOT EXISTS idx_video_tags_created_at ON video_tags(created_at);

-- Composite index for common queries
CREATE INDEX IF NOT EXISTS idx_video_tags_video_timestamp ON video_tags(video_id, timestamp_seconds);
CREATE INDEX IF NOT EXISTS idx_video_tags_video_event ON video_tags(video_id, event_type);

-- RLS Policies
ALTER TABLE video_tags ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view tags from their organization (simplified for migration safety)
CREATE POLICY "Users can view video tags from their organization"
    ON video_tags FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM profiles p
            WHERE p.id = auth.uid()
            AND p.organization_id = video_tags.organization_id
        )
    );

-- Policy: Users can create tags for videos in their organization
CREATE POLICY "Users can create video tags in their organization"
    ON video_tags FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM profiles p
            WHERE p.id = auth.uid()
            AND p.organization_id = video_tags.organization_id
        )
        AND video_id IN (
            SELECT id
            FROM videos
            WHERE organization_id = video_tags.organization_id
        )
    );

-- Policy: Users can update tags in their organization
CREATE POLICY "Users can update video tags in their organization"
    ON video_tags FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM profiles p
            WHERE p.id = auth.uid()
            AND p.organization_id = video_tags.organization_id
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM profiles p
            WHERE p.id = auth.uid()
            AND p.organization_id = video_tags.organization_id
        )
    );

-- Policy: Users can delete tags in their organization
CREATE POLICY "Users can delete video tags in their organization"
    ON video_tags FOR DELETE
    USING (
        EXISTS (
            SELECT 1 FROM profiles p
            WHERE p.id = auth.uid()
            AND p.organization_id = video_tags.organization_id
        )
    );

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_video_tags_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for updated_at
CREATE TRIGGER video_tags_updated_at_trigger
    BEFORE UPDATE ON video_tags
    FOR EACH ROW
    EXECUTE FUNCTION update_video_tags_updated_at();

-- Create view for video tag analytics
CREATE OR REPLACE VIEW video_tag_analytics AS
SELECT
    v.id as video_id,
    v.title as video_title,
    v.organization_id,
    COUNT(vt.id) as total_tags,
    COUNT(DISTINCT vt.event_type) as unique_event_types,
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
    (
        SELECT jsonb_object_agg(event_type, event_count)
        FROM (
            SELECT vt2.event_type, COUNT(*) as event_count
            FROM video_tags vt2
            WHERE vt2.video_id = v.id AND vt2.event_type IS NOT NULL
            GROUP BY vt2.event_type
        ) event_counts
    ) as event_type_counts
FROM videos v
LEFT JOIN video_tags vt ON v.id = vt.video_id
GROUP BY v.id, v.title, v.organization_id, v.duration_seconds;

-- Grant permissions on the view
GRANT SELECT ON video_tag_analytics TO authenticated;

-- Note: security_invoker option not supported in all PostgreSQL versions
-- GRANT permissions handle access control for views

-- Create function to get video hotspots (30-second intervals)
CREATE OR REPLACE FUNCTION get_video_hotspots(
    p_video_id UUID,
    p_interval_seconds INTEGER DEFAULT 30
)
RETURNS TABLE (
    interval_start DECIMAL,
    interval_end DECIMAL,
    tag_count BIGINT,
    event_types TEXT[]
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        (FLOOR(vt.timestamp_seconds / p_interval_seconds) * p_interval_seconds)::DECIMAL as interval_start,
        ((FLOOR(vt.timestamp_seconds / p_interval_seconds) + 1) * p_interval_seconds)::DECIMAL as interval_end,
        COUNT(*) as tag_count,
        array_agg(DISTINCT vt.event_type) as event_types
    FROM video_tags vt
    WHERE vt.video_id = p_video_id
    GROUP BY FLOOR(vt.timestamp_seconds / p_interval_seconds)
    ORDER BY interval_start;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission on the function
GRANT EXECUTE ON FUNCTION get_video_hotspots(UUID, INTEGER) TO authenticated;

-- Create function to export video tags as JSON
CREATE OR REPLACE FUNCTION export_video_tags(p_video_id UUID)
RETURNS JSON AS $$
DECLARE
    result JSON;
BEGIN
    -- Check if user has access to this video
    IF NOT EXISTS (
        SELECT 1 FROM videos v
        JOIN profiles p ON v.organization_id = p.organization_id
        WHERE v.id = p_video_id AND p.id = auth.uid()
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
                'event_type', vt.event_type,
                'timestamp_seconds', vt.timestamp_seconds,
                'player_id', vt.player_id,
                'notes', vt.notes,
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

-- Grant execute permission on the export function
GRANT EXECUTE ON FUNCTION export_video_tags(UUID) TO authenticated;

-- Insert demo data for testing (only if no tags exist)
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

        IF demo_video_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM video_tags WHERE video_id = demo_video_id) THEN
            -- Insert sample tags
            INSERT INTO video_tags (video_id, event_type, timestamp_seconds, notes, organization_id) VALUES
            (demo_video_id, 'goal', 45.5, 'Great goal from the penalty area', demo_org_id),
            (demo_video_id, 'assist', 44.2, 'Perfect cross leading to goal', demo_org_id),
            (demo_video_id, 'shot', 12.3, 'Shot on target, saved by goalkeeper', demo_org_id),
            (demo_video_id, 'save', 12.8, 'Excellent save by the keeper', demo_org_id),
            (demo_video_id, 'foul', 67.1, 'Tactical foul to stop counter attack', demo_org_id),
            (demo_video_id, 'card', 67.5, 'Yellow card for tactical foul', demo_org_id),
            (demo_video_id, 'corner_kick', 23.4, 'Corner kick from good cross attempt', demo_org_id),
            (demo_video_id, 'pass', 89.2, 'Key pass in final third', demo_org_id);
        END IF;
    END IF;
END $$;

-- Add comments for documentation
COMMENT ON TABLE video_tags IS 'Video event tags for tactical analysis';
COMMENT ON COLUMN video_tags.event_type IS 'Type of football event (goal, assist, shot, etc.)';
COMMENT ON COLUMN video_tags.timestamp_seconds IS 'Time in video when event occurred (seconds)';
COMMENT ON COLUMN video_tags.player_id IS 'Player involved in the event (nullable)';
COMMENT ON COLUMN video_tags.notes IS 'Additional notes about the event';

COMMENT ON VIEW video_tag_analytics IS 'Aggregated analytics for video tags';
COMMENT ON FUNCTION get_video_hotspots(UUID, INTEGER) IS 'Get video hotspots grouped by time intervals';
COMMENT ON FUNCTION export_video_tags(UUID) IS 'Export all tags for a video as JSON';
