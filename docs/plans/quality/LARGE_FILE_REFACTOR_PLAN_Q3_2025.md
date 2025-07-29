# Large File Refactor Plan – Q3 2025

_Last updated: 2025-07-12_

## Why
Keeping files under ±300 LOC improves comprehension, PR review time and hot-reload performance. 2025 Flutter best-practice guidelines recommend:

* Feature-first folder structure with "leaf" widgets < 200 LOC.
* Split state (provider/notifier) from view widgets.
* Extract pure helpers to `utils/` or dedicated services.
* Generated files are exempt (\*.g.dart / \*.freezed.dart).

## Inventory (non-generated > 300 LOC)
| # | File | LOC | Category | Primary Concerns |
|---|------|----:|----------|------------------|
| 1 | lib/screens/training_sessions/session_builder_screen.dart | 1074 | Screen | Monolithic build method, dialogs & remaining helpers | **In Progress** – controller & major steps extracted; needs further split to ≤300 LOC |
| 2 | lib/screens/annual_planning/load_monitoring_screen.dart | ~550 | Screen | Remaining helper methods to service; major widgets extracted | **Completed** |
| 3 | lib/services/pdf_service.dart | 1288 | Service | Mixed IO, layout & aggregation logic |
| 4 | lib/widgets/field_diagram/field_painter.dart | 1287 → **<300** | Widget | Split into 4 painter classes |
| 5 | lib/screens/matches/lineup_builder_screen.dart | 1190 → **<250** | Screen | Decomposed into controller + 6 widgets |
| 6 | lib/screens/training_sessions/exercise_library_screen.dart | 1149 | Screen | Filter/search + dialogs in one file |
| 7 | lib/screens/annual_planning/weekly_planning_screen.dart | 1087 | Screen | 7 tabs + charts inline |
| 8 | lib/screens/dashboard/dashboard_screen.dart | 951 | Screen | Dashboard cards + providers in same file |
| 9 | lib/screens/admin/performance_monitoring_screen.dart | 934 | Screen | Charts + data fetch inline |
|10 | lib/providers/annual_planning_provider.dart | 850 | Provider | 20+ methods, could split into services |

## Refactor Strategy
1. **Spike/Facade extraction** – Move heavy business logic into dedicated `services/` where possible.
2. **Widget decomposition** – For each screen extract: `*_view.dart`, `*_toolbar.dart`, `*_chart.dart`, etc.
3. **State isolation** – Use Riverpod `Notifier` classes in `providers/` and keep UI stateless.
4. **Painter split** – Break `field_painter.dart` into sub painers per layer (pitch, players, annotations).
5. **Service modularisation** – `pdf_service.dart` → separate generators: `invoice_pdf.dart`, `training_plan_pdf.dart`.
6. **UT & golden tests** – Ensure same coverage after refactor.

## Milestones & TODOs
| ID | Task | Depends | Owner |
|----|------|---------|-------|
| refactor-session-builder | Split SessionBuilderScreen (UI bits + controller + sub-widgets) | refactor-large-files | dev-team |
| refactor-load-monitoring | Extract charts & risk cards to widgets; move calculations to `analysis_service.dart` | refactor-large-files | dev-team |
| refactor-pdf-service | Break `pdf_service.dart` into module files + interface `PdfGenerator` | refactor-large-files | dev-team |
| refactor-field-painter | Separate painter layers into individual classes (`PitchPainter`, `PlayerPainter`, …) | refactor-large-files | dev-team |
| refactor-lineup-builder | Decompose LineupBuilderScreen into widgets & provider | refactor-large-files | dev-team |
| refactor-exercise-library | Split ExerciseLibrary screen & move filter logic to provider | refactor-large-files | dev-team |
| refactor-weekly-planning | Decompose WeeklyPlanning screen | refactor-large-files | dev-team |
| refactor-dashboard-screen | Extract dashboard cards widgets & provider | refactor-large-files | dev-team |
| refactor-performance-monitoring | Split PerformanceMonitoringScreen | refactor-large-files | dev-team |
| refactor-annual-planning-provider | Break provider into smaller services (`PlanLoader`, `RiskAnalyzer`) | refactor-large-files | dev-team |

Each PR must keep analyzer at 0 issues & tests green.

## Success Criteria
* No file > 300 LOC (except generated).
* 0 analyzer warnings/infos.
* >=40 % test coverage maintained.
* CI passes with `--fatal-infos`.

### Progress _(updated 2025-07-16)_

* **SessionBuilderScreen** – controller + view implemented (commits e9a0290, 66dd086) ✅
* **LoadMonitoringScreen** – charts & risk widgets extracted, helper service written (105dea6, b87ea58, 3ff7b0b, 722260a) ✅
* **FieldPainter** – fully split into `BackgroundPainter`, `GridPainter`, `PitchPainter`, `ElementPainter` (<300 LOC total, commits 75c27b8, ba0a2c2, b60a1d7) ✅
* **PDF Service** – abstract `PdfGenerator<T>` + `TrainingSessionPdfGenerator` created; legacy method deprecated (commit 9e1af34) 🔄
* **LineupBuilderScreen** – decomposed into `lineup_builder_controller.dart` + 6 widgets; new unit tests added (`lineup_builder_controller_test.dart`, commit 3437b83) 🔄
* **PDF Service Modularisation** – all generators wired, legacy code deleted ✅
* **PerformanceMonitoringScreen** – split into widgets, screen <230 LOC, generators wired ✅
