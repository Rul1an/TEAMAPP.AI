// ignore_for_file: one_member_abstracts

// Project imports:
import '../core/result.dart';

/// Repository interface for aggregated club statistics shown on the dashboard.
abstract interface class StatisticsRepository {
  Future<Result<Map<String, dynamic>>> getStatistics();
}
