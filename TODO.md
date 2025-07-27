### Performance & Assessment (from `PERFORMANCE_RATING_ROADMAP.md`)

**Phase 2: Periodieke Assessments (Partially Completed)**
*   [X] **Rapporten:**
    *   [X] Implement individual development reports. *(Done via `pdf_service.dart` -> `generateAssessmentReport`)*
    *   [X] Create team overview reports. *(Done via `export_service.dart` for players and matches)*
    *   [X] Add functionality to export reports to PDF. *(Done via `pdf_service.dart` and `export_service.dart`)*

**Phase 3: Advanced Analytics (Sprint 5-6)**
*   [X] **Data Visualization:**
    *   [X] Create performance graphs. *(Done: Pie, Bar, and Horizontal Bar charts implemented in analytics dialogs)*
    *   [X] Implement spider/radar charts for skills. *(Done: Implemented in `assessment_detail_screen.dart`)*
    *   [ ] Develop heatmaps for team performance.
*   [/] **Predictive Analytics:** *(In Progress: Basic rule-based insights exist, but no real prediction)*
    *   [ ] Implement form predictions.
    *   [ ] Model development trajectories.
    *   [ ] Provide position recommendations.

**Phase 4: Import Functionality (Sprint 7-8)**
*   [X] **Excel/CSV Import:**
    *   [X] Build a template generator. *(Done for players in `import_service.dart`)*
    *   [X] Enable bulk import of players. *(Done in `import_service.dart`)*
    *   [ ] Allow import of match schedules.
    *   [ ] Allow import of training plans.
*   [/] **Validation & Error Handling:**
    *   [X] Implement data validation for imports. *(Done)*
    *   [/] Add duplicate detection. *(Partially Done: Needs explicit check before insert)*
    *   [X] Create error reporting for failed imports. *(Done)*

**Future Features (Backlog)**
*   [ ] **OCR & AI Integration**
*   [ ] **Video Analysis Integration**
*   [ ] **Parent/Player Portal**

---

### Performance Monitoring Plan Q3 2025 (NEW)

**PM1: Memory Leak Detection (✅ Completed)**
- [X] **PM1.1** Create memory leak test harness in `test/memory/`
- [X] **PM1.2** Add leak tracker to CI workflow
- [X] **PM1.3** Configure dart_code_metrics memory-leak rule

**PM2: Web-Vitals & Firebase Performance (✅ Completed)**
- [x] **PM2.1** Web-vitals polyfill injected in build process
- [x] **PM2.2** Firebase Performance initialized in `main.dart` and `main_fan.dart`
- [x] **PM2.3** Edge function `web_vitals.ts` created for RUM collection
- [x] **PM2.4** Netlify redirect configured for `/api/web-vitals`
- [X] **PM2.5** Verify web-vitals data flow in production

**PM3: PerformanceTracker Integration (✅ Completed)**
- [x] **PM3.1** `PerformanceTracker` utility implemented
- [x] **PM3.2** Integration with `AnalyticsRouteObserver` for route tracing
- [x] **PM3.3** Provider configured in `config/providers.dart`
- [ ] **PM3.4** Add performance tracking to heavy operations

**PM4: Error Boundaries & Sentry (✅ Completed)**
- [x] **PM4.1** `runAppWithGuards` function with `runZonedGuarded`
- [x] **PM4.2** Sentry integration with environment-based initialization
- [x] **PM4.3** FlutterError.onError wired to Sentry
- [x] **PM4.4** Performance traces enabled (20% sampling)
- [ ] **PM4.5** Add error boundary to specific screens

**PM5: Lighthouse CI Integration (✅ Completed)**
- [X] **PM5.1** Lighthouse CI workflow in `.github/workflows/flutter-web.yml`
- [X] **PM5.2** `lighthouserc.json` configuration
- [X] **PM5.3** Basic performance testing in `advanced-deployment.yml`
- [X] **PM5.4** Create dedicated `performance.yml` workflow
- [X] **PM5.5** Add performance regression thresholds
- [X] **PM5.6** Add PWA budget enforcement

**PM6: Documentation & Badges (✅ Completed)**
- [X] **PM6.1** Add performance badge to README.md
- [X] **PM6.2** Update performance monitoring documentation
- [X] **PM6.3** Create performance dashboard documentation

---

### Video Features (from `VIDEO_FEATURE_ROADMAP.md`) - NOT STARTED

**Phase 1: Basic Video Upload & Playback (Sprint 1-2)**
*   [ ] **Video Upload**
*   [ ] **Video Storage**
*   [ ] **Video Player**
*   [ ] **UI Components**

**Phase 2: Video Processing & Optimization (Sprint 3-4)**
*   [ ] **Video Compression**
*   [ ] **Thumbnail Generation**
*   [ ] **Metadata Extraction**

**Phase 3: Tagging & Categorization (Sprint 5-6)**
*   [ ] **Video Tagging**
*   [ ] **Smart Playlists**
*   [ ] **Search & Filter**

**Phase 4: Advanced Features (Sprint 7-8)**
*   [ ] **Video Analysis Tools**
*   [ ] **Sharing & Export**
*   [ ] **Offline Support**

**Phase 5: AI & Automation (Future)**
*   [ ] **AI Video Analysis**
*   [ ] **Performance Analytics from Video**

---

### General/Architectural (from `ARCHITECTURE.md` and other files) - NOT STARTED

*   [ ] Set up Firebase Analytics for user behavior tracking.
*   [ ] Integrate Sentry for error reporting.
*   [ ] Explore and integrate with OpenAI, Anthropic Claude, and vector databases for future AI features.

---

### Quality & Refactors (Q3 2025)

**PDF Service Modularisation** (see `PDF_SERVICE_MIGRATION_PLAN_Q3_2025.md`)

*   [X] P1: Skeleton `lib/pdf/` module & asset migration
*   [X] P2: Implement `PdfGenerator` base class
*   [X] P3: Build `MatchReportPdfGenerator`
*   [X] P4: Build `PlayerAssessmentPdfGenerator`
*   [X] P5: Unit & golden tests (≥ 80 % coverage)
*   [X] P6: Wire up providers & UI export flows
*   [X] P7: Remove legacy `pdf_service.dart` & static helpers
*   [X] P8: Update docs & roadmap

**Large File Refactor** (see `LARGE_FILE_REFACTOR_PLAN_Q3_2025.md`)

*   [ ] refactor-session-builder *(split UI, controller, widgets)*
*   [ ] refactor-pdf-service *(modularise PDF generation)*
*   [X] refactor-exercise-library *(widget-first split)*
*   [X] refactor-weekly-planning *(week selector, table & controller extracted; screen <300 LOC – 2025-08-04)*
*   [ ] refactor-dashboard-screen *(extract dashboard cards)*
*   [X] refactor-performance-monitoring *(split charts & providers)*
*   [ ] refactor-annual-planning-provider *(move helpers to services)*

*Document laatst bijgewerkt: **25 July 2025***

---

### 🆕 In Progress – Exercise Library Screen Refactor (Q3 2025)

ID: **refactor-exercise-library**

Objective: Split `exercise_library_screen.dart` (≈ 1.1 k LOC) into a clean, testable structure following 2025 best-practices.

Incremental Steps (TDD-based)
1. **Unit tests – ExerciseLibraryController**
   * Write tests for search filter, intensity filter, and reset behaviour.
2. **Extract ExerciseLibraryController**
   * Move filter/search logic from screen into `exercise_library_controller.dart` (ChangeNotifier + Riverpod provider).
3. **Widget tests – SearchBar & FilterBar**
   * Ensure chips/dropdowns update controller state.
4. **Extract UI widgets**
   * `search_bar.dart`, `filter_bar.dart`, `morphocycle_banner.dart`, `exercise_tab_view.dart`.
5. **Refactor ExerciseLibraryScreen**
   * Keep only Scaffold, TabBar, body composition; ensure < 300 LOC.
6. **Golden/widget tests – main flows**
   * Search + filter flow golden snapshot; list updates.
7. **Cleanup & docs update**
   * Remove obsolete providers, update `LARGE_FILE_REFACTOR_PLAN_Q3_2025.md`, ensure analyzer 0-issues.

Exit criteria:
* `exercise_library_screen.dart` < 300 LOC, widgets < 200 LOC each.
* Controller unit-tests ≥ 90 % statement coverage.
* All tests green; CI passes.

---

*Document laatst bijgewerkt: **04 Aug 2025***

### WebAssembly (Skwasm) Compatibility Roadmap – Target Q4 2025

> See Flutter docs: https://docs.flutter.dev/platform-integration/web/wasm

**Step 0 – Unblock CI (DONE / In-progress)**
- [ ] CI: Switch mandatory web build to CanvasKit (`flutter build web --release --web-renderer canvaskit`). *(Task id: ci-switch-canvaskit – in progress)*

**Phase 1 – Dependency Audit**
- [ ] List all direct & transitive packages that import `dart:html`, `dart:js`, or `dart:ffi` (e.g. `win32`, `ffi`, `flutter_secure_storage_web`, `share_plus`, `connectivity_plus`). *(Task id: wasm-dep-audit)*
- [ ] Identify web-safe alternatives or create stub implementations.

**Phase 2 – Conditional Imports & Stubs**
- [ ] Introduce conditional imports (`if (dart.library.js_interop)` / `if (dart.library.ffi)` stubs).
- [ ] Replace insecure packages with `package:web` + `dart:js_interop` where needed.

**Phase 3 – CI Workflow**
- [ ] Add optional job `Build Web (wasm)` using `flutter build web --wasm` (allowed_to_fail until green). *(Task id: wasm-workflow-matrix)*
- [ ] Configure Netlify/Cloud Run with COEP: `credentialless` and COOP: `same-origin` headers for multi-threading. *(Task id: wasm-server-headers)*

**Exit Criteria**
* CanvasKit build remains green.
* Skwasm build compiles and passes smoke tests in Chrome 119+.
* No `dart:ffi`, `dart:html`, or `dart:js` errors in Wasm job.
* Performance benchmark ≥ CanvasKit.
