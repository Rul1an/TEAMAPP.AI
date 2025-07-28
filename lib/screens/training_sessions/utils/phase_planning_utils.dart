import '../../../models/training_session/session_phase.dart';

/// Utility helpers for calculating phase planning data.
int calculateTotalDuration(List<SessionPhase> phases) =>
    phases.fold(0, (sum, p) => sum + p.durationMinutes);

/// Returns a human-readable name for a [PhaseType].
String phaseTypeName(PhaseType type) {
  switch (type) {
    case PhaseType.preparation:
      return 'Voorbereiding';
    case PhaseType.warmup:
      return 'Warming-up';
    case PhaseType.technical:
      return 'Technisch';
    case PhaseType.tactical:
      return 'Tactisch';
    case PhaseType.physical:
      return 'Fysiek';
    case PhaseType.main:
      return 'Hoofdtraining';
    case PhaseType.game:
      return 'Spelvorm';
    case PhaseType.discussion:
      return 'Bespreking';
    case PhaseType.evaluation:
      return 'Evaluatie';
    case PhaseType.cooldown:
      return 'Afkoeling';
  }
}

/// Formats a readable time-range for a [SessionPhase].
String formatPhaseTime(SessionPhase phase) {
  String _pad(int v) => v.toString().padLeft(2, '0');
  final start = phase.startTime;
  final end = phase.endTime;
  return '${_pad(start.hour)}:${_pad(start.minute)} - '
      '${_pad(end.hour)}:${_pad(end.minute)}';
}

/// Recalculates [SessionPhase.startTime] / [SessionPhase.endTime] in-place
/// based on each phase's `durationMinutes` starting from a fixed base time.
void recalculatePhaseTimes(List<SessionPhase> phases) {
  final baseTime = DateTime(2024, 1, 1, 18); // 18:00 baseline
  var current = baseTime;
  for (final p in phases) {
    p.startTime = current;
    p.endTime = current.add(Duration(minutes: p.durationMinutes));
    current = p.endTime;
  }
}
