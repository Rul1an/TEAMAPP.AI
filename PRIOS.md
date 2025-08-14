# PRIOS – Volgorde uitvoering (Q3 2025)

Volgorde gebaseerd op 2025 best practices (Flutter/M3/Web), security first, UX impact, en CI stabiliteit.

1. UI Audit – A11y restpunten
   - Tekstschaal audit, minimale tappable sizes in content, contrast-checks.
2. UI Audit – Performance restpunten
   - Lazy loading images/video, juiste filterQuality, thumbnails; Web Vitals preloads/budgets.
3. Observability – Events/metrics standaardiseren
   - Canonical event set, OTLP endpoint validatie; dashboards aligneren.
4. PWA/Web polish
   - Offline scherm, install prompt/manifest audit, SW cache strategieën review.
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

