// Project imports:
import '../models/annual_planning/periodization_plan.dart';
import 'base_hive_cache.dart';

class HivePeriodizationCache {
  HivePeriodizationCache()
    : _cache = BaseHiveCache<List<PeriodizationPlan>>(
        boxName: _box,
        valueKey: _key,
        fromJson: _fromJson,
        toJson: _toJson,
      );

  static const _box = 'periodization_plans_box';
  static const _key = 'periodization_plans_json';

  final BaseHiveCache<List<PeriodizationPlan>> _cache;

  Future<List<PeriodizationPlan>?> read({Duration? ttl}) =>
      _cache.read(ttl: ttl);
  Future<void> write(List<PeriodizationPlan> list) => _cache.write(list);
  Future<void> clear() => _cache.clear();

  static List<PeriodizationPlan> _fromJson(Map<String, dynamic> map) {
    final raw = (map['plans'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    return raw.map(_fromMap).toList();
  }

  static Map<String, dynamic> _toJson(List<PeriodizationPlan> list) => {
    'plans': list.map(_toMap).toList(),
  };

  // Simplified serialization (core fields only)
  static Map<String, dynamic> _toMap(PeriodizationPlan p) => {
    'id': p.id,
    'name': p.name,
    'description': p.description,
    'modelType': p.modelType.name,
    'targetAgeGroup': p.targetAgeGroup.name,
    'totalDurationWeeks': p.totalDurationWeeks,
    'numberOfPeriods': p.numberOfPeriods,
    'isTemplate': p.isTemplate,
    'isDefault': p.isDefault,
    'createdBy': p.createdBy,
    'createdAt': p.createdAt.toIso8601String(),
    'updatedAt': p.updatedAt.toIso8601String(),
  };

  static PeriodizationPlan _fromMap(Map<String, dynamic> json) {
    final plan = PeriodizationPlan();
    plan.id = json['id'] as String? ?? '';
    plan.name = json['name'] as String? ?? '';
    plan.description = json['description'] as String? ?? '';
    plan.modelType = PeriodizationModel.values.firstWhere(
      (e) => e.name == json['modelType'],
      orElse: () => PeriodizationModel.custom,
    );
    plan.targetAgeGroup = AgeGroup.values.firstWhere(
      (e) => e.name == json['targetAgeGroup'],
      orElse: () => AgeGroup.u17,
    );
    plan.totalDurationWeeks = json['totalDurationWeeks'] as int? ?? 36;
    plan.numberOfPeriods = json['numberOfPeriods'] as int? ?? 4;
    plan.isTemplate = json['isTemplate'] as bool? ?? false;
    plan.isDefault = json['isDefault'] as bool? ?? false;
    plan.createdBy = json['createdBy'] as String?;
    plan.createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt'] as String)
        : DateTime.now();
    plan.updatedAt = json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'] as String)
        : DateTime.now();
    return plan;
  }
}
