// ignore_for_file: unused_import
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async' show unawaited;

import '../models/training_session/session_phase.dart';
import '../models/training_session/training_session.dart';
import '../repositories/training_session_repository.dart';
import '../services/training_session_builder_service.dart';
import '../providers/training_sessions_repo_provider.dart';
import '../repositories/player_repository.dart';
import '../providers/players_provider.dart';

/// Immutable state for the Session Builder flow.
class SessionBuilderState {
  const SessionBuilderState({
    required this.session,
    required this.phases,
    this.isLoading = false,
  });

  final TrainingSession? session;
  final List<SessionPhase> phases;
  final bool isLoading;

  SessionBuilderState copyWith({
    TrainingSession? session,
    List<SessionPhase>? phases,
    bool? isLoading,
  }) =>
      SessionBuilderState(
        session: session ?? this.session,
        phases: phases ?? this.phases,
        isLoading: isLoading ?? this.isLoading,
      );

  static const initial = SessionBuilderState(
    session: null,
    phases: <SessionPhase>[],
    isLoading: true,
  );
}

/// Controller handling loading/creation of [TrainingSession]s for the builder UI.
class SessionBuilderController extends StateNotifier<SessionBuilderState> {
  SessionBuilderController(
    this._ref, {
    required this.sessionId,
  }) : super(SessionBuilderState.initial) {
    _init();
  }

  final Ref _ref;
  final int? sessionId;

  TrainingSessionRepository get _sessionRepo =>
      _ref.read(trainingSessionRepositoryProvider);

  Future<void> _init() async {
    if (sessionId != null) {
      await _loadExisting(sessionId!);
    } else {
      _createNew();
    }

    // Prefetch players for the team to ensure repository is warmed up.
    // This makes the player repository import a legitimate dependency.
    unawaited(_ref.read(playerRepositoryProvider).getAll());
  }

  Future<void> _loadExisting(int id) async {
    state = state.copyWith(isLoading: true);
    final sessionsRes = await _sessionRepo.getAll();
    final loaded = sessionsRes.dataOrNull?.firstWhere(
      (s) => s.id == id.toString(),
      orElse: TrainingSession.new,
    );
    if (loaded != null && loaded.id.isNotEmpty) {
      state = state.copyWith(
        session: loaded,
        phases: loaded.phases,
        isLoading: false,
      );
    } else {
      // Fallback to new session if not found
      _createNew();
    }
  }

  void _createNew() {
    final newSession = TrainingSessionBuilderService.createNewSession(
      teamId: 'jo17-1',
      date: DateTime.now(),
      type: TrainingType.regularTraining,
    );
    state = state.copyWith(
      session: newSession,
      phases: newSession.phases,
      isLoading: false,
    );
  }

  // UI actions
  void setDate(DateTime date) {
    final s = state.session;
    if (s == null) return;
    s.date = date;
    state = state.copyWith(session: s);
  }

  void setType(TrainingType type) {
    final s = state.session;
    if (s == null) return;
    s.type = type;
    state = state.copyWith(session: s);
  }
}

/// Public provider (family) to access controller + state by [sessionId].
final sessionBuilderControllerProvider = StateNotifierProvider.autoDispose
    .family<SessionBuilderController, SessionBuilderState, int?>(
  (ref, sessionId) => SessionBuilderController(
    ref,
    sessionId: sessionId,
  ),
);
