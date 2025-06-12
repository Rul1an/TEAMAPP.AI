import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/training_session/training_exercise.dart';
import '../../models/training_session/field_diagram.dart';
import '../../providers/exercise_designer_provider.dart';
import '../../providers/field_diagram_provider.dart';
import '../../widgets/field_diagram/field_diagram_toolbar.dart';
import '../../widgets/field_diagram/field_canvas.dart';
import 'exercise_library_screen.dart';
import '../../services/database_service.dart';

class ExerciseDesignerScreen extends ConsumerStatefulWidget {
  final String? sessionId;
  final ExerciseType? initialType;

  const ExerciseDesignerScreen({
    super.key,
    this.sessionId,
    this.initialType,
  });

  @override
  ConsumerState<ExerciseDesignerScreen> createState() => _ExerciseDesignerScreenState();
}

class _ExerciseDesignerScreenState extends ConsumerState<ExerciseDesignerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize form data with initial values
      if (widget.initialType != null) {
        ref.read(exerciseDesignerProvider.notifier).updateFormData('type', widget.initialType);
      }
      if (widget.sessionId != null) {
        ref.read(exerciseDesignerProvider.notifier).updateFormData('sessionId', widget.sessionId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final designerState = ref.watch(exerciseDesignerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎯 Oefening Designer'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildProgressIndicator(designerState),
          _buildStepHeader(designerState),
          Expanded(
            child: _buildStepContent(designerState),
          ),
          _buildNavigationBar(designerState),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(ExerciseDesignerState state) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.green[50],
        border: Border(bottom: BorderSide(color: Colors.green[200]!)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Stap ${state.currentStepIndex + 1} van ${state.totalSteps}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.green[700],
                ),
              ),
              Text(
                '${(state.progress * 100).toInt()}% voltooid',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: state.progress,
            backgroundColor: Colors.green[100],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
          ),
        ],
      ),
    );
  }

  Widget _buildStepHeader(ExerciseDesignerState state) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getStepIcon(state.currentStepIndex),
              color: Colors.green[700],
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.stepTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getStepDescription(state.currentStepIndex),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(ExerciseDesignerState state) {
    switch (state.currentStepIndex) {
      case 0: // Basis Informatie
        return _buildBasicInfoStep(state);
      case 1: // Oefening Details
        return _buildDetailsStep(state);
      case 2: // Doelstellingen
        return _buildObjectivesStep(state);
      case 3: // Uitvoering
        return _buildFieldDiagramStep(state);
      case 4: // Evaluatie
        return _buildReviewStep(state);
      default:
        return _buildPlaceholderStep(state);
    }
  }

  Widget _buildBasicInfoStep(ExerciseDesignerState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Optie om bestaande oefening te selecteren
          Card(
            margin: const EdgeInsets.only(bottom: 20.0),
            color: Colors.green[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.library_books, color: Colors.green[700]),
                      const SizedBox(width: 12),
                      Text(
                        'Bestaande oefening gebruiken',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Je kunt een bestaande oefening selecteren als basis om aan te passen.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _selectExistingExercise(context),
                      icon: const Icon(Icons.search),
                      label: const Text('Selecteer uit Oefeningen Bibliotheek'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          _buildFormSection(
            title: 'Basis Informatie',
            icon: Icons.info_outline,
            children: [
              TextFormField(
                initialValue: state.formData['name']?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'Oefening Naam *',
                  hintText: 'Naam van de oefening',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  ref.read(exerciseDesignerProvider.notifier).updateFormData('name', value);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: state.formData['description']?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'Beschrijving *',
                  hintText: 'Korte uitleg van de oefening',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) {
                  ref.read(exerciseDesignerProvider.notifier).updateFormData('description', value);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ExerciseType>(
                value: state.formData['type'] as ExerciseType? ?? ExerciseType.technical,
                decoration: const InputDecoration(
                  labelText: 'Type Oefening *',
                  border: OutlineInputBorder(),
                ),
                items: ExerciseType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(_getExerciseTypeDisplayName(type)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    ref.read(exerciseDesignerProvider.notifier).updateFormData('type', value);
                  }
                },
              ),
              const SizedBox(height: 20),

              // Load from Library Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _selectExistingExercise(context),
                  icon: const Icon(Icons.library_books),
                  label: const Text('Selecteer Uit Bibliotheek'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFieldDiagramStep(ExerciseDesignerState state) {
    final diagramState = ref.watch(fieldDiagramProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Oefening Visualisatie',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        FieldDiagramToolbar(
          selectedTool: diagramState.currentTool,
          onToolSelected: (tool) => ref.read(fieldDiagramProvider.notifier).selectTool(tool),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: FieldCanvas(
              diagram: diagramState.diagram,
              currentTool: diagramState.currentTool,
              selectedElementId: diagramState.selectedElementId,
              selectedPlayerType: diagramState.selectedPlayerType,
              selectedEquipmentType: diagramState.selectedEquipmentType,
              selectedLineType: diagramState.selectedLineType,
              currentLinePoints: diagramState.currentLinePoints,
              isDrawingLine: diagramState.isDrawingLine,
              onElementSelected: (elementId) => ref.read(fieldDiagramProvider.notifier).selectElement(elementId),
              onElementMoved: (elementId, newPosition) => ref.read(fieldDiagramProvider.notifier).moveElement(elementId, newPosition),
              onElementAdded: (element) => ref.read(fieldDiagramProvider.notifier).addElement(element),
              onElementRemoved: (elementId) => ref.read(fieldDiagramProvider.notifier).removeElement(elementId),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsStep(ExerciseDesignerState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormSection(
            title: 'Oefening Details',
            icon: Icons.settings,
            children: [
              TextFormField(
                initialValue: state.formData['duration']?.toString() ?? '15',
                decoration: const InputDecoration(
                  labelText: 'Duur (minuten)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  ref.read(exerciseDesignerProvider.notifier).updateFormData('duration', int.tryParse(value) ?? 15);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: state.formData['equipment']?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'Materialen',
                  hintText: 'Benodigde materialen',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  ref.read(exerciseDesignerProvider.notifier).updateFormData('equipment', value);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildObjectivesStep(ExerciseDesignerState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormSection(
            title: 'Doelstellingen',
            icon: Icons.track_changes,
            children: [
              TextFormField(
                initialValue: state.formData['objectives']?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'Hoofddoelstellingen',
                  hintText: 'Doelen van deze oefening',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) {
                  ref.read(exerciseDesignerProvider.notifier).updateFormData('objectives', value);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: state.formData['coachingPoints']?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'Coaching Punten',
                  hintText: 'Belangrijke aandachtspunten',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) {
                  ref.read(exerciseDesignerProvider.notifier).updateFormData('coachingPoints', value);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep(ExerciseDesignerState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormSection(
            title: 'Overzicht',
            icon: Icons.preview,
            children: [
              _buildReviewItem('Naam', state.formData['name']?.toString() ?? 'Niet ingevuld'),
              _buildReviewItem('Beschrijving', state.formData['description']?.toString() ?? 'Niet ingevuld'),
              _buildReviewItem('Duur', '${state.formData['duration'] ?? 15} minuten'),
              _buildReviewItem('Materialen', state.formData['equipment']?.toString() ?? 'Geen'),
              _buildReviewItem('Doelstellingen', state.formData['objectives']?.toString() ?? 'Niet ingevuld'),
              _buildReviewItem('Coaching Punten', state.formData['coachingPoints']?.toString() ?? 'Niet ingevuld'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderStep(ExerciseDesignerState state) {
    // All steps should be implemented - redirect to completion
    return _buildReviewStep(state);
  }

  Widget _buildFormSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.green[700]),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }


  Widget _buildNavigationBar(ExerciseDesignerState state) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (!state.isFirstStep)
            OutlinedButton(
              onPressed: () {
                ref.read(exerciseDesignerProvider.notifier).previousStep();
              },
              child: const Text('Vorige'),
            ),
          const Spacer(),
          if (state.isLastStep)
            ElevatedButton.icon(
              onPressed: _saveExercise,
              icon: const Icon(Icons.save),
              label: const Text('Voltooien'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
              ),
            )
          else
            ElevatedButton(
              onPressed: () {
                ref.read(exerciseDesignerProvider.notifier).nextStep();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
              ),
              child: const Text('Volgende'),
            ),
        ],
      ),
    );
  }

  IconData _getStepIcon(int stepIndex) {
    switch (stepIndex) {
      case 0: // Basis Informatie
        return Icons.info_outline;
      case 1: // Oefening Details
        return Icons.settings;
      case 2: // Doelstellingen
        return Icons.track_changes;
      case 3: // Uitvoering
        return Icons.sports_soccer;
      case 4: // Evaluatie
        return Icons.preview;
      default:
        return Icons.help_outline;
    }
  }

  String _getStepDescription(int stepIndex) {
    switch (stepIndex) {
      case 0: // Basis Informatie
        return 'Geef je oefening een naam, beschrijving en type';
      case 1: // Oefening Details
        return 'Stel duur, intensiteit en materialen in';
      case 2: // Doelstellingen
        return 'Definieer doelstellingen en coaching punten';
      case 3: // Uitvoering
        return 'Teken je oefening visueel op het veld';
      case 4: // Evaluatie
        return 'Controleer en sla je oefening op';
      default:
        return 'Onbekende stap';
    }
  }

  Future<void> _saveExercise() async {
    try {
      final exerciseData = ref.read(exerciseDesignerProvider.notifier).buildExerciseFromFormData();

      // Add field diagram data
      final diagramState = ref.read(fieldDiagramProvider);
      if (diagramState.diagram.players.isNotEmpty ||
          diagramState.diagram.equipment.isNotEmpty ||
          diagramState.diagram.movements.isNotEmpty) {
        // Only save diagram if it has content
        try {
          final Map<String, dynamic> diagramJson = diagramState.diagram.toJson();
          exerciseData.fieldDiagram = FieldDiagram.fromJson(diagramJson);
        } catch (e) {
          // Silent fail for field diagram save - exercise will be saved without diagram
        }
      }

      // Ensure sessionId is set if provided via widget
      if (widget.sessionId != null) {
        exerciseData.trainingSessionId = widget.sessionId!;
      } else {
        // Als geen sessionId, dan is dit een bibliotheek oefening
        exerciseData.trainingSessionId = "library";
      }

      // Save to database
      final db = DatabaseService();
      await db.saveTrainingExercise(exerciseData);

      // Refresh the exercise library provider to show the new exercise
      ref.invalidate(exerciseLibraryProvider);

      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Oefening succesvol opgeslagen!'),
            backgroundColor: Colors.green,
          ),
        );

        context.pop();
      }
    } catch (e) {
      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Fout bij opslaan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _selectExistingExercise(BuildContext context) async {
    // Navigeer naar de oefeningen bibliotheek in selectie modus
    final selectedExercise = await Navigator.push<TrainingExercise>(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseLibraryScreen(
          isSelectMode: true,
          onExerciseSelected: (exercise) {
            Navigator.pop(context, exercise);
          },
        ),
      ),
    );

    // Als een oefening is geselecteerd, vul de form data
    if (selectedExercise != null) {
      final Map<String, dynamic> formData = {
        'name': selectedExercise.name,
        'description': selectedExercise.description,
        'type': selectedExercise.type,
        'duration': selectedExercise.durationMinutes,
        'intensityLevel': selectedExercise.intensityLevel,
        'equipment': selectedExercise.equipment,
        'coachingPoints': selectedExercise.coachingPoints,
        'keyFocus': selectedExercise.keyFocus,
        'objectives': selectedExercise.objectives,
      };

      // Voeg fieldDiagram toe als het beschikbaar is
      if (selectedExercise.fieldDiagram != null) {
        formData['fieldDiagram'] = selectedExercise.fieldDiagram;

        // Update het field diagram in de provider
        if (selectedExercise.fieldDiagram is Map<String, dynamic>) {
          ref.read(fieldDiagramProvider.notifier).loadFromData(
            selectedExercise.fieldDiagram as Map<String, dynamic>
          );
        }
      }

      // Update alle form data in één keer
      ref.read(exerciseDesignerProvider.notifier).setFormData(formData);

      // Toon een snackbar om te bevestigen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${selectedExercise.name} geladen om aan te passen'),
          backgroundColor: Colors.green[700],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _getExerciseTypeDisplayName(ExerciseType type) {
    switch (type) {
      case ExerciseType.technical:
        return 'Technische Oefening';
      case ExerciseType.tactical:
        return 'Tactische Oefening';
      case ExerciseType.physical:
        return 'Fysieke Oefening';
      case ExerciseType.conditioning:
        return 'Conditie Oefening';
      case ExerciseType.warmup:
        return 'Warming-up';
      case ExerciseType.cooldown:
        return 'Cooling-down';
      case ExerciseType.smallSidedGame:
        return 'Partijvorm';
      case ExerciseType.possession:
        return 'Balbezit Oefening';
      case ExerciseType.finishing:
        return 'Afwerking';
      case ExerciseType.defending:
        return 'Verdediging';
      case ExerciseType.transition:
        return 'Omschakeling';
      default:
        return 'Onbekend';
    }
  }
}
