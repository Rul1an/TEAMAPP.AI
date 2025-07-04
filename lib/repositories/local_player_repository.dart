import '../core/result.dart';
import '../hive/local_store.dart';
import '../models/player.dart';
import 'player_repository.dart';

/// A simple repository that proxies calls to [LocalStore].
/// This keeps legacy in-memory data source working while aligning to the
/// new repository abstraction.
class LocalPlayerRepository implements PlayerRepository {
  LocalPlayerRepository({LocalStore<List<Player>>? store})
      : _store = store ?? _defaultStore();

  final LocalStore<List<Player>> _store;

  static LocalStore<List<Player>> _defaultStore() => LocalStore<List<Player>>(
        boxName: 'player_box',
        valueKey: 'players_json',
        fromJson: (map) => (map['players'] as List<dynamic>? ?? [])
            .cast<Map<String, dynamic>>()
            .map(_fromPlayerJson)
            .toList(),
        toJson: (list) => {
          'players': list.map(_toPlayerJson).toList(),
        },
      );

  // Player <-> JSON ------------------------------------------------------
  static Map<String, dynamic> _toPlayerJson(Player p) => {
        'id': p.id,
        'firstName': p.firstName,
        'lastName': p.lastName,
        'jerseyNumber': p.jerseyNumber,
        'birthDate': p.birthDate.toIso8601String(),
        'position': p.position.name,
        'preferredFoot': p.preferredFoot.name,
        'height': p.height,
        'weight': p.weight,
        'phoneNumber': p.phoneNumber,
        'email': p.email,
        'parentContact': p.parentContact,
        'matchesPlayed': p.matchesPlayed,
        'matchesInSelection': p.matchesInSelection,
        'minutesPlayed': p.minutesPlayed,
        'goals': p.goals,
        'assists': p.assists,
        'yellowCards': p.yellowCards,
        'redCards': p.redCards,
        'trainingsAttended': p.trainingsAttended,
        'trainingsTotal': p.trainingsTotal,
        'createdAt': p.createdAt.toIso8601String(),
        'updatedAt': p.updatedAt.toIso8601String(),
      };

  static Player _fromPlayerJson(Map<String, dynamic> map) {
    final p = Player()
      ..id = map['id'] as String? ?? ''
      ..firstName = map['firstName'] as String? ?? ''
      ..lastName = map['lastName'] as String? ?? ''
      ..jerseyNumber = map['jerseyNumber'] as int? ?? 0
      ..birthDate = DateTime.parse(map['birthDate'] as String)
      ..position = Position.values
          .firstWhere((e) => e.name == (map['position'] as String))
      ..preferredFoot = PreferredFoot.values
          .firstWhere((e) => e.name == (map['preferredFoot'] as String))
      ..height = (map['height'] as num?)?.toDouble() ?? 0
      ..weight = (map['weight'] as num?)?.toDouble() ?? 0
      ..phoneNumber = map['phoneNumber'] as String?
      ..email = map['email'] as String?
      ..parentContact = map['parentContact'] as String?
      ..matchesPlayed = map['matchesPlayed'] as int? ?? 0
      ..matchesInSelection = map['matchesInSelection'] as int? ?? 0
      ..minutesPlayed = map['minutesPlayed'] as int? ?? 0
      ..goals = map['goals'] as int? ?? 0
      ..assists = map['assists'] as int? ?? 0
      ..yellowCards = map['yellowCards'] as int? ?? 0
      ..redCards = map['redCards'] as int? ?? 0
      ..trainingsAttended = map['trainingsAttended'] as int? ?? 0
      ..trainingsTotal = map['trainingsTotal'] as int? ?? 0
      ..createdAt = DateTime.parse(map['createdAt'] as String)
      ..updatedAt = DateTime.parse(map['updatedAt'] as String);
    return p;
  }

  @override
  Future<Result<void>> add(Player player) async {
    try {
      final list = await _store.read() ?? [];
      list.add(player);
      await _store.write(list);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      final list = await _store.read() ?? [];
      list.removeWhere((p) => p.id == id);
      await _store.write(list);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Player>>> getAll() async {
    try {
      final players = await _store.read() ?? [];
      return Success(players);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<Player?>> getById(String id) async {
    try {
      final list = await _store.read() ?? [];
      Player? player;
      for (final p in list) {
        if (p.id == id) {
          player = p;
          break;
        }
      }
      return Success(player);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Player>>> getByPosition(Position position) async {
    try {
      final list = await _store.read() ?? [];
      final players = list.where((p) => p.position == position).toList();
      return Success(players);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> update(Player player) async {
    try {
      final list = await _store.read() ?? [];
      final idx = list.indexWhere((p) => p.id == player.id);
      if (idx == -1) {
        list.add(player);
      } else {
        list[idx] = player;
      }
      await _store.write(list);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }
}
