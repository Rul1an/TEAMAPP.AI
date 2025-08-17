// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../data/supabase_match_data_source.dart';
import '../hive/hive_match_cache.dart';
import '../models/match.dart';
import '../repositories/match_repository.dart';
import '../repositories/match_repository_impl.dart';

final matchRepositoryProvider = Provider<MatchRepository>((ref) {
  return MatchRepositoryImpl(
    remote: SupabaseMatchDataSource(),
    cache: HiveMatchCache(),
  );
});

final matchesProvider = FutureProvider<List<Match>>((ref) async {
  final repo = ref.read(matchRepositoryProvider);
  try {
    final res = await repo.getAll().timeout(const Duration(seconds: 4));
    return res.dataOrNull ?? [];
  } catch (_) {
    return [];
  }
});

final upcomingMatchesProvider = FutureProvider<List<Match>>((ref) async {
  final repo = ref.read(matchRepositoryProvider);
  try {
    final res = await repo.getUpcoming().timeout(const Duration(seconds: 4));
    return res.dataOrNull ?? [];
  } catch (_) {
    return [];
  }
});

final recentMatchesProvider = FutureProvider<List<Match>>((ref) async {
  final repo = ref.read(matchRepositoryProvider);
  try {
    final res = await repo.getRecent().timeout(const Duration(seconds: 4));
    return res.dataOrNull ?? [];
  } catch (_) {
    return [];
  }
});

final matchByIdProvider = FutureProvider.family<Match?, String>((
  ref,
  id,
) async {
  final repo = ref.read(matchRepositoryProvider);
  final res = await repo.getById(id);
  return res.dataOrNull;
});

final matchesNotifierProvider =
    StateNotifierProvider<MatchesNotifier, AsyncValue<List<Match>>>(
  MatchesNotifier.new,
);

class MatchesNotifier extends StateNotifier<AsyncValue<List<Match>>> {
  MatchesNotifier(this._ref) : super(const AsyncValue.loading()) {
    loadMatches();
  }

  final Ref _ref;

  MatchRepository get _repo => _ref.read(matchRepositoryProvider);

  Future<void> loadMatches() async {
    state = const AsyncValue.loading();
    final res = await _repo.getAll();
    state = res.when(
      success: AsyncValue.data,
      failure: (err) => AsyncValue.error(err, StackTrace.current),
    );
  }

  Future<void> addMatch(Match match) async {
    state = const AsyncValue.loading();
    final res = await _repo.add(match);
    if (res.isSuccess) {
      await loadMatches();
    } else {
      state = AsyncValue.error(res.errorOrNull!, StackTrace.current);
    }
  }

  Future<void> updateMatch(Match match) async {
    state = const AsyncValue.loading();
    final res = await _repo.update(match);
    if (res.isSuccess) {
      await loadMatches();
    } else {
      state = AsyncValue.error(res.errorOrNull!, StackTrace.current);
    }
  }
}
