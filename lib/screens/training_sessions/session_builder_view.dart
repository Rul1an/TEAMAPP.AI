import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/training_session/session_phase.dart';
import '../../models/training_session/training_session.dart';
import 'widgets/session_builder_wizard.dart';
import 'widgets/basic_info_step.dart';
import 'widgets/objectives_step.dart';
import 'widgets/phase_planning_step.dart';
import 'widgets/evaluation_step.dart';

class SessionBuilderView extends StatelessWidget {
  const SessionBuilderView({
    super.key,
    required this.currentStep,
    required this.onNext,
    required this.onPrev,
    required this.onSave,
    required this.onSelectDate,
    required this.onSelectTrainingType,
    required this.onAddPhase,
    required this.onEditPhase,
    required this.onDeletePhase,
    required this.onReorderPhases,
    required this.onExportPdf,
    this.onShowExercises = _noop,
    required this.selectedDate,
    required this.selectedType,
    required this.objectiveController,
    required this.teamFunctionController,
    required this.coachingAccentController,
    required this.notesController,
    required this.sessionPhases,
    required this.totalDuration,
  });

  final int currentStep;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final VoidCallback onSave;
  final VoidCallback onSelectDate;
  final VoidCallback onSelectTrainingType;
  final VoidCallback onAddPhase;
  final void Function(int) onEditPhase;
  final void Function(int) onDeletePhase;
  final void Function(int, int) onReorderPhases;
  final void Function(SessionPhase) onShowExercises;
  final VoidCallback onExportPdf;

  final DateTime selectedDate;
  final TrainingType selectedType;
  final TextEditingController objectiveController;
  final TextEditingController teamFunctionController;
  final TextEditingController coachingAccentController;
  final TextEditingController notesController;
  final List<SessionPhase> sessionPhases;
  final int totalDuration;

  int get _stepCount => 4;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Training Sessie'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Terug',
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            onPressed: () => context.pop(),
          ),
          actions: [
            if (currentStep > 0)
              TextButton(onPressed: onPrev, child: const Text('Vorige')),
            const SizedBox(width: 8),
            if (currentStep < _stepCount - 1)
              ElevatedButton(onPressed: onNext, child: const Text('Volgende'))
            else
              ElevatedButton(onPressed: onSave, child: const Text('Opslaan')),
            const SizedBox(width: 16),
          ],
        ),
        body: SessionBuilderWizard(
          stepTitles: const [
            'Basis Info',
            'Doelstellingen',
            'Fase Planning',
            'Evaluatie',
          ],
          stepBuilders: [
            (_) => BasicInfoStep(
                  selectedDate: selectedDate,
                  onSelectDate: onSelectDate,
                  trainingType: selectedType,
                  onSelectTrainingType: onSelectTrainingType,
                ),
            (_) => ObjectivesStep(
                  objectiveController: objectiveController,
                  teamFunctionController: teamFunctionController,
                  coachingAccentController: coachingAccentController,
                ),
            (_) => PhasePlanningStep(
                  phases: sessionPhases,
                  onReorder: onReorderPhases,
                  onAddPhase: onAddPhase,
                  onEditPhase: onEditPhase,
                  onDeletePhase: onDeletePhase,
                  onShowExercises: onShowExercises,
                  totalDuration: totalDuration,
                ),
            (_) => EvaluationStep(
                  selectedDate: selectedDate,
                  trainingType: selectedType,
                  objective: objectiveController.text,
                  totalDuration: totalDuration,
                  phaseCount: sessionPhases.length,
                  notesController: notesController,
                  onExportPdf: onExportPdf,
                  onSave: onSave,
                ),
          ],
          onFinished: onSave,
        ),
      );
}

// ignore: prefer_function_declarations_over_variables
void _noop(SessionPhase _) {}
