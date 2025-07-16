import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/player_movement_analytics.dart';
import './analytics_repository_provider.dart';

/// Fetches [PlayerMovementAnalytics] for a player+match.
final playerMovementAnalyticsProvider = FutureProvider.autoDispose
    .family<PlayerMovementAnalytics, (String playerId, String matchId)>(
  (ref, tuple) async {
    final (playerId, matchId) = tuple;
    final repo = ref.read(analyticsRepositoryProvider);
    final result = await repo.getPlayerMovementAnalytics(
      playerId: playerId,
      matchId: matchId,
    );
    return result.when(
      success: (data) => data,
      failure: (error) => throw Exception(error.message),
    );
  },
);