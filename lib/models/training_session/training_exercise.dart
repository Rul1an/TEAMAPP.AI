import '../annual_planning/morphocycle.dart';
import 'field_diagram.dart';

// part 'training_exercise.g.dart'; // Disabled for web compatibility

// @Collection() // Disabled for web compatibility
class TrainingExercise {
  // Id id = Isar.autoIncrement; // Disabled for web compatibility
  int id = 0;

  // Basic information
  late String name;
  late String description;
  late double durationMinutes;
  late int playerCount;
  late String equipment;
  late double intensityLevel;
  late ExerciseType type;
  late List<String> coachingPoints;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  // Additional properties for enhanced functionality
  String? trainingSessionId;
  String? sessionPhaseId;  // Links exercise to specific phase
  int orderIndex = 0;
  String? keyFocus;
  List<String> objectives = [];
  FieldDiagram? fieldDiagram;

  // Extended properties for morphocycle integration
  int minPlayers = 1;
  int maxPlayers = 22;
  ExerciseCategory category = ExerciseCategory.technical;
  ExerciseComplexity complexity = ExerciseComplexity.basic;
  String spaceRequired = "Half field";
  double estimatedRPE = 5.0;
  double averageRating = 0.0;

  // Tactical focus for morphocycle compatibility
  TacticalFocus? tacticalFocus;
  double primaryIntensity = 5.0;

  // Get training intensity enum based on intensity level
  TrainingIntensity get trainingIntensity {
    if (intensityLevel <= 4.0) return TrainingIntensity.recovery;
    if (intensityLevel <= 6.0) return TrainingIntensity.activation;
    if (intensityLevel <= 8.0) return TrainingIntensity.development;
    if (intensityLevel <= 9.0) return TrainingIntensity.acquisition;
    return TrainingIntensity.competition;
  }

  // Basic exercise data
  TrainingExercise({
    this.id = 0,
    required this.name,
    required this.description,
    required this.durationMinutes,
    required this.playerCount,
    required this.equipment,
    required this.intensityLevel,
    required this.type,
    required this.coachingPoints,
    this.trainingSessionId,
    this.sessionPhaseId,
    this.orderIndex = 0,
    this.keyFocus,
    this.objectives = const [],
    this.fieldDiagram,
    this.minPlayers = 1,
    this.maxPlayers = 22,
    this.category = ExerciseCategory.technical,
    this.complexity = ExerciseComplexity.basic,
    this.spaceRequired = "Half field",
    this.estimatedRPE = 5.0,
    this.averageRating = 0.0,
    this.tacticalFocus,
    this.primaryIntensity = 5.0,
  });

  // Factory constructor for creating a new exercise
  factory TrainingExercise.create({
    required String name,
    required String description,
    required double durationMinutes,
    required int playerCount,
    String equipment = '',
    double intensityLevel = 5.0,
    ExerciseType type = ExerciseType.technical,
    List<String>? coachingPoints,
    String? trainingSessionId,
    String? sessionPhaseId,
    int orderIndex = 0,
    String? keyFocus,
    List<String>? objectives,
    FieldDiagram? fieldDiagram,
    int minPlayers = 1,
    int maxPlayers = 22,
    ExerciseCategory category = ExerciseCategory.technical,
    ExerciseComplexity complexity = ExerciseComplexity.basic,
    String spaceRequired = "Half field",
    double estimatedRPE = 5.0,
    double averageRating = 0.0,
    TacticalFocus? tacticalFocus,
    double primaryIntensity = 5.0,
  }) {
    return TrainingExercise(
      name: name,
      description: description,
      durationMinutes: durationMinutes,
      playerCount: playerCount,
      equipment: equipment,
      intensityLevel: intensityLevel,
      type: type,
      coachingPoints: coachingPoints ?? [],
      trainingSessionId: trainingSessionId,
      sessionPhaseId: sessionPhaseId,
      orderIndex: orderIndex,
      keyFocus: keyFocus,
      objectives: objectives ?? [],
      fieldDiagram: fieldDiagram,
      minPlayers: minPlayers,
      maxPlayers: maxPlayers,
      category: category,
      complexity: complexity,
      spaceRequired: spaceRequired,
      estimatedRPE: estimatedRPE,
      averageRating: averageRating,
      tacticalFocus: tacticalFocus,
      primaryIntensity: primaryIntensity,
    )
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();
  }

  // Computed properties
  bool get isHighIntensity => intensityLevel >= 7.0;
  bool get isMediumIntensity => intensityLevel >= 4.0 && intensityLevel < 7.0;
  bool get isLowIntensity => intensityLevel < 4.0;

  String get intensityDescription {
    if (isHighIntensity) return 'High';
    if (isMediumIntensity) return 'Medium';
    return 'Low';
  }

  // Update the exercise
  void updateExercise({
    String? name,
    String? description,
    double? durationMinutes,
    int? playerCount,
    String? equipment,
    double? intensityLevel,
    ExerciseType? type,
    List<String>? coachingPoints,
  }) {
    if (name != null) this.name = name;
    if (description != null) this.description = description;
    if (durationMinutes != null) this.durationMinutes = durationMinutes;
    if (playerCount != null) this.playerCount = playerCount;
    if (equipment != null) this.equipment = equipment;
    if (intensityLevel != null) this.intensityLevel = intensityLevel;
    if (type != null) this.type = type;
    if (coachingPoints != null) this.coachingPoints = coachingPoints;
    updatedAt = DateTime.now();
  }

  // JSON serialization
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'durationMinutes': durationMinutes,
        'playerCount': playerCount,
        'equipment': equipment,
        'intensityLevel': intensityLevel,
        'type': type.name,
        'coachingPoints': coachingPoints,
        'trainingSessionId': trainingSessionId,
        'sessionPhaseId': sessionPhaseId,
        'orderIndex': orderIndex,
        'keyFocus': keyFocus,
        'objectives': objectives,
        'minPlayers': minPlayers,
        'maxPlayers': maxPlayers,
        'category': category.name,
        'complexity': complexity.name,
        'spaceRequired': spaceRequired,
        'estimatedRPE': estimatedRPE,
        'averageRating': averageRating,
        'tacticalFocus': tacticalFocus?.name,
        'primaryIntensity': primaryIntensity,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory TrainingExercise.fromJson(Map<String, dynamic> json) {
    final exercise = TrainingExercise.create(
      name: json['name'],
      description: json['description'],
      durationMinutes: (json['durationMinutes'] as num).toDouble(),
      playerCount: json['playerCount'],
      equipment: json['equipment'] ?? '',
      intensityLevel: (json['intensityLevel'] as num?)?.toDouble() ?? 5.0,
      type: ExerciseType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ExerciseType.technical,
      ),
      coachingPoints: json['coachingPoints'] != null
          ? List<String>.from(json['coachingPoints'])
          : [],
      trainingSessionId: json['trainingSessionId'],
      sessionPhaseId: json['sessionPhaseId'],
      orderIndex: json['orderIndex'] ?? 0,
      keyFocus: json['keyFocus'],
      objectives: json['objectives'] != null
          ? List<String>.from(json['objectives'])
          : [],
      minPlayers: json['minPlayers'] ?? 1,
      maxPlayers: json['maxPlayers'] ?? 22,
      category: json['category'] != null
          ? ExerciseCategory.values.firstWhere(
              (e) => e.name == json['category'],
              orElse: () => ExerciseCategory.technical,
            )
          : ExerciseCategory.technical,
      complexity: json['complexity'] != null
          ? ExerciseComplexity.values.firstWhere(
              (e) => e.name == json['complexity'],
              orElse: () => ExerciseComplexity.basic,
            )
          : ExerciseComplexity.basic,
      spaceRequired: json['spaceRequired'] ?? "Half field",
      estimatedRPE: (json['estimatedRPE'] as num?)?.toDouble() ?? 5.0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      tacticalFocus: json['tacticalFocus'] != null
          ? TacticalFocus.values.firstWhere(
              (e) => e.name == json['tacticalFocus'],
              orElse: () => TacticalFocus.gameModel,
            )
          : null,
      primaryIntensity: (json['primaryIntensity'] as num?)?.toDouble() ?? 5.0,
    );
    exercise.id = json['id'] ?? 0;
    exercise.createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now();
    exercise.updatedAt = json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : DateTime.now();
    return exercise;
  }

  // Copy method
  TrainingExercise copyWith({
    int? id,
    String? name,
    String? description,
    double? durationMinutes,
    int? playerCount,
    String? equipment,
    double? intensityLevel,
    ExerciseType? type,
    List<String>? coachingPoints,
    String? trainingSessionId,
    String? sessionPhaseId,
    int? orderIndex,
    String? keyFocus,
    List<String>? objectives,
    FieldDiagram? fieldDiagram,
    int? minPlayers,
    int? maxPlayers,
    ExerciseCategory? category,
    ExerciseComplexity? complexity,
    String? spaceRequired,
    double? estimatedRPE,
    double? averageRating,
    TacticalFocus? tacticalFocus,
    double? primaryIntensity,
  }) {
    final copy = TrainingExercise.create(
      name: name ?? this.name,
      description: description ?? this.description,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      playerCount: playerCount ?? this.playerCount,
      equipment: equipment ?? this.equipment,
      intensityLevel: intensityLevel ?? this.intensityLevel,
      type: type ?? this.type,
      coachingPoints: coachingPoints ?? this.coachingPoints,
      trainingSessionId: trainingSessionId ?? this.trainingSessionId,
      sessionPhaseId: sessionPhaseId ?? this.sessionPhaseId,
      orderIndex: orderIndex ?? this.orderIndex,
      keyFocus: keyFocus ?? this.keyFocus,
      objectives: objectives ?? this.objectives,
      fieldDiagram: fieldDiagram ?? this.fieldDiagram,
      minPlayers: minPlayers ?? this.minPlayers,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      category: category ?? this.category,
      complexity: complexity ?? this.complexity,
      spaceRequired: spaceRequired ?? this.spaceRequired,
      estimatedRPE: estimatedRPE ?? this.estimatedRPE,
      averageRating: averageRating ?? this.averageRating,
      tacticalFocus: tacticalFocus ?? this.tacticalFocus,
      primaryIntensity: primaryIntensity ?? this.primaryIntensity,
    );
    copy.id = id ?? this.id;
    copy.createdAt = createdAt;
    copy.updatedAt = DateTime.now();
    return copy;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrainingExercise &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  // Check if exercise is compatible with a training intensity
  bool isCompatibleWithIntensity(TrainingIntensity intensity) {
    switch (intensity) {
      case TrainingIntensity.recovery:
        return intensityLevel <= 4.0;
      case TrainingIntensity.activation:
        return intensityLevel >= 4.0 && intensityLevel <= 6.0;
      case TrainingIntensity.development:
        return intensityLevel >= 6.0 && intensityLevel <= 8.0;
      case TrainingIntensity.acquisition:
        return intensityLevel >= 8.0;
      case TrainingIntensity.competition:
        return intensityLevel >= 9.0;
    }
  }

  // Check if exercise is compatible with a tactical focus
  bool isCompatibleWithTacticalFocus(TacticalFocus focus) {
    return tacticalFocus == focus || tacticalFocus == null;
  }

  // Static method for getting recommended exercises for a morphocycle week
  static Map<String, List<TrainingExercise>> getRecommendedExercisesForWeek(
    List<TrainingExercise> exercises,
    int weekNumber
  ) {
    // Organize exercises by morphocycle day based on week number
    final Map<String, List<TrainingExercise>> recommendations = {
      'recovery': [],
      'acquisition': [],
      'development': [],
      'activation': [],
    };

    for (final exercise in exercises) {
      if (weekNumber % 4 == 1) {
        // Recovery week - low intensity
        if (exercise.intensityLevel <= 5.0) {
          recommendations['recovery']!.add(exercise);
        }
      } else if (weekNumber % 4 == 2) {
        // Acquisition week - high intensity
        if (exercise.intensityLevel >= 7.0) {
          recommendations['acquisition']!.add(exercise);
        }
      } else if (weekNumber % 4 == 3) {
        // Development week - medium intensity
        if (exercise.intensityLevel >= 5.0 && exercise.intensityLevel <= 7.0) {
          recommendations['development']!.add(exercise);
        }
      } else {
        // Activation week - medium-low intensity
        if (exercise.intensityLevel >= 4.0 && exercise.intensityLevel <= 6.0) {
          recommendations['activation']!.add(exercise);
        }
      }
    }

    return recommendations;
  }
}

// Extension methods for filtering exercises
extension TrainingExerciseFilters on List<TrainingExercise> {
  List<TrainingExercise> forIntensity(TrainingIntensity intensity) {
    return where((exercise) {
      // Map TrainingIntensity enum to intensity level ranges
      switch (intensity) {
        case TrainingIntensity.recovery:
          return exercise.intensityLevel <= 4.0;
        case TrainingIntensity.activation:
          return exercise.intensityLevel >= 4.0 && exercise.intensityLevel <= 6.0;
        case TrainingIntensity.development:
          return exercise.intensityLevel >= 6.0 && exercise.intensityLevel <= 8.0;
        case TrainingIntensity.acquisition:
          return exercise.intensityLevel >= 8.0;
        case TrainingIntensity.competition:
          return exercise.intensityLevel >= 9.0;
      }
    }).toList();
  }

  List<TrainingExercise> forTacticalFocus(TacticalFocus focus) {
    return where((exercise) =>
      exercise.tacticalFocus == focus
    ).toList();
  }

  List<TrainingExercise> search(String query) {
    final lowerQuery = query.toLowerCase();
    return where((exercise) =>
      exercise.name.toLowerCase().contains(lowerQuery) ||
      exercise.description.toLowerCase().contains(lowerQuery) ||
      exercise.coachingPoints.any((point) =>
        point.toLowerCase().contains(lowerQuery)
      )
    ).toList();
  }

  List<TrainingExercise> forCategory(ExerciseCategory category) {
    return where((exercise) => exercise.category == category).toList();
  }

  List<TrainingExercise> forComplexity(ExerciseComplexity complexity) {
    return where((exercise) => exercise.complexity == complexity).toList();
  }

  List<TrainingExercise> forDuration(int minMinutes, int maxMinutes) {
    return where((exercise) =>
      exercise.durationMinutes >= minMinutes &&
      exercise.durationMinutes <= maxMinutes
    ).toList();
  }

  List<TrainingExercise> forPlayerCount(int minPlayers, int maxPlayers) {
    return where((exercise) =>
      exercise.minPlayers <= maxPlayers &&
      exercise.maxPlayers >= minPlayers
    ).toList();
  }
}

// Extension methods for individual exercises
extension TrainingExerciseExtension on TrainingExercise {
  bool isCompatibleWithTacticalFocus(TacticalFocus focus) {
    return tacticalFocus == focus;
  }
}

// Exercise types following professional coaching methodology
enum ExerciseType {
  technical,       // Technical skills (passing, shooting, dribbling)
  tactical,        // Tactical concepts (positioning, pressing, transitions)
  physical,        // Conditioning, fitness, speed, agility
  goalkeeping,     // Goalkeeper specific training
  psychological,   // Mental skills, decision making
  warmUp,          // Warm-up and activation exercises
  coolDown,        // Cool-down and recovery
  smallSidedGames, // Small-sided games for tactical development
  conditioning,    // Physical conditioning and fitness
  warmup,          // Alternative warm-up naming
  cooldown,        // Alternative cool-down naming
  smallSidedGame,  // Alternative small-sided game naming
  possession,      // Possession-based exercises
  finishing,       // Finishing and shooting exercises
  defending,       // Defensive exercises
  transition,      // Transition exercises (attack to defense)
}

// Exercise categories for organization
enum ExerciseCategory {
  warmup,         // Warm-up exercises
  technical,      // Technical skill development
  tactical,       // Tactical understanding
  physical,       // Physical conditioning
  finishing,      // Goal scoring
  defending,      // Defensive work
  goalkeeping,    // Goalkeeper training
  smallSided,     // Small-sided games
  cooldown,       // Cool-down and recovery
}

// Extension for ExerciseCategory display names
extension ExerciseCategoryExtension on ExerciseCategory {
  String get displayName {
    switch (this) {
      case ExerciseCategory.warmup:
        return 'Warming-up';
      case ExerciseCategory.technical:
        return 'Technisch';
      case ExerciseCategory.tactical:
        return 'Tactisch';
      case ExerciseCategory.physical:
        return 'Fysiek';
      case ExerciseCategory.finishing:
        return 'Afwerken';
      case ExerciseCategory.defending:
        return 'Verdedigen';
      case ExerciseCategory.goalkeeping:
        return 'Keeperswerk';
      case ExerciseCategory.smallSided:
        return 'Klein Spel';
      case ExerciseCategory.cooldown:
        return 'Cooling-down';
    }
  }
}

// Exercise complexity levels
enum ExerciseComplexity {
  basic,          // Basic/beginner level
  intermediate,   // Intermediate level
  advanced,       // Advanced level
  expert,         // Expert/professional level
}

// Extension for ExerciseComplexity display names
extension ExerciseComplexityExtension on ExerciseComplexity {
  String get displayName {
    switch (this) {
      case ExerciseComplexity.basic:
        return 'Basis';
      case ExerciseComplexity.intermediate:
        return 'Gemiddeld';
      case ExerciseComplexity.advanced:
        return 'Gevorderd';
      case ExerciseComplexity.expert:
        return 'Expert';
    }
  }
}

// Age groups for exercise appropriateness - REMOVED (using the one from periodization_plan.dart)
