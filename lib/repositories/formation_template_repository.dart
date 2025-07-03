import '../core/result.dart';
import '../models/formation_template.dart';

abstract interface class FormationTemplateRepository {
  Future<Result<List<FormationTemplate>>> getAll();
  Future<Result<void>> add(FormationTemplate template);
  Future<Result<void>> delete(String id);
}
