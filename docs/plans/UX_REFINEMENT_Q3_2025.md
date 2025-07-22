# UI Refinement & Consistency Plan (Q3 2025)

_Aligns with Fan & Family pilot and 2025 best-practice UX guidelines_

**Related docs**  
• [Fan & Family Flavour Plan (Q3 2025)](fan_family_flavour_plan_Q3_2025.md)  
• [Architecture.md – Build Flavours](../architecture/ARCHITECTURE.md#🔀-build-flavours-2025-q3)  
• [Master Delivery Roadmap 2025-2026](MASTER_DELIVERY_ROADMAP_2025-2026.md)

---

## 🎯 Goals

1. Remove UI redundancies & align language across roles/flavours.  
2. Guarantee ≤ 1 primary action per screen (Material 3 “Action Economy”).  
3. Ensure navigation destinations ≤ 5 on mobile, ≤ 7 on desktop.  
4. Harden view-only flows (Parents/Players) – no mutating actions visible.  
5. Instrument navigation analytics (GA4 `screen_view`).

---

## 📋 Task Matrix

| ID | Area | Description | Owner | ETA |
|----|------|-------------|-------|-----|
| N1 | Navigation | Merge _Analytics_ & _SVS_ under **Insights** tab; collapse _Season_ + _Annual planning_ into **Season** hub | Front-end | W3 D1 |
| N2 | FAB/AppBar | Deduplicate “Add” icons on Training & Matches screens – follow breakpoint rules | Front-end | W3 D2 |
| N3 | Terminology | NL string audit – remove EN remnants; conform to NL style guide | Docs + FE | W3 D2 |
| S1 | View-only | Hide PDF export & Line-up buttons in `MatchDetail` when view-only | Front-end | W3 D1 |
| S2 | Share | Add `share_training_link` & TrainingDetail share icon | Front-end | W3 D3 |
| A1 | Analytics | GoRouter observer → log `screen_view` + `tab_switch` | Front-end | W3 D3 |
| T1 | Tests | Golden & widget tests for new navigation + view-only gating | QA | W3 D4 |

---

## 🔄 Implementation Sequence

1. **Create feature branch** `feature/ui_refinement_q3_2025`.  
2. Implement **N1** – update `main_scaffold.dart`, `router.dart`, add `InsightsScreen` (wrapper for existing Analytics & SVS tabs).  
3. Apply **S1** logic in `match_detail_screen.dart` (reuse `PermissionService`).  
4. Refactor **N2** in Training & Matches screens (breakpoint-based actions).  
5. Introduce `lib/services/i18n_lint.dart` & run audit, fix strings (**N3**).  
6. Extend `DeepLinkService` with Training sharing (**S2**).  
7. Add `AnalyticsObserver` to GoRouter providers (**A1**).  
8. Update golden tests & add widget tests (**T1**).  
9. PR review → merge into `develop`.  
10. Tag `ui-v<semver>` → CI matrix build + Lighthouse.

---

## ✅ Definition of Done

* Navigation bar/rail shows **≤ 5 (mobile)** / **≤ 7 (desktop)** primary destinations.  
* No duplicate “Add” buttons on any breakpoint.  
* Parents/Players cannot view _edit_, _export_ or _line-up_ actions.  
* All user-facing strings NL.  
* Share icon present on Match & Training detail → opens OS share-sheet with Dynamic Link.  
* GA4 `screen_view` events fire on every route change (checked in DebugView).  
* All tests (unit, widget, golden, integration) green; Lighthouse scores ≥ 90.  
* Docs updated & KPI dashboard references remain valid.