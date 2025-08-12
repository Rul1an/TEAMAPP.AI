-- Enable RLS and add tenant isolation policies in a safe/idempotent manner
-- Notes:
-- - Uses DO blocks to guard against duplicate policy creation
-- - Assumes membership via public.organization_members (user_id, organization_id)
-- - Read access: users can read rows for organizations they are a member of
-- - Write access: authenticated users who are members can modify rows

-- Helper to enable RLS if not enabled
do $$ begin
  perform 1 from pg_tables where schemaname = 'public' and tablename = 'players';
  execute 'alter table public.players enable row level security';
exception when others then null; end $$;

do $$ begin
  perform 1 from pg_tables where schemaname = 'public' and tablename = 'training_sessions';
  execute 'alter table public.training_sessions enable row level security';
exception when others then null; end $$;

do $$ begin
  perform 1 from pg_tables where schemaname = 'public' and tablename = 'matches';
  execute 'alter table public.matches enable row level security';
exception when others then null; end $$;

do $$ begin
  perform 1 from pg_tables where schemaname = 'public' and tablename = 'videos';
  execute 'alter table public.videos enable row level security';
exception when others then null; end $$;

do $$ begin
  perform 1 from pg_tables where schemaname = 'public' and tablename = 'video_tags';
  execute 'alter table public.video_tags enable row level security';
exception when others then null; end $$;

do $$ begin
  perform 1 from pg_tables where schemaname = 'public' and tablename = 'organizations';
  execute 'alter table public.organizations enable row level security';
exception when others then null; end $$;

do $$ begin
  perform 1 from pg_tables where schemaname = 'public' and tablename = 'organization_members';
  execute 'alter table public.organization_members enable row level security';
exception when others then null; end $$;

-- Policy guards
-- players
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'players' AND policyname = 'players_select_by_org')
  THEN
    EXECUTE $$
      CREATE POLICY players_select_by_org ON public.players
      FOR SELECT
      USING (
        exists (
          select 1 from public.organization_members om
          where om.organization_id = players.organization_id
            and om.user_id = auth.uid()
        )
      )
    $$;
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'players' AND policyname = 'players_modify_by_org_member')
  THEN
    EXECUTE $$
      CREATE POLICY players_modify_by_org_member ON public.players
      FOR ALL
      TO authenticated
      USING (
        exists (
          select 1 from public.organization_members om
          where om.organization_id = players.organization_id
            and om.user_id = auth.uid()
        )
      )
      WITH CHECK (
        exists (
          select 1 from public.organization_members om
          where om.organization_id = players.organization_id
            and om.user_id = auth.uid()
        )
      )
    $$;
  END IF;
END $$;

-- training_sessions
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'training_sessions' AND policyname = 'training_sessions_select_by_org')
  THEN
    EXECUTE $$
      CREATE POLICY training_sessions_select_by_org ON public.training_sessions
      FOR SELECT
      USING (
        exists (
          select 1 from public.organization_members om
          where om.organization_id = training_sessions.organization_id
            and om.user_id = auth.uid()
        )
      )
    $$;
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'training_sessions' AND policyname = 'training_sessions_modify_by_org_member')
  THEN
    EXECUTE $$
      CREATE POLICY training_sessions_modify_by_org_member ON public.training_sessions
      FOR ALL
      TO authenticated
      USING (
        exists (
          select 1 from public.organization_members om
          where om.organization_id = training_sessions.organization_id
            and om.user_id = auth.uid()
        )
      )
      WITH CHECK (
        exists (
          select 1 from public.organization_members om
          where om.organization_id = training_sessions.organization_id
            and om.user_id = auth.uid()
        )
      )
    $$;
  END IF;
END $$;

-- matches
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'matches' AND policyname = 'matches_select_by_org')
  THEN
    EXECUTE $$
      CREATE POLICY matches_select_by_org ON public.matches
      FOR SELECT
      USING (
        exists (
          select 1 from public.organization_members om
          where om.organization_id = matches.organization_id
            and om.user_id = auth.uid()
        )
      )
    $$;
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'matches' AND policyname = 'matches_modify_by_org_member')
  THEN
    EXECUTE $$
      CREATE POLICY matches_modify_by_org_member ON public.matches
      FOR ALL
      TO authenticated
      USING (
        exists (
          select 1 from public.organization_members om
          where om.organization_id = matches.organization_id
            and om.user_id = auth.uid()
        )
      )
      WITH CHECK (
        exists (
          select 1 from public.organization_members om
          where om.organization_id = matches.organization_id
            and om.user_id = auth.uid()
        )
      )
    $$;
  END IF;
END $$;

-- videos
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'videos' AND policyname = 'videos_select_by_org')
  THEN
    EXECUTE $$
      CREATE POLICY videos_select_by_org ON public.videos
      FOR SELECT
      USING (
        exists (
          select 1 from public.organization_members om
          where om.organization_id = videos.organization_id
            and om.user_id = auth.uid()
        )
      )
    $$;
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'videos' AND policyname = 'videos_modify_by_org_member')
  THEN
    EXECUTE $$
      CREATE POLICY videos_modify_by_org_member ON public.videos
      FOR ALL
      TO authenticated
      USING (
        exists (
          select 1 from public.organization_members om
          where om.organization_id = videos.organization_id
            and om.user_id = auth.uid()
        )
      )
      WITH CHECK (
        exists (
          select 1 from public.organization_members om
          where om.organization_id = videos.organization_id
            and om.user_id = auth.uid()
        )
      )
    $$;
  END IF;
END $$;

-- video_tags
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'video_tags' AND policyname = 'video_tags_select_by_org')
  THEN
    EXECUTE $$
      CREATE POLICY video_tags_select_by_org ON public.video_tags
      FOR SELECT
      USING (
        exists (
          select 1 from public.organization_members om
          where om.organization_id = video_tags.organization_id
            and om.user_id = auth.uid()
        )
      )
    $$;
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'video_tags' AND policyname = 'video_tags_modify_by_org_member')
  THEN
    EXECUTE $$
      CREATE POLICY video_tags_modify_by_org_member ON public.video_tags
      FOR ALL
      TO authenticated
      USING (
        exists (
          select 1 from public.organization_members om
          where om.organization_id = video_tags.organization_id
            and om.user_id = auth.uid()
        )
      )
      WITH CHECK (
        exists (
          select 1 from public.organization_members om
          where om.organization_id = video_tags.organization_id
            and om.user_id = auth.uid()
        )
      )
    $$;
  END IF;
END $$;

-- organizations & organization_members: restrict by membership on org
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'organizations' AND policyname = 'organizations_select_by_membership')
  THEN
    EXECUTE $$
      CREATE POLICY organizations_select_by_membership ON public.organizations
      FOR SELECT
      USING (
        exists (
          select 1 from public.organization_members om
          where om.organization_id = organizations.id
            and om.user_id = auth.uid()
        )
      )
    $$;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'organization_members' AND policyname = 'organization_members_select_self_org')
  THEN
    EXECUTE $$
      CREATE POLICY organization_members_select_self_org ON public.organization_members
      FOR SELECT
      USING (
        exists (
          select 1 from public.organization_members om
          where om.organization_id = organization_members.organization_id
            and om.user_id = auth.uid()
        )
      )
    $$;
  END IF;
END $$;
