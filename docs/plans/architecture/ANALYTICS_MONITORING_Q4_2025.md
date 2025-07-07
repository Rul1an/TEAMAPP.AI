# Analytics & Monitoring Integration Plan – Q4 2025

_Last updated: 2025-07-16_

## Objective
Add production-grade analytics and error monitoring to JO17 Tactical Manager using **Firebase Analytics** and **Sentry**.

## Deliverables
1. Event tracking design (screen views, key actions).
2. Firebase project setup, secrets management in CI.
3. Integrate `firebase_analytics` (v11) with Riverpod observer.
4. Integrate `sentry_flutter` (v8) capturing errors & performance.
5. CI/CD secret injection & environment-based toggles.
6. GDPR consent & opt-out logic.
7. Dashboard documentation & team training.

## Work Breakdown
| ID | Task | Owner | ETA |
|----|------|-------|-----|
| A1 | Define analytics events & parameter schema | Product | Oct Wk1 |
| A2 | Create Firebase project & service accounts | Dev-ops | Oct Wk1 |
| A3 | Add dependencies, env toggles, secrets | Dev-ops | Oct Wk1 |
| A4 | Implement `AnalyticsService` + Riverpod observer | Dev | Oct Wk2 |
| A5 | Wire events in key screens | Dev | Oct Wk2-3 |
| A6 | Integrate `sentry_flutter` with flutter run modes | Dev | Oct Wk2 |
| A7 | Write unit tests for analytics hooks | QA | Oct Wk3 |
| A8 | Update privacy policy & consent dialog | Legal | Oct Wk3 |
| A9 | Dashboard docs & training session | Tech writer | Oct Wk4 |

## Risks & Mitigations
| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| GDPR compliance missteps | Medium | High | Legal review before release |
| Performance overhead | Low | Medium | Use sampling & background isolate |
| Secret leakage in CI logs | Low | High | Use GitHub Encrypted Secrets |

## Success Criteria
* Events visible in Firebase Console <1 min after action.
* Sentry captures uncaught exceptions in staging and production.
* Opt-out toggle removes analytics.
* CI remains green.

## Status
Draft v0.1 – awaiting approval.