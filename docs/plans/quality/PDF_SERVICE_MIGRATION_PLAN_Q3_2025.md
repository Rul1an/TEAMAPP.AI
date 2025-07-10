# PDF Service Migration Plan – Q3 2025

> Owner: **@core-team – Quality Guild**
> Status: **Completed** (2025-07-16)

---

## 1. Background
The current PDF export logic is concentrated in `lib/services/pdf_service.dart` (~700 LOC) and several static helpers embedded in widgets. This causes:

* Tight coupling to UI → difficult unit-testing
* Single, God-object class with mixed responsibilities (data mapping, layout, IO)
* Low coverage (<15 %)

A refactor is required to hit the 40 % repo-wide coverage target and to unblock upcoming enterprise white-label templates.

## 2. Goals & Success Criteria
| Goal | Metric |
|------|--------|
| Modular, testable PDF generators | ≥ 80 % unit-test coverage for `lib/pdf/*` |
| Remove legacy static helpers | `grep -R "PdfService\." lib/` returns **0** hits |
| Support Match Report & Player Assessment exports | Manual QA passes in staging |
| CI passes | `flutter analyze` → 0 issues, coverage ≥ 40 % |

## 3. Scope
### In-scope
1. Create `lib/pdf/` module with:
   * `pdf_generator.dart` (abstract base)
   * `match_report_pdf_generator.dart`
   * `player_assessment_pdf_generator.dart`
   * Shared utils (`pdf_styles.dart`, `pdf_assets.dart`)
2. Move fonts/logos to `assets/pdf/` and load lazily.
3. Unit & golden tests using `printing` mocks.
4. Update providers & UI export flows.
5. Delete legacy `pdf_service.dart` + widget helpers.

### Out-of-scope
* Redesigning layouts (follow-up ticket).
* Multi-language localisation.

## 4. Architecture Overview
```
UI Layer ──┐               export()
           │
Provider (Riverpod) ──► PdfGenerator (abstract)
                         │ build()
                         ▼
                 Concrete Generators
              (MatchReport / PlayerAssessment)
                         │ returns Uint8List
                         ▼
                   Export Utility / Printing
```

* Generators return a `Uint8List` → framework-agnostic, can run in isolates.
* DI via Riverpod keeps tests simple.

## 5. Work Breakdown
| ID | Task | Est. h | Owner | Depends |
|----|------|--------|-------|---------|
| P1 | Skeleton `lib/pdf/`, move assets | 3 | @dev1 | — |
| P2 | Implement `PdfGenerator` base | 4 | @dev1 | P1 |
| P3 | Match Report generator | 8 | @dev2 | P2 |
| P4 | Player Assessment generator | 6 | @dev2 | P2 |
| P5 | Unit + golden tests (≥80 %) | 6 | @qa | P3-P4 |
| P6 | Wire up providers & UI | 4 | @dev3 | P3-P4 |
| P7 | Remove legacy code | 2 | @dev1 | P6 |
| P8 | Docs & roadmap updates | 2 | @techwriter | P7 |
| **Total** | **35 h** | — | — |

## 6. Risks & Mitigations
| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Golden tests flaky | Medium | Medium | Deterministic fonts; stub current date |
| Asset path issues on Web | Low | High | Web integration test in CI |
| Time overrun on complex layouts | Medium | Medium | Keep layout parity; avoid redesign |

## 7. Timeline
* **Week 29** – P1-P3
* **Week 30** – P4-P6
* **Week 31** – P7-P8, staging QA
* **Week 32** – Production rollout

## 8. Acceptance Checklist
- [X] Unit & golden tests ≥ 80 %
- [X] Legacy service/helpers removed
- [X] CI green (analyze + tests + coverage)
- [X] Functional QA sign-off (Head Coach & Analyst)

---
*Generated with Cursor AI assistant.*
