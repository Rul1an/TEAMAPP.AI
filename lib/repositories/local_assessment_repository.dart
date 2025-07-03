import '../core/result.dart';
import '../models/assessment.dart';
import '../services/database_service.dart';
import 'assessment_repository.dart';

class LocalAssessmentRepository implements AssessmentRepository {
  LocalAssessmentRepository({DatabaseService? service})
      : _service = service ?? DatabaseService();

  final DatabaseService _service;

  @override
  Future<Result<List<PlayerAssessment>>> getAll() async {
    try {
      final assessments = await _service.getAllAssessments();
      return Success(assessments);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<PlayerAssessment>>> getByPlayer(String playerId) async {
    try {
      final assessments = await _service.getPlayerAssessments(playerId);
      return Success(assessments);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> save(PlayerAssessment assessment) async {
    try {
      if (assessment.id.isEmpty) {
        await _service.addAssessment(assessment);
      } else {
        await _service.updateAssessment(assessment);
      }
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }
}
