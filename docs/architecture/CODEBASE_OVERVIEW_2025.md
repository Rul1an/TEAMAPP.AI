## Codebase Overview – JO17 Tactical Manager (Q3 2025)

Doel: een up‑to‑date, hoog‑over overzicht van structuur, entrypoints, dataflow, state management, security en CI/CD om de huidige codebase volledig in kaart te brengen.

### 1) Entrypoints & Runtime
- `lib/main.dart` en `lib/main_fan.dart`: app entry (production/demo variant). Init van env, theming, router en monitoring.
- `lib/app_runner.dart`: guarded app start (error boundaries, Sentry/monitoring hooks).
- Configuratie: `lib/config/environment.dart`, `lib/config/providers.dart`, `lib/config/supabase_config.dart`.

### 2) Routing & Navigatie
- `lib/config/router.dart` (en `router_fan.dart`): route declaraties, guards en deep‑links.
- Observability: `lib/analytics/analytics_route_observer.dart` registreert navigatie-events.

### 3) Lagen & Modules
- Presentatie/UI: `lib/screens/**`, `lib/widgets/**`, theming in `lib/config/theme*.dart`.
- State Management: `lib/providers/**` (Providers als façade over services/repositories).
- Services: `lib/services/**` (businesslogica, integraties: auth, monitoring, notificaties, import/export, feature flags).
- Repositories: `lib/repositories/**` (abstracties en implementaties; remote+local cache).
- Data Sources: `lib/data/**` (Supabase PostgREST/RPC toegang per domein).
- Modellen: `lib/models/**` (domain modellen; JSON serde; ID’s als `String`).
- Lokale cache: `lib/hive/**` (cache tabellen per domein, key management).
- PDF: `lib/pdf/**` (generators, assets, core util).
- Kern util: `lib/core/**`, `lib/utils/**`, `lib/extensions/**`.

### 4) Dataflow (voorbeeld)
- UI (Widget/Screen) → Provider → Service/Repository → DataSource (Supabase) → Repository (cache write‑through) → Provider → UI update.
- Observability: route observer + `PerformanceTracker` + Sentry in `services/monitoring_service.dart`.

### 5) Security & RBAC
- UI‑toegang: `lib/services/permission_service.dart` (rol/actie‑checks, view‑only restricties).
- RBAC document: `docs/architecture/RBAC_MATRIX.md` (routes/actions x rollen).
- RLS (database): enforced via Supabase policies (gevalideerd in CI/harnas‑tests).
- Runtime bescherming: `lib/services/runtime_security_service.dart` en CSP/headers in `netlify.toml`.

### 6) Supabase & Database
- Config: `lib/config/supabase_config.dart` (URL/keys via defines).
- Migrations: `supabase/migrations/**` (idempotent, zonder psql meta‑commando’s).
- CLI/CI: `.github/workflows/main-ci.yml` (optionele schema prepare) en `integration_tests_secured.yml` (migrations push voor preview).

### 7) Tests
- Unit/Widget: `test/**` (exclusief `integration/`, `security/`).
- Integratie: `test/integration/**` (real DB suite standaard geskipt in CI; enable via env).
- Security (Dart‑only): `test/security/**` (netwerkende checks zonder Flutter binding).
- Policies: `test/policies/**` (ID‑policy, String IDs overal).

### 8) CI/CD & Deploy
- Hoofdworkflow: `.github/workflows/main-ci.yml`
  - Quality & tests → Migrations (optioneel) → Build & Netlify deploy → (optioneel) Integration tests → Preview deploy voor PR’s.
- Extra workflows: `integration_tests_secured.yml` (migrations + beperkte tests), `pure_dart_prod_checks.yml` (Dart‑only net tests).
- Netlify hosting: `netlify.toml` (CSP, security headers, SPA redirects, publish `build/web`).

### 9) Web build
- Standaard CanvasKit: `flutter build web --release` (Impeller/SKWasm roadmap optioneel, zie TODO/roadmap).
- CSP: Supabase + Sentry ingest in `connect-src` (prod hardened).
- Custom 404/500: `web/404.html`, `web/500.html`.

### 10) Open Points / Verdere Verdieping
- RLS end‑to‑end verificatie uitbouwen (admin harnas beschikbaar; standaard skip in CI).
- Repository‑consistentie (cache strategieën, error mapping) expliciet documenteren.
- Wasm build proef (allowed‑to‑fail matrix) en dependency audit voor `dart:html/js/ffi` paden.
- Privacy/GDPR flows (export/delete, consent) en log‑sanitization bevestigen.
- Rollen constants/enum centraliseren (vervang stringliterals) voor type‑veiligheid.

Bronnen voor detail:
- Providers: `lib/providers/**`
- Repositories: `lib/repositories/**`
- Data sources: `lib/data/**`
- Security/RBAC: `lib/services/permission_service.dart`, `docs/architecture/RBAC_MATRIX.md`
- CI/CD: `.github/workflows/*.yml`
- Hosting/security: `netlify.toml`


