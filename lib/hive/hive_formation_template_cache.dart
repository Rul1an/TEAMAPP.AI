// Project imports:
import '../models/formation_template.dart';
import '../models/team.dart' show Formation;
import 'base_hive_cache.dart';

class HiveFormationTemplateCache {
  HiveFormationTemplateCache()
      : _cache = BaseHiveCache<List<FormationTemplate>>(
          boxName: _box,
          valueKey: _key,
          fromJson: _fromJson,
          toJson: _toJson,
        );

  static const _box = 'formation_templates_box';
  static const _key = 'formation_templates_json';

  final BaseHiveCache<List<FormationTemplate>> _cache;

  Future<List<FormationTemplate>?> read({Duration? ttl}) =>
      _cache.read(ttl: ttl);
  Future<void> write(List<FormationTemplate> list) => _cache.write(list);
  Future<void> clear() => _cache.clear();

  static List<FormationTemplate> _fromJson(Map<String, dynamic> map) {
    final raw =
        (map['templates'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    return raw.map(_templateFromMap).toList();
  }

  static Map<String, dynamic> _toJson(List<FormationTemplate> list) => {
        'templates': list.map(_templateToMap).toList(),
      };

  // Helper serialization
  static Map<String, dynamic> _templateToMap(FormationTemplate t) => {
        'id': t.id,
        'name': t.name,
        'description': t.description,
        'formation': t.formation.name,
        'positionPreferences': t.positionPreferences,
        'isDefault': t.isDefault,
        'isCustom': t.isCustom,
        'createdBy': t.createdBy,
        'createdAt': t.createdAt.toIso8601String(),
        'updatedAt': t.updatedAt.toIso8601String(),
      };

  static FormationTemplate _templateFromMap(Map<String, dynamic> json) {
    return FormationTemplate()
      ..id = json['id'] as String? ?? ''
      ..name = json['name'] as String? ?? ''
      ..description = json['description'] as String? ?? ''
      ..formation = Formation.values.firstWhere(
        (f) => f.name == json['formation'],
        orElse: () => Formation.fourThreeThree,
      )
      ..positionPreferences =
          (json['positionPreferences'] as Map?)?.cast<String, String>() ?? {}
      ..isDefault = json['isDefault'] as bool? ?? false
      ..isCustom = json['isCustom'] as bool? ?? true
      ..createdBy = json['createdBy'] as String? ?? ''
      ..createdAt = json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now()
      ..updatedAt = json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now();
  }
}
