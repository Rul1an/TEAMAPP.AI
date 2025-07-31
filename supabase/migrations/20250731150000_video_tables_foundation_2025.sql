-- =============================================
-- VIDEO TABLES FOUNDATION MIGRATION 2025
-- Creates video-related tables that were missing
-- =============================================

-- Videos table
CREATE TABLE IF NOT EXISTS public.videos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id uuid NOT NULL REFERENCES public.organizations(id),
  title text NOT NULL,
  description text,
  file_url text,
  thumbnail_url text,
  duration_seconds integer,
  file_size_bytes bigint,
  mime_type text,
  processing_status text DEFAULT 'pending' CHECK (processing_status IN ('pending', 'processing', 'completed', 'failed')),
  upload_status text DEFAULT 'pending' CHECK (upload_status IN ('pending', 'uploading', 'completed', 'failed')),
  metadata jsonb DEFAULT '{}',
  tags text[] DEFAULT '{}',
  is_public boolean DEFAULT false,
  created_by uuid REFERENCES auth.users(id),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Video tags table
CREATE TABLE IF NOT EXISTS public.video_tags (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  video_id uuid NOT NULL REFERENCES public.videos(id),
  organization_id uuid NOT NULL REFERENCES public.organizations(id),
  event_type text NOT NULL CHECK (event_type IN ('goal', 'assist', 'shot', 'save', 'foul', 'card', 'substitution', 'corner_kick', 'free_kick', 'offside', 'penalty', 'tackle', 'interception', 'pass', 'cross', 'drill', 'moment', 'other')),
  timestamp_seconds numeric NOT NULL CHECK (timestamp_seconds >= 0),
  player_id uuid REFERENCES public.players(id),
  label text,
  description text,
  notes text,
  created_by uuid REFERENCES auth.users(id),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Training exercises table
CREATE TABLE IF NOT EXISTS public.training_exercises (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id uuid NOT NULL REFERENCES public.organizations(id),
  name text NOT NULL,
  description text,
  category text,
  difficulty text CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')),
  duration integer,
  equipment_needed text[],
  instructions jsonb DEFAULT '[]',
  variations jsonb DEFAULT '[]',
  objectives text[],
  is_public boolean DEFAULT false,
  created_by uuid REFERENCES auth.users(id),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- VEO highlights table
CREATE TABLE IF NOT EXISTS public.veo_highlights (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id uuid NOT NULL REFERENCES public.organizations(id),
  video_id uuid REFERENCES public.videos(id),
  match_id uuid REFERENCES public.matches(id),
  title text NOT NULL,
  description text,
  start_time numeric NOT NULL,
  end_time numeric NOT NULL,
  tags text[] DEFAULT '{}',
  players_involved uuid[] DEFAULT '{}',
  highlight_type text CHECK (highlight_type IN ('goal', 'assist', 'save', 'skill', 'tactical', 'other')),
  quality_score integer CHECK (quality_score >= 1 AND quality_score <= 10),
  is_featured boolean DEFAULT false,
  storage_path text,
  external_url text,
  metadata jsonb DEFAULT '{}',
  created_by uuid REFERENCES auth.users(id),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS on video tables
ALTER TABLE public.videos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.video_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.training_exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.veo_highlights ENABLE ROW LEVEL SECURITY;

-- Create essential indexes for video tables
CREATE INDEX IF NOT EXISTS idx_videos_organization_id ON public.videos(organization_id);
CREATE INDEX IF NOT EXISTS idx_videos_created_by ON public.videos(created_by);
CREATE INDEX IF NOT EXISTS idx_videos_processing_status ON public.videos(processing_status);
CREATE INDEX IF NOT EXISTS idx_video_tags_video_id ON public.video_tags(video_id);
CREATE INDEX IF NOT EXISTS idx_video_tags_organization_id ON public.video_tags(organization_id);
CREATE INDEX IF NOT EXISTS idx_video_tags_event_type ON public.video_tags(event_type);
CREATE INDEX IF NOT EXISTS idx_video_tags_player_id ON public.video_tags(player_id);
CREATE INDEX IF NOT EXISTS idx_training_exercises_organization_id ON public.training_exercises(organization_id);
CREATE INDEX IF NOT EXISTS idx_training_exercises_category ON public.training_exercises(category);
CREATE INDEX IF NOT EXISTS idx_veo_highlights_organization_id ON public.veo_highlights(organization_id);
CREATE INDEX IF NOT EXISTS idx_veo_highlights_video_id ON public.veo_highlights(video_id);
CREATE INDEX IF NOT EXISTS idx_veo_highlights_match_id ON public.veo_highlights(match_id);

-- Create RLS policies for video tables
CREATE POLICY "Videos: Users can view videos in their organizations" ON public.videos
  FOR SELECT TO authenticated
  USING (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Videos: Users can insert videos in their organizations" ON public.videos
  FOR INSERT TO authenticated
  WITH CHECK (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Video Tags: Users can view tags in their organizations" ON public.video_tags
  FOR SELECT TO authenticated
  USING (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Video Tags: Users can insert tags in their organizations" ON public.video_tags
  FOR INSERT TO authenticated
  WITH CHECK (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Training Exercises: Users can view exercises in their organizations" ON public.training_exercises
  FOR SELECT TO authenticated
  USING (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "VEO Highlights: Users can view highlights in their organizations" ON public.veo_highlights
  FOR SELECT TO authenticated
  USING (
    organization_id IN (
      SELECT organization_id FROM public.organization_members
      WHERE user_id = auth.uid()
    )
  );

-- Add updated_at triggers to video tables
DROP TRIGGER IF EXISTS handle_updated_at ON public.videos;
CREATE TRIGGER handle_updated_at
  BEFORE UPDATE ON public.videos
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS handle_updated_at ON public.video_tags;
CREATE TRIGGER handle_updated_at
  BEFORE UPDATE ON public.video_tags
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS handle_updated_at ON public.training_exercises;
CREATE TRIGGER handle_updated_at
  BEFORE UPDATE ON public.training_exercises
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS handle_updated_at ON public.veo_highlights;
CREATE TRIGGER handle_updated_at
  BEFORE UPDATE ON public.veo_highlights
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- Final validation
DO $$
BEGIN
  RAISE NOTICE '==============================================';
  RAISE NOTICE '✅ VIDEO TABLES FOUNDATION COMPLETE';
  RAISE NOTICE '✅ Videos table created with proper organization reference';
  RAISE NOTICE '✅ Video tags table created with video_id column';
  RAISE NOTICE '✅ Training exercises table created';
  RAISE NOTICE '✅ VEO highlights table created';
  RAISE NOTICE '✅ RLS enabled on all video tables';
  RAISE NOTICE '✅ Performance indexes created';
  RAISE NOTICE '✅ RLS policies applied';
  RAISE NOTICE '✅ Updated_at triggers applied';
  RAISE NOTICE '==============================================';
END
$$;
