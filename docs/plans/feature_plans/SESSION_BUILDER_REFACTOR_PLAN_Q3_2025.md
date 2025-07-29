# SessionBuilder Screen Refactor – Final Slice (Q3 2025)

_Last updated: 2025-07-28_

## 🎯 Goal
Reduce `session_builder_screen.dart` from ~1 600 LOC to **≤ 300 LOC** (non-generated) and finish the screen/view separation introduced in slice 4.

## Background
Slice 4 introduced `SessionBuilderView`, but the legacy `_build*Step()` UI helpers still reside inside `SessionBuilderScreen`, keeping the file oversized. We need to:
1. Move all UI composition to the view.
2. Keep the screen purely responsible for state/DI/navigation.
3. Update tests + providers to use the new structure.

## Branch Strategy
```
git checkout -b refactor/session-builder-final-slice
```
Keep commits small (< 400 LOC diff), push after each checklist item, CI must stay green.

## Implementation Plan

| ID | Step | Owner | Est. h |
|----|------|-------|--------|
| **S1** | **Move UI helpers to view**<br>- Copy `_buildBasicInfoStep`, `_buildObjectivesStep`, `_buildPhasePlanningStep`, `_buildEvaluationStep` into `SessionBuilderView` private methods.<br>- Remove them from the screen file. | dev | 1.0 |
| **S2** | **Slim Screen**<br>- Delete obsolete imports (wizard + widgets).<br>- Remove unused `_build*` references/comments.<br>- Verify resulting LOC ≤ 300. | dev | 0.5 |
| **S3** | **Update Tests**<br>- Adjust existing widget tests to pump `SessionBuilderView` directly (mocking callbacks). | QA | 1.0 |
| **S4** | **Analyzer & Formatting**<br>- `dart format .` and `flutter analyze --fatal-infos` must return 0 issues. | dev | 0.2 |
| **S5** | **Integration QA**<br>- Manual test: create & edit a training session across all steps.<br>- Verify exercise dialog, PDF export, navigation. | QA | 0.5 |
| **S6** | **Commit & PR**<br>- Commit message: `refactor(session-builder): final slice – screen <300 LOC`.<br>- Push branch, open PR, auto-merge after green CI. | dev | 0.2 |

## Acceptance Criteria
* `session_builder_screen.dart` **≤ 300 LOC** (excluding comments).
* No UI code remains in the screen – only state & callbacks.
* CI green, analyzer 0 issues, tests pass.
* Coverage unchanged or higher.

## Checklist
- [ ] S1 completed & unit tests green
- [ ] S2 LOC check (`wc -l`) ≤ 300
- [ ] S3 widget tests updated & passing
- [ ] S4 analyzer 0 issues
- [ ] S5 manual QA ok
- [ ] S6 PR merged into `main`

---
*Document generated via Cursor AI assistant.*
