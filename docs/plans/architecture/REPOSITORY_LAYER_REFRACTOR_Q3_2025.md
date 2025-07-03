# Repository Layer Refactor – Execution Plan (Q3 2025)

*Document version: 2025-07-02*

---

## 🎯 Objective
Introduce a formal **Repository Layer** to decouple Riverpod providers from Supabase/Hive data-sources, align with Flutter Clean Architecture 2025, and improve testability/offline-readiness.

## 🗺 Milestones & Timeline
| ID | Milestone | Description | Owner | ETA |
|----|-----------|-------------|-------|-----|
| R1 | Repo Analysis | Catalogue all data calls in `services/` & `providers/`, group by domain | Lead dev | Aug 05 |
| R2 | Design Spec | Define abstract repository interfaces (`ProfileRepository`, `PlayerRepository`, …) and common error model | Architect | Aug 10 |
| R3 | Profile Repo | Implement `SupabaseProfileRepository` + unit tests | Feature team | Aug 15 |
| R4 | Provider Migration | Refactor `profileService` → provider depends on repository | Feature team | Aug 20 |
| R5 | Hive Cache | Implement `HiveProfileCache`; wire behind repository with stale-while-revalidate | Feature team | Sep 01 |
| R6 | Domain Roll-out | Repeat R3–R5 for Players, Matches, Trainings | Squad | Sep 20 |
| R7 | Docs & Samples | Update `ARCHITECTURE.md`, write usage cookbook | Tech writer | Sep 25 |
| R8 | Cleanup | Remove obsolete service classes, ensure 0 analyzer issues | Squad | Sep 30 |

## 🔑 Key Decisions
1. **Per-entity repositories** keep interfaces small and composable.
2. Use **sealed `Result<T>`** objects instead of throwing for predictable error handling.
3. Cache writes = *write-through*, reads = *read-through* with background refresh.
4. Leverage **Riverpod `Provider.autoDispose`** + `AsyncNotifier` for async exposal.

## 🛠 Tech Choices
* *Supabase* remains primary remote source → wrap with `SupabaseXXXRepository`.
* *Hive 4* (encrypted boxes) for local cache.
* **Mocktail** for unit test fakes.
* Code generation (`riverpod_generator`, `freezed`) to produce repository providers & DTO mappers.

## 📈 Success Metrics
* Coverage of repository unit tests ≥ 80 %.
* Launch time (cold start) improved by ≥ 20 % on low-end Android (due to cache).
* Analyzer: 0 errors, 0 warnings after refactor.

## 📚 Further Reading
* Clean Architecture in Flutter 2025 – https://verygood.ventures/blog/flutter-architecture-guide-2025
* Supabase Offline Sync Patterns – https://supabase.com/docs/guides/solutions/offline-first
* Hive 4 Encryption Guide – https://docs.hivedb.dev/#/advanced/encrypted_box
