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
  - Import/Export: pure helpers beschikbaar voor parsing en excel headers; IO vrij getest (CSV/Excel parsing helpers, playtime calc).
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
- GDPR: `lib/services/gdpr_service.dart` (export/delete hooks via RPC); PII-sanitization in `lib/utils/app_logger.dart` en Sentry `sendDefaultPii=false`.
  - Consent: `lib/services/consent_service.dart` (lokale flags met Hive + sync naar Supabase user metadata).

### 6) Supabase & Database
- Config: `lib/config/supabase_config.dart` (URL/keys via defines).
- Migrations: `supabase/migrations/**` (idempotent, zonder psql meta‑commando’s).
- CLI/CI: `.github/workflows/main-ci.yml` (optionele schema prepare) en `integration_tests_secured.yml` (migrations push voor preview).

### 7) Tests
- Unit/Widget: `test/**` (exclusief `integration/`, `security/`).
- Integratie: `test/integration/**` (real DB suite standaard geskipt in CI; enable via env).
- Security (Dart‑only): `test/security/**` (netwerkende checks zonder Flutter binding).
- Policies: `test/policies/**` (ID‑policy, String IDs overal).
 - Providers rooktests: Players/Trainings/Matches/Profile/Statistics valideren UI‑safe folding; GraphQL tag‑subscription mapping gedekt.
 - Import: schema‑/kolomvalidatie rooktests voor `ScheduleImportService.importCsvBytes` (zonder IO).
 - Export: pure helpers voor headers, playtime en attendance symbolen met unit tests; PDF/Excel IO buiten unit-run gehouden.

### 7a) Repository Test Standard (2025)
Doel: voorspelbaar, gedekt gedrag voor offline‑first repositories (Result<T>, cache fallback, invalidatie).

- Basisprincipes
  - Result‑gebaseerde API: `Future<Result<T>>` met expliciete `AppFailure` (`NetworkFailure`, `CacheFailure`, `GenericFailure`).
  - Offline‑first: remote success → cache write‑through; remote failure → cache fallback; beide falen → `NetworkFailure` wanneer oorzaak netwerk is.
  - Mutaties: `add/update/delete` geven `Result<void>` terug en legen relevante caches bij succes.
  - Provider‑laag: UI‑safe folding (bij failure lege lijsten/null‑objecten naar UI) + logging/telemetrie.

- Standaard testgevallen per repo type (Players, Matches, Trainings, etc.)
  1) getAll success → retourneert remote data en schrijft cache.
  2) getAll netwerkfout + cache hit → retourneert cache (Success).
  3) getAll netwerkfout + cache miss → `Failure(NetworkFailure)`.
  4) getById success/fallback → zoekt ook in cache bij remote failure.
  5) Mutations clear cache on success; bij failure: geen cache invalidatie, `Failure(NetworkFailure)` indien netwerk.
  6) Afgeleide queries (bijv. `getUpcoming`/`getRecent`) filteren op basis van `getAll`‑resultaat en bubbelen failures door.

- Provider rooktests
  - Providers vouwen failures naar UI‑veilige defaults (bv. lege lijst) en loggen failure context.

- Implementatiestatus
  - Players: standaard testset aanwezig (success/fallback/failure/mutaties).
  - Matches: standaard testset aanwezig (incl. failure mapping).
  - Trainings: standaard testset aanwezig (incl. cache invalidatie op mutaties).
  - Profiles/Statistics: provider rooktests aanwezig (UI‑safe folding). GraphQL (video tagging) actief en gedekt.

### 8) CI/CD & Deploy
- Hoofdworkflow: `.github/workflows/main-ci.yml`
  - Quality & tests → Migrations (optioneel) → Build & Netlify deploy → (optioneel) Integration tests → Preview deploy voor PR’s.
- Extra workflows: `integration_tests_secured.yml` (migrations + beperkte tests), `pure_dart_prod_checks.yml` (Dart‑only net tests).
- Netlify hosting: `netlify.toml` (CSP, security headers, SPA redirects, publish `build/web`).
 - Teststrategie (2025):
   - Unit/Widget: standaard in hoofdworkflow; hermetisch.
   - Integration (zonder netwerk): optioneel/gated.
   - Live/E2E (Supabase real DB, integration_test): alleen via manual dispatch/scheduled met secrets; standaard geskipt.

### 9) Web build
- Standaard CanvasKit: `flutter build web --release` (Impeller/SKWasm roadmap optioneel, zie TODO/roadmap).
- CI Matrix: CanvasKit en Wasm builds draaien in hoofdworkflow (Wasm als allowed-to-fail) met build metrics in job summary.
- Wasm hardening (2025): COOP/COEP headers, Trusted Types (sentry-dart, dompurify, goog#html, flutter-js), CSP uitgebreid; wasm audit (`tool/wasm_audit.dart`) in CI.
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

---

### Changelog (rolling)
- 2025‑08‑13
  - Observability: Sentry `sendDefaultPii=false` en `tracesSampler` toegevoegd; PII-scrubbing blijft via breadcrumbs.
  - CI: Production deploy faalt wanneer verplichte secrets ontbreken (SUPABASE_URL/ANON_KEY, SENTRY_DSN).
  - CI: Web Build Matrix toegevoegd (CanvasKit + Wasm, metrics upload); duplicate workflow-headers verwijderd.
  - Tests: RLS integratiecovers toegevoegd: `rls_unauth_restrictions_test.dart` en `rls_create_edit_delete_view_test.dart` (skippen zonder env).
  - RBAC: string literals vervangen door `Roles` constants in `PermissionService`, `FeatureService.hasPermission`, en `CoachDashboardScreen`.
  - CI: “Integration Tests (secured)” beperkt tot unit/widget suites; dart‑only security tests gescheiden. Real DB/prod suites skippen in CI via env toggles.
  - Netlify: CSP `connect-src` uitgebreid met Sentry ingest‑domeinen; 404/500 pagina’s toegevoegd.
  - IDs policy: audit afgerond, `TrainingExercise.id` naar `String`.
  - CI: optionele wasm build workflow toegevoegd (manual/scheduled), geen deploy.
  - RBAC: rollenstrings gecentraliseerd in `lib/constants/roles.dart`; `PermissionService` + tests geüpdatet.
  - RLS: extra smoke test toegevoegd (`test/integration/rls_rules_smoke_test.dart`) die alleen draait met service role.
  - Video: `VeoHighlightRepository` gemigreerd naar Result<T> interface met `SupabaseVeoHighlightRepository` implementatie; providers vouwen Result naar concrete waarden.
  - RBAC: eerste adoptie van `lib/constants/roles.dart` in services/tests; uitrol naar UI/providers gestart.
  - Training UI: null-safety hardening toegepast (coachNotes check en attendance percentage bij 0 deelnemers) om web null‑assert crashes te voorkomen.
  - Demo mode: `demo_mode_provider` switched naar `Roles` constants voor consistente rolbenamingen.
  - RBAC demo: `RBACDemoWidget` gebruikt nu `Roles` constants (buttons/labels/kleuren) i.p.v. string literals.
  - CSP: Trusted Types uitgebreid met `goog#html` om Closure policy creatie toe te staan (fix voor console warning).
  - Tests: “Repository Test Standard (2025)” toegevoegd aan overview; standaard testset geïmplementeerd voor Players/Matches/Trainings.
  - Observability: Sentry PII‑scrubbing op breadcrumbs + sample rates via defines; analyzer info’s verwijderd.
  - Notifications: topic helpers + validatie; rooktests zonder Firebase init.
  - Providers: rooktests toegevoegd voor Players/Trainings/Matches (UI‑safe folding) en GraphQL tag‑subscription mapping.


