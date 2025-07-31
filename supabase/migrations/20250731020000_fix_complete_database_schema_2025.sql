-- 2025-07-31  Complete Database Schema Fix - Critical Production Deployment
-- Addresses missing tables, columns, relations, policies, and roles

-- 1. Create missing role
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated') THEN
        CREATE ROLE authenticated;
    END IF;
END$$;

-- 2. Create organizations table if missing
CREATE TABLE IF NOT EXISTS organizations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 3. Create organization_members table if missing
CREATE TABLE IF NOT EXISTS organization_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    user_id UUID NOT NULL,
    role TEXT NOT NULL DEFAULT 'member',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(organization_id, user_id)
);

-- 4. Create players table with proper constraints
CREATE TABLE IF NOT EXISTS players (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    jersey_number INTEGER,
    position TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT unique_jersey_per_org UNIQUE (organization_id, jersey_number)
);

-- 5. Create videos table
CREATE TABLE IF NOT EXISTS videos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    url TEXT,
    thumbnail_url TEXT,
    duration_seconds INTEGER,
    file_size BIGINT,
    content_type TEXT,
    storage_path TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 6. Create video_tags table with all required columns
CREATE TABLE IF NOT EXISTS video_tags (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    video_id UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE,
    tag_type TEXT NOT NULL,
    event_type TEXT,
    timestamp_seconds INTEGER NOT NULL,
    description TEXT,
    notes TEXT,
    player_id UUID REFERENCES players(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 7. Create video_tag_analytics table
CREATE TABLE IF NOT EXISTS video_tag_analytics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    video_id UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE,
    tag_type TEXT NOT NULL,
    event_type TEXT,
    count INTEGER NOT NULL DEFAULT 0,
    total_duration_seconds INTEGER NOT NULL DEFAULT 0,
    average_timestamp_seconds DECIMAL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(organization_id, video_id, tag_type, event_type)
);

-- 8. Create storage schema and tables if not exists
CREATE SCHEMA IF NOT EXISTS storage;

CREATE TABLE IF NOT EXISTS storage.buckets (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    owner UUID,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    public BOOLEAN DEFAULT false,
    avif_autodetection BOOLEAN DEFAULT false,
    file_size_limit BIGINT,
    allowed_mime_types TEXT[]
);

CREATE TABLE IF NOT EXISTS storage.objects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bucket_id TEXT REFERENCES storage.buckets(id),
    name TEXT NOT NULL,
    owner UUID,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    last_accessed_at TIMESTAMPTZ DEFAULT now(),
    metadata JSONB,
    path_tokens TEXT[] GENERATED ALWAYS AS (string_to_array(name, '/')) STORED,
    version TEXT,
    owner_id TEXT
);

-- 9. Insert required storage buckets
INSERT INTO storage.buckets (id, name, public) VALUES
    ('training-videos', 'training-videos', false),
    ('video-thumbnails', 'video-thumbnails', true)
ON CONFLICT (id) DO NOTHING;

-- 10. Create essential indexes for performance
CREATE INDEX IF NOT EXISTS idx_organization_members_org_id ON organization_members(organization_id);
CREATE INDEX IF NOT EXISTS idx_organization_members_user_id ON organization_members(user_id);
CREATE INDEX IF NOT EXISTS idx_players_org_id ON players(organization_id);
CREATE INDEX IF NOT EXISTS idx_videos_org_id ON videos(organization_id);
CREATE INDEX IF NOT EXISTS idx_video_tags_org_id ON video_tags(organization_id);
CREATE INDEX IF NOT EXISTS idx_video_tags_video_id ON video_tags(video_id);
CREATE INDEX IF NOT EXISTS idx_video_tags_timestamp ON video_tags(timestamp_seconds);
CREATE INDEX IF NOT EXISTS idx_video_tag_analytics_org_video ON video_tag_analytics(organization_id, video_id);

-- 11. Create current_org_id() function if not exists
CREATE OR REPLACE FUNCTION current_org_id()
RETURNS UUID
LANGUAGE SQL
STABLE
AS $$
    SELECT COALESCE(
        current_setting('my.organization_id', true)::UUID,
        '00000000-0000-0000-0000-000000000000'::UUID
    );
$$;

-- 12. Enable RLS on all tables
ALTER TABLE organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE organization_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE players ENABLE ROW LEVEL SECURITY;
ALTER TABLE videos ENABLE ROW LEVEL SECURITY;
ALTER TABLE video_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE video_tag_analytics ENABLE ROW LEVEL SECURITY;

-- 13. Create RLS policies for organization isolation
CREATE POLICY IF NOT EXISTS "organization_isolation" ON organizations
    FOR ALL USING (id = current_org_id());

CREATE POLICY IF NOT EXISTS "organization_isolation" ON organization_members
    FOR ALL USING (organization_id = current_org_id());

CREATE POLICY IF NOT EXISTS "organization_isolation" ON players
    FOR ALL USING (organization_id = current_org_id());

CREATE POLICY IF NOT EXISTS "organization_isolation" ON videos
    FOR ALL USING (organization_id = current_org_id());

CREATE POLICY IF NOT EXISTS "organization_isolation" ON video_tags
    FOR ALL USING (organization_id = current_org_id());

CREATE POLICY IF NOT EXISTS "organization_isolation" ON video_tag_analytics
    FOR ALL USING (organization_id = current_org_id());

-- 14. Create additional policies for authenticated users
CREATE POLICY IF NOT EXISTS "authenticated_access" ON organizations
    FOR ALL TO authenticated USING (id = current_org_id());

CREATE POLICY IF NOT EXISTS "authenticated_access" ON organization_members
    FOR ALL TO authenticated USING (organization_id = current_org_id());

CREATE POLICY IF NOT EXISTS "authenticated_access" ON players
    FOR ALL TO authenticated USING (organization_id = current_org_id());

CREATE POLICY IF NOT EXISTS "authenticated_access" ON videos
    FOR ALL TO authenticated USING (organization_id = current_org_id());

CREATE POLICY IF NOT EXISTS "authenticated_access" ON video_tags
    FOR ALL TO authenticated USING (organization_id = current_org_id());

CREATE POLICY IF NOT EXISTS "authenticated_access" ON video_tag_analytics
    FOR ALL TO authenticated USING (organization_id = current_org_id());

-- 15. Grant necessary permissions
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA storage TO authenticated;

GRANT ALL ON organizations TO authenticated;
GRANT ALL ON organization_members TO authenticated;
GRANT ALL ON players TO authenticated;
GRANT ALL ON videos TO authenticated;
GRANT ALL ON video_tags TO authenticated;
GRANT ALL ON video_tag_analytics TO authenticated;

GRANT SELECT ON storage.buckets TO authenticated;
GRANT ALL ON storage.objects TO authenticated;

-- 16. Create updated_at triggers
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

DO $$
DECLARE
    t text;
BEGIN
    FOR t IN SELECT table_name FROM information_schema.tables
             WHERE table_schema = 'public' AND table_name IN (
                'organizations', 'organization_members', 'players',
                'videos', 'video_tags', 'video_tag_analytics'
             )
    LOOP
        IF NOT EXISTS (
            SELECT 1 FROM pg_trigger
            WHERE tgname = 'update_' || t || '_updated_at'
        ) THEN
            EXECUTE format('CREATE TRIGGER update_%I_updated_at
                           BEFORE UPDATE ON %I
                           FOR EACH ROW EXECUTE FUNCTION update_updated_at_column()', t, t);
        END IF;
    END LOOP;
END$$;

-- 17. Insert default test organization for development
INSERT INTO organizations (id, name) VALUES
    ('00000000-0000-0000-0000-000000000001', 'Test Organization')
ON CONFLICT (id) DO NOTHING;

-- 18. Verify schema completeness
DO $$
DECLARE
    missing_table text;
    missing_column text;
BEGIN
    -- Check for missing tables
    FOR missing_table IN
        SELECT unnest(ARRAY['organizations', 'organization_members', 'players', 'videos', 'video_tags', 'video_tag_analytics'])
        EXCEPT
        SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'
    LOOP
        RAISE WARNING 'Missing table: %', missing_table;
    END LOOP;

    -- Check for missing columns in video_tags
    FOR missing_column IN
        SELECT unnest(ARRAY['id', 'organization_id', 'video_id', 'tag_type', 'event_type', 'timestamp_seconds', 'description', 'notes'])
        EXCEPT
        SELECT column_name FROM information_schema.columns
        WHERE table_schema = 'public' AND table_name = 'video_tags'
    LOOP
        RAISE WARNING 'Missing column in video_tags: %', missing_column;
    END LOOP;

    RAISE NOTICE 'Database schema verification complete';
END$$;
