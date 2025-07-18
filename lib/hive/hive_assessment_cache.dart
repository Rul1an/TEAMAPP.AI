// Project imports:
import '../models/assessment.dart';
import 'base_hive_cache.dart';

class HiveAssessmentCache {
  HiveAssessmentCache()
      : _cache = BaseHiveCache<List<PlayerAssessment>>(
          boxName: _box,
          valueKey: _key,
          fromJson: _fromJson,
          toJson: _toJson,
        );

  static const _box = 'player_assessments_box';
  static const _key = 'player_assessments_json';

  final BaseHiveCache<List<PlayerAssessment>> _cache;

  Future<List<PlayerAssessment>?> read({Duration? ttl}) =>
      _cache.read(ttl: ttl);
  Future<void> write(List<PlayerAssessment> list) => _cache.write(list);
  Future<void> clear() => _cache.clear();

  static List<PlayerAssessment> _fromJson(Map<String, dynamic> map) {
    final raw = (map['assessments'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    return raw.map(_fromMap).toList();
  }

  static Map<String, dynamic> _toJson(List<PlayerAssessment> list) => {
        'assessments': list.map(_toMap).toList(),
      };

  // Serialize
  static Map<String, dynamic> _toMap(PlayerAssessment a) => {
        'id': a.id,
        'playerId': a.playerId,
        'assessmentDate': a.assessmentDate.toIso8601String(),
        'type': a.type.name,
        // technical
        'ballControl': a.ballControl,
        'passing': a.passing,
        'shooting': a.shooting,
        'dribbling': a.dribbling,
        'defending': a.defending,
        // tactical
        'positioning': a.positioning,
        'gameReading': a.gameReading,
        'decisionMaking': a.decisionMaking,
        'communication': a.communication,
        'teamwork': a.teamwork,
        // physical
        'speed': a.speed,
        'stamina': a.stamina,
        'strength': a.strength,
        'agility': a.agility,
        'coordination': a.coordination,
        // mental
        'confidence': a.confidence,
        'concentration': a.concentration,
        'leadership': a.leadership,
        'coachability': a.coachability,
        'motivation': a.motivation,
        // text fields
        'strengths': a.strengths,
        'areasForImprovement': a.areasForImprovement,
        'developmentGoals': a.developmentGoals,
        'coachNotes': a.coachNotes,
        'assessorId': a.assessorId,
        'createdAt': a.createdAt.toIso8601String(),
        'updatedAt': a.updatedAt.toIso8601String(),
      };

  // Deserialize
  static PlayerAssessment _fromMap(Map<String, dynamic> json) {
    final a = PlayerAssessment();
    a.id = json['id'] as String? ?? '';
    a.playerId = json['playerId'] as String? ?? '';
    a.assessmentDate = DateTime.parse(json['assessmentDate'] as String);
    a.type = AssessmentType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => AssessmentType.monthly,
    );
    // technical
    a.ballControl = json['ballControl'] as int? ?? 3;
    a.passing = json['passing'] as int? ?? 3;
    a.shooting = json['shooting'] as int? ?? 3;
    a.dribbling = json['dribbling'] as int? ?? 3;
    a.defending = json['defending'] as int? ?? 3;
    // tactical
    a.positioning = json['positioning'] as int? ?? 3;
    a.gameReading = json['gameReading'] as int? ?? 3;
    a.decisionMaking = json['decisionMaking'] as int? ?? 3;
    a.communication = json['communication'] as int? ?? 3;
    a.teamwork = json['teamwork'] as int? ?? 3;
    // physical
    a.speed = json['speed'] as int? ?? 3;
    a.stamina = json['stamina'] as int? ?? 3;
    a.strength = json['strength'] as int? ?? 3;
    a.agility = json['agility'] as int? ?? 3;
    a.coordination = json['coordination'] as int? ?? 3;
    // mental
    a.confidence = json['confidence'] as int? ?? 3;
    a.concentration = json['concentration'] as int? ?? 3;
    a.leadership = json['leadership'] as int? ?? 3;
    a.coachability = json['coachability'] as int? ?? 3;
    a.motivation = json['motivation'] as int? ?? 3;
    // text
    a.strengths = json['strengths'] as String?;
    a.areasForImprovement = json['areasForImprovement'] as String?;
    a.developmentGoals = json['developmentGoals'] as String?;
    a.coachNotes = json['coachNotes'] as String?;
    a.assessorId = json['assessorId'] as String? ?? '';
    a.createdAt = DateTime.parse(json['createdAt'] as String);
    a.updatedAt = DateTime.parse(json['updatedAt'] as String);
    return a;
  }
}
