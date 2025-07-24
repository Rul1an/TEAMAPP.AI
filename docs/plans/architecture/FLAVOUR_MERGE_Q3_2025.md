# Fan & Family Flavour – Staged Merge Plan (Q3 2025)

_Last updated: 2025-07-24_

## 🎯 Objective
Safely integrate the **fan_family** flavour (branch `controleer-en-implementeer-nieuwe-ui-plannen-0afa`) without jeopardising the stable _coach_suite_ in `main`.

Adopt a **strangler-fig pattern**: extract self-contained slices from the large branch into small, reviewable PRs that land green on CI.

## 🗺️ PR Sequence
| Order | Slice | Source paths | Target LOC | Checks | Status |
|-------|-------|--------------|------------|--------|--------|
| 1 | **Docs & CI/Infra** | `.github/workflows/*`, `docs/` only | < 2 k | CI green (no Dart) | ✅ Merged |
| 2 | **Video Tagging module** | `lib/features/video_tagging/`, `supabase/edge_functions/*video*`, tests | ~3 k | Analyzer & unit-tests | ✅ Merged |
| 3 | **Match Schedule Import** | `lib/services/schedule_*`, `lib/screens/matches/import_*`, Hive cache + tests | ~2 k | Widget & unit tests | ✅ Merged |
| 4 | **Flavour Bootstrap** | `lib/main_fan.dart`, `router_fan.dart`, `theme_fan.dart`, assets | ~1 k | Build matrix (`--flavor fan_family`) | ✅ Merged |
| 5 | **UI Refinement** | Updates to shared screens, scaffold, NL strings | remainder | Golden & Lighthouse >= 90 | ✅ Merged |

Each PR must:
1. **Rebase on current `main`.**
2. Pass **Lefthook**, **security-scan**, **CI/test** jobs.
3. Add/adjust documentation where relevant.

## 🔄 Workflow
```bash
# Example for slice 1
git checkout -b flavour-slice-docs 0afa
# remove all non-docs/CI files
git restore --staged :/** && git add docs .github/workflows
...
git commit -m "feat(flavour): docs & CI groundwork"
git push -u origin flavour-slice-docs
gh pr create --base main --title "Flavour merge – slice 1 (docs & CI)" --body "Part of FLAVOUR_MERGE_Q3_2025"
```
After merge of a slice, **rebase the next slice** on the new `main`.

## ✅ Definition of Done
* All five PRs merged into `main`.
* CI green on `main`; Lighthouse ≥ 90; no increase in analyzer issues.
* Fan & Family build (`flutter build apk --flavor fan_family`) succeeds locally and in CI.
* Demo flows (coach_suite & fan_family) verified in staging.

## References
* Google “Trunk-based development with feature slicing” (2025)
* Flutter 2025 best practice “Keep PRs <1 k LOC”
* GitHub Actions incremental adoption guide (2025-05).

## 🏁 Completion
All five slices landed on `main` as of **24 Jul 2025**. CI is green, Lighthouse scores ≥ 90, and `fan_family` flavour builds successfully across Web and Android. The Flavour Merge initiative is now **closed**.
