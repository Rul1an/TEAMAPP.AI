// Project imports:
import '../models/annual_planning/season_plan.dart';
import 'base_hive_cache.dart';

class HiveSeasonCache {
  HiveSeasonCache()
    : _cache = BaseHiveCache<List<SeasonPlan>>(
        boxName: _box,
        valueKey: _key,
        fromJson: _fromJson,
        toJson: _toJson,
      );

  static const _box = 'season_plans_box';
  static const _key = 'season_plans_json';

  final BaseHiveCache<List<SeasonPlan>> _cache;

  Future<List<SeasonPlan>?> read({Duration? ttl}) => _cache.read(ttl: ttl);
  Future<void> write(List<SeasonPlan> list) => _cache.write(list);
  Future<void> clear() => _cache.clear();

  static List<SeasonPlan> _fromJson(Map<String, dynamic> map) {
    final raw = (map['seasons'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    return raw.map(SeasonPlan.fromJson).toList();
  }

  static Map<String, dynamic> _toJson(List<SeasonPlan> list) => {
    'seasons': list.map((e) => e.toJson()).toList(),
  };
}
