# Repository Layer Cookbook & Usage Guide (2025)

*Document version: 2025-07-11*

---

## 🎯 Purpose
This guide **teaches teams how to use, extend and test** the new Repository Layer that powers JO17 Tactical Manager.  It consolidates best-practices from Flutter Clean Architecture 2025, Supabase offline-first patterns and Riverpod 3.

> If you only need the TL;DR jump to the **Quick Start** below.

---

## 🌐 Context Recap
```
Widgets → Riverpod Provider → Repository → Data-source(s)
                     ↑                        ↑
                 Result<T>               Hive / Supabase
```
* UI depends **only** on `Repository` abstractions.
* Repositories orchestrate **remote** (Supabase) + **local** (Hive) data-sources.
* All methods return `Result<T>` (sealed) to avoid crashes and surface stale-cache data gracefully.

---

## 🚀 Quick Start
```dart
final playersProvider = FutureProvider.autoDispose((ref) async {
  final repo = ref.watch(playerRepositoryProvider);
  final res  = await repo.getAll();
  return res.dataOrThrow;   // handy extension inside result.dart
});
```
That's it.  No HTTP, no Hive logic in UI.

---

## 1. Setting up a new Repository
### 1.1 Create interface
```dart
abstract interface class FooRepository {
  Future<Result<List<Foo>>> getAll();
  Future<Result<Foo?>>      getById(String id);
  Future<Result<void>>      add(Foo foo);
}
```

### 1.2 Implement data-sources
* **Remote** → `SupabaseFooDataSource` (single responsibility = network)
* **Cache**  → `HiveFooCache` (encrypted, TTL aware)

### 1.3 Implement repository `FooRepositoryImpl`
* Follow the **read-through / write-invalidate** skeleton (see `player_repository_impl.dart`).
* Map low-level errors to domain-level `AppFailure` subclasses.

### 1.4 Wire providers
```dart
final fooRepositoryProvider = Provider<FooRepository>((ref) =>
  FooRepositoryImpl(
    remote: ref.read(fooRemoteProvider),
    cache : ref.read(fooCacheProvider),
  ),
);
```

---

## 2. Offline-First Pattern
| Phase | Remote OK? | Behaviour |
|-------|------------|-----------|
| 1     | ✅ yes     | Return data, **update cache** |
| 2     | ❌ no      | Try cache ⇒ if hit return stale data else failure |

> TTL can be overridden per call – useful for pull-to-refresh.

---

## 3. Handling `Result<T>`
```dart
final res = await repo.add(foo);
res.when(
  success: (_)  => showSnack('Saved'),
  failure: (e) => showError(e.message),
);
```
* Use `dataOrNull`, `errorOrNull`, `isSuccess` helpers for compact code.
* Never **throw** inside repositories.

---

## 4. Testing Strategy (Mocktail)
```dart
class _FakeRemote extends Mock implements SupabaseFooDataSource {}

void main() {
  late _FakeRemote remote;
  late HiveFooCache cache;
  late FooRepository repo;

  setUp(() {
    remote = _FakeRemote();
    cache  = HiveFooCache(memoryBox: true); // in-mem box for tests
    repo   = FooRepositoryImpl(remote: remote, cache: cache);
  });

  test('falls back to cache when network fails', () async {
    when(() => remote.fetchAll()).thenThrow(SocketException('down'));
    await cache.write([Foo.fake()]);
    final res = await repo.getAll();
    expect(res.isSuccess, true);
  });
}
```
Coverage for repositories should stay ≥ 80 % (CI gate).

---

## 5. Migration Checklist (new Domain)
1. [ ] Define `DomainModel`
2. [ ] Create **remote** data-source
3. [ ] Create **cache** (Hive)
4. [ ] Write repository interface & impl
5. [ ] Add Riverpod providers
6. [ ] Write unit tests (success + cache fallback + mutation)
7. [ ] Update docs/analysis & roadmap tables

---

## 6. FAQ
* **Why Hive and not Isar?**  Hive 4 is lighter, web-ready and already used for other caches.  Future switch remains possible thanks to repository abstraction.
* **What about optimistic updates?**  Wrap mutation inside `Result<void>`; UI can speculatively update state while repository invalidates cache in background.
* **Encryption keys?**  Managed centrally via `HiveKeyManager`; never commit keys to git.

---

## 🔗 References
* Clean Architecture in Flutter 2025 – Very Good Ventures
* Supabase Offline Patterns – docs.supabase.com
* Riverpod 3 AsyncNotifier cookbook – riverpod.dev

---

Happy coding 🏗️🦄
