// ignore_for_file: flutter_style_todos
import '../core/result.dart';
import '../models/action_event.dart';
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
}
