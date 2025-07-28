import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/training_session/session_phase.dart';
import '../models/training_session/training_session.dart';
import '../services/training_session_builder_service.dart';

/// Immutable view-state for the Session Builder wizard.
class SessionBuilderState {
  const SessionBuilderState({
    this.session,
    this.currentStep = 0,
  });

  final TrainingSession? session;
  final int currentStep;

  SessionBuilderState copyWith({
    TrainingSession? session,
    int? currentStep,
  }) {
    return SessionBuilderState(
      session: session ?? this.session,
      currentStep: currentStep ?? this.currentStep,
    );
  }

  bool get isEditing => session != null && session!.id.isNotEmpty;

  DateTime get selectedDate => session?.date ?? DateTime.now();

  TrainingType get trainingType =>
      session?.type ?? TrainingType.regularTraining;

  List<SessionPhase> get phases => session?.phases ?? const [];
}

/// Riverpod controller holding the mutable wizard logic. UI layers should
/// remain stateless and subscribe to the exposed [SessionBuilderState].
class SessionBuilderController extends Notifier<SessionBuilderState> {
  @override
  SessionBuilderState build() {
    // Fresh wizard – no session yet.
    return const SessionBuilderState();
  }

  Future<void> createNew({required String teamId}) async {
    final newSession = TrainingSessionBuilderService.createNewSession(
      teamId: teamId,
      date: DateTime.now(),
      type: TrainingType.regularTraining,
    );
    state = state.copyWith(session: newSession);
  }

  Future<void> loadExisting(TrainingSession existing) async {
    state = state.copyWith(session: existing);
  }

  void updateStep(int step) {
    state = state.copyWith(currentStep: step);
  }
}

final sessionBuilderControllerProvider =
    NotifierProvider<SessionBuilderController, SessionBuilderState>(
  SessionBuilderController.new,
);
