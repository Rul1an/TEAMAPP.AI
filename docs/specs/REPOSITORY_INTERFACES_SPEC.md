# Repository Layer – Design Specification

_Version: 0.1 • 2025-07-XX_

## 1  Goals

1. Decouple Riverpod providers/UI from data-source specifics (Supabase vs. Hive vs. Memory).
2. Provide predictable error & loading semantics (`Result<T>` sealed class).
3. Enable offline-first with transparent cache (Hive) and optional Isar migration later.
4. Facilitate unit-testing via in-memory / mock repositories.

---

## 2  Error & Result Model

```dart
sealed class Result<T> {
  const Result();
  factory Result.success(T data) = Success<T>;
  factory Result.failure(AppFailure error) = Failure<T>;
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final AppFailure error;
  const Failure(this.error);
}

sealed class AppFailure {
  const AppFailure();
}

class NetworkFailure extends AppFailure {
  final String message;
  const NetworkFailure(this.message);
}

class CacheFailure extends AppFailure {
  final String message;
  const CacheFailure(this.message);
}

class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure();
}
```

Providers will expose `AsyncValue<Result<T>>` so UI can display loading/error states consistently.

---

## 3  Abstract Interfaces

Only essential operations per domain; CRUD variants beyond _read_ are flagged with ✏️ to implement iteratively.

### 3.1  ProfileRepository
```dart
abstract interface class ProfileRepository {
  Future<Result<Profile?>> getCurrent();
  Future<Result<Profile>> update({
    String? username,
    String? avatarUrl,
    String? website,
  });
  Future<Result<Profile>> uploadAvatar(File file); // ✏️
  Stream<Profile> watch();
}
```

### 3.2  PlayerRepository
```dart
abstract interface class PlayerRepository {
  Future<Result<List<Player>>> all();
  Future<Result<Player>> byId(String id);
  Future<Result<void>> save(Player player); // ✏️ create/update
  Future<Result<void>> delete(String id); // ✏️
  Stream<List<Player>> watchAll();
}
```

_Similar pattern for `TeamRepository`, `MatchRepository`, `TrainingRepository`, etc._

### 3.3  OrganizationRepository
```dart
abstract interface class OrganizationRepository {
  Future<Result<List<Organization>>> list();
  Future<Result<Organization>> create(String name); // ✏️
  Future<Result<void>> switchActive(String id);
}
```

### 3.4  FeatureFlagRepository
```dart
abstract interface class FeatureFlagRepository {
  Future<Result<bool>> isEnabled(String key);
  Future<Result<String>> variant(String experimentKey);
}
```

### 3.5  PermissionRepository
```dart
abstract interface class PermissionRepository {
  Future<Result<Set<String>>> permissionsForRole(String role);
  Future<Result<bool>> hasPermission(String role, String action);
}
```

---

## 4  Implementation Matrix

| Repository | Remote Source | Cache | Status |
|------------|---------------|-------|--------|
| Profile | Supabase (REST + Storage) | 🐝 Hive (encrypted) | Pending (R3) |
| Player | None (local only for now) | Isar / Memory | Existing via `DatabaseService` – to wrap |
| Team | Same as Player | Isar / Memory | Existing – to wrap |
| Match | Same | Isar / Memory | Existing – to wrap |
| Training | Same | Isar / Memory | Existing – to wrap |
| TrainingSession | Same | Isar / Memory | Existing – to wrap |
| Organization | Supabase | Hive | Pending |
| FeatureFlag | Supabase | Memory (runtime cache) | Pending |
| Permission | Supabase | Memory | Pending |

---

## 5  Provider Migration Strategy

1. Implement `SupabaseProfileRepository` + tests (R3).
2. Introduce `RepositoryProvider<T>` pattern using Riverpod generators.
3. Migrate `profile_*` providers to repository.
4. Gradually roll out to other domains following road-map R4–R6.

---

## 6  Code Generation

* Add `build_runner`, `freezed`, `riverpod_generator` to dev_dependencies.
* Use `@riverpod` to generate repository providers.
* Use `freezed` for `Result<T>` (maybe). Placeholder above is manual to avoid extra boilerplate initially.

---

## 7  Testing

* Each repository gets a `*_fake.dart` using in-memory collections.
* 80 %+ statement coverage target (see plan metrics).
* Hive encryption unit tested with mock secure storage.

---

## 8  Open Questions

1. Should we deprecate `DatabaseService` once repositories are complete? _(Proposed: yes, after R8 clean-up)_
2. How to reconcile Isar (mobile) vs. Hive (unified)? _(Option: keep Isar for complex queries, Hive for small profile cache)_

---

_Authors: Dev Team • Reviewers: Arch Guild_
