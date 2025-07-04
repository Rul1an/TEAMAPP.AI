// Project imports:
import '../core/result.dart';
import '../models/assessment.dart';

abstract interface class AssessmentRepository {
  Future<Result<List<PlayerAssessment>>> getAll();
  Future<Result<List<PlayerAssessment>>> getByPlayer(String playerId);
  Future<Result<void>> save(PlayerAssessment assessment);
}
