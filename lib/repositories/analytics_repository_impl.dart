import '../core/result.dart';
import '../models/action_event.dart';
import '../config/supabase_config.dart';
import '../models/player_movement_analytics.dart';
import 'analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  @override
  Future<Result<List<ActionEvent>>> getHeatMapData({
    required DateTime start,
    required DateTime end,
    required ActionCategory category,
  }) async {
    // TODO: fetch from data-source
    return const Success([]);
  }

  @override
  Future<Result<PlayerMovementAnalytics>> getPlayerMovementAnalytics({
    required String playerId,
    required String matchId,
  }) async {
    try {
      final response = await SupabaseConfig.rpc(
        'get_player_movement_analytics',
        {
          'p_player_id': playerId,
          'p_match_id': matchId,
        },
      ) as Map<String, dynamic>;

      final analytics = PlayerMovementAnalytics.fromJson(response);
      return Success(analytics);
    } catch (e) {
      return Failure(NetworkFailure(e.toString()));
    }
  }
}
