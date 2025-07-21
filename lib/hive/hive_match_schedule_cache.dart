// Project imports:
import '../models/match_schedule.dart';
import '../models/match.dart';
import 'base_hive_cache.dart';

/// Offline cache for list of [MatchSchedule] objects.
class HiveMatchScheduleCache {
  HiveMatchScheduleCache()
      : _cache = BaseHiveCache<List<MatchSchedule>>(
          boxName: _boxName,
          valueKey: _valueKey,
          fromJson: _listFromJson,
          toJson: _listToJson,
        );

  static const _boxName = 'match_schedules_box';
  static const _valueKey = 'match_schedules_json';

  final BaseHiveCache<List<MatchSchedule>> _cache;

  Future<List<MatchSchedule>?> read({Duration? ttl}) => _cache.read(ttl: ttl);
  Future<void> write(List<MatchSchedule> schedules) => _cache.write(schedules);
  Future<void> clear() => _cache.clear();

  // helpers
  static List<MatchSchedule> _listFromJson(Map<String, dynamic> map) {
    final list = (map['schedules'] as List<dynamic>? ?? <dynamic>[])
        .cast<Map<String, dynamic>>();
    return list.map(_scheduleFromJson).toList();
  }

  static Map<String, dynamic> _listToJson(List<MatchSchedule> schedules) => {
        'schedules': schedules.map(_scheduleToJson).toList(),
      };

  static MatchSchedule _scheduleFromJson(Map<String, dynamic> json) {
    return MatchSchedule()
      ..id = json['id'] as String? ?? ''
      ..dateTime = DateTime.tryParse(json['date_time'] as String? ?? '') ??
          DateTime.now()
      ..opponent = json['opponent'] as String? ?? ''
      ..location = _locationFrom(json['location'] as String?)
      ..competition = _competitionFrom(json['competition'] as String?)
      ..createdAt = DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now()
      ..updatedAt = DateTime.tryParse(json['updated_at'] as String? ?? '') ??
          DateTime.now();
  }

  static Map<String, dynamic> _scheduleToJson(MatchSchedule s) =>
      <String, dynamic>{
        'id': s.id,
        'date_time': s.dateTime.toIso8601String(),
        'opponent': s.opponent,
        'location': s.location.name,
        'competition': s.competition.name,
        'created_at': s.createdAt.toIso8601String(),
        'updated_at': s.updatedAt.toIso8601String(),
      }..removeWhere((_, v) => v == null);

  static Location _locationFrom(String? s) => Location.values.firstWhere(
        (e) => e.name == (s ?? '').toLowerCase(),
        orElse: () => Location.home,
      );

  static Competition _competitionFrom(String? s) =>
      Competition.values.firstWhere(
        (e) => e.name == (s ?? '').toLowerCase(),
        orElse: () => Competition.league,
      );
}
