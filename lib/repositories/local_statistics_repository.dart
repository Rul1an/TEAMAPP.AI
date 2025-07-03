import '../core/result.dart';
import '../services/database_service.dart';
import 'statistics_repository.dart';

class LocalStatisticsRepository implements StatisticsRepository {
  LocalStatisticsRepository({DatabaseService? service})
      : _service = service ?? DatabaseService();

  final DatabaseService _service;

  @override
  Future<Result<Map<String, dynamic>>> getStatistics() async {
    try {
      final stats = await _service.getStatistics();
      return Success(stats);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }
}
