import '../models/match.dart';
import 'base_hive_cache.dart';

/// Offline cache for list of [Match] objects.
class HiveMatchCache {
  HiveMatchCache()
      : _cache = BaseHiveCache<List<Match>>(
          boxName: _boxName,
          valueKey: _valueKey,
          fromJson: _listFromJson,
          toJson: _listToJson,
        );

  static const _boxName = 'matches_box';
  static const _valueKey = 'matches_json';

  final BaseHiveCache<List<Match>> _cache;

  Future<List<Match>?> read({Duration? ttl}) => _cache.read(ttl: ttl);
  Future<void> write(List<Match> matches) => _cache.write(matches);
  Future<void> clear() => _cache.clear();

  // helpers
  static List<Match> _listFromJson(Map<String, dynamic> map) {
    final list = (map['matches'] as List<dynamic>? ?? <dynamic>[])
        .cast<Map<String, dynamic>>();
    return list.map(_matchFromJson).toList();
  }

  static Map<String, dynamic> _listToJson(List<Match> matches) => {
        'matches': matches.map(_matchToJson).toList(),
      };

  static Match _matchFromJson(Map<String, dynamic> json) {
    final m = Match()
      ..id = json['id'] as String? ?? ''
      ..date =
          DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now()
      ..opponent = json['opponent'] as String? ?? ''
      ..location = _locationFrom(json['location'] as String?)
      ..competition = _competitionFrom(json['competition'] as String?)
      ..status = _statusFrom(json['status'] as String?)
      ..teamScore = json['team_score'] as int?
      ..opponentScore = json['opponent_score'] as int?
      ..createdAt = DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now()
      ..updatedAt = DateTime.tryParse(json['updated_at'] as String? ?? '') ??
          DateTime.now();
    return m;
  }

  static Map<String, dynamic> _matchToJson(Match m) => <String, dynamic>{
        'id': m.id,
        'date': m.date.toIso8601String(),
        'opponent': m.opponent,
        'location': m.location.name,
        'competition': m.competition.name,
        'status': m.status.name,
        'team_score': m.teamScore,
        'opponent_score': m.opponentScore,
        'created_at': m.createdAt.toIso8601String(),
        'updated_at': m.updatedAt.toIso8601String(),
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

  static MatchStatus _statusFrom(String? s) => MatchStatus.values.firstWhere(
        (e) => e.name == (s ?? '').toLowerCase(),
        orElse: () => MatchStatus.scheduled,
      );
}
