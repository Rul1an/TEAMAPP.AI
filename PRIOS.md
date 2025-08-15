# PRIOS – Volgorde uitvoering (Q3 2025)

Werkafspraak: na iedere wijziging of afronding van een TODO/PRIO wordt dit bestand direct bijgewerkt (Gedaan/Open).

Voortgang (stand nu):
- Router startup safety: opgelost. Redirect-guard leest providers nu veilig met fallbacks; null-check crash bij opstart verholpen.
- UI A11y: focus traversal (globaal + nav), tooltips/semantics op kernschermen, 48x48 tap targets op zoom/reset controls, diverse leading/back/close knoppen.
- Web performance: preconnect voor Supabase (REST/Realtime) en Sentry ingest; Flutter manifests high-priority preload; `flutter_bootstrap.js` preload.
- Observability: gestandaardiseerde events gelogd; parameters genormaliseerd (key normalisatie, flatten van metadata/context), PII-scrub toegepast, caps/limieten gezet.
- PWA/Web polish: Offline scherm en router-redirect naar `/offline` bij startup zonder verbinding; manifest verrijkt (categories, screenshots, shortcuts, protocol handlers); meta description verbeterd.
- UI performance bewaking: Lighthouse CI (static) met budgets (FCP/LCP/TBT/CLS) toegevoegd aan GitHub Actions; rapporten als artifact.
- Service Worker: verbeterde cachingstrategie (versioned caches per commit, cache-first voor CanvasKit/Wasm, stale-while-revalidate voor app-assets); minimale precache uitgebreid met manifesten en favicon (offline FCP verbeterd).
- Import trainingsplannen: service en UI-menu (Trainingen) toegevoegd; template-download beschikbaar; UI-koppeling om na import direct te persistenteren + refresh.
- Video thumbnails (web): cacheHeight geschaald op devicePixelRatio voor kleinere previews (minder bandbreedte/geheugen).
- Training lijst: ListView builder afgestemd (repaint boundaries/keepAlives/cacheExtent) voor soepeler scrollen.


Volgorde gebaseerd op 2025 best practices (Flutter/M3/Web), security first, UX impact, en CI stabiliteit. Status per prio bevat: Gedaan (concreet resultaat) en Open (gerichte next steps).

1. UI Audit – A11y restpunten [in progress]
   - Gedaan:
     - Globale `FocusTraversalGroup` + OrderedTraversalPolicy; nav toegankelijk.
     - Tooltips & Semantics: Dashboard shell, Players, Matches, Training.
     - 48x48 tap targets: Field Canvas (zoom/reset), Video Player (controls), Weekly Calendar acties, diverse leading/back/close knoppen.
     - Tekstschaal: badges in TrainingScreen omgezet naar `Wrap` voor nette layout bij hogere scaling.
     - Tekstschaal: ellipsis clamps toegevoegd op Dashboard UpcomingEvents kaarten (Match/Training), Player Detail titel.
     - Profiel: avatar camera-knop met tooltip + 48x48 constraints.
   - Open (gericht):
     - Tekstschaal-audit in content; clamp-overschrijdingen/ellipsis checken.
     - Contrast-checks M3: badges/overlays (Video, Training-cards) naar high-contrast tokens; Match badges (locatie/competitie) dynamische tekstkleur.
     - Overige schermen nalopen op ontbrekende `tooltip` bij `IconButton`s: toegevoegd op Player Detail (edit/export), Match Detail (share/edit/export/save), Exercise Selector (add/remove), Periodization Template dialog (close), AI Demo (info). 48x48 constraints toegepast.

2. UI Audit – Performance restpunten [in progress]
   - Gedaan:
     - Resource hints (preconnect Supabase/Sentry) en preload van Flutter manifests + bootstrap.
     - Lighthouse CI met budgets (FCP/LCP/TBT/CLS) in workflow; artefacten beschikbaar.
     - Video thumbnails: dpr-gebaseerde `cacheHeight` en deferred loading via `NetworkImageSmart`.
     - Lijsten: `ListView.builder` tuned (repaint boundaries/keepAlives/cacheExtent) op Training- en Matches-lijsten.
     - Profiel avatar: overgezet naar `NetworkImageSmart` met deferred loading.
   - Open (gericht):
     - Lazy loading verfijnen (zware views/images) en hero-animaties beperken op web.
     - Web-fonts fine-tuning (subset/`display: swap`) indien nodig na LH-artefact review.

3. Observability – Events/metrics standaardiseren [in progress]
   - Gedaan:
     - Canonical events voor create/import/export; parameters gesaneerd (PII scrub), keys genormaliseerd, metadata geflattened, limieten toegepast.
     - OTLP: init-diagnostics, `OTLP_ENDPOINT` override, startup-event, resource attrs: `service.name`, `service.version`, `service.namespace`, `service.instance.id`, `deployment.environment`, `app.mode`.
     - Router observers: analytics observer + Sentry navigator breadcrumbs geactiveerd.
   - Open (gericht):
     - Dashboards alignment: view/convert op basis van nieuwe resource attrs; filters op env/mode/instance.

4. PWA/Web polish [in progress]
   - Gedaan:
     - Trusted Types/COOP/COEP/CSP in Netlify headers.
     - Offline scherm en router-redirect; manifest verrijkt (shortcuts, categories, screenshots, protocol handlers).
     - SW: versioned caches, cache-first (CanvasKit/Wasm), SWR (app-assets), precache core shell + Asset/FontManifest + favicon; cache cleanup.
     - Wasm-compat: PWA install interop vervangen door Wasm-veilige no-op shim om Wasm build te deblokkeren.
     - Web startup: `main.dart.js` preload toegevoegd voor snellere initialisatie.
   - Open (gericht):
     - Precache-lijst verfijnen met LH-artefacten (alleen LCP/FCP-kritisch, geen overlap met SWR).
     - CI Secrets (Actions) controleren/zetten: `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `SENTRY_DSN`.

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
   - Gedaan: CSV/Excel service (validaties data/tijd/duratie/focus/intensiteit); template-generator; UI-menu (import + template-download); gebruiker-feedback + waarschuwingen dialoog; UI-koppeling persist + refresh.
   - Open (gericht): Mapping edge-cases (tijdzones/locale), unit-tests parser en persist, happy-path e2e rooktest.

Not planned/Q4+:
- Wasm dependency vervolgaudit (`share_plus`, `connectivity_plus`) en conditional stubs.
- Analyzer 6 migratiepakket (kwaliteitsinfra), zodra upstream stable en zonder regressies.


