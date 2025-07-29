// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import '../../models/training_session/session_phase.dart';
import '../../models/training_session/training_session.dart';
import '../../providers/players_provider.dart';
import '../../providers/training_sessions_repo_provider.dart';
import '../../repositories/player_repository.dart';
import '../../repositories/training_session_repository.dart';
import 'session_builder_view.dart';
import '../../services/training_session_builder_service.dart';
import '../../providers/pdf/pdf_generators_providers.dart';
import '../../controllers/session_builder_controller.dart';

class SessionBuilderScreen extends ConsumerStatefulWidget {
  const SessionBuilderScreen({super.key, this.sessionId});
  final int? sessionId;

  @override
  ConsumerState<SessionBuilderScreen> createState() =>
      _SessionBuilderScreenState();
}

class _SessionBuilderScreenState extends ConsumerState<SessionBuilderScreen> {
  int currentStep = 0;

  // Session data being built
  TrainingSession? session;

  // Repositories via Riverpod
  TrainingSessionRepository get _sessionRepo =>
      ref.read(trainingSessionRepositoryProvider);
  PlayerRepository get _playerRepo => ref.read(playerRepositoryProvider);

  // Form controllers
  final TextEditingController _objectiveController = TextEditingController();
  final TextEditingController _teamFunctionController = TextEditingController();
  final TextEditingController _coachingAccentController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TrainingType selectedType = TrainingType.regularTraining;
  List<SessionPhase> sessionPhases = [];

  @override
  void initState() {
    super.initState();
    _initializeSession();
  }

  @override
  void dispose() {
    _objectiveController.dispose();
    _teamFunctionController.dispose();
    _coachingAccentController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _initializeSession() {
    if (widget.sessionId != null) {
      _loadExistingSession();
    } else {
      ref.read(sessionBuilderControllerProvider.notifier).createNew(
            teamId: 'default',
          );
    }
  }

  Future<void> _loadExistingSession() async {
    if (widget.sessionId != null) {
      final sessionsRes = await _sessionRepo.getAll();
      final loadedSession = sessionsRes.dataOrNull?.firstWhere(
        (s) => s.id == widget.sessionId!.toString(),
        orElse: TrainingSession.new,
      );
      if (loadedSession != null && loadedSession.id.isNotEmpty) {
        await ref
            .read(sessionBuilderControllerProvider.notifier)
            .loadExisting(loadedSession);

        setState(() {
          session = loadedSession;
          _objectiveController.text = loadedSession.sessionObjective ?? '';
          _teamFunctionController.text = loadedSession.teamFunction ?? '';
          _coachingAccentController.text = loadedSession.coachingAccent ?? '';
        });
      }
    } else {
      _createNewSession();
    }
  }

  void _createNewSession() {
    session = TrainingSession.create(
      teamId: 'jo17-1',
      date: selectedDate,
      trainingNumber:
          DateTime.now().millisecondsSinceEpoch ~/ (1000 * 60 * 60 * 24),
      type: selectedType,
    );

    sessionPhases = _createDefaultVOABPhases();
    session!.phases = sessionPhases;
  }

  List<SessionPhase> _createDefaultVOABPhases() =>
      TrainingSessionBuilderService.createDefaultVOABPhases();

  @override
  Widget build(BuildContext context) => SessionBuilderView(
        currentStep: currentStep,
        onNext: _nextStep,
        onPrev: _previousStep,
        onSave: _saveSession,
        onSelectDate: _selectDate,
        onSelectTrainingType: _selectTrainingType,
        onAddPhase: _addCustomPhase,
        onEditPhase: _editPhase,
        onDeletePhase: _deletePhase,
        onReorderPhases: _reorderPhases,
        onShowExercises: _showPhaseExercises,
        onExportPdf: _exportToPDF,
        selectedDate: selectedDate,
        selectedType: selectedType,
        objectiveController: _objectiveController,
        teamFunctionController: _teamFunctionController,
        coachingAccentController: _coachingAccentController,
        notesController: _notesController,
        sessionPhases: sessionPhases,
        totalDuration: _getTotalDuration(),
      );

  void _nextStep() {
    if (currentStep < 3) {
      setState(() => currentStep++);
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
    }
  }

  int _getTotalDuration() =>
      sessionPhases.fold(0, (sum, phase) => sum + phase.durationMinutes);

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
        session!.date = date;
      });
    }
  }

  void _selectTrainingType() {
    // TODO(refactor): Extract to TrainingTypeSelector widget for better maintainability
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Training type selectie komt in volgende update')),
    );
  }

  void _reorderPhases(int oldIndex, int newIndex) {
    setState(() {
      final adjustedNewIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
      final item = sessionPhases.removeAt(oldIndex);
      sessionPhases.insert(adjustedNewIndex, item);
    });
  }

  void _deletePhase(int index) {
    // TODO(refactor): Extract to ConfirmDialog widget for better maintainability
    setState(() => sessionPhases.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Fase "${sessionPhases.length > index ? sessionPhases[index].name : 'onbekend'}" verwijderd')),
    );
  }

  void _editPhase(int index) {
    // TODO(refactor): Extract to separate dialog class for better maintainability
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fase bewerken komt in volgende update')),
    );
  }

  void _addCustomPhase() {
    // TODO(refactor): Extract to PhaseDialog widget for better maintainability
    final newPhase = SessionPhase()
      ..name = 'Nieuwe Fase'
      ..type = PhaseType.technical
      ..orderIndex = sessionPhases.length
      ..startTime = DateTime(2024, 1, 1, 18)
      ..endTime = DateTime(2024, 1, 1, 18, 15)
      ..description = 'Beschrijving toevoegen...';

    setState(() => sessionPhases.add(newPhase));
  }

  void _showPhaseExercises(SessionPhase phase) {
    // TODO(refactor): Extract to ExercisePhaseDialog widget for better maintainability
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('${phase.exerciseIds.length} oefeningen in ${phase.name}')),
    );
  }


  Future<void> _saveSession() async {
    try {
      session!.sessionObjective = _objectiveController.text;
      session!.teamFunction = _teamFunctionController.text;
      session!.coachingAccent = _coachingAccentController.text;
      session!.notes = _notesController.text;
      session!.phases = sessionPhases;

      await _sessionRepo.save(session!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Training sessie succesvol opgeslagen!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/training-sessions');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fout bij opslaan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _exportToPDF() async {
    // TODO(refactor): Extract to PdfExportService for better maintainability
    if (session == null) return;

    try {
      _updateSessionData();
      final generator = ref.read(trainingSessionPdfGeneratorProvider);
      final playersRes = await _playerRepo.getAll();
      await generator.generate((session!, playersRes.dataOrNull ?? []));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('PDF export voltooid'),
              backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF fout: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _updateSessionData() {
    session!.sessionObjective = _objectiveController.text;
    session!.teamFunction = _teamFunctionController.text;
    session!.coachingAccent = _coachingAccentController.text;
    session!.notes = _notesController.text;
    session!.phases = sessionPhases;
  }
}
