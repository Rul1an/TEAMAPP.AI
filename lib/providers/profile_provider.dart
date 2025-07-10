// Dart imports:
import 'dart:async';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../data/supabase_profile_data_source.dart';
import '../hive/hive_profile_cache.dart';
import '../models/profile.dart';
import '../repositories/profile_repository.dart';
import '../repositories/profile_repository_impl.dart';

/// Exposes the concrete [ProfileRepository]. Swap implementation in tests.
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    remote: SupabaseProfileDataSource(),
    cache: HiveProfileCache(),
  );
});

/// Holds the current user profile as [AsyncValue]. Automatically refreshes when
/// repository emits changes.
class CurrentProfileNotifier extends AsyncNotifier<Profile?> {
  late final ProfileRepository _repo;
  StreamSubscription<Profile>? _sub;

  @override
  FutureOr<Profile?> build() async {
    _repo = ref.watch(profileRepositoryProvider);

    _setupDispose();

    // Listen to live updates
    _sub = _repo.watch().listen((profile) {
      state = AsyncData(profile);
    });

    // Initial fetch
    final res = await _repo.getCurrent();
    return res.dataOrNull;
  }

  Future<void> editProfile({
    String? username,
    String? avatarUrl,
    String? website,
  }) async {
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

  void _setupDispose() {
    ref.onDispose(() {
      _sub?.cancel();
    });
  }
}

/// Provider for the [CurrentProfileNotifier].
final currentProfileProvider =
    AsyncNotifierProvider<CurrentProfileNotifier, Profile?>(
      CurrentProfileNotifier.new,
    );
