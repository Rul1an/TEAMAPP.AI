-- Performance indexes for players and matches (safe, idempotent)

-- Players: index on organization_id
DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'players'
      AND column_name = 'organization_id'
  ) THEN
    EXECUTE 'CREATE INDEX IF NOT EXISTS idx_players_organization_id ON public.players (organization_id)';
  END IF;
END $$;

-- Matches: composite index on (organization_id, <date column>) supporting upcoming/recent queries
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'matches' AND column_name = 'date_time'
  ) THEN
    EXECUTE 'CREATE INDEX IF NOT EXISTS idx_matches_org_date_time ON public.matches (organization_id, date_time)';
  ELSIF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'matches' AND column_name = 'match_date'
  ) THEN
    EXECUTE 'CREATE INDEX IF NOT EXISTS idx_matches_org_match_date ON public.matches (organization_id, match_date)';
  ELSIF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'matches' AND column_name = 'date'
  ) THEN
    EXECUTE 'CREATE INDEX IF NOT EXISTS idx_matches_org_date ON public.matches (organization_id, date)';
  END IF;
END $$;

-- Training sessions: ensure composite index exists as fallback (harmless if already created)
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'training_sessions' AND column_name = 'date_time'
  ) THEN
    EXECUTE 'CREATE INDEX IF NOT EXISTS idx_training_sessions_date_org ON public.training_sessions (date_time, organization_id)';
  END IF;
END $$;


