# Security & CI Modernization (v0.9.1)

This release migrates secrets to build-time defines, adds observability, and improves CI stability.

## Build-time configuration (dart-defines)

Provide these defines at build/run time:

- SUPABASE_URL
- SUPABASE_ANON_KEY
- (optional) SENTRY_DSN
- APP_MODE (standalone|demo|saas)
- FLUTTER_ENV (development|test|production)

Examples:

```bash
# Local run (standalone)
flutter run \
  --dart-define=APP_MODE=standalone \
  --dart-define=FLUTTER_ENV=development \
  --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=xxxxx

# Web build
flutter build web --release \
  --dart-define=SUPABASE_URL=... \
  --dart-define=SUPABASE_ANON_KEY=...
```

## CI test strategy

- Unit/Widget tests (fork-friendly):
  - Runs without real network. Plugin channels are mocked.
  - Secrets are optional; harmless local defaults are used when missing.
  - Excludes `test/integration/**`, `test/security/**`, `test/connectivity/**`, `test/e2e/**`.

- Integration/Security tests (secured):
  - Separate job `integration-tests`, only on internal PRs or main.
  - Requires Supabase secrets (preview or base).

## Observability

- SentryNavigatorObserver added to router for navigation breadcrumbs.
- You may enable Sentry via `SENTRY_DSN` define in production builds.

## Notes

- Default `APP_MODE` remains `standalone` for backward compatibility.
- ErrorSanitizer no longer redacts all exceptions; only DB/internal keywords.
