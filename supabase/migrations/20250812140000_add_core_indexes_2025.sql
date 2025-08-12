-- Add core indexes for organization-scoped performance
-- Safe and idempotent for repeated runs

-- Players
create index if not exists idx_players_organization_id on public.players(organization_id);

-- Training sessions
create index if not exists idx_training_sessions_organization_id on public.training_sessions(organization_id);
create index if not exists idx_training_sessions_date on public.training_sessions(date);

-- Matches
create index if not exists idx_matches_organization_id on public.matches(organization_id);
create index if not exists idx_matches_date on public.matches(date);

-- Videos
create index if not exists idx_videos_organization_id on public.videos(organization_id);

-- Video tags
create index if not exists idx_video_tags_organization_id on public.video_tags(organization_id);
create index if not exists idx_video_tags_video_id on public.video_tags(video_id);

-- Organization members
create index if not exists idx_org_members_organization_id on public.organization_members(organization_id);
create index if not exists idx_org_members_user_id on public.organization_members(user_id);
