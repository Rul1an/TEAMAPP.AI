# Local Repository Refactor – Q3 2025

_Migrate all in-memory `Local*Repository` classes away from the legacy `DatabaseService` singleton and onto the unified Hive-based caching layer._

## Goals
1. Eliminate `DatabaseService` and all global state it introduces.
2. Standardise offline storage around `BaseHiveCache` (TTL + schema versioning).
3. Improve unit-test isolation and raise filtered test-coverage ≥ 40 %.
4. Align with 2025 Flutter SaaS best-practices: clean architecture, repository pattern, Riverpod DI.

---

## Phase 1 – Foundation
| Step | Deliverable |
|---|---|
| 1.1 | **`LocalStore<T>` wrapper** built on `BaseHiveCache` with:<br>• automatic JSON serialisation<br>• optional `ttl` parameter<br>• schema-migration hook (`onUpgrade`) |
| 1.2 | Deprecate `DatabaseService` (leave adapter for transitional tests). |

## Phase 2 – Repository Migrations
Each legacy repo gets a pure-local implementation that delegates to `LocalStore`. CRUD is synchronous; filters are applied in-memory.

| Repo | File | Status |
|------|------|--------|
| Player | `local_player_repository.dart` | pending |
| Match | `local_match_repository.dart` | pending |
| Training | `local_training_repository.dart` | pending |
| Training Session | `local_training_session_repository.dart` | pending |
| Training Exercise | `local_training_exercise_repository.dart` | pending |
| Training Period | `local_training_period_repository.dart` | pending |
| Season | `local_season_repository.dart` | pending |
| Statistics | `local_statistics_repository.dart` | pending |
| Formation Template | `local_formation_template_repository.dart` | pending |
| Performance Rating | `local_performance_rating_repository.dart` | pending |
| Assessment | `local_assessment_repository.dart` | pending |
| Periodization Plan | `local_periodization_plan_repository.dart` | pending |

Guidelines:
* Keep repositories **stateless**; data lives only in `LocalStore`.
* Provide `clear()` for demo-mode resets.
* Default `ttl`: 24 hours; overridable per repo.

## Phase 3 – DI & Providers
* Add `Provider<LocalStore<T>>` instances (lazy, `autoDispose`).
* Replace old repository providers in `lib/config/providers.dart`.

## Phase 4 – Testing & Coverage
* Unit tests per repo:<br>  – read-empty ⇒ `[]` / `null`<br>  – write → read round-trip<br>  – overwrite & merge scenarios<br>  – ttl expiry.
* Use in-memory Hive (via `hive_test`).

## Phase 5 – Cleanup
1. Delete `DatabaseService` and related imports.
2. Remove deprecated adapters.
3. Run `flutter analyze --fatal-infos` – expect **0 issues**.
4. Update docs & diagrams.

---

## Timeline
| Week | Milestone |
|---|---|
| 28 | Phase 1 complete + Player repo migrated |
| 29 | Core Training/Match repos migrated |
| 30 | Remaining repos migrated |
| 31 | Tests + coverage ≥ 40 % |
| 32 | Cleanup & docs |

---

_Lead_: **Local-data squad**
_Status_: Draft v0.1 (2025-07-10)

