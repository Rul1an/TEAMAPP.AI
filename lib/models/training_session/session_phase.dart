import 'package:isar/isar.dart';

// part 'session_phase.g.dart'; // Disabled for web compatibility

// @Collection() // Disabled for web compatibility
class SessionPhase {
  Id id = Isar.autoIncrement;

  late String name; // "training uitzetten", "bespreking", "evaluatie"
  late DateTime startTime;
  late DateTime endTime;
  String? description;
  late int orderIndex;

  @Enumerated(EnumType.name)
  late PhaseType type;

  // Exercise IDs linked to this phase
  List<String> exerciseIds = [];

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  // Computed properties
  @ignore
  Duration get duration => endTime.difference(startTime);

  @ignore
  int get durationMinutes => duration.inMinutes;

  @ignore
  String get timeRange =>
    '${_formatTime(startTime)} - ${_formatTime(endTime)}';

  @ignore
  int get exerciseCount => exerciseIds.length;

  @ignore
  bool get hasExercises => exerciseIds.isNotEmpty;

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
           '${time.minute.toString().padLeft(2, '0')}';
  }

  // Exercise management methods
  void addExercise(String exerciseId) {
    if (!exerciseIds.contains(exerciseId)) {
      exerciseIds.add(exerciseId);
      updatedAt = DateTime.now();
    }
  }

  void removeExercise(String exerciseId) {
    if (exerciseIds.remove(exerciseId)) {
      updatedAt = DateTime.now();
    }
  }

  void reorderExercises(int oldIndex, int newIndex) {
    if (oldIndex < exerciseIds.length && newIndex < exerciseIds.length) {
      final exerciseId = exerciseIds.removeAt(oldIndex);
      exerciseIds.insert(newIndex, exerciseId);
      updatedAt = DateTime.now();
    }
  }

  // Constructor
  SessionPhase();

  // Named constructors for common phases
  SessionPhase.warmup({
    required DateTime start,
    int durationMinutes = 15,
  }) {
    name = "Warming-up";
    type = PhaseType.warmup;
    startTime = start;
    endTime = start.add(Duration(minutes: durationMinutes));
    description = "Spelers warming-up en voorbereiding";
    orderIndex = 1;
    exerciseIds = [];
  }

  SessionPhase.trainingSetup({
    required DateTime start,
    int durationMinutes = 10,
  }) {
    name = "Training uitzetten";
    type = PhaseType.preparation;
    startTime = start;
    endTime = start.add(Duration(minutes: durationMinutes));
    description = "Veld inrichten en materiaal klaarzetten";
    orderIndex = 2;
    exerciseIds = [];
  }

  SessionPhase.mainTraining({
    required DateTime start,
    int durationMinutes = 60,
  }) {
    name = "Hoofdtraining";
    type = PhaseType.main;
    startTime = start;
    endTime = start.add(Duration(minutes: durationMinutes));
    description = "Hoofddeel van de training";
    orderIndex = 3;
    exerciseIds = [];
  }

  SessionPhase.evaluation({
    required DateTime start,
    int durationMinutes = 10,
  }) {
    name = "Evaluatie";
    type = PhaseType.evaluation;
    startTime = start;
    endTime = start.add(Duration(minutes: durationMinutes));
    description = "Bespreking en evaluatie van de training";
    orderIndex = 4;
    exerciseIds = [];
  }

  SessionPhase.cooldown({
    required DateTime start,
    int durationMinutes = 10,
  }) {
    name = "Cool-down";
    type = PhaseType.cooldown;
    startTime = start;
    endTime = start.add(Duration(minutes: durationMinutes));
    description = "Afkoeling en stretching";
    orderIndex = 5;
    exerciseIds = [];
  }

  // JSON serialization
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'description': description,
    'orderIndex': orderIndex,
    'type': type.name,
    'exerciseIds': exerciseIds,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory SessionPhase.fromJson(Map<String, dynamic> json) {
    final phase = SessionPhase();
    phase.id = json['id'] ?? Isar.autoIncrement;
    phase.name = json['name'] ?? '';
    phase.startTime = json['startTime'] != null
        ? DateTime.parse(json['startTime'])
        : DateTime.now();
    phase.endTime = json['endTime'] != null
        ? DateTime.parse(json['endTime'])
        : DateTime.now();
    phase.description = json['description'];
    phase.orderIndex = json['orderIndex'] ?? 0;
    phase.type = PhaseType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => PhaseType.main,
    );
    phase.exerciseIds = json['exerciseIds'] != null
        ? List<String>.from(json['exerciseIds'])
        : [];
    phase.createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now();
    phase.updatedAt = json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : DateTime.now();
    return phase;
  }

  // Copy with method
  SessionPhase copyWith({
    String? name,
    DateTime? startTime,
    DateTime? endTime,
    String? description,
    int? orderIndex,
    PhaseType? type,
    List<String>? exerciseIds,
  }) {
    final copy = SessionPhase();
    copy.id = id;
    copy.name = name ?? this.name;
    copy.startTime = startTime ?? this.startTime;
    copy.endTime = endTime ?? this.endTime;
    copy.description = description ?? this.description;
    copy.orderIndex = orderIndex ?? this.orderIndex;
    copy.type = type ?? this.type;
    copy.exerciseIds = exerciseIds ?? List.from(this.exerciseIds);
    copy.createdAt = createdAt;
    copy.updatedAt = DateTime.now();
    return copy;
  }

  @override
  String toString() {
    return 'SessionPhase(name: $name, time: $timeRange, type: $type, exercises: ${exerciseIds.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SessionPhase &&
        other.id == id &&
        other.name == name &&
        other.startTime == startTime &&
        other.endTime == endTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
           name.hashCode ^
           startTime.hashCode ^
           endTime.hashCode;
  }
}

enum PhaseType {
  preparation,    // Training uitzetten, materiaal klaarzetten
  warmup,        // Warming-up
  technical,     // Technische training
  tactical,      // Tactische training
  physical,      // Fysieke training
  main,          // Hoofdtraining (algemeen)
  game,          // Partijtje/spelvormen
  discussion,    // Bespreking/tactiekbespreking
  evaluation,    // Evaluatie van training
  cooldown       // Afkoeling
}
