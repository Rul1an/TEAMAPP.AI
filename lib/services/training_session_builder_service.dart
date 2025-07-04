import '../models/training_session/session_phase.dart';
import '../models/training_session/training_session.dart';

/// Utility service providing helper methods for constructing training sessions.
class TrainingSessionBuilderService {
  /// Generates default VOAB session phases.
  static List<SessionPhase> createDefaultVOABPhases({DateTime? baseDateTime}) {
    final base = baseDateTime ?? DateTime(2024, 1, 1, 18);
    return [
      _phase('Training uitzetten', PhaseType.preparation, base, 0, 10,
          'Materiaal klaarzetten, welkom spelers'),
      _phase('Warming-up', PhaseType.warmup, base, 10, 25,
          'Algemene warming-up met bal'),
      _phase('Technisch deel', PhaseType.technical, base, 25, 50,
          'Technische vaardigheden training'),
      _phase('Tactisch deel', PhaseType.tactical, base, 50, 80,
          'Tactische vorm of positiespel'),
      _phase('Hoofdtraining', PhaseType.main, base, 80, 115,
          'Partijvorm of wedstrijdsituaties'),
      _phase('Evaluatie', PhaseType.evaluation, base, 115, 125,
          'Korte bespreking en feedback'),
      _phase('Cool-down', PhaseType.cooldown, base, 125, 130,
          'Rustige afsluiting en materiaal opruimen'),
    ];
  }

  /// Creates a new [TrainingSession] with default phases and simple training number.
  static TrainingSession createNewSession({
    required String teamId,
    required DateTime date,
    required TrainingType type,
  }) {
    final session = TrainingSession.create(
      teamId: teamId,
      date: date,
      trainingNumber: DateTime.now().millisecondsSinceEpoch ~/ 86400000,
      type: type,
    );
    session.phases = createDefaultVOABPhases(baseDateTime: date);
    return session;
  }

  // Helper to instantiate a SessionPhase.
  static SessionPhase _phase(String name, PhaseType type, DateTime base,
      int startMin, int endMin, String desc) {
    return SessionPhase()
      ..name = name
      ..type = type
      ..orderIndex = type.index
      ..startTime = base.add(Duration(minutes: startMin))
      ..endTime = base.add(Duration(minutes: endMin))
      ..description = desc;
  }
}
