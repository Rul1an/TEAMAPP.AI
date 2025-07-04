// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'session_phase_simple.g.dart';

enum PhaseType {
  warmup,
  technical,
  tactical,
  physical,
  smallSidedGames,
  match,
  cooldown,
  discussion
}

@JsonSerializable()
class SessionPhase {
  const SessionPhase({
    required this.id,
    required this.sessionId,
    required this.name,
    required this.description,
    required this.type,
    required this.orderIndex,
    required this.durationMinutes,
    required this.exerciseIds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SessionPhase.fromJson(Map<String, dynamic> json) =>
      _$SessionPhaseFromJson(json);
  final String id;
  final String sessionId;
  final String name;
  final String description;
  final PhaseType type;
  final int orderIndex;
  final int durationMinutes;
  final List<String> exerciseIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Computed properties
  bool get hasExercises => exerciseIds.isNotEmpty;
  int get exerciseCount => exerciseIds.length;

  // Mock properties for compatibility
  DateTime? get startTime => null;
  DateTime? get endTime => null;

  // Methods for compatibility
  void addExercise(String exerciseId) {
    // Mock implementation - in real app this would be handled by copyWith
  }
  Map<String, dynamic> toJson() => _$SessionPhaseToJson(this);
}
