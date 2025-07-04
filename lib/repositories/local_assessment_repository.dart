import '../core/result.dart';
import '../hive/hive_assessment_cache.dart';
import '../models/assessment.dart';
import 'assessment_repository.dart';

class LocalAssessmentRepository implements AssessmentRepository {
  LocalAssessmentRepository({HiveAssessmentCache? cache})
      : _cache = cache ?? HiveAssessmentCache();

  final HiveAssessmentCache _cache;

  Future<List<PlayerAssessment>> _all() async => await _cache.read() ?? [];
  Future<void> _saveAll(List<PlayerAssessment> list) => _cache.write(list);

  @override
  Future<Result<List<PlayerAssessment>>> getAll() async {
    try {
      final list = await _all();
      return Success(list);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<PlayerAssessment>>> getByPlayer(String playerId) async {
    try {
      final list = await _all();
      return Success(list.where((a) => a.playerId == playerId).toList());
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> save(PlayerAssessment assessment) async {
    try {
      final list = await _all();
      if (assessment.id.isEmpty) {
        list.add(assessment);
      } else {
        final idx = list.indexWhere((a) => a.id == assessment.id);
        if (idx == -1) {
          list.add(assessment);
        } else {
          list[idx] = assessment;
        }
      }
      await _saveAll(list);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }
}
