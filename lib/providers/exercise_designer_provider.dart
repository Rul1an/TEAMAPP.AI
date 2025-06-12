import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/training_session/training_exercise.dart';
import '../models/training_session/field_diagram.dart';

// Exercise Designer Wizard Steps
enum ExerciseDesignerStep {
  basicInfo,     // Step 1: Name, description, category
  setup,         // Step 2: Duration, players, equipment
  objectives,    // Step 3: Learning objectives, coaching points
  fieldDiagram,  // Step 4: Visual field diagram creation
  details,       // Step 5: Variations, safety notes
  review,        // Step 6: Final review and save
}

// Exercise Designer State
class ExerciseDesignerState {
  final int currentStepIndex;
  final List<String> stepTitles;
  final Map<String, dynamic> formData;

  const ExerciseDesignerState({
    this.currentStepIndex = 0,
    this.stepTitles = const [
      'Basis Informatie',
      'Oefening Details',
      'Doelstellingen',
      'Uitvoering',
      'Evaluatie'
    ],
    this.formData = const {},
  });

  // Computed properties
  int get totalSteps => stepTitles.length;
  double get progress => (currentStepIndex + 1) / totalSteps;
  String get stepTitle => stepTitles[currentStepIndex];
  bool get isFirstStep => currentStepIndex == 0;
  bool get isLastStep => currentStepIndex == totalSteps - 1;

  ExerciseDesignerState copyWith({
    int? currentStepIndex,
    List<String>? stepTitles,
    Map<String, dynamic>? formData,
  }) {
    return ExerciseDesignerState(
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      stepTitles: stepTitles ?? this.stepTitles,
      formData: formData ?? this.formData,
    );
  }
}

// Exercise Designer Notifier
class ExerciseDesignerNotifier extends StateNotifier<ExerciseDesignerState> {
  ExerciseDesignerNotifier() : super(const ExerciseDesignerState());

  void nextStep() {
    if (!state.isLastStep) {
      state = state.copyWith(currentStepIndex: state.currentStepIndex + 1);
    }
  }

  void previousStep() {
    if (!state.isFirstStep) {
      state = state.copyWith(currentStepIndex: state.currentStepIndex - 1);
    }
  }

  void updateFormData(String key, dynamic value) {
    final updatedFormData = Map<String, dynamic>.from(state.formData);
    updatedFormData[key] = value;
    state = state.copyWith(formData: updatedFormData);
  }

  void setFormData(Map<String, dynamic> newFormData) {
    // Replace the entire form data with the new data
    state = state.copyWith(formData: newFormData);
  }

  TrainingExercise buildExerciseFromFormData() {
    // Convert the form data to a TrainingExercise object
    final exercise = TrainingExercise.create(
      name: state.formData['name'] ?? '',
      description: state.formData['description'] ?? '',
      durationMinutes: (state.formData['duration'] as num?)?.toDouble() ?? 15.0,
      playerCount: (state.formData['playerCount'] as int?) ?? 18,
      equipment: state.formData['equipment'] ?? '',
      intensityLevel: (state.formData['intensityLevel'] as num?)?.toDouble() ?? 5.0,
      type: state.formData['type'] ?? ExerciseType.technical,
      coachingPoints: [],
    );

    // Handle coaching points (could be a string or a list)
    if (state.formData['coachingPoints'] != null) {
      if (state.formData['coachingPoints'] is String) {
        exercise.coachingPoints = (state.formData['coachingPoints'] as String)
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .toList();
      } else if (state.formData['coachingPoints'] is List) {
        exercise.coachingPoints = List<String>.from(state.formData['coachingPoints']);
      }
    }

    // Handle key focus (should be a string, not a list)
    if (state.formData['keyFocus'] != null) {
      if (state.formData['keyFocus'] is String) {
        exercise.keyFocus = state.formData['keyFocus'] as String;
      }
    }

    // Handle objectives (convert to list)
    if (state.formData['objectives'] != null) {
      if (state.formData['objectives'] is String) {
        exercise.objectives = [(state.formData['objectives'] as String)];
      } else if (state.formData['objectives'] is List) {
        exercise.objectives = List<String>.from(state.formData['objectives']);
      }
    }

    // Handle field diagram
    if (state.formData['fieldDiagram'] != null) {
      try {
        if (state.formData['fieldDiagram'] is Map<String, dynamic>) {
          exercise.fieldDiagram = FieldDiagram.fromJson(
            state.formData['fieldDiagram'] as Map<String, dynamic>
          );
        } else if (state.formData['fieldDiagram'] is FieldDiagram) {
          exercise.fieldDiagram = state.formData['fieldDiagram'] as FieldDiagram;
        }
      } catch (e) {
        // Silent fail for field diagram parsing issues
        // Field diagram will remain null if parsing fails
      }
    }

    return exercise;
  }

  void reset() {
    state = const ExerciseDesignerState();
  }
}

// Provider
final exerciseDesignerProvider = StateNotifierProvider<ExerciseDesignerNotifier, ExerciseDesignerState>(
  (ref) => ExerciseDesignerNotifier(),
);

// Predefined key focus areas for quick selection
final keyFocusOptions = [
  'Passing',
  'Eerste aanname',
  'Dribbling',
  'Afwerken',
  'Kopspel',
  'Verdedigen',
  'Pressing',
  'Positiespel',
  'Omschakeling',
  'Loopacties',
  'Communicatie',
  'Overzicht',
  'Snelheid',
  'Conditie',
  'Coördinatie',
];

// Common coaching points templates
final coachingPointsTemplates = {
  ExerciseType.technical: [
    'Zuivere passing met binnenkant voet',
    'Hoofd omhoog voor overzicht',
    'Goede eerste aanname',
    'Balans in het lichaam',
    'Timing van de passing',
  ],
  ExerciseType.tactical: [
    'Snelle beslissingen nemen',
    'Positie innemen voor medespeler',
    'Druk naar voren uitoefenen',
    'Compactheid behouden',
    'Kommunicatie met medespelers',
  ],
  ExerciseType.physical: [
    'Maximale intensiteit',
    'Correcte techniek behouden',
    'Adequate rust tussen herhalingen',
    'Explosieve bewegingen',
    'Focus op snelheid en kracht',
  ],
};

// Equipment suggestions based on exercise type
final equipmentSuggestions = {
  ExerciseType.technical: [
    '8 kegels, 4 ballen',
    '12 kegels, 6 ballen',
    '4 pionnen, 2 ballen',
    'Coördinatieladder, 4 ballen',
  ],
  ExerciseType.tactical: [
    '4 doeltjes, 1 bal',
    '8 kegels, 2 ballen, 2 goals',
    '6 pionnen, 4 hesjes, 1 bal',
    '2 grote doelen, 1 bal, hesjes',
  ],
  ExerciseType.smallSidedGame: [
    '4 kegels, 2 goals, 1 bal',
    '8 pionnen, 2 doeltjes, hesjes',
    '4 kleine doelen, 2 ballen',
    'Groot veld, 1 bal, hesjes',
  ],
};

// Exercise Library Provider for the Enhanced Exercise Library Screen
final exerciseLibraryProvider = FutureProvider<List<TrainingExercise>>((ref) async {
  return _getSampleExercises();
});

List<TrainingExercise> _getSampleExercises() {
  return [
    TrainingExercise.create(
      name: "Passing Square",
      description: "4v4 passing exercise in a 20x20m square",
      durationMinutes: 15.0,
      playerCount: 8,
      equipment: "Cones, balls",
      intensityLevel: 5.0,
      type: ExerciseType.technical,
      coachingPoints: ["Keep head up", "Use both feet", "Quick pass decisions"],
    ),
    TrainingExercise.create(
      name: "1v1 Finishing",
      description: "Individual finishing practice with keeper",
      durationMinutes: 20.0,
      playerCount: 10,
      equipment: "Goals, balls",
      intensityLevel: 7.0,
      type: ExerciseType.technical,
      coachingPoints: ["Pick your spot", "Follow through", "Be decisive"],
    ),
    TrainingExercise.create(
      name: "Small Sided Game",
      description: "7v7 game focusing on possession",
      durationMinutes: 25.0,
      playerCount: 14,
      equipment: "Goals, balls, bibs",
      intensityLevel: 8.0,
      type: ExerciseType.smallSidedGames,
      coachingPoints: ["Keep possession", "Switch play", "Support teammate"],
    ),
    TrainingExercise.create(
      name: "Tactical Pressing",
      description: "Practice coordinated team pressing",
      durationMinutes: 20.0,
      playerCount: 16,
      equipment: "Cones, balls, bibs",
      intensityLevel: 6.0,
      type: ExerciseType.tactical,
      coachingPoints: ["Press together", "Cut passing lanes", "Win ball high"],
    ),
    TrainingExercise.create(
      name: "Warm-up Jogging",
      description: "Light jogging and dynamic stretching",
      durationMinutes: 10.0,
      playerCount: 18,
      equipment: "None",
      intensityLevel: 2.0,
      type: ExerciseType.warmUp,
      coachingPoints: ["Gradual intensity", "Full range of motion", "Stay focused"],
    ),
    TrainingExercise.create(
      name: "Physical Conditioning",
      description: "Sprint intervals and agility work",
      durationMinutes: 15.0,
      playerCount: 18,
      equipment: "Cones, ladders",
      intensityLevel: 8.5,
      type: ExerciseType.physical,
      coachingPoints: ["Maximum effort", "Proper form", "Active recovery"],
    ),
    TrainingExercise.create(
      name: "Goalkeeper Training",
      description: "Shot stopping and distribution practice",
      durationMinutes: 20.0,
      playerCount: 3,
      equipment: "Goals, balls, gloves",
      intensityLevel: 6.5,
      type: ExerciseType.goalkeeping,
      coachingPoints: ["Set position", "Quick reactions", "Accurate distribution"],
    ),
    TrainingExercise.create(
      name: "Cool-down Stretching",
      description: "Static stretching and relaxation",
      durationMinutes: 10.0,
      playerCount: 18,
      equipment: "Mats",
      intensityLevel: 1.0,
      type: ExerciseType.coolDown,
      coachingPoints: ["Hold stretches", "Breathe deeply", "Relax muscles"],
    ),
  ];
}
