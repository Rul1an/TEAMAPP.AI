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

## Migration Plan
| Phase | Deliverable | Owner | ETA |
|-------|-------------|-------|-----|
| 1 | _Repo Analysis_ – catalogue every `supabase` call inside `services/`, group by domain | Core architect | Aug 5 |
| 2 | `abstract class ProfileRepository` + `SupabaseProfileRepository` | Core architect | Aug 15 |
| 3 | Migrate `profileService` & providers to repository | Feature dev | Aug 20 |
| 4 | Implement & wire `HiveProfileCache` (read-through) | Feature dev | Sep 1 |
| 5 | Repeat pattern for Players, Matches, Trainings | Team | Sep 20 |
| 6 | Remove obsolete service classes, update docs/tests | Team | Sep 30 |

## Open Questions
* Granularity – per entity repository vs grouped.
* Error handling strategy (sealed `Result<T>` or exceptions).
* How to surface cache-staleness to UI (e.g. optimistic updates).

## References
* VGV Flutter Architecture 2025 Guide – https://verygood.ventures/blog/flutter-architecture-guide-2025
* Flutter Clean Architecture Sample (2025 edition) – https://github.com/brianegan/flutter_arch_sample_clean
* Supabase Offline-First Patterns – https://supabase.com/docs/guides/solutions/offline-first
