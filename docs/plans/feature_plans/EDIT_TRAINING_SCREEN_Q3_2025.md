# Edit Training Screen – Implementation Plan (Q3 2025)

_Issue: #28 – Phase 1 Master Roadmap_
_Last updated: 2025-07-16_

## 1. Background
The Training entity currently supports create & view flows. Editing is still missing, forcing users to delete + recreate. Goal: provide full CRUD with validation, consistent with Edit Player/Match screens and adhering to Clean-Architecture (Repository layer, Riverpod ViewModel).

## 2. Functional Requirements
1. Edit existing Training session: date, duration, focus, intensity, status.
2. Validation rules:
   * Date ≥ today (or allow past if status = Completed).
   * Duration 15 – 240 min.
   * Mandatory fields: date, duration, focus, intensity.
3. Attendance & notes remain unchanged in this MVP (separate story).
4. UI parity across Web, Desktop, Mobile (Material 3 forms).
5. Successful save updates repository (Local/Hive → Supabase sync when online).

## 3. Architecture Decisions
* **Screen split** <300 LOC: `training_edit_screen.dart` (view) + `training_edit_viewmodel.dart` (StateNotifier).
* Leverage existing `TrainingRepository` for update.
* Form uses `Form`, `TextFormField`, `DropdownButtonFormField`, `DatePicker`.
* Navigation via `context.go('/trainings/:id/edit')`.

## 4. Work Breakdown
| ID | Task | Est. h | Owner |
|----|------|--------|-------|
| E1 | Route `/trainings/:id/edit` in router.dart | 0.5 | dev |
| E2 | Scaffold `training_edit_screen.dart` with reactive form | 3 | dev |
| E3 | `training_edit_viewmodel.dart` (StateNotifier) | 2 | dev |
| E4 | Validation functions & unit tests | 2 | qa |
| E5 | Wire to `TrainingRepository.update()` (+Hive cache write-through) | 1 | dev |
| E6 | Widget tests (golden) – form initial state & save | 2 | qa |
| E7 | Docs update & screenshots (`guides/`) | 1 | docs |
| **Total** | **11.5 h** | — |

## 5. Acceptance Criteria
* Form pre-filled with existing Training data.
* Validation blocks submit until fields valid.
* Saving updates repository and navigates back with SnackBar.
* Unit + widget tests pass; analyzer 0 issues.
* File lengths: screen < 230 LOC, viewmodel < 120 LOC.

## 6. Risks & Mitigations
| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Date-picker web bug | Low | Medium | Use `showDatePicker` workaround test in Chrome CI |
| Repository update latency on web (mock) | Low | Low | Optimistic UI, Hive write first |

---
_Draft ready – to be implemented immediately._