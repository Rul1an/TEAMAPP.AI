import '../core/result.dart';
import '../models/action_event.dart';

abstract interface class AnalyticsRepository {
  Future<Result<List<ActionEvent>>> getHeatMapData({
    required DateTime start,
    required DateTime end,
    required ActionCategory category,
  });
}

enum ActionCategory { overall, offensive, defensive }
