# Local Repository Refactor – Phase 2

_Migrate remaining legacy `Local*Repository` classes to the unified Hive cache layer._

## Scope
The following repositories still depend on `DatabaseService`:

| Repo | Cache helper | File |
|------|--------------|------|
| Training Session | `HiveTrainingCache` (reuse) | `local_training_session_repository.dart` |
| Training Exercise | **NEW** `HiveTrainingExerciseCache` | `local_training_exercise_repository.dart` |
| Training Period   | **NEW** `HiveTrainingPeriodCache`   | `local_training_period_repository.dart` |
| Season            | **NEW** `HiveSeasonCache`           | `local_season_repository.dart` |
| Statistics        | **NEW** `HiveStatisticsCache`       | `local_statistics_repository.dart` |
| Formation Template| `HiveFormationTemplateCache` (exists) | `local_formation_template_repository.dart` |
| Performance Rating| **NEW** `HivePerformanceRatingCache` | `local_performance_rating_repository.dart` |
| Assessment        | `HiveAssessmentCache` (exists)      | `local_assessment_repository.dart` |
| Periodization Plan| **NEW** `HivePeriodizationCache`     | `local_periodization_plan_repository.dart` |

> Caches marked **NEW** will wrap `LocalStore<T>` to keep code DRY.

## Migration Steps per Repo
1. Replace `DatabaseService` import with `hive/<cache>.dart`.
2. Inject cache via constructor (default to singleton).
3. Rewrite CRUD/query methods to operate on in-memory list & write-back.
4. Remove `firstWhere` + `orElse: () => <model>()` pattern → return nullable.
5. Add unit tests (read-empty, add, update, delete, filters).

## Deliverables
1. `hive/` cache classes for NEW caches (use `LocalStore`).
2. Refactored repositories & updated imports.
3. Updated provider bindings if any UI layer instantiates these repos.
4. Green analyzer (`flutter analyze --no-fatal-infos`).
5. All new tests passing, coverage unaffected or higher.

## Timeline (rolling)
| Task | ETA |
|------|-----|
| Create new cache helpers | Day 1 |
| Migrate Training Session & Exercise repos | Day 1 |
| Migrate Period & Season repos | Day 2 |
| Migrate Statistics & Performance repos | Day 2 |
| Migrate Assessment & PeriodizationPlan repos | Day 3 |
| Clean up `DatabaseService` if no more references | Day 3 |

---

Document version 0.1 (2025-07-10)
