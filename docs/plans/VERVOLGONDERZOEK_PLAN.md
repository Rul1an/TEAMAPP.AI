## Vervolgonderzoek JO17 Tactical Manager (Q3 2025)

Doel: risico’s minimaliseren, kwaliteit borgen en open eindes sluiten voor SaaS/standalone/demo modi. Focus op RBAC/RLS, data-consistentie, observability, web-perf en platform-specifieke integraties.

### Prioriteiten en volgorde
1) RBAC + RLS end-to-end  2) CI/CD + dart-define/secrets  3) Data-modellen/JSON  4) Repository/caching  5) Web-build (WASM)  6) Observability  7) Notifications  8) Video  9) Billing  10) Demo/standalone gates  11) GraphQL triage  12) Privacy/GDPR

---

### 1. RBAC en RLS end-to-end audit
- Doel: UI/route-permissies matchen met Supabase RLS-policies; geen privilege escalation mogelijk.
- Onderzoek:
  - Permissies in `PermissionService` vs. RLS per tabel (players, trainings, matches, exercises, organizations, features).
  - Edge cases: view-only rollen (‘speler’, ‘ouder’) en demo/standalone modi.
- Artefacts: matrix permissies vs. RLS; testcases in `test/security/` en `integration/`.
- Succescriteria: alle mutatiepaden die UI blokkeert, worden ook door RLS geblokkeerd; tests groen.

### 2. CI/CD, dart-define en secrets management
- Doel: stabiele builds met correcte `--dart-define` waarden en veilig secretsbeheer.
- Onderzoek: GitHub Actions/Netlify workflows, required defines (SUPABASE_URL/ANON_KEY, APP_MODE, SENTRY_DSN, OTLP, enz.).
- Artefacts: geverifieerde CI-config, document met vereiste defines per omgeving.
- Succescriteria: groene pipeline, geen runtime-misconfiguratie logs.

### 3. Data-modellen en JSON-casting audit
- Doel: alle ID’s `String`, expliciete casts en defaults consequent.
- Onderzoek: `models/` en `.fromJson()` paden; enum casing; datum/tijd parsing; null-safety.
- Artefacts: kleine fixes + stylegids snippet in `docs/`.
- Succescriteria: `flutter analyze` 0 errors; gerichte tests groen.

### 4. Repository-consistentie en caching-strategie
- Doel: uniforme error-afhandeling, invalidatie, offline gedrag.
- Onderzoek: `repositories/*` en bijbehorende `data/*` + `hive/*` caches; stale-while-revalidate strategie vastleggen.
- Artefacts: repo-conventies document + eventuele refactor.
- Succescriteria: consistente API over alle repo’s, tests dekken cache-hits/misses.

### 5. Web-build performance en WASM-validatie
- Doel: stabiele web-builds; experiment met `--wasm` waar compatibel.
- Onderzoek: CI build matrix, bundlegrootte, cold start, WASM-compat van dependencies.
- Artefacts: rapport met metrieken en aanbeveling (CanvasKit vs WASM).
- Succescriteria: succesvolle builds, gemeten verbetering of duidelijke trade-offs gedocumenteerd.

### 6. Observability en telemetry
- Doel: juiste sampling/PII-hygiëne, correcte endpoints per omgeving.
- Onderzoek: Sentry init, OTel `TelemetryService`, `AnalyticsRouteObserver`, eventnamen en payloads.
- Artefacts: observability checklist + dashboards/alerts-lijst.
- Succescriteria: bruikbare breadcrumbs en traces; geen PII-lekkage.

### 7. Notifications (Firebase Messaging)
- Doel: correcte platform-setup, permissies en topic/tenant-scheiding.
- Onderzoek: iOS/Android init, web fallback (indien gewenst), multi-tenant topic-strategie.
- Artefacts: setup-gids per platform + smoke tests.
- Succescriteria: notificaties ontvangen in test builds, juiste scoping.

### 8. Billing en subscriptions
- Doel: status inschatten (Stripe/RevenueCat), datastromen en UI-flows.
- Onderzoek: huidige implementatiegraad vs. roadmap; feature gating per tier.
- Artefacts: plan van aanpak + minimale MVP-flow.
- Succescriteria: happy path werkend in test/staging met sandbox.

### 9. Video pipeline (web en mobiel)
- Doel: compat en performance; fallback-strategie op web.
- Onderzoek: `video_player`, `ffmpeg_kit_flutter`, buffering, WASM/web-compat.
- Artefacts: compat matrix + perf-metingen.
- Succescriteria: video-use cases draaien stabiel op target platforms.

### 10. Demo/standalone gating en deep-links
- Doel: geen ongewenste mutaties; correcte router-redirects.
- Onderzoek: deep-links naar mutatieroutes; `isLoggedInProvider`/`demoModeProvider` gedrag.
- Artefacts: extra tests rond routing/guards.
- Succescriteria: alle paden correct afgevangen; geen bypass.

### 11. GraphQL dependency triage
- Doel: `graphql_flutter` verwijderen of plan voor adoptie.
- Onderzoek: codebase usages (verwacht 0), toekomstige behoefte.
- Artefacts: beslisnotitie; indien ongebruikt, dependency opschonen.
- Succescriteria: geen dode dependencies; CI blijft groen.

### 12. Privacy en GDPR
- Doel: export/delete flows, logging-hygiëne, consent.
- Onderzoek: dataretentie, PII in logs/events, export/delete services.
- Artefacts: privacy checklist + tickets.
- Succescriteria: minimale set aan privacy-features aantoonbaar aanwezig.

---

## Planning en deliverables
- Week 1: 1–3, high risk; Week 2: 4–6; Week 3: 7–10; Week 4: 11–12 + afronding.
- Voor elk thema: korte notitie in `docs/reports/` + bijbehorende tests/code-edits.

## Test- en kwaliteitsborgen
- Commands (lokaal binnen `jo17_tactical_manager/`):
  - `dart format . && flutter analyze --fatal-infos`
  - `flutter test && flutter test integration_test/`
  - Web build: `flutter build web` en optioneel `flutter build web --wasm`


