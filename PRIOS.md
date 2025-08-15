# PRIOS – Volgorde uitvoering (Q3 2025)

Voortgang (stand nu):
- Router startup safety: opgelost. Redirect-guard leest providers nu veilig met fallbacks; null-check crash bij opstart verholpen.
- UI A11y: focus traversal toegevoegd (globaal + nav), tooltips/semantics aangevuld op kernschermen (Dashboard shell, Players, Matches, Training).
- Web performance: preconnect voor Supabase (REST/Realtime) en Sentry ingest; Flutter manifests high-priority preload; `flutter_bootstrap.js` preload.
- Observability: gestandaardiseerde events gelogd voor create/import/export in Players/Matches/Training.


Volgorde gebaseerd op 2025 best practices (Flutter/M3/Web), security first, UX impact, en CI stabiliteit.

1. UI Audit – A11y restpunten [in progress]
   - Gedaan: FocusTraversalGroup (globaal en nav), tooltips/semantics op kernschermen.
   - Open: Tekstschaal audit in content, contrast-checks (M3 HC), icon-buttons in overige schermen.
2. UI Audit – Performance restpunten [in progress]
   - Gedaan: Preconnect Supabase/Sentry; high-priority preloads; bootstrap preload.
   - Open: Web Vitals budget en CI meting; verdere lazy loading verfijningen.
3. Observability – Events/metrics standaardiseren [in progress]
   - Gedaan: Canonical events voor create/import/export (players/matches/training).
   - Open: OTLP endpoint validatie + dashboards alignment.
4. PWA/Web polish [in progress]
   - Gedaan: Trusted Types beleid in headers, resource hints/preloads.
   - Open: Offline scherm, manifest audit, SW cache-strategie review.
5. Notifications – platform setup valideren
   - iOS/Android setup en topic/tenant scoping rooktests.
6. Demo/standalone – e2e guard/deep-link tests
   - Navigatie naar mutatieroutes borgen in standalone/demo mode.
7. Privacy/GDPR – Dataretentie
   - Retentiebeleid en purge-jobs (cron/edge functions), documentatie.
8. Performance Monitoring – PM4.5 Error boundaries
   - Specifieke schermen voorzien van error boundaries.
9. Advanced Analytics – Heatmaps/predictions (research)
   - Heatmaps, form predictions, trajecten, positie-adviezen (fasegewijs, na events-standaardisatie).
10. Import – Training plans
   - CSV/Excel flow voor trainingen met validaties.

Not planned/Q4+:
- Wasm dependency vervolgaudit (`share_plus`, `connectivity_plus`) en conditional stubs.
- Analyzer 6 migratiepakket (kwaliteitsinfra), zodra upstream stable en zonder regressies.


