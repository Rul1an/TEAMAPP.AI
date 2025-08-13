## CI/CD Secrets & Environment Defines (Preview/Staging = PREVIEW)

Required GitHub Secrets (Preview-only):
- SUPABASE_ACCESS_TOKEN: Supabase org token for CLI
- SUPABASE_PROJECT_REF_PREVIEW: Project ref (e.g., ohdbsujae...)
- SUPABASE_URL_PREVIEW: https://<ref>.supabase.co
- SUPABASE_ANON_KEY_PREVIEW: anon key
- SUPABASE_DB_URL_PREVIEW (optional, recommended): direct 5432 Postgres URL with sslmode=require for db push

Optional (for real-db admin tests – not enabled by default):
- SUPABASE_SERVICE_ROLE_KEY_PREVIEW: service role key for admin/schema checks

Build-time dart-defines (managed via deploy/hosting):
- FLUTTER_ENV: development|test|production
- APP_MODE: standalone|demo|saas
- SUPABASE_URL / SUPABASE_ANON_KEY (per environment)
- SENTRY_PING / SENTRY_PING_MESSAGE (optional)

Workflow guardrails:
- Migration job gates on modifications to `supabase/migrations/**`
- Concurrency: only one migration push at a time
- Db push uses direct DB URL when present, with retries
- Flutter job runs only unit/widget/perf; network/prod checks run in separate Dart-only job

Local recommendations:
- Align `supabase/config.toml` db.major_version to remote
- Never commit service role keys; only in GitHub Secrets


