# Performance & Monitoring Enhancement Plan – Q3 2025

_Linked docs_:
* [Master Delivery Roadmap 2025-2026](../MASTER_DELIVERY_ROADMAP_2025-2026.md)
* [Code Quality Upgrade Q4 2025](CODE_QUALITY_UPGRADE_Q4_2025.md)
* [Analytics & Monitoring Integration Plan – Q4 2025](../architecture/ANALYTICS_MONITORING_Q4_2025.md)

> Draft v0.1 – 25 Jul 2025 – to be reviewed in Sprint 6 refinement session.

---

## 🎯 Objectives
1. Detect memory-leak & performance regressions _before_ they hit production.
2. Instrument **real-user metrics** (RUM) across mobile & web builds.
3. Harden runtime resilience with global error boundaries and Sentry tracing.
4. Benchmark the Impeller renderer on target Android devices and toggle per tier.
5. Automate a performance-regression gate in CI (Lighthouse + Frame-timing).

## 🔍 Current Gaps
| Area | Risk | Note |
|------|------|------|
| Memory leaks | Medium | Complex PDF/video features allocate large buffers; no leak tracker yet. |
| Impeller rollout | Unknown perf impact | Budget Android devices may regress FPS. |
| RUM / web-vitals | Missing | Only GA4 `screen_view` events tracked. |
| Global error boundaries | Partial | FlutterError.onError logs but no Sentry fallback. |
| CI perf gate | Absent | Lighthouse runs only on PR comment basis. |

## 🗺️ Work Breakdown
| ID | Task | Owner | ETA | Depends |
|----|------|-------|-----|---------|
| PM1 | Integrate **leak_tracker** & **dart_code_metrics** “memory-leak” rule | DevOps | Aug Wk1 | quality_metrics_pilot |
| PM2 | Firebase Performance Monitoring SDK (mobile) + web-vitals polyfill | Mobile/Web guild | Aug Wk1 | PM1 |
| PM3 | Add `PerformanceTracker` utility & inject in `AnalyticsRouteObserver` | FE guild | Aug Wk2 | PM2 |
| PM4 | Wrap `runApp` in error boundary & wire Sentry performance traces | FE guild | Aug Wk2 | PM1 |
| PM5 | Benchmark Impeller (release APK, 3 device tiers) – record FPS, memory | QA | Aug Wk2 | — |
| PM6 | Conditional Impeller toggle via `--dart-define=DISABLE_IMPELLER` | Mobile guild | Aug Wk3 | PM5 |
| PM7 | Add **Lighthouse-CI** job (`performance.yml`) with PWA budget <2 MB | DevOps | Aug Wk3 | — |
| PM8 | Perf regression badge in README & docs update | Docs | Aug Wk4 | PM7 |

## 🛠  Technical Notes
* **Memory Leak Detection**: enable `leak_tracker` in test harness & run in post-test CI step.
* **RUM**: `firebase_performance` for mobile; `web-vitals` npm package + custom JS interop for web.
* **Error boundaries**: adopt `runZonedGuarded` + `FlutterError.onError` to route to Sentry.
* **Impeller toggle**: AndroidManifest meta-data flag & iOS `Info.plist` key.
* **Performance gate**: threshold—CLS <0.1, LCP <2.5 s, TBT <300 ms.

## 🚨 Risks & Mitigations
| Risk | Impact | Mitigation |
|------|--------|-----------|
| Performance SDK adds size | Low | Measure APK size diff; enable code-shrink & tree-shaking |
| Leak tracker false-positives | Low | Run only in debug/tests; ignore known SDK leaks |
| Lighthouse flakiness | Medium | Use median of 3 runs; cache resources |
| Impeller off lowers smoothness | Low | Keep fallback Canvas path; document flag |

## ✅ Exit Criteria
* Memory-leak test stage green with no leaks on smoke flows.
* Firebase Perf dashboard shows data <5 min after action.
* Impeller decision documented; renderer flag respected by CI builds.
* `performance.yml` fails PR when any metric regresses >10 %.
* Docs & README updated; Roadmap Phase 1 item **Performance-Monitoring** marked ✅.

---
