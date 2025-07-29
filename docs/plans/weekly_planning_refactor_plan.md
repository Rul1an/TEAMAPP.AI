# Weekly Planning Screen Refactor Plan (Q3 2025)

_Last updated: 2025-07-25_

## Objective
Refactor `weekly_planning_screen.dart` (<900 LOC) into a clean, testable structure:
- Extract UI state and scroll logic into a controller (`WeeklyPlanningController`).
- Decompose the screen into modular widgets (`SeasonHeader`, `WeeklyWeekSelector`, `WeeklyTable`).
- Adopt a test-first, incremental approach to ensure CI stability.

## Context
The current screen mixes:
- Presentation (Scaffold, AppBar, dialogs)
- Business logic (state updates via Riverpod provider)
- Scroll logic (manual ScrollController)
- Dialog and mutation helpers (add/edit training, match, notes)

This monolithic file violates 2025 best practices (file <300 LOC, single responsibility).

## Branch Strategy
Work on a dedicated feature branch:
```
git checkout -b feature/weekly-planning-refactor
```
Keep commits small, run CI locally after each step, and open a PR when done.

## Plan Steps

### 1. Controller Unit Tests (TDD)
- Create `test/controllers/weekly_planning_controller_test.dart`.
- Write tests for:
  - `scrollToWeek(index)` moves the controller's `ScrollController` to the correct offset.
- Run:
  ```bash
  dart format .
  flutter analyze --fatal-infos
  flutter test test/controllers/weekly_planning_controller_test.dart
  ```
- Commit & push.

### 2. Extract `WeeklyPlanningController` Provider
- Create `lib/controllers/weekly_planning_controller.dart` with `ChangeNotifier` and `ChangeNotifierProvider`.
- Confirm unit tests still pass.
- Commit & push.

### 3. Widget Tests for Selector & Table Stubs
- **Week Selector**:
  - Ensure existing `WeekSelector` logic is preserved.
  - Create `WeeklyWeekSelector` extending `WeekSelector`.
  - Write `test/widgets/weekly_planning/weekly_week_selector_test.dart` to verify rendering and tap behavior.
- **Table Stub**:
  - Create `WeeklyTable` stub with simple parsing of `AnnualPlanningState`.
  - Write `test/widgets/weekly_planning/weekly_table_test.dart` to confirm correct row count for a sample state.
- Run full test suite:
  ```bash
  flutter test
  ```
- Commit & push.

### 4. Screen Integration
- Modify `weekly_planning_screen.dart`:
  - Import the controller provider, `SeasonHeader`, `WeeklyWeekSelector`, and `WeeklyTable`.
  - Remove inlined scroll and build logic.
  - Wire `controller.scrollToWeek(...)` and `_showAddEventDialog` calls.
- Run:
  ```bash
  dart format .
  flutter analyze --fatal-infos
  flutter test
  ```
- Confirm the screen builds and tests pass.
- Commit & push.

### 5. Cleanup and Coverage
- Remove any unused imports and private helper methods.
- Ensure `weekly_planning_screen.dart` is under 300 LOC (excl. comments).
- Verify code coverage still meets project threshold.
- Final commit & push.

## Exit Criteria
- `main` CI remains green after merge of feature branch.
- All tests (unit, widget) pass without flaky failures.
- Analyzer reports 0 errors/warnings/infos.
- File sizes and structure conform to 2025 best practices.
