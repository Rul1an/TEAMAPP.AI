# Performance & Monitoring Enhancement Plan – Q3 2025

_Linked docs_:
* [Master Delivery Roadmap 2025-2026](../MASTER_DELIVERY_ROADMAP_2025-2026.md)
* [Code Quality Upgrade Q4 2025](CODE_QUALITY_UPGRADE_Q4_2025.md)
* [Analytics & Monitoring Integration Plan – Q4 2025](../architecture/ANALYTICS_MONITORING_Q4_2025.md)

> **Status Update**: 25 Jul 2025 – Current implementation status checked

---

## 🎯 Objectives
1. Detect memory-leak & performance regressions _before_ they hit production.
2. Instrument **real-user metrics** (RUM) across web builds using web-vitals polyfill and Firebase Performance Monitoring for web.
3. Harden runtime resilience with global error boundaries and Sentry tracing.
4. Automate a performance-regression gate in CI (Lighthouse + Frame-timing).

## 🔍 Current Gaps
| Area                  | Risk     | Note                                                       |
|-----------------------|----------|------------------------------------------------------------|
| Memory leaks          | Medium   | Complex PDF/video features allocate large buffers; no leak tracker yet. |
| RUM / web-vitals      | Missing  | Only GA4 `screen_view` events tracked.                     |
| Global error boundaries | Partial | FlutterError.onError logs but no Sentry fallback.          |
| CI perf gate          | Absent   | Lighthouse runs only on PR comment basis.                  |

## 🗺️ Work Breakdown & Current Status
| ID  | Task                                                                        | Owner      | ETA       | Depends               | Status |
|-----|-----------------------------------------------------------------------------|------------|-----------|-----------------------|--------|
| PM1 | Integrate **leak_tracker** & **dart_code_metrics** "memory-leak" rule       | DevOps     | Aug Wk1   | quality_metrics_pilot | 🔄 **In Progress** |
| PM2 | Integrate web-vitals polyfill & Firebase Performance Monitoring for web      | Web guild  | Aug Wk1   | PM1                  | ✅ **Completed** |
| PM3 | Add `PerformanceTracker` utility & inject in `AnalyticsRouteObserver`        | FE guild   | Aug Wk2   | PM2                  | ✅ **Completed** |
| PM4 | Wrap `runApp` in error boundary & wire Sentry performance traces             | FE guild   | Aug Wk2   | PM1                  | ✅ **Completed** |
| PM5 | Add **Lighthouse-CI** job (`performance.yml`) with PWA budget <2 MB          | DevOps     | Aug Wk3   | —                     | 🔄 **In Progress** |
| PM6 | Perf regression badge in README & docs update                              | Docs       | Aug Wk4   | PM5                  | ⏳ **Pending** |

## 📋 Detailed TODO Items

### PM1: Memory Leak Detection (🔄 In Progress)
**Status**: `leak_tracker` dependency added to `pubspec.yaml`, but not yet integrated

#### TODO Items:
- [ ] **PM1.1** Create memory leak test harness in `test/memory/`
  ```dart
  // test/memory/leak_tracker_test.dart
  import 'package:leak_tracker_flutter_testing/leak_tracker_flutter_testing.dart';

  void main() {
    testWidgets('No memory leaks in smoke flows', (tester) async {
      await tester.pumpWidget(const MyApp());
      // Navigate through key screens
      await tester.tap(find.text('Dashboard'));
      await tester.pumpAndSettle();
      // Verify no leaks detected
    });
  }
  ```

- [ ] **PM1.2** Add leak tracker to CI workflow
  ```yaml
  # .github/workflows/advanced-deployment.yml
  - name: Memory Leak Detection
    run: |
      flutter test test/memory/ --dart-define=LEAK_TRACKER_ENABLED=true
  ```

- [ ] **PM1.3** Configure dart_code_metrics memory-leak rule
  ```yaml
  # .dart_code_metrics.yaml
  rules:
    - memory-leak
  ```

### PM2: Web-Vitals & Firebase Performance (✅ Completed)
**Status**: Web-vitals polyfill injected in CI, Firebase Performance initialized

#### Completed Items:
- [x] **PM2.1** Web-vitals polyfill injected in build process
- [x] **PM2.2** Firebase Performance initialized in `main.dart` and `main_fan.dart`
- [x] **PM2.3** Edge function `web_vitals.ts` created for RUM collection
- [x] **PM2.4** Netlify redirect configured for `/api/web-vitals`

#### Remaining TODO:
- [ ] **PM2.5** Verify web-vitals data flow in production
  ```bash
  # Test web-vitals collection
  curl -X POST https://teamappai.netlify.app/api/web-vitals \
    -H "Content-Type: application/json" \
    -d '{"name":"LCP","value":1200,"id":"v3-123","url":"/dashboard","ts":1234567890}'
  ```

### PM3: PerformanceTracker Integration (✅ Completed)
**Status**: `PerformanceTracker` utility created and integrated with `AnalyticsRouteObserver`

#### Completed Items:
- [x] **PM3.1** `PerformanceTracker` utility implemented
- [x] **PM3.2** Integration with `AnalyticsRouteObserver` for route tracing
- [x] **PM3.3** Provider configured in `config/providers.dart`

#### Remaining TODO:
- [ ] **PM3.4** Add performance tracking to heavy operations
  ```dart
  // lib/services/pdf_service.dart
  await PerformanceTracker.instance.startRouteTrace('pdf_generation');
  // ... PDF generation logic
  await PerformanceTracker.instance.stopCurrentTrace();
  ```

### PM4: Error Boundaries & Sentry (✅ Completed)
**Status**: `app_runner.dart` implements error boundaries with Sentry integration

#### Completed Items:
- [x] **PM4.1** `runAppWithGuards` function with `runZonedGuarded`
- [x] **PM4.2** Sentry integration with environment-based initialization
- [x] **PM4.3** FlutterError.onError wired to Sentry
- [x] **PM4.4** Performance traces enabled (20% sampling)

#### Remaining TODO:
- [ ] **PM4.5** Add error boundary to specific screens
  ```dart
  // lib/widgets/error_boundary.dart
  class ErrorBoundary extends StatelessWidget {
    final Widget child;
    final Widget Function(Object error)? errorBuilder;

    @override
    Widget build(BuildContext context) {
      return ErrorWidget.builder = (FlutterErrorDetails details) {
        Sentry.captureException(details.exception, stackTrace: details.stack);
        return errorBuilder?.call(details.exception) ??
               const ErrorFallbackWidget();
      };
    }
  }
  ```

### PM5: Lighthouse CI Integration (🔄 In Progress)
**Status**: Basic Lighthouse CI configured, but needs performance regression gates

#### Completed Items:
- [x] **PM5.1** Lighthouse CI workflow in `.github/workflows/flutter-web.yml`
- [x] **PM5.2** `lighthouserc.json` configuration
- [x] **PM5.3** Basic performance testing in `advanced-deployment.yml`

#### TODO Items:
- [ ] **PM5.4** Create dedicated `performance.yml` workflow
  ```yaml
  # .github/workflows/performance.yml
  name: Performance Regression Gate
  on: [pull_request]

  jobs:
    lighthouse:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v4
        - name: Run Lighthouse CI
          uses: treosh/lighthouse-ci-action@v10
          with:
            configPath: ./lighthouserc.json
            uploadArtifacts: true
            temporaryPublicStorage: true
  ```

- [ ] **PM5.5** Add performance regression thresholds
  ```json
  // lighthouserc.json
  {
    "ci": {
      "assert": {
        "assertions": {
          "categories:performance": ["error", { "minScore": 0.8 }],
          "first-contentful-paint": ["error", { "maxNumericValue": 2500 }],
          "largest-contentful-paint": ["error", { "maxNumericValue": 4000 }],
          "cumulative-layout-shift": ["error", { "maxNumericValue": 0.1 }]
        }
      }
    }
  }
  ```

- [ ] **PM5.6** Add PWA budget enforcement
  ```json
  // lighthouserc.json
  {
    "ci": {
      "assert": {
        "assertions": {
          "resource-summary:script:size": ["error", { "maxNumericValue": 2000000 }],
          "resource-summary:total:size": ["error", { "maxNumericValue": 5000000 }]
        }
      }
    }
  }
  ```

### PM6: Documentation & Badges (⏳ Pending)
**Status**: Not started

#### TODO Items:
- [ ] **PM6.1** Add performance badge to README.md
  ```markdown
  ![Performance](https://img.shields.io/badge/performance-90%25-brightgreen)
  ![Lighthouse](https://img.shields.io/badge/lighthouse-95%25-brightgreen)
  ```

- [ ] **PM6.2** Update performance monitoring documentation
  ```markdown
  # docs/monitoring/PERFORMANCE_MONITORING.md
  ## Real User Metrics (RUM)
  - Web-vitals collection via `/api/web-vitals`
  - Firebase Performance traces
  - Sentry error tracking
  ```

- [ ] **PM6.3** Create performance dashboard documentation
  ```markdown
  # docs/monitoring/PERFORMANCE_DASHBOARD.md
  ## Accessing Performance Data
  1. Firebase Console → Performance
  2. Sentry → Performance
  3. Supabase → web_vitals table
  ```

## 🛠  Technical Notes
* **Memory Leak Detection**: enable `leak_tracker` in test harness & run in post-test CI step.
* **RUM**: `web-vitals` npm package + custom JS interop; optionally integrate `firebase_performance` for web if available.
* **Error boundaries**: adopt `runZonedGuarded` + `FlutterError.onError` to route to Sentry.
* **Performance gate**: threshold—CLS <0.1, LCP <2.5 s, TBT <300 ms.

## 🚨 Risks & Mitigations
| Risk                     | Impact | Mitigation                                             |
|--------------------------|--------|--------------------------------------------------------|
| Performance SDK adds size| Low    | Measure bundle size diff; enable code-splitting & tree-shaking |
| Leak tracker false-positives | Low | Run only in debug/tests; ignore known SDK leaks         |
| Lighthouse flakiness     | Medium | Use median of 3 runs; cache resources                  |

## ✅ Exit Criteria
* Memory-leak test stage green with no leaks on smoke flows.
* Firebase Perf dashboard shows data <5 min after action.
* `performance.yml` fails PR when any metric regresses >10 %.
* Docs & README updated; Roadmap Phase 1 item **Performance-Monitoring** marked ✅.

## 📊 Progress Summary
- **Completed**: 3/6 tasks (50%)
- **In Progress**: 2/6 tasks (33%)
- **Pending**: 1/6 tasks (17%)

**Next Priority**: Complete PM1 (Memory Leak Detection) and PM5 (Lighthouse CI Integration)

---
