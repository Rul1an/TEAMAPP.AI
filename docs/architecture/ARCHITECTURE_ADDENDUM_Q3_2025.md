# Architecture Addendum – Repository Layer Refactor (Q3 2025)

> This document amends `ARCHITECTURE.md` and will be merged once the refactor lands in `main`.

## Why a Repository Layer?

Flutter best-practices (2025) and the official **Clean Architecture** recommendation advocate a dedicated Repository layer to isolate **business rules** from **data access**.
Our current code couples Riverpod providers directly to _Supabase_ (remote) or _Hive_ (local) calls inside `services/`.

### Target Stack
```
Widgets → Riverpod Provider → Repository → Data-source (Supabase / Hive / Mock)
```

* **Repository** – pure Dart interface exposed to the app (e.g. `ProfileRepository`).
* **Data-source** – concrete implementation: `SupabaseProfileDataSource`, `HiveProfileCache`, …  injected into repository.

## Benefits
1. **Testability** – Providers can be unit-tested with an in-memory fake repository; no HTTP, no DB.
2. **Pluggability** – Caching, offline-first, or alternative back-ends swapable via constructor injection.
3. **Consistency** – Single place for mapping DTO ⇄ domain models.
4. **Performance** – Hive cache can satisfy reads instantly and defer writes.

## Migration Plan – Progress Snapshot (as of 8 June 2025)

| Phase | Deliverable | Status | ETA |
|-------|-------------|--------|-----|
| 1 | _Repo Analysis_ – catalogue every `supabase` call inside `services/`, group by domain | **✅ Completed** 2025-06-07 | — |
| 2 | `abstract class ProfileRepository` + `SupabaseProfileRepository` | **�� In progress** – PR #163 drafts interface & mapper | 15 Jun |
| 3 | Migrate `profileService` & providers to repository | ✅ Completed (0c83060) | 25 Jun |
| 4 | Implement & wire `HiveProfileCache` (read-through) | Pending | 01 Jul |
| 5 | Repeat pattern for Players, Matches, Trainings | Planned | 20 Jul |
| 6 | Remove obsolete service classes, update docs/tests | Planned | 31 Jul |

> Decision 2025-06-08: based on the latest code-analysis the **Repository Layer Refactor** delivers the highest architectural leverage (testability, Supabase decoupling) now that observability & lint cleanup are done. We therefore prioritise Phase 2 (ProfileRepository implementation) as the next sprint focus.

## Open Questions
* Granularity – per entity repository vs grouped.
* Error handling strategy (sealed `Result<T>` or exceptions).
* How to surface cache-staleness to UI (e.g. optimistic updates).

## References
* VGV Flutter Architecture 2025 Guide – https://verygood.ventures/blog/flutter-architecture-guide-2025
* Flutter Clean Architecture Sample (2025 edition) – https://github.com/brianegan/flutter_arch_sample_clean
* Supabase Offline-First Patterns – https://supabase.com/docs/guides/solutions/offline-first

**Status (25 Jun 2025):** Migration finished. `ProfileService` deleted, providers wired to `ProfileRepositoryImpl` (Supabase + Hive). All tests pass. Commit `0c83060`.
