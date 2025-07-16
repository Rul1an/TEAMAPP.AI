import '../core/result.dart';
import '../models/action_event.dart';
import '../models/player_movement_analytics.dart';

abstract interface class AnalyticsRepository {
  Future<Result<List<ActionEvent>>> getHeatMapData({
    required DateTime start,
    required DateTime end,
    required ActionCategory category,
  });

  /// Returns movement analytics (heat-map & distance) for a specific player
  /// within a match. Used by AnalysisDashboard in Sprint 10.
  Future<Result<PlayerMovementAnalytics>> getPlayerMovementAnalytics({
    required String playerId,
    required String matchId,
  });
}

enum ActionCategory { overall, offensive, defensive }
