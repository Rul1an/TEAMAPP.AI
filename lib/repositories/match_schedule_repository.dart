// Project imports:
import '../core/result.dart';
import '../models/match_schedule.dart';

/// Contract for retrieving and mutating [`MatchSchedule`] entities.
/// Mirrors the API of [`MatchRepository`] to keep the data layer
/// consistent across domain types.
abstract interface class MatchScheduleRepository {
  Future<Result<List<MatchSchedule>>> getAll();
  Future<Result<List<MatchSchedule>>> getUpcoming();
  Future<Result<List<MatchSchedule>>> getRecent();
  Future<Result<MatchSchedule?>> getById(String id);
  Future<Result<void>> add(MatchSchedule schedule);
  Future<Result<void>> update(MatchSchedule schedule);
  Future<Result<void>> delete(String id);
}