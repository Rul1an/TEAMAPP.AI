import '../core/result.dart';
import '../models/formation_template.dart';
import '../services/database_service.dart';
import 'formation_template_repository.dart';

class LocalFormationTemplateRepository implements FormationTemplateRepository {
  LocalFormationTemplateRepository({DatabaseService? service})
      : _service = service ?? DatabaseService();

  final DatabaseService _service;

  @override
  Future<Result<List<FormationTemplate>>> getAll() async {
    try {
      final templates = await _service.getAllFormationTemplates();
      return Success(templates);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> add(FormationTemplate template) async {
    try {
      await _service.addFormationTemplate(template);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await _service.deleteFormationTemplate(id);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }
}
