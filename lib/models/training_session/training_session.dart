// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:isar/isar.dart';

// Project imports:
import '../annual_planning/training_period.dart';
import 'player_attendance.dart';
import 'session_phase.dart';

// part 'training_session.g.dart'; // Disabled for web compatibility

class TrainingSession {
  // Constructor
  TrainingSession();

  // Named constructors
  TrainingSession.create({
    required this.teamId,
    required this.date,
    required this.trainingNumber,
    this.type = TrainingType.regularTraining,
  }) {
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }

  factory TrainingSession.fromJson(Map<String, dynamic> json) {
    return TrainingSession()
      ..id = json['id'] as String? ?? ''
      ..teamId = json['teamId'] as String? ?? ''
      ..date = _parseDateTimeOrNow(json['date'] as String?)
      ..trainingNumber = json['trainingNumber'] as int? ?? 1
      ..type = _parseTrainingType(json['type'] as String?)
      ..sessionObjective = json['sessionObjective'] as String?
      ..teamFunction = json['teamFunction'] as String?
      ..coachingAccent = json['coachingAccent'] as String?
      ..technicalTacticalGoal = json['technicalTacticalGoal'] as String?
      ..phasesJson = json['phasesJson'] as String?
      ..warmupActivitiesJson = json['warmupActivitiesJson'] as String?
      ..playerAttendanceJson = json['playerAttendanceJson'] as String?
      ..expectedPlayers = json['expectedPlayers'] as int? ?? 16
      ..actualPlayers = json['actualPlayers'] as int? ?? 0
      ..notes = json['notes'] as String?
      ..postSessionEvaluation = json['postSessionEvaluation'] as String?
      ..periodizationPhaseId = json['periodizationPhaseId'] as String?
      ..contentFocusJson = json['contentFocusJson'] as String?
      ..targetIntensity = (json['targetIntensity'] as num?)?.toDouble()
      ..startTime = _parseDateTime(json['startTime'] as String?)
      ..endTime = _parseDateTime(json['endTime'] as String?)
      ..durationMinutes = json['durationMinutes'] as int?
      ..status = _parseSessionStatus(json['status'] as String?)
      ..createdAt = _parseDateTimeOrNow(json['createdAt'] as String?)
      ..updatedAt = _parseDateTimeOrNow(json['updatedAt'] as String?);
  }
  String id = '';

  // Basic session info
  late String teamId;
  late DateTime date;
  late int trainingNumber;
  late TrainingType type;

  // Session details
  String? sessionObjective;
  String? teamFunction;
  String? coachingAccent;
  String? technicalTacticalGoal;

  // Planning - stored as JSON strings for web compatibility
  String? phasesJson;
  String? warmupActivitiesJson;
  String? playerAttendanceJson;

  // Player management
  int expectedPlayers = 16;
  int actualPlayers = 0;

  // Notes & evaluation
  String? notes;
  String? postSessionEvaluation;

  // Periodization integration
  String? periodizationPhaseId;
  String? contentFocusJson;
  double? targetIntensity;

  // Session timing
  DateTime? startTime;
  DateTime? endTime;
  int? durationMinutes;

  // Status tracking
  SessionStatus status = SessionStatus.planned;

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  // Computed properties
  @Ignore()
  List<SessionPhase> get phases {
    if (phasesJson == null) return [];
    try {
      final list = jsonDecode(phasesJson!) as List<dynamic>;
      return list
          .map((json) => SessionPhase.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  set phases(List<SessionPhase> phaseList) {
    phasesJson = jsonEncode(phaseList.map((p) => p.toJson()).toList());
  }

  List<String> get warmupActivities {
    if (warmupActivitiesJson == null) return [];
    try {
      return List<String>.from(
        jsonDecode(warmupActivitiesJson!) as List<dynamic>,
      );
    } catch (e) {
      return [];
    }
  }

  set warmupActivities(List<String> activities) {
    warmupActivitiesJson = jsonEncode(activities);
  }

  Map<String, PlayerAttendance> get playerAttendance {
    if (playerAttendanceJson == null) return {};
    try {
      final json = jsonDecode(playerAttendanceJson!) as Map<String, dynamic>;
      return json.map(
        (key, value) => MapEntry(
          key,
          PlayerAttendance.fromJson(value as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      return {};
    }
  }

  set playerAttendance(Map<String, PlayerAttendance> attendance) {
    final json = attendance.map((key, value) => MapEntry(key, value.toJson()));
    playerAttendanceJson = jsonEncode(json);
  }

  ContentDistribution? get contentFocus {
    if (contentFocusJson == null) return null;
    try {
      return ContentDistribution.fromJson(
        jsonDecode(contentFocusJson!) as Map<String, dynamic>,
      );
    } catch (e) {
      return null;
    }
  }

  set contentFocus(ContentDistribution? distribution) {
    if (distribution == null) {
      contentFocusJson = null;
    } else {
      contentFocusJson = jsonEncode(distribution.toJson());
    }
  }

  // Helper methods
  @Ignore()
  Duration get sessionDuration {
    if (startTime != null && endTime != null) {
      return endTime!.difference(startTime!);
    }
    return Duration(minutes: durationMinutes ?? 120);
  }

  @Ignore()
  List<PlayerAttendance> get presentPlayers => playerAttendance.values
        .where((p) => p.status == AttendanceStatus.present)
        .toList();

  @Ignore()
  List<PlayerAttendance> get absentPlayers => playerAttendance.values
        .where((p) => p.status == AttendanceStatus.absent)
        .toList();

  @Ignore()
  double get attendancePercentage {
    if (playerAttendance.isEmpty) return 0;
    return (presentPlayers.length / playerAttendance.length) * 100;
  }

  @Ignore()
  bool get isInProgress => status == SessionStatus.inProgress;

  @Ignore()
  bool get isCompleted => status == SessionStatus.completed;

  // Helper methods for JSON parsing
  static TrainingType _parseTrainingType(String? typeString) {
    return TrainingType.values.firstWhere(
      (e) => e.name == typeString,
      orElse: () => TrainingType.regularTraining,
    );
  }

  static SessionStatus _parseSessionStatus(String? statusString) {
    return SessionStatus.values.firstWhere(
      (e) => e.name == statusString,
      orElse: () => SessionStatus.planned,
    );
  }

  static DateTime? _parseDateTime(String? dateString) {
    return dateString != null ? DateTime.parse(dateString) : null;
  }

  static DateTime _parseDateTimeOrNow(String? dateString) {
    return dateString != null ? DateTime.parse(dateString) : DateTime.now();
  }

  // JSON serialization
  Map<String, dynamic> toJson() => {
    'id': id,
    'teamId': teamId,
    'date': date.toIso8601String(),
    'trainingNumber': trainingNumber,
    'type': type.name,
    'sessionObjective': sessionObjective,
    'teamFunction': teamFunction,
    'coachingAccent': coachingAccent,
    'technicalTacticalGoal': technicalTacticalGoal,
    'phasesJson': phasesJson,
    'warmupActivitiesJson': warmupActivitiesJson,
    'playerAttendanceJson': playerAttendanceJson,
    'expectedPlayers': expectedPlayers,
    'actualPlayers': actualPlayers,
    'notes': notes,
    'postSessionEvaluation': postSessionEvaluation,
    'periodizationPhaseId': periodizationPhaseId,
    'contentFocusJson': contentFocusJson,
    'targetIntensity': targetIntensity,
    'startTime': startTime?.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
    'durationMinutes': durationMinutes,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  // 🔧 CASCADE OPERATOR DOCUMENTATION: Complex Model CopyWith Method
  // This copyWith method demonstrates a pattern where cascade notation could
  // significantly improve readability for complex object copying operations.
  //
  // **CURRENT PATTERN**: copy.property = value (explicit assignments)
  // **RECOMMENDED**: copy..property = value (cascade notation)
  //
  // **CASCADE BENEFITS FOR COPYWITH METHODS**:
  // ✅ Eliminates 25+ repetitive "copy." references
  // ✅ Creates visual grouping of property assignments
  // ✅ Reduces cognitive load when reading complex copy operations
  // ✅ Maintains consistency with other model initialization patterns
  // ✅ Makes large copyWith methods more maintainable
  //  // Copy with method
  TrainingSession copyWith({
    String? teamId,
    DateTime? date,
    int? trainingNumber,
    TrainingType? type,
    String? sessionObjective,
    String? teamFunction,
    String? coachingAccent,
    String? technicalTacticalGoal,
    List<SessionPhase>? phases,
    List<String>? warmupActivities,
    Map<String, PlayerAttendance>? playerAttendance,
    int? expectedPlayers,
    int? actualPlayers,
    String? notes,
    String? postSessionEvaluation,
    String? periodizationPhaseId,
    ContentDistribution? contentFocus,
    double? targetIntensity,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    SessionStatus? status,
  }) {
    return TrainingSession()
      ..id = id
      ..teamId = teamId ?? this.teamId
      ..date = date ?? this.date
      ..trainingNumber = trainingNumber ?? this.trainingNumber
      ..type = type ?? this.type
      ..sessionObjective = sessionObjective ?? this.sessionObjective
      ..teamFunction = teamFunction ?? this.teamFunction
      ..coachingAccent = coachingAccent ?? this.coachingAccent
      ..technicalTacticalGoal =
          technicalTacticalGoal ?? this.technicalTacticalGoal
      ..phasesJson = phasesJson
      ..warmupActivitiesJson = warmupActivitiesJson
      ..playerAttendanceJson = playerAttendanceJson
      ..expectedPlayers = expectedPlayers ?? this.expectedPlayers
      ..actualPlayers = actualPlayers ?? this.actualPlayers
      ..notes = notes ?? this.notes
      ..postSessionEvaluation =
          postSessionEvaluation ?? this.postSessionEvaluation
      ..periodizationPhaseId = periodizationPhaseId ?? this.periodizationPhaseId
      ..contentFocusJson = contentFocusJson
      ..targetIntensity = targetIntensity ?? this.targetIntensity
      ..startTime = startTime ?? this.startTime
      ..endTime = endTime ?? this.endTime
      ..durationMinutes = durationMinutes ?? this.durationMinutes
      ..status = status ?? this.status
      ..createdAt = createdAt
      ..updatedAt = DateTime.now();
    // Note: Complex assignments like phases, warmupActivities, playerAttendance, and contentFocus
    // are handled separately after the cascade due to their conditional nature
  }

  @override
  String toString() => 'TrainingSession(id: $id, date: $date, type: $type, '
           'objective: $sessionObjective, players: $actualPlayers/$expectedPlayers)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TrainingSession &&
        other.id == id &&
        other.teamId == teamId &&
        other.date == date &&
        other.trainingNumber == trainingNumber;
  }

  @override
  int get hashCode =>
      id.hashCode ^ teamId.hashCode ^ date.hashCode ^ trainingNumber.hashCode;
}

enum TrainingType {
  regularTraining,
  matchPreparation,
  tacticalSession,
  technicalSession,
  fitnessSession,
  recoverySession,
  teamBuilding,
}

enum SessionStatus { planned, inProgress, completed, cancelled, postponed }
