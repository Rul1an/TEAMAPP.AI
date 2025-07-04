# Exercise Library Refactor Plan – Q3 2025

_Last updated: 2025-07-13_

## 1. Background
`exercise_library_screen.dart` is **≈ 1150 LOC** and blends UI, business logic, data loading and filtering.  This violates our < 300 LOC guideline and makes the file hard to test and maintain.

Since 2025 best-practice recommendations emphasise **clean architecture**, **feature-first folders**, **Riverpod state isolation** and **80 %+ hot-reload efficiency**, the screen requires a structured decomposition.

## 2. Goals
* Reduce each source file to ≤ 300 LOC (UI) or ≤ 200 LOC (widgets).
* Separate business logic (filter/search) from UI using a **Riverpod `ChangeNotifier` controller**.
* Keep analyser at **0 errors / ≤ 10 infos** and maintain **≥ 40 % coverage**.
* Preserve existing functionality (search, filters, morphocycle recommendations, tabs, select-mode).

## 3. Architectural Principles (Flutter 2025)
1. **UI-Logic Separation** – Widgets remain dumb; state lives in providers/controllers.
2. **Layered Widgets** – Prefer small "leaf" widgets ≤ 200 LOC with explicit, immutable props.
3. **Feature-First Folders** – All Exercise Library files live under `lib/screens/training_sessions/exercise_library/`.
4. **Typed Filtering** – Enums/values flow through strongly-typed API instead of dynamic maps.
5. **Reusable Services** – Heavy compute helpers move to `services/` if they can be shared elsewhere.
6. **Testing Pyramid** – Unit tests for controller filters; golden/widget tests for critical UI; e2e already covered in integration tests.

## 4. High-Level Breakdown
| Layer | File | Responsibility |
|-------|------|----------------|
| Controller | `exercise_library_controller.dart` | Holds raw data, filter state, exposes `filteredExercises` (DONE – initial) |
| Screen | `exercise_library_screen.dart` | Assembles Scaffold, TabBar & high-level layout; delegates state to controller |
| Widgets | `filter_bar.dart` | Chips & dropdown filters |
| | `search_bar.dart` | Search textfield |
| | `morphocycle_banner.dart` | Gradient card with week info & intensity chips |
| | `exercise_tab_view.dart` | Generic list builder per tab |
| Tests | `exercise_library_controller_test.dart` | Unit tests (filters & reset) |
| | `exercise_library_screen_test.dart` | Widget test (search/filter flow) |

## 5. Task List
1. **Finalize Controller**
   * Add methods: `toggleMorphocycleBanner`, `setDurationRange`, etc.
   * Wire to providers (already partially implemented).
   * Coverage ≥ 90 % for controller.
2. **Extract Widgets**
   2.1 `search_bar.dart`
   2.2 `filter_bar.dart`
   2.3 `morphocycle_banner.dart`
   2.4 `exercise_tab_view.dart` (param: `List<TrainingExercise>`)
3. **Refactor Screen**
   * Keep only Scaffold, TabBar, body composition (< 300 LOC).
   * Replace inline filter dialog with `showModalBottomSheet` util widget.
4. **Hook Up Controller**
   * Screen listens to `exerciseLibraryControllerProvider`.
   * Remove obsolete StateProviders (`exerciseSearchProvider`, `exerciseTypeFilterProvider`).
5. **Testing**
   * `exercise_library_controller_test.dart` – filtering by search/intensity/focus, reset.
   * `exercise_library_screen_test.dart` – golden snapshot after applying filter.
6. **Docs & Coverage**
   * Update `LARGE_FILE_REFACTOR_PLAN_Q3_2025.md` inventory.
   * Ensure `flutter analyze --fatal-infos` = 0 errors / ≤ 10 infos.
   * Verify coverage gate still ≥ 40 %.

## 6. Acceptance Criteria
* `exercise_library_screen.dart` **< 300 LOC**.
* All newly created widgets **< 200 LOC**.
* Controller unit tests pass (≥ 95 % statements covered).
* CI green, coverage gate passes, no new infos >10.
* UX identical to current behaviour.

---

_Lead_: Dev-team @teamapp.ai
_Target PR window_: **Week 29 • (15 – 19 July 2025)**
