# Code Quality Upgrade Plan – Q4 2025

_Last updated: 2025-07-16_

## Objective
Elevate the codebase to Very Good Ventures (VGV) analysis standards and enforce automated quality gates.

## Scope
1. Adopt `package:very_good_analysis` v5 ruleset.
2. Enable Dart 3.3 `strict-casts`, `strict-inference`, and `implicit-dynamic: false`.
3. Introduce `dart_code_metrics` v6 with thresholds (cyclomatic ≤20, nesting ≤4, NOC ≤15, file length ≤300 LOC).
4. Configure CI to fail on any `info`/`warning`.
5. Provide auto-formatting & import-sorting Git hooks via `lefthook`.
6. Document new standards in `docs/quality/CODING_STANDARDS.md`.

## Milestones & Timeline
| ID | Task | Owner | ETA |
|----|------|-------|-----|
| Q4-1 | Update `analysis_options.yaml` with VGV ruleset | @core-team | Oct Week 1 |
| Q4-2 | Run `dart fix --apply` + manual cleanup | @interns | Oct Week 1-2 |
| Q4-3 | Add `dart_code_metrics.yaml` baseline | @qa | Oct Week 2 |
| Q4-4 | Integrate `very_good analyze --fatal-infos` in CI | Dev-ops | Oct Week 3 |
| Q4-5 | Add pre-commit `lefthook` for `dart format` & `import_sorter` | Dev-ops | Oct Week 3 |
| Q4-6 | Refactor >300 LOC files still exceeding limits | Dev-team | Oct Week 4 |
| Q4-7 | Write `CODING_STANDARDS.md` & run workshop | Tech writer | Nov Week 1 |

## Success Criteria
* CI passes only when 0 `error`/`warning`/`info`.
* dart_code_metrics thresholds enforced.
* Team adopts auto-format hooks (>90 % pushes lint-clean).

## Risks & Mitigations
| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Massive autofix diff complicates open PRs | Medium | Medium | Land changes early in cycle; rebase guidance |
| dart_code_metrics false-positives | Low | Low | Start with warning-only mode, tighten gradually |
| Developer friction with stricter lints | Medium | Low | Provide VSCode settings & docs |

## Status Tracking
- Initial draft ready (16 Jul 2025).
- Awaiting stakeholder approval to schedule in Q4 backlog.