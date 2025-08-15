# PRIOS – Volgorde uitvoering (Q3 2025)

Werkafspraak: na iedere wijziging of afronding van een TODO/PRIO wordt dit bestand direct bijgewerkt (Gedaan/Open).

Voortgang (stand nu):
- Router startup safety: opgelost. Redirect-guard leest providers nu veilig met fallbacks; null-check crash bij opstart verholpen.
- UI A11y: focus traversal (globaal + nav), tooltips/semantics op kernschermen, 48x48 tap targets op zoom/reset controls, diverse leading/back/close knoppen.
- Web performance: preconnect voor Supabase (REST/Realtime) en Sentry ingest; Flutter manifests high-priority preload; `flutter_bootstrap.js` preload.
- Observability: gestandaardiseerde events gelogd; parameters genormaliseerd (key normalisatie, flatten van metadata/context), PII-scrub toegepast, caps/limieten gezet.
- PWA/Web polish: Offline scherm en router-redirect naar `/offline` bij startup zonder verbinding; manifest verrijkt (categories, screenshots, shortcuts, protocol handlers); meta description verbeterd.
- UI performance bewaking: Lighthouse CI (static) met budgets (FCP/LCP/TBT/CLS) toegevoegd aan GitHub Actions; rapporten als artifact.
- Service Worker: verbeterde cachingstrategie (versioned caches per commit, cache-first voor CanvasKit/Wasm, stale-while-revalidate voor app-assets); minimale precache teruggebracht tot alleen shell (`/`, `/index.html`, `/flutter_bootstrap.js`) om overlap met SWR te voorkomen.
- Import trainingsplannen: service en UI-menu (Trainingen) toegevoegd; template-download beschikbaar; UI-koppeling om na import direct te persistenteren + refresh.
- Video thumbnails (web): cacheHeight geschaald op devicePixelRatio voor kleinere previews (minder bandbreedte/geheugen).
- Training lijst: ListView builder afgestemd (repaint boundaries/keepAlives/cacheExtent) voor soepeler scrollen.


Volgorde gebaseerd op 2025 best practices (Security/Compliance → Stabiliteit/Performance → UX/Polish). Herordend naar Must/Should/Could met concrete open acties.

Must-have (Q3 2025)
- GDPR/Dataretentie: retentiebeleid + purge-jobs (cron/edge); documentatie en verifieerbare runbooks.
- PWA precache verfijnen: Done – minimal shell only in `sw-extra.js` (FCP/LCP‑kritisch); geen overlap met SWR. Monitor LHCI.
- Observability dashboards: resource-attributen geïmplementeerd; dashboards/filters extern inrichten per env/mode/instance.
- Performance: extra lazy/deferred loading voor zware views/images; hero-animaties minimaliseren op web.
- Notifications (mobile): iOS/Android platform-setup en rooktests (topic/tenant).

Should-have (Q3→Q4 2025)
- Import Trainingen: mapping edge-cases (tijdzones/locale) + unit-tests (parser/persist) + happy-path e2e.
- RLS end‑to‑end verificatie uitbreiden (admin harnas, standaard skip in CI).

Could-have (Q4+ 2025)
- Advanced Analytics: heatmaps/predictions (na events-standaardisatie).
- Wasm dependency vervolgaudit (`share_plus`, `connectivity_plus`) en conditional stubs.
- Analyzer 6 migratiestap (kwaliteitsinfra) zodra upstream stabiel.

Afgerond (Q3 2025 – selectie)
- Router startup safety; offline route/guard.
- A11y: focus traversal, tooltips, 48x48 targets, tekstschaal clamps (Dashboard/Players/Matches/Training/PhasePlanning/Season Hub), contrast voor badges (incl. Matches), Weekly Calendar/Video controls.
- Performance: resource hints + preloads; LHCI budgets; lijst-tuning; deferred images (`NetworkImageSmart`) voor avatar en video-thumbnails.
- PWA/Web: CSP/Trusted Types/COOP/COEP; SW versioned caches, cache-first (CanvasKit/Wasm) + SWR; precache core shell; manifest verrijkt; `main.dart.js` preload.
- Observability: events gestandaardiseerd (PII scrub, caps/limieten), OTLP init + resource attrs, router observers.
- Wasm compat: PWA install interop naar Wasm‑veilige no‑op shim.
- Security tests: env-aware gating (prod/live checks disabled by default; ENABLE_PROD_TESTS=1 om te activeren) – CI‑safe.
- Analyzer: alle info‑issues opgelost; analyzer clean.
- Import Trainingen: Excel serial date en numerieke tijd (fraction of day) ondersteund; parser vereenvoudigd (HH:mm, HH.mm). Tests groen.
- Resilience: SWR remote timeout 8s toegevoegd; Hive cache herstelt corrupte box (purge + retry).
- Web‑fonts: thema omgezet naar systeemtypografie (geen runtime fetching); `google_fonts` niet meer gebruikt.
- Web UX: pagina‑transities op web uitgeschakeld voor rust/performantie; native transities mobiel/desktop intact.
- Notifications: NotificationApi + topic scoping (tenant/user) + demo toggle; feature gated en web‑safe.
- CI/Workflow: `--web-renderer` verwijderd (Flutter 3.22+); standaard CanvasKit, optioneel `--wasm`.


