import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/profile.dart';
import '../repositories/profile_repository.dart';
import '../repositories/supabase_profile_repository.dart';

/// Exposes the concrete [ProfileRepository]. Swap implementation in tests.
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return SupabaseProfileRepository();
});

/// Holds the current user profile as [AsyncValue]. Automatically refreshes when
/// repository emits changes.
class CurrentProfileNotifier extends AsyncNotifier<Profile?> {
  late final ProfileRepository _repo;
  StreamSubscription<Profile>? _sub;

  @override
  FutureOr<Profile?> build() async {
    _repo = ref.watch(profileRepositoryProvider);

    // Listen to live updates
    _sub = _repo.watch().listen((profile) {
      state = AsyncData(profile);
    });

    // Initial fetch
    final res = await _repo.getCurrent();
    return res.dataOrNull;
  }

  Future<void> update({String? username, String? avatarUrl, String? website}) async {
    state = const AsyncLoading();
    final res = await _repo.update(
      username: username,
      avatarUrl: avatarUrl,
      website: website,
    );
    state = res.when(
      success: AsyncData.new,
      failure: (e) => AsyncError(e, StackTrace.current),
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

/// Provider for the [CurrentProfileNotifier].
final currentProfileProvider = AsyncNotifierProvider<CurrentProfileNotifier, Profile?>(
  CurrentProfileNotifier.new,
);
