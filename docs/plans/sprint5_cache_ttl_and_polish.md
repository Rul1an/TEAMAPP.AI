# Sprint 5 – Cache-TTL & Product Polish Plan (Aug 2025)

_Linked to:_ [Master Delivery Roadmap 2025-2026](MASTER_DELIVERY_ROADMAP_2025-2026.md) · Phase 1 items **1.1, 1.2**

## 🎯 Goals
1. Replace placeholder TTL tests with real cache-expiry implementation (Hive).
2. Finalise **Edit Training** CRUD flow (ID 1.1) for coach flavour.
3. Integrate HeatMapCard into Performance Analytics + GA4 screen event (ID 1.2).
4. Warm-up for Phase 2 quality sprint: run VGA & DCM in warning-only mode.

---

## 1  Cache TTL (≤2 h)
| Task | File | Est. h |
|------|------|--------|
| C1 | Add `lastWrite` metadata to `BaseHiveCache.write()` | 0.25 |
| C2 | `BaseHiveCache.read({Duration? ttl})` compare `DateTime.now()` – `lastWrite` | 0.5 |
| C3 | Update concrete caches (`HiveTraining/Player/MatchScheduleCache`) | 0.5 |
| C4 | Re-enable TTL tests, remove placeholders | 0.5 |
| **Total** | | **1.75 h** |

**Exit criteria** : 3 TTL tests pass, coverage +0.3 pp, no analyzer warnings.

---

## 2  Edit Training Screen (ID 1.1, ~6 h)
| Step | Details | Est. h |
|------|---------|--------|
| E1 | Add missing validators (`validateDate`, `validateDuration`) | 1 |
| E2 | Implement `TrainingRepository.update()` write-through (remote → cache) | 1 |
| E3 | Wire `training_edit_viewmodel.dart` to repository | 1 |
| E4 | Success snackbar + navigation pop | 0.25 |
| E5 | Widget tests (form validation, happy path) | 1.5 |
| E6 | Golden test (initial state) | 0.75 |
| ~~E7~~ | Docs screenshot & update UX plan | 0.5 | ✅ |
| **Total** | | **6 h** |

**Exit criteria** : CRUD works, 3 widget tests green, file LOC limits respected, Roadmap 1.1 marked _completed_.

---

## 3  HeatMap Integration (ID 1.2, ~3 h)
| Step | Details | Est. h |
|------|---------|--------|
| H1 | Embed `HeatMapCard` in `performance_analytics_screen.dart` | 0.75 |
| H2 | Add `HeatMapController` binning unit test | 0.5 |
| H3 | GA4 `screen_view` for `FanHomeScreen` & heatmap tab via `AnalyticsRouteObserver` | 0.5 |
| H4 | Update golden test for Performance Analytics screen | 0.75 |
| H5 | Docs update & KPI | 0.5 |

**Exit criteria** : Heatmap visible, bin test passes, GA4 event appears in DebugView.

---

## 4  Quality Sprint Prep (warning-only, ≤2 h)
1. Add `very_good_analysis` & `dart_code_metrics` to `dev_dependencies`.
2. `analysis_options.yaml` includes VGA preset; `dart_code_metrics.yaml` basic thresholds.
3. New CI job `lint_metrics.yml` runs both, but fails only on _error_ (infos allowed).
4. Generate violatie-rapport → top-10 issues logged in `docs/reports/quality/metrics_baseline_Aug2025.md`.

---

## Timeline (1-day spike)
Morning (09:00-12:00) → Cache TTL tasks C1-C4 ► PR #TTL-cache.
Mid-day (12:30-18:00) → Edit Training tasks E1-E7 ► PR #editTrainingFinalize.
Evening (18:00-20:00) → HeatMap & Quality prep ► PR #heatmap_integration, #quality_pilot.

---

## Risks & Mitigations
| Risk | Impact | Mitigation |
|------|--------|-----------|
| TTL logic wrong → negative cache hit | Low | Unit tests simulate expiry windows |
| EditTraining validation edge cases | Medium | Add validator unit tests & QA checklist |
| Heatmap binning perf on web | Low | Throttle controller & cache matrix |

---

## Definition of Done
* All PRs merged green; coverage ≥ 45 %; no analyzer infos.
* Roadmap Phase 1 items **1.1** & **1.2** marked ✅.
* `fix_skipped_tests` TODO fully closed (TTL tests active).
