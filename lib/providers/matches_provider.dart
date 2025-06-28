import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/match.dart';
import '../services/database_service.dart';

final matchesProvider = FutureProvider<List<Match>>((ref) async {
  final db = DatabaseService();
  return await db.getAllMatches();
});

final upcomingMatchesProvider = FutureProvider<List<Match>>((ref) async {
  final db = DatabaseService();
  return await db.getUpcomingMatches();
});

final recentMatchesProvider = FutureProvider<List<Match>>((ref) async {
  final db = DatabaseService();
  return await db.getRecentMatches();
});

final matchByIdProvider = FutureProvider.family<Match?, String>((ref, id) async {
  final db = DatabaseService();
  return await db.getMatch(id);
});

final matchesNotifierProvider = StateNotifierProvider<MatchesNotifier, AsyncValue<List<Match>>>((ref) {
  return MatchesNotifier();
});

class MatchesNotifier extends StateNotifier<AsyncValue<List<Match>>> {
  MatchesNotifier() : super(const AsyncValue.loading()) {
    loadMatches();
  }

  final _db = DatabaseService();

  Future<void> loadMatches() async {
    state = const AsyncValue.loading();
    try {
      final matches = await _db.getAllMatches();
      state = AsyncValue.data(matches);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addMatch(Match match) async {
    try {
      await _db.saveMatch(match);
      await loadMatches();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateMatch(Match match) async {
    try {
      await _db.saveMatch(match);
      await loadMatches();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
