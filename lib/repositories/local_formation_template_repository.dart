// Project imports:
import '../core/result.dart';
import '../hive/hive_formation_template_cache.dart';
import '../models/formation_template.dart';
import 'formation_template_repository.dart';

class LocalFormationTemplateRepository implements FormationTemplateRepository {
  LocalFormationTemplateRepository({HiveFormationTemplateCache? cache})
    : _cache = cache ?? HiveFormationTemplateCache();

  final HiveFormationTemplateCache _cache;

  @override
  Future<Result<List<FormationTemplate>>> getAll() async {
    try {
      final templates = await _cache.read() ?? [];
      return Success(templates);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> add(FormationTemplate template) async {
    try {
      final list = await _cache.read() ?? [];
      list.add(template);
      await _cache.write(list);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      final list = await _cache.read() ?? [];
      list.removeWhere((t) => t.id == id);
      await _cache.write(list);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }
}
