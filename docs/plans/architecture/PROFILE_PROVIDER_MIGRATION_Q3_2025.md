# Profile Provider Migration – Execution Plan (Q3 2025)

_Last updated: 2025-07-XX_

## 🎯 Objective
✅ Migration completed (Jun 25 2025 – commit `ce49df0`).

The app now uses `ProfileRepositoryImpl` (remote `SupabaseProfileDataSource` + `HiveProfileCache`) exposed via `profileRepositoryProvider`.
`ProfileScreen` and `currentProfileProvider` consume the repository. Legacy `ProfileService` & `SupabaseProfileRepository` removed.

## 1. Design Principles
1. Providers praten alleen met **ProfileRepository** – niet met services/APIs.
2. State-exposure via `AsyncNotifier<Profile?>` en `AsyncValue` voor consistente loading/error handling.
3. Gebruik `Result<T>` & `AppFailure` voor foutafhandeling.
4. Demo-mode & offline-decorators kunnen later als Repository decorators worden toegevoegd.

## 2. Implementation Steps
| ID | Task | Owner | ETA |
|----|------|-------|-----|
| P1 | Add `profileRepositoryProvider` (simple `Provider<ProfileRepository>`) | Dev | — |
| P2 | Implement `CurrentProfileNotifier` (`AsyncNotifier<Profile?>`) | Dev | — |
| P3 | Hook notifier `build()` → `getCurrent()` & listen to `watch()` stream | Dev | — |
| P4 | Add mutation helpers `updateProfile()`, `uploadAvatar()` that delegate to repo | Dev | — |
| P5 | Unit-tests with a fake repository (success & failure cases) | QA | — |
| P6 | Integrate notifier where profile data will be shown (future UI) | FE | — |
| P7 | Update docs (`ARCHITECTURE.md`) with provider diagram | Tech writer | — |

## 3. Provider API Sketch
```dart
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return SupabaseProfileRepository();
});

@riverpod
class CurrentProfile extends AsyncNotifier<Profile?> {
  @override
  FutureOr<Profile?> build() async {
    final repo = ref.watch(profileRepositoryProvider);
    ref.listenManual<Profile>(repo.watch(), (profile) => state = AsyncData(profile));
    final res = await repo.getCurrent();
    return res.dataOrNull;
  }

  Future<void> update({String? username, String? avatarUrl, String? website}) async {
    final repo = ref.read(profileRepositoryProvider);
    state = const AsyncLoading();
    state = (await repo.update(username: username, avatarUrl: avatarUrl, website: website))
        .when(success: AsyncData.new, failure: (e) => AsyncError(e, StackTrace.current));
  }
}
```

## 4. Testing Strategy
* Fake repository returns stub `Profile`, toggles failures.
* Verify notifier emits loading → data / error.
* Ensure stream updates refresh state without rebuild loops.

## 5. Risks & Mitigations
| Risk | Mitigation |
|------|------------|
| Breaking existing UI that directly accesses Supabase auth user | Gradual migration; keep old getters until screens updated |
| Increased boilerplate | Use `riverpod_generator` to auto-generate providers |

---

_This plan is part of the [Repository Layer Refactor Roadmap](REPOSITORY_LAYER_REFRACTOR_Q3_2025.md)._
