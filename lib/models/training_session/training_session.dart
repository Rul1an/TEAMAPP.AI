import 'dart:convert';

import 'package:isar/isar.dart';

import '../annual_planning/content_distribution.dart';
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
    final session = TrainingSession();
    session.id = json['id'] ?? '';
    session.teamId = json['teamId'] ?? '';
    session.date =
        json['date'] != null ? DateTime.parse(json['date'] as String) : DateTime.now();
    session.trainingNumber = json['trainingNumber'] ?? 1;
    session.type = TrainingType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => TrainingType.regularTraining,
    );
    session.sessionObjective = json['sessionObjective'];
    session.teamFunction = json['teamFunction'];
    session.coachingAccent = json['coachingAccent'];
    session.technicalTacticalGoal = json['technicalTacticalGoal'];
    session.phasesJson = json['phasesJson'];
    session.warmupActivitiesJson = json['warmupActivitiesJson'];
    session.playerAttendanceJson = json['playerAttendanceJson'];
    session.expectedPlayers = json['expectedPlayers'] ?? 16;
    session.actualPlayers = json['actualPlayers'] ?? 0;
    session.notes = json['notes'];
    session.postSessionEvaluation = json['postSessionEvaluation'];
    session.periodizationPhaseId = json['periodizationPhaseId'];
    session.contentFocusJson = json['contentFocusJson'];
    session.targetIntensity = json['targetIntensity']?.toDouble();
    session.startTime =
        json['startTime'] != null ? DateTime.parse(json['startTime'] as String) : null;
    session.endTime =
        json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null;
    session.durationMinutes = json['durationMinutes'];
    session.status = SessionStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => SessionStatus.planned,
    );
    session.createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt'] as String)
        : DateTime.now();
    session.updatedAt = json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'] as String)
        : DateTime.now();
    return session;
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
      final List<dynamic> list = jsonDecode(phasesJson!);
      return list.map((json) => SessionPhase.fromJson(json as Map<String, dynamic>)).toList();
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
      return List<String>.from(jsonDecode(warmupActivitiesJson!) as List<dynamic>);
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
      final Map<String, dynamic> json = jsonDecode(playerAttendanceJson!);
      return json.map(
        (key, value) => MapEntry(key, PlayerAttendance.fromJson(value as Map<String, dynamic>)),
      );
    } catch (e) {
      return {};
    }
  }

  set playerAttendance(Map<String, PlayerAttendance> attendance) {
    final json = attendance.map(
      (key, value) => MapEntry(key, value.toJson()),
    );
    playerAttendanceJson = jsonEncode(json);
  }

  ContentDistribution? get contentFocus {
    if (contentFocusJson == null) return null;
    try {
      return ContentDistribution.fromJson(jsonDecode(contentFocusJson!) as Map<String, dynamic>);
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

  // Copy with method
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
    final copy = TrainingSession();
    copy.id = id;
    copy.teamId = teamId ?? this.teamId;
    copy.date = date ?? this.date;
    copy.trainingNumber = trainingNumber ?? this.trainingNumber;
    copy.type = type ?? this.type;
    copy.sessionObjective = sessionObjective ?? this.sessionObjective;
    copy.teamFunction = teamFunction ?? this.teamFunction;
    copy.coachingAccent = coachingAccent ?? this.coachingAccent;
    copy.technicalTacticalGoal =
        technicalTacticalGoal ?? this.technicalTacticalGoal;
    copy.phasesJson = phasesJson;
    if (phases != null) copy.phases = phases;
    copy.warmupActivitiesJson = warmupActivitiesJson;
    if (warmupActivities != null) copy.warmupActivities = warmupActivities;
    copy.playerAttendanceJson = playerAttendanceJson;
    if (playerAttendance != null) copy.playerAttendance = playerAttendance;
    copy.expectedPlayers = expectedPlayers ?? this.expectedPlayers;
    copy.actualPlayers = actualPlayers ?? this.actualPlayers;
    copy.notes = notes ?? this.notes;
    copy.postSessionEvaluation =
        postSessionEvaluation ?? this.postSessionEvaluation;
    copy.periodizationPhaseId =
        periodizationPhaseId ?? this.periodizationPhaseId;
    copy.contentFocusJson = contentFocusJson;
    if (contentFocus != null) copy.contentFocus = contentFocus;
    copy.targetIntensity = targetIntensity ?? this.targetIntensity;
    copy.startTime = startTime ?? this.startTime;
    copy.endTime = endTime ?? this.endTime;
    copy.durationMinutes = durationMinutes ?? this.durationMinutes;
    copy.status = status ?? this.status;
    copy.createdAt = createdAt;
    copy.updatedAt = DateTime.now();
    return copy;
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
  teamBuilding
}

enum SessionStatus { planned, inProgress, completed, cancelled, postponed }
