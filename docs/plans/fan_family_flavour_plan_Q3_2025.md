# Fan & Family Flavour Plan (Q3 2025)

_Approved by product board • 17 Jul 2025_

This document formalises the decision to introduce a **dedicated “Fan & Family” Flutter flavour** for **Parents (O)** and **Players (P)** while keeping the existing _Coach-Suite_ flavour for staff roles.

Links:
* Architecture reference: [`docs/architecture/ARCHITECTURE.md`](../architecture/ARCHITECTURE.md)
* RBAC details: [`docs/reports/security/RBAC_IMPLEMENTATION_STATUS_FINAL.md`](../../reports/security/RBAC_IMPLEMENTATION_STATUS_FINAL.md)
* Previous analysis & recommendation: chat session **2025-07-17** (internal)

---

## 1  Scope & Goals

1. Ultra-light UI focused on match/training schedule, player list and personal stats (read-only).
2. Re-use ≥ 85 % of shared code via Flutter **flavours** – no duplicate business logic.
3. Provide growth hooks (push notifications, share links) & faster install (≤ 7 MB Android bundle).
4. Deliver pilot in **4 weeks**; gatekeeper KPIs: MAU ↑ 20 %, support tickets ↓ 30 %, p95 load < 2 s.

## 2  Role Visibility Matrix (canonical)

| Route / Feature | A | H | L | P | O |
|-----------------|---|---|---|---|---|
| Dashboard & Agenda | ✓ | ✓ | ✓ | ✓ | ✓ |
| Players list/detail (view) | ✓ | ✓ | ✓ | ✓ | ✓ |
| Players CRUD | ✓ | ✓ |   |   |   |
| Training schedule (view) | ✓ | ✓ | ✓ | ✓ | ✓ |
| Training management | ✓ | ✓ | ✓ |   |   |
| Exercise library | ✓ | ✓ | ✓ |   |   |
| Field-diagram / Designer | ✓ | ✓ | ✓ |   |   |
| Match calendar (view) | ✓ | ✓ | ✓ | ✓ | ✓ |
| Match management / Line-up | ✓ | ✓ | ✓ |   |   |
| Analytics & SVS | ✓ | ✓ |   |   |   |
| Annual planning / Budget | ✓ | ✓ |   |   |   |
| Organization & RBAC | ✓ |   |   |   |   |

*Parents (O) & Players (P) remain **strictly view-only** as enforced by `PermissionService`.*

## 3  Architecture Decision

* Adopt **two flavours** in the same Flutter workspace:
  * `coach_suite` (default, existing)
  * `fan_family` (new)
* Shared layers (Models, Repositories, Providers, Widgets) stay untouched.
* Flavour-specific files:
  * `lib/main_fan.dart`
  * `lib/config/router_fan.dart`
  * `lib/config/theme_fan.dart`
  * Store metadata & icons (android/ios/web).
* CI matrix expands to {`coach_suite`, `fan_family`}.

## 4  4-Week Action Plan

### Week 1 – Setup
1. `git checkout -b feature/fan_flavour_init`
2. Add `--flavor fan_family` config in **Android**, **iOS**, **Web**.
3. Scaffold `main_fan.dart` → bootstraps `AppFan` with `router_fan` & `theme_fan`.
4. Prepare Fastlane lanes & Firebase project (analytics + push).

### Week 2 – UI Slim-Down
5. Build home `FanHomeScreen` (card grid → Dashboard, Training, Matches, Players, My Stats).
6. Wrap existing shared screens; hide staff-only FABs via `PermissionService.isViewOnlyUser`.
7. Golden tests: ensure navigation reachable ≤ 3 taps.

### Week 3 – Growth & Analytics
8. Push notification opt-in flow (`firebase_messaging`).
9. Deep-link share to match schedule (`context.go('/matches/:id')`).
10. Configure CI → GitHub Actions `build_fan.yaml` (Android APK, Web PWA).

### Week 4 – Pilot & KPI Gate
11. Closed beta install for Club X (TestFlight + Play Internal).  
12. Capture KPIs (MAU uplift, ticket reduction, performance) in Firebase dashboard.
13. **Go/No-Go** review; if green → roadmap to public release Q2 2026, else rollback to _Focus-Mode_ strategy.

## 5  Deliverables
* Merge request `feature/fan_flavour_init` → `develop` (Week 1).
* Updated documentation:
  * `ARCHITECTURE.md` – add flavour diagram (link placeholder).
  * `DEPLOYMENT_GUIDE.md` – flavour build & store steps.
* CI pipelines green for both flavours.
* KPI dashboard url shared in `/docs/status/`.

## 6  Risks & Mitigations
| Risk | Impact | Mitigation |
|------|--------|-----------|
| Theme / router divergence | Medium | Enforce design tokens + shared route constants |
| CI complexity | Low | Matrix build with caching; reuse existing Fastlane |
| Store review delays | Medium | Start provisioning Week 1, submit beta Week 3 |

## 7  Appendix – Commands
```bash
# Build Android APK (fan flavour)
flutter build apk --flavor fan_family -t lib/main_fan.dart

# Build Web (fan flavour)
flutter build web --release --dart-define=FLAVOR=fan_family
```

---
*Owner*: @dev-team   *Next review*: Pilot retro – Aug 2025