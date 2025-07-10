# Hive Profile Cache – Implementation Plan (Q3 2025)

_Last updated: 2025-07-16_

## 🎯  Goal
Provide an encrypted offline cache for the user `Profile` entity using **Hive 4**. The cache will be leveraged by `SupabaseProfileRepository` with a stale-while-revalidate strategy.

## 1  Design Decisions
1. **Encrypted Box** – Use `HiveKeyManager` (AES-256) for encryption key.
2. **Single-Item Box** – Since there is at most one active profile, store it in a dedicated `profiles` box with key `current`.
3. **TypeAdapter** – Generate `ProfileAdapter` via `build_runner`.
4. **SW-R Strategy**
   * `getCurrent()`
     1. Read from Hive; if exists → return cached **Success** immediately.
     2. Fetch from Supabase → update cache → emit fresh data.
   * `update()/uploadAvatar()`
     * After remote success, write updated profile to cache.
5. **Box Lifecycle** – Open box lazily inside repository; close automatically via `Hive.close()` in app shutdown (outside scope).

## 2  Task Breakdown
| ID | Task | Owner | ETA |
|----|------|-------|-----|
| H1 | Add Hive deps (`hive`, `hive_flutter`) to `pubspec.yaml` | Dev | — |
| H2 | Create `ProfileAdapter` + run codegen | Dev | — |
| H3 | Implement `HiveProfileCache` (read/write helpers) | Dev | — |
| H4 | Refactor `SupabaseProfileRepository` to inject optional cache & implement SW-R | Dev | — |
| H5 | Unit tests with in-memory Hive (`Hive.initMemory()`) | QA | — |
| H6 | Update docs (`ARCHITECTURE.md`) & diagrams | Tech writer | — | ✅ Done
=======
| H1 | Add Hive deps (`hive`, `hive_flutter`) to `pubspec.yaml` | Dev | ✅ Completed |
| H2 | Create `ProfileAdapter` + run codegen | Dev | ✅ Completed |
| H3 | Implement `HiveProfileCache` (read/write helpers) | Dev | ✅ Completed |
| H4 | Refactor `SupabaseProfileRepository` to inject optional cache & implement SW-R | Dev | ✅ Completed |
| H5 | Unit tests with in-memory Hive (`Hive.initMemory()`) | QA | ✅ Completed |
| H6 | Update docs (`ARCHITECTURE.md`) & diagrams | Tech writer | ✅ Completed |


## 3  API Sketch
```dart
class HiveProfileCache {
  static const _boxName = 'profiles';
  static const _key = 'current';

  Future<Box<Profile>> _openBox() async {
    final key = await HiveKeyManager().getKey();
    return Hive.openBox<Profile>(
      _boxName,
      encryptionCipher: HiveAesCipher(key),
    );
  }

  Future<Profile?> read() async {
    final box = await _openBox();
    return box.get(_key);
  }

  Future<void> write(Profile profile) async {
    final box = await _openBox();
    await box.put(_key, profile);
  }
}
```

Repository integration:
```dart
final cached = await _cache.read();
if (cached != null) return Success(cached);
// otherwise fetch remote …
```

## 4  Acceptance Criteria
* Offline launch shows cached profile data.
* Encryption key stored only in secure storage.
* Unit tests: cache hit, cache miss, encryption.

---

_After this cache is validated, repeat pattern for Players, Matches, Trainings in `domain-rollout`._
