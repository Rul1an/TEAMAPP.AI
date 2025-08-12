// Project imports:
import '../models/player.dart';
import 'base_hive_cache.dart';

/// Offline cache for list of [Player] objects using encrypted Hive storage.
///
/// Delegates persistence mechanics to [BaseHiveCache] while providing
/// (de)serialization for the `Player` domain model.
class HivePlayerCache {
  HivePlayerCache()
      : _cache = BaseHiveCache<List<Player>>(
          boxName: _boxName,
          valueKey: _valueKey,
          fromJson: _listFromJson,
          toJson: _listToJson,
        );

  // Box/value identifiers --------------------------------------------------
  static const _boxName = 'players_box';
  static const _valueKey = 'players_json';

  final BaseHiveCache<List<Player>> _cache;

  /// Retrieves players from cache when not stale.
  Future<List<Player>?> read({Duration? ttl}) => _cache.read(ttl: ttl);

  /// Saves [players] to cache, refreshing the timestamp.
  Future<void> write(List<Player> players) => _cache.write(players);

  /// Clears cached players.
  Future<void> clear() => _cache.clear();

  // region JSON helpers -----------------------------------------------------

  static List<Player> _listFromJson(Map<String, dynamic> map) {
    final list = (map['players'] as List<dynamic>? ?? <dynamic>[])
        .cast<Map<String, dynamic>>();
    return list.map(_playerFromJson).toList();
  }

  static Map<String, dynamic> _listToJson(List<Player> players) => {
        'players': players.map(_playerToJson).toList(),
      };

  static Player _playerFromJson(Map<String, dynamic> json) {
    return Player.fromJson({
      'id': json['id'] as String? ?? '',
      'firstName': json['first_name'] as String? ?? '',
      'lastName': json['last_name'] as String? ?? '',
      'jerseyNumber': json['jersey_number'] ?? 0,
      'birthDate':
          json['birth_date'] as String? ?? DateTime.now().toIso8601String(),
      'position': (json['position'] as String?)?.toLowerCase() ?? 'midfielder',
      'preferredFoot':
          (json['preferred_foot'] as String?)?.toLowerCase() ?? 'right',
      'height': (json['height_cm'] as num?)?.toDouble() ?? 0.0,
      'weight': (json['weight_kg'] as num?)?.toDouble() ?? 0.0,
      'phoneNumber': json['phone'] as String?,
      'email': json['email'] as String?,
      'parentContact': json['parent_contact'] as String?,
      'matchesPlayed': json['matches_played'] as int? ?? 0,
      'matchesInSelection': json['matches_in_selection'] as int? ?? 0,
      'minutesPlayed': json['minutes_played'] as int? ?? 0,
      'goals': json['goals'] as int? ?? 0,
      'assists': json['assists'] as int? ?? 0,
      'yellowCards': json['yellow_cards'] as int? ?? 0,
      'redCards': json['red_cards'] as int? ?? 0,
      'trainingsAttended': json['trainings_attended'] as int? ?? 0,
      'trainingsTotal': json['trainings_total'] as int? ?? 0,
      'createdAt':
          json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      'updatedAt':
          json['updated_at'] as String? ?? DateTime.now().toIso8601String(),
    });
  }

  static Map<String, dynamic> _playerToJson(Player p) => <String, dynamic>{
        'id': p.id,
        'first_name': p.firstName,
        'last_name': p.lastName,
        'jersey_number': p.jerseyNumber,
        'birth_date': p.birthDate.toIso8601String(),
        'position': p.position.name,
        'preferred_foot': p.preferredFoot.name,
        'height_cm': p.height,
        'weight_kg': p.weight,
        'phone': p.phoneNumber,
        'email': p.email,
        'parent_contact': p.parentContact,
        'matches_played': p.matchesPlayed,
        'matches_in_selection': p.matchesInSelection,
        'minutes_played': p.minutesPlayed,
        'goals': p.goals,
        'assists': p.assists,
        'yellow_cards': p.yellowCards,
        'red_cards': p.redCards,
        'trainings_attended': p.trainingsAttended,
        'trainings_total': p.trainingsTotal,
        'created_at': p.createdAt.toIso8601String(),
        'updated_at': p.updatedAt.toIso8601String(),
      }..removeWhere((_, v) => v == null);

  // Note: legacy helpers removed; now using Player.fromJson for safer parsing

  // endregion ---------------------------------------------------------------
}
