-- Fix Critical Test Schema Issues 2025
-- Addresses: missing tables, columns, and functions identified in test failures

BEGIN;

-- 1. Add missing exercises table (critical for integration tests)
CREATE TABLE IF NOT EXISTS exercises (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  category TEXT,
  difficulty_level INTEGER CHECK (difficulty_level >= 1 AND difficulty_level <= 5),
  duration_minutes INTEGER,
  player_count INTEGER,
  equipment TEXT[],
  instructions TEXT,
  tags TEXT[],
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Add missing shirt_number column to players table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'players' AND column_name = 'shirt_number'
  ) THEN
    ALTER TABLE players ADD COLUMN shirt_number INTEGER;

    -- Add unique constraint per organization
    ALTER TABLE players ADD CONSTRAINT unique_shirt_number_per_org
      UNIQUE (organization_id, shirt_number);
  END IF;
END $$;

-- 3. Add missing performance_ratings table
CREATE TABLE IF NOT EXISTS performance_ratings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  player_id UUID REFERENCES players(id) ON DELETE CASCADE,
  session_id UUID REFERENCES training_sessions(id) ON DELETE CASCADE,
  rating INTEGER CHECK (rating >= 1 AND rating <= 10),
  technical_score INTEGER CHECK (technical_score >= 1 AND technical_score <= 10),
  physical_score INTEGER CHECK (physical_score >= 1 AND physical_score <= 10),
  mental_score INTEGER CHECK (mental_score >= 1 AND mental_score <= 10),
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(player_id, session_id)
);

-- 4. Create missing database functions
CREATE OR REPLACE FUNCTION calculate_player_performance(
  date_from DATE,
  date_to DATE,
  organization_id UUID,
  player_id UUID
) RETURNS JSON AS $$
DECLARE
  result JSON;
BEGIN
  SELECT json_build_object(
    'player_id', player_id,
    'average_rating', COALESCE(AVG(pr.rating), 0),
    'total_sessions', COUNT(pr.id),
    'technical_avg', COALESCE(AVG(pr.technical_score), 0),
    'physical_avg', COALESCE(AVG(pr.physical_score), 0),
    'mental_avg', COALESCE(AVG(pr.mental_score), 0)
  ) INTO result
  FROM performance_ratings pr
  JOIN training_sessions ts ON pr.session_id = ts.id
  WHERE pr.player_id = calculate_player_performance.player_id
    AND ts.organization_id = calculate_player_performance.organization_id
    AND ts.date BETWEEN date_from AND date_to;

  RETURN COALESCE(result, json_build_object(
    'player_id', player_id,
    'average_rating', 0,
    'total_sessions', 0,
    'technical_avg', 0,
    'physical_avg', 0,
    'mental_avg', 0
  ));
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 5. Create organization stats function
CREATE OR REPLACE FUNCTION get_organization_stats(org_id UUID)
RETURNS JSON AS $$
DECLARE
  result JSON;
BEGIN
  SELECT json_build_object(
    'organization_id', org_id,
    'total_players', (SELECT COUNT(*) FROM players WHERE organization_id = org_id),
    'total_sessions', (SELECT COUNT(*) FROM training_sessions WHERE organization_id = org_id),
    'total_matches', (SELECT COUNT(*) FROM matches WHERE organization_id = org_id),
    'active_players', (SELECT COUNT(*) FROM players WHERE organization_id = org_id AND status = 'active')
  ) INTO result;

  RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 6. Create update training metrics function
CREATE OR REPLACE FUNCTION update_training_metrics()
RETURNS TRIGGER AS $$
BEGIN
  -- Update session metrics when performance ratings change
  IF TG_TABLE_NAME = 'performance_ratings' THEN
    UPDATE training_sessions
    SET updated_at = NOW()
    WHERE id = NEW.session_id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for performance ratings
DROP TRIGGER IF EXISTS update_training_metrics_trigger ON performance_ratings;
CREATE TRIGGER update_training_metrics_trigger
  AFTER INSERT OR UPDATE ON performance_ratings
  FOR EACH ROW EXECUTE FUNCTION update_training_metrics();

-- 7. Add RLS policies for new tables
ALTER TABLE exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE performance_ratings ENABLE ROW LEVEL SECURITY;

-- RLS for exercises
CREATE POLICY "Users can view exercises from their organization" ON exercises
  FOR SELECT USING (
    organization_id IN (
      SELECT organization_id FROM profiles
      WHERE id = auth.uid()
    )
  );

CREATE POLICY "Coaches can manage exercises" ON exercises
  FOR ALL USING (
    organization_id IN (
      SELECT organization_id FROM profiles
      WHERE id = auth.uid()
      AND role IN ('coach', 'head_coach', 'admin')
    )
  );

-- RLS for performance_ratings
CREATE POLICY "Users can view ratings from their organization" ON performance_ratings
  FOR SELECT USING (
    player_id IN (
      SELECT p.id FROM players p
      JOIN profiles pr ON p.organization_id = pr.organization_id
      WHERE pr.id = auth.uid()
    )
  );

CREATE POLICY "Coaches can manage ratings" ON performance_ratings
  FOR ALL USING (
    player_id IN (
      SELECT p.id FROM players p
      JOIN profiles pr ON p.organization_id = pr.organization_id
      WHERE pr.id = auth.uid()
      AND pr.role IN ('coach', 'head_coach', 'admin')
    )
  );

-- 8. Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_exercises_organization_id ON exercises(organization_id);
CREATE INDEX IF NOT EXISTS idx_exercises_category ON exercises(category);
CREATE INDEX IF NOT EXISTS idx_performance_ratings_player_id ON performance_ratings(player_id);
CREATE INDEX IF NOT EXISTS idx_performance_ratings_session_id ON performance_ratings(session_id);
CREATE INDEX IF NOT EXISTS idx_players_shirt_number ON players(organization_id, shirt_number);

-- 9. Insert some default exercises for testing
INSERT INTO exercises (organization_id, name, description, category, difficulty_level, duration_minutes, player_count, tags)
SELECT
  o.id,
  'Passing Drill',
  'Basic passing exercise for skill development',
  'Technical',
  2,
  15,
  8,
  ARRAY['passing', 'technical']
FROM organizations o
WHERE NOT EXISTS (
  SELECT 1 FROM exercises e WHERE e.organization_id = o.id AND e.name = 'Passing Drill'
)
LIMIT 10; -- Limit to prevent mass insertions

COMMIT;
