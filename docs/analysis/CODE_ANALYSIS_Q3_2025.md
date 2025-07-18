# Code Analysis Overview – Q3 2025

_Last updated: 2025-07-16_

## Current State

| Metric | Result |
|--------|--------|
| Analyzer errors | **0** |
| Analyzer warnings | **0** |
| Analyzer infos (hints) | **0** |
| Test coverage | ≥ 40 % lines (lcov)
| Golden tests | 4 suites passing |

All functional errors are resolved. Remaining _info_ hints are style-only: directive ordering, trailing commas, cascade suggestions, etc.

## Goal

Bring analyzer to **0 infos** and lift overall code-quality bar in line with 2025 best practices:

1. Adopt `package:very_good_analysis` (v5) rule-set for stricter lints.
2. Enable Dart 3.3 `strict-casts` & `strict-inference`.
3. Enforce import sorting & trailing commas via `dart format` + `import_sorter`.
4. Integrate `dart_code_metrics` (v6) with CI gating (cyclomatic ≤ 20, NOC ≤ 15, file length ≤ 300).

## Action Plan (Q4 2025)

| Step | Owner | ETA |
|------|-------|-----|
| Update `analysis_options.yaml` with `very_good_analysis` & new language flags | @core-team | Week 1 |
| Run `dart fix --apply` & manual cleanup for remaining hints | @interns | Week 1-2 |
| Configure pre-commit Git hook (`lefthook`) for `dart format` & `import_sorter` | Dev-ops | Week 2 |
| Add `dart_code_metrics` config + baseline suppression file | @qa | Week 2 |
| CI: add `dart run very_good analysis --fatal-infos` stage | Dev-ops | Week 3 |
| Refactor >300 line files into modules  | @tech-lead | Week 3-4 |
| Document rules in `docs/quality/CODING_STANDARDS.md` | @docs | Week 4 |

### Risk Mitigation

- Run fixes branch-wise; protect `main` via PR status checks.
- For golden tests, re-capture images after UI changes caused by trailing commas.

### Success Criteria

- `flutter analyze` returns **0 issues** with `--fatal-infos`.
- CI fails on any new lint violation.
- Code coverage ≥ 40 % remains.
- Dev-team acknowledges new standards in retro.

### CI Monitor
A dedicated **CI Monitor** GitHub workflow is active. On every failing build it automatically opens/updates a `ci-failure` issue with logs attached. The current `main` and `develop` branches are green (build #354, 2025-07-16).

### Notable Updates (2025-07-13)
* **Exercise Library Modularisation** – Legacy 1 100+ LOC screen refactored into modular widgets; analyzer now 0 issues overall (`3aa66d7`).
* Added `SessionBuilderController` (StateNotifier) and `SessionBuilderView` – both fully covered by analyzer with 0 issues.
* Introduced `training_session_builder_service.dart` with formatted code.

### Notable Updates (2025-07-16)
* **PDF Service Modularisation** – Legacy service removed; generators & golden tests raise overall coverage, analyzer still 0 issues.
* **Large File Refactor** – PerformanceMonitoringScreen split; all target files ≤300 LOC.
* **Hive Profile Cache** – Encrypted cache implemented and integrated; offline launch verified, tests pass.
