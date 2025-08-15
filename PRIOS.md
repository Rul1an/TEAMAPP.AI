# PRIOS – Volgorde uitvoering (Q3 2025)

Voortgang (stand nu):
- Router startup safety: opgelost. Redirect-guard leest providers nu veilig met fallbacks; null-check crash bij opstart verholpen.
- UI A11y: focus traversal toegevoegd (globaal + nav), tooltips/semantics aangevuld op kernschermen (Dashboard shell, Players, Matches, Training).
- Web performance: preconnect voor Supabase (REST/Realtime) en Sentry ingest; Flutter manifests high-priority preload; `flutter_bootstrap.js` preload.
- Observability: gestandaardiseerde events gelogd voor create/import/export in Players/Matches/Training.
 - Observability: gestandaardiseerde events gelogd; parameters genormaliseerd (key normalisatie, flatten van metadata/context), PII-scrub toegepast, caps/limieten gezet.
- PWA/Web polish: Offline scherm en router-redirect naar `/offline` bij startup zonder verbinding; manifest verrijkt (categories, screenshots, shortcuts, protocol handlers); meta description verbeterd.
- UI performance bewaking: Lighthouse CI (static) met budgets (FCP/LCP/TBT/CLS) toegevoegd aan GitHub Actions; rapporten als artifact.
- Service Worker: verbeterde cachingstrategie (versioned caches per commit, cache-first voor CanvasKit/Wasm, stale-while-revalidate voor app-assets).
- Import trainingsplannen: service en UI-menu (Trainingen) toegevoegd; template-download beschikbaar.


Volgorde gebaseerd op 2025 best practices (Flutter/M3/Web), security first, UX impact, en CI stabiliteit.

1. UI Audit – A11y restpunten [in progress]
   - Gedaan: FocusTraversalGroup (globaal en nav), tooltips/semantics op kernschermen.
   - Open: Tekstschaal audit in content, contrast-checks (M3 HC), icon-buttons in overige schermen.
2. UI Audit – Performance restpunten [in progress]
   - Gedaan: Preconnect Supabase/Sentry; high-priority preloads; bootstrap preload.
   - Gedaan: Web Vitals budget en CI-meting via Lighthouse CI; artefacten per build.
   - Open: Verdere lazy loading verfijningen; web fonts fine-tuning.
3. Observability – Events/metrics standaardiseren [in progress]
   - Gedaan: Canonical events voor create/import/export; attributen gesaneerd en genormaliseerd (PII scrub, key normalisatie, metadata flatten, limieten).
   - Open: OTLP endpoint validatie + dashboards alignment.
4. PWA/Web polish [in progress]
   - Gedaan: Trusted Types beleid in headers; resource hints/preloads; Offline scherm; manifest audit/verbeteringen; SW caching (versioned caches + SWR assets); minimale precache (core shell) + versioned cache cleanup.
   - Open: Precache-lijst verfijnen op basis van Lighthouse artefacten (LCP/FCP-kritische assets).
5. Notifications – platform setup valideren
   - iOS/Android setup en topic/tenant scoping rooktests.
6. Demo/standalone – e2e guard/deep-link tests
   - Navigatie naar mutatieroutes borgen in standalone/demo mode.
7. Privacy/GDPR – Dataretentie
   - Retentiebeleid en purge-jobs (cron/edge functions), documentatie.
8. Performance Monitoring – PM4.5 Error boundaries [done]
   - AppErrorBoundary toegevoegd en toegepast op Players/Matches/Training.
9. Advanced Analytics – Heatmaps/predictions (research)
   - Heatmaps, form predictions, trajecten, positie-adviezen (fasegewijs, na events-standaardisatie).
10. Import – Training plans [in progress]
   - Gedaan: CSV/Excel service met strikte parsing en foutverzameling; template-generator; UI-menu in `Trainingen` (import + template-download).
   - Open: Mapping van geïmporteerde items naar persistente planning (repo/service) en unit-tests.

Not planned/Q4+:
- Wasm dependency vervolgaudit (`share_plus`, `connectivity_plus`) en conditional stubs.
- Analyzer 6 migratiepakket (kwaliteitsinfra), zodra upstream stable en zonder regressies.


