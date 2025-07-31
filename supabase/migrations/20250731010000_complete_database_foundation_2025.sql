-- Complete Database Foundation Migration 2025
-- Addresses all missing tables, roles, policies, and schema objects
-- Created: July 31, 2025

-- Step 1: Create missing database roles
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated') THEN
        CREATE ROLE authenticated;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'anon') THEN
        CREATE ROLE anon;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'service_role') THEN
        CREATE ROLE service_role;
    END IF;
END $$;

-- Step 2: Create storage schema and tables if they don't exist
CREATE SCHEMA IF NOT EXISTS storage;

-- Create storage.buckets table
CREATE TABLE IF NOT EXISTS storage.buckets (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    owner UUID,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    public BOOLEAN DEFAULT FALSE,
    avif_autodetection BOOLEAN DEFAULT FALSE,
    file_size_limit BIGINT,
    allowed_mime_types TEXT[]
);

-- Create storage.objects table
CREATE TABLE IF NOT EXISTS storage.objects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bucket_id TEXT REFERENCES storage.buckets(id),
    name TEXT NOT NULL,
    owner UUID,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    last_accessed_at TIMESTAMPTZ DEFAULT NOW(),
    metadata JSONB
);

-- Create storage policies table (renamed from storage.policy to avoid conflicts)
CREATE TABLE IF NOT EXISTS storage.policies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bucket_id TEXT REFERENCES storage.buckets(id),
    name TEXT NOT NULL,
    definition TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Step 3: Create core application tables

-- Organizations table
CREATE TABLE IF NOT EXISTS public.organizations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    description TEXT,
    tier TEXT DEFAULT 'basic' CHECK (tier IN ('basic', 'pro', 'enterprise')),
    settings JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Organization members table
CREATE TABLE IF NOT EXISTS public.organization_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    user_id UUID NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('admin', 'coach', 'assistant', 'player', 'parent', 'viewer')),
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'pending')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(organization_id, user_id)
);

-- Players table
CREATE TABLE IF NOT EXISTS public.players (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    jersey_number INTEGER,
    position TEXT,
    date_of_birth DATE,
    email TEXT,
    phone TEXT,
    address TEXT,
    emergency_contact JSONB,
    medical_info JSONB,
    stats JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(organization_id, jersey_number)
);

-- Videos table
CREATE TABLE IF NOT EXISTS public.videos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    file_url TEXT NOT NULL,
    thumbnail_url TEXT,
    duration_seconds INTEGER NOT NULL DEFAULT 0,
    file_size_bytes BIGINT NOT NULL DEFAULT 0,
    resolution_width INTEGER,
    resolution_height INTEGER,
    processing_status TEXT DEFAULT 'uploaded' CHECK (processing_status IN ('uploaded', 'processing', 'ready', 'failed')),
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Video tags table
CREATE TABLE IF NOT EXISTS public.video_tags (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    video_id UUID NOT NULL REFERENCES public.videos(id) ON DELETE CASCADE,
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    tag_type TEXT NOT NULL CHECK (tag_type IN ('drill', 'moment', 'player', 'tactic', 'mistake', 'skill')),
    timestamp_seconds FLOAT NOT NULL,
    description TEXT,
    notes TEXT,
    event_type TEXT, -- Legacy compatibility column
    tag_data JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Video tag analytics view
CREATE OR REPLACE VIEW public.video_tag_analytics AS
SELECT
    v.id as video_id,
    v.organization_id,
    COUNT(vt.id) as total_tags,
    COUNT(vt.id) FILTER (WHERE vt.tag_type = 'drill') as drill_tags,
    COUNT(vt.id) FILTER (WHERE vt.tag_type = 'moment') as moment_tags,
    COUNT(vt.id) FILTER (WHERE vt.tag_type = 'player') as player_tags,
    COUNT(vt.id) FILTER (WHERE vt.tag_type = 'tactic') as tactic_tags,
    COUNT(vt.id) FILTER (WHERE vt.tag_type = 'mistake') as mistake_tags,
    COUNT(vt.id) FILTER (WHERE vt.tag_type = 'skill') as skill_tags,
    CASE
        WHEN v.duration_seconds > 0 THEN (COUNT(vt.id)::FLOAT / (v.duration_seconds / 60.0))
        ELSE 0
    END as average_tags_per_minute
FROM public.videos v
LEFT JOIN public.video_tags vt ON v.id = vt.video_id
GROUP BY v.id, v.organization_id, v.duration_seconds;

-- Step 4: Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_organization_members_org_id ON public.organization_members(organization_id);
CREATE INDEX IF NOT EXISTS idx_organization_members_user_id ON public.organization_members(user_id);
CREATE INDEX IF NOT EXISTS idx_players_org_id ON public.players(organization_id);
CREATE INDEX IF NOT EXISTS idx_videos_org_id ON public.videos(organization_id);
CREATE INDEX IF NOT EXISTS idx_videos_status ON public.videos(processing_status);
CREATE INDEX IF NOT EXISTS idx_video_tags_video_id ON public.video_tags(video_id);
CREATE INDEX IF NOT EXISTS idx_video_tags_org_id ON public.video_tags(organization_id);
CREATE INDEX IF NOT EXISTS idx_video_tags_type ON public.video_tags(tag_type);
CREATE INDEX IF NOT EXISTS idx_video_tags_timestamp ON public.video_tags(timestamp_seconds);

-- Step 5: Enable Row Level Security (RLS)
ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.organization_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.players ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.videos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.video_tags ENABLE ROW LEVEL SECURITY;

-- Step 6: Create RLS Policies

-- Organizations policies
CREATE POLICY IF NOT EXISTS "Organizations are viewable by members" ON public.organizations
    FOR SELECT USING (
        id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY IF NOT EXISTS "Organizations are manageable by admins" ON public.organizations
    FOR ALL USING (
        id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = auth.uid() AND role IN ('admin')
        )
    );

-- Organization members policies
CREATE POLICY IF NOT EXISTS "Organization members are viewable by org members" ON public.organization_members
    FOR SELECT USING (
        organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY IF NOT EXISTS "Organization members are manageable by admins" ON public.organization_members
    FOR ALL USING (
        organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = auth.uid() AND role IN ('admin')
        )
    );

-- Players policies
CREATE POLICY IF NOT EXISTS "Players are viewable by org members" ON public.players
    FOR SELECT USING (
        organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY IF NOT EXISTS "Players are manageable by coaches and admins" ON public.players
    FOR ALL USING (
        organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = auth.uid() AND role IN ('admin', 'coach', 'assistant')
        )
    );

-- Videos policies
CREATE POLICY IF NOT EXISTS "Videos are viewable by org members" ON public.videos
    FOR SELECT USING (
        organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY IF NOT EXISTS "Videos are manageable by coaches and admins" ON public.videos
    FOR ALL USING (
        organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = auth.uid() AND role IN ('admin', 'coach', 'assistant')
        )
    );

-- Video tags policies
CREATE POLICY IF NOT EXISTS "Video tags are viewable by org members" ON public.video_tags
    FOR SELECT USING (
        organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY IF NOT EXISTS "Video tags are manageable by coaches and admins" ON public.video_tags
    FOR ALL USING (
        organization_id IN (
            SELECT organization_id FROM public.organization_members
            WHERE user_id = auth.uid() AND role IN ('admin', 'coach', 'assistant')
        )
    );

-- Step 7: Create utility functions

-- Function to get tags by data key
CREATE OR REPLACE FUNCTION get_tags_by_data_key(
    p_video_id UUID,
    p_key TEXT,
    p_value TEXT DEFAULT NULL
)
RETURNS TABLE (
    id UUID,
    tag_type TEXT,
    timestamp_seconds FLOAT,
    description TEXT,
    tag_data JSONB,
    created_at TIMESTAMPTZ
)
LANGUAGE SQL
SECURITY DEFINER
AS $$
    SELECT vt.id, vt.tag_type, vt.timestamp_seconds, vt.description, vt.tag_data, vt.created_at
    FROM public.video_tags vt
    WHERE vt.video_id = p_video_id
    AND (
        CASE
            WHEN p_value IS NULL THEN vt.tag_data ? p_key
            ELSE vt.tag_data ->> p_key = p_value
        END
    )
    ORDER BY vt.timestamp_seconds ASC;
$$;

-- Function to get video analytics
CREATE OR REPLACE FUNCTION get_video_analytics(p_video_id UUID)
RETURNS TABLE (
    total_tags BIGINT,
    tags_by_type JSONB,
    average_tags_per_minute FLOAT
)
LANGUAGE SQL
SECURITY DEFINER
AS $$
    SELECT
        COUNT(vt.id) as total_tags,
        jsonb_object_agg(
            vt.tag_type,
            COUNT(vt.id) FILTER (WHERE vt.tag_type IS NOT NULL)
        ) as tags_by_type,
        CASE
            WHEN v.duration_seconds > 0 THEN (COUNT(vt.id)::FLOAT / (v.duration_seconds / 60.0))
            ELSE 0
        END as average_tags_per_minute
    FROM public.videos v
    LEFT JOIN public.video_tags vt ON v.id = vt.video_id
    WHERE v.id = p_video_id
    GROUP BY v.id, v.duration_seconds;
$$;

-- Step 8: Grant appropriate permissions

-- Grant basic permissions to authenticated users
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA storage TO authenticated;

-- Grant permissions on tables
GRANT SELECT, INSERT, UPDATE, DELETE ON public.organizations TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.organization_members TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.players TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.videos TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.video_tags TO authenticated;

-- Grant permissions on storage tables
GRANT SELECT, INSERT, UPDATE, DELETE ON storage.buckets TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON storage.objects TO authenticated;
GRANT SELECT ON storage.policies TO authenticated;

-- Grant permissions on views and functions
GRANT SELECT ON public.video_tag_analytics TO authenticated;
GRANT EXECUTE ON FUNCTION get_tags_by_data_key(UUID, TEXT, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION get_video_analytics(UUID) TO authenticated;

-- Grant permissions to anon role (for public access where needed)
GRANT USAGE ON SCHEMA public TO anon;

-- Grant service role full access
GRANT ALL ON ALL TABLES IN SCHEMA public TO service_role;
GRANT ALL ON ALL TABLES IN SCHEMA storage TO service_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO service_role;

-- Step 9: Create default storage bucket for videos
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'videos',
    'videos',
    false,
    104857600, -- 100MB limit
    ARRAY['video/mp4', 'video/quicktime', 'video/x-msvideo', 'video/webm']
) ON CONFLICT (id) DO NOTHING;

-- Step 10: Insert sample data for development (optional)
INSERT INTO public.organizations (id, name, slug, description, tier)
VALUES (
    '550e8400-e29b-41d4-a716-446655440000',
    'VOAB JO17 Team',
    'voab-jo17',
    'VOAB JO17 Tactical Manager Team',
    'pro'
) ON CONFLICT (id) DO NOTHING;

-- Step 11: Create triggers for updated_at timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply updated_at triggers to all tables
CREATE TRIGGER update_organizations_updated_at
    BEFORE UPDATE ON public.organizations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_organization_members_updated_at
    BEFORE UPDATE ON public.organization_members
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_players_updated_at
    BEFORE UPDATE ON public.players
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_videos_updated_at
    BEFORE UPDATE ON public.videos
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_video_tags_updated_at
    BEFORE UPDATE ON public.video_tags
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Final step: Refresh schema cache
NOTIFY pgrst, 'reload schema';

-- Log completion
DO $$
BEGIN
    RAISE NOTICE 'Complete Database Foundation Migration 2025 completed successfully';
    RAISE NOTICE 'Created tables: organizations, organization_members, players, videos, video_tags';
    RAISE NOTICE 'Created storage tables: buckets, objects, policies';
    RAISE NOTICE 'Created roles: authenticated, anon, service_role';
    RAISE NOTICE 'Enabled RLS and created security policies';
    RAISE NOTICE 'Created utility functions and granted permissions';
END $$;
