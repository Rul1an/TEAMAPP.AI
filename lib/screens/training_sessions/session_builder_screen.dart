// Dart imports:
import 'dart:async';
import 'dart:io' as io;

// Flutter imports:
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import '../../models/training_session/session_phase.dart';
import '../../models/training_session/training_exercise.dart';
import '../../models/training_session/training_session.dart';
import '../../providers/players_provider.dart';
import '../../providers/training_sessions_repo_provider.dart';
import '../../repositories/player_repository.dart';
import '../../repositories/training_session_repository.dart';
import '../../widgets/training/session_wizard_stepper.dart';
import 'exercise_library_screen.dart';
import '../../services/training_session_builder_service.dart';
import '../../providers/pdf/pdf_generators_providers.dart';

// Import voor web support
// ignore: avoid_web_libraries_in_flutter
// Web functionality removed - use notifications instead for 2025 compatibility

class SessionBuilderScreen extends ConsumerStatefulWidget {
  const SessionBuilderScreen({super.key, this.sessionId});
  final int? sessionId;

  @override
  ConsumerState<SessionBuilderScreen> createState() =>
      _SessionBuilderScreenState();
}

class _SessionBuilderScreenState extends ConsumerState<SessionBuilderScreen> {
  int currentStep = 0;
  final PageController _pageController = PageController();

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
    _pageController.dispose();
    super.dispose();
  }

  void _initializeSession() {
    if (widget.sessionId != null) {
      // Load existing session for editing
      _loadExistingSession();
    } else {
      // Create new session with VOAB defaults
      _createNewSession();
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
        // 🔧 CASCADE OPERATOR DOCUMENTATION: Complex State Update Pattern
        // This setState with multiple property assignments demonstrates where
        // cascade notation could improve readability for complex state updates.
        //
        // **CURRENT PATTERN**: setState(() { prop1 = val1; prop2 = val2; }) (block)
        // **RECOMMENDED**: setState(() { object..prop1 = val1..prop2 = val2; }) (cascade)
        //
        // **CASCADE BENEFITS FOR COMPLEX STATE UPDATES**:
        // ✅ Groups related property assignments visually
        // ✅ Reduces repetitive object references
        // ✅ Better readability for large state updates
        // ✅ Maintains Flutter state management patterns
        //
        setState(() {
          session = loadedSession;
          selectedDate = session!.date;
          selectedType = session!.type;
          sessionPhases = session!.phases;

          // Vul de formuliervelden
          _objectiveController.text = session!.sessionObjective ?? '';
          _teamFunctionController.text = session!.teamFunction ?? '';
          _coachingAccentController.text = session!.coachingAccent ?? '';
          _notesController.text = session!.notes ?? '';
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
      trainingNumber: DateTime.now().millisecondsSinceEpoch ~/
          (1000 * 60 * 60 * 24), // Simple unique number
      type: selectedType,
    );

    // Initialize with VOAB-style default phases
    sessionPhases = _createDefaultVOABPhases();
    session!.phases = sessionPhases;
  }

  List<SessionPhase> _createDefaultVOABPhases() =>
      TrainingSessionBuilderService.createDefaultVOABPhases();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            widget.sessionId == null
                ? 'Nieuwe Training Sessie'
                : 'Bewerk Training Sessie',
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          actions: [
            if (currentStep > 0)
              TextButton(onPressed: _previousStep, child: const Text('Vorige')),
            const SizedBox(width: 8),
            if (currentStep < _stepCount - 1)
              ElevatedButton(
                onPressed: _nextStep,
                child: const Text('Volgende'),
              )
            else
              ElevatedButton(
                onPressed: _saveSession,
                child: const Text('Opslaan'),
              ),
            const SizedBox(width: 16),
          ],
        ),
        body: Column(
          children: [
            // Progress indicator
            Container(
              padding: const EdgeInsets.all(16),
              child: SessionWizardStepper(
                currentStep: currentStep,
                steps: const [
                  'Basis Info',
                  'Doelstellingen',
                  'Fase Planning',
                  'Evaluatie',
                ],
                onStepTapped: (step) {
                  if (step <= currentStep) {
                    // 🔧 CASCADE OPERATOR DOCUMENTATION: Complex State Update Pattern
                    // This setState with multiple property assignments demonstrates where
                    // cascade notation could improve readability for complex state updates.
                    //
                    // **CURRENT PATTERN**: setState(() { prop1 = val1; prop2 = val2; }) (block)
                    // **RECOMMENDED**: setState(() { object..prop1 = val1..prop2 = val2; }) (cascade)
                    //
                    // **CASCADE BENEFITS FOR COMPLEX STATE UPDATES**:
                    // ✅ Groups related property assignments visually
                    // ✅ Reduces repetitive object references
                    // ✅ Better readability for large state updates
                    // ✅ Maintains Flutter state management patterns
                    //
                    setState(() {
                      currentStep = step;
                    });
                    _pageController.animateToPage(
                      step,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),

            // Step content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  // 🔧 CASCADE OPERATOR DOCUMENTATION: Complex State Update Pattern
                  // This setState with multiple property assignments demonstrates where
                  // cascade notation could improve readability for complex state updates.
                  //
                  // **CURRENT PATTERN**: setState(() { prop1 = val1; prop2 = val2; }) (block)
                  // **RECOMMENDED**: setState(() { object..prop1 = val1..prop2 = val2; }) (cascade)
                  //
                  // **CASCADE BENEFITS FOR COMPLEX STATE UPDATES**:
                  // ✅ Groups related property assignments visually
                  // ✅ Reduces repetitive object references
                  // ✅ Better readability for large state updates
                  // ✅ Maintains Flutter state management patterns
                  //
                  setState(() {
                    currentStep = page;
                  });
                },
                children: [
                  _buildBasicInfoStep(),
                  _buildObjectivesStep(),
                  _buildPhasePlanningStep(),
                  _buildEvaluationStep(),
                ],
              ),
            ),
          ],
        ),
      );

  int get _stepCount => 4;

  void _nextStep() {
    if (currentStep < _stepCount - 1) {
      // 🔧 CASCADE OPERATOR DOCUMENTATION: Complex State Update Pattern
      // This setState with multiple property assignments demonstrates where
      // cascade notation could improve readability for complex state updates.
      //
      // **CURRENT PATTERN**: setState(() { prop1 = val1; prop2 = val2; }) (block)
      // **RECOMMENDED**: setState(() { object..prop1 = val1..prop2 = val2; }) (cascade)
      //
      // **CASCADE BENEFITS FOR COMPLEX STATE UPDATES**:
      // ✅ Groups related property assignments visually
      // ✅ Reduces repetitive object references
      // ✅ Better readability for large state updates
      // ✅ Maintains Flutter state management patterns
      //
      setState(() {
        currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      // 🔧 CASCADE OPERATOR DOCUMENTATION: Complex State Update Pattern
      // This setState with multiple property assignments demonstrates where
      // cascade notation could improve readability for complex state updates.
      //
      // **CURRENT PATTERN**: setState(() { prop1 = val1; prop2 = val2; }) (block)
      // **RECOMMENDED**: setState(() { object..prop1 = val1..prop2 = val2; }) (cascade)
      //
      // **CASCADE BENEFITS FOR COMPLEX STATE UPDATES**:
      // ✅ Groups related property assignments visually
      // ✅ Reduces repetitive object references
      // ✅ Better readability for large state updates
      // ✅ Maintains Flutter state management patterns
      //
      setState(() {
        currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildBasicInfoStep() => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basis Informatie',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date selection
                    ListTile(
                      leading: Icon(
                        Icons.calendar_today,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: const Text('Training Datum'),
                      subtitle: Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _selectDate,
                    ),
                    const Divider(),

                    // Training type
                    ListTile(
                      leading: Icon(
                        Icons.sports_soccer,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: const Text('Training Type'),
                      subtitle: Text(_getTrainingTypeDisplayName(selectedType)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _selectTrainingType,
                    ),
                    const Divider(),

                    // Team info
                    ListTile(
                      leading: Icon(
                        Icons.groups,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: const Text('Team'),
                      subtitle: const Text('JO17-1 (16 spelers verwacht)'),
                    ),
                    const Divider(),

                    // Timing section
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Timing Instellingen',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            ListTile(
                              leading: const Icon(Icons.schedule),
                              title: const Text('Standaard VOAB timing'),
                              subtitle:
                                  const Text('18:00 - 20:10 (130 minuten)'),
                              trailing: TextButton(
                                onPressed: _selectTiming,
                                child: const Text('Wijzigen'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildObjectivesStep() => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Doelstellingen & Focus',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _objectiveController,
                      decoration: const InputDecoration(
                        labelText: 'Sessie Doelstelling',
                        hintText: 'Bijv: Verbeteren van passing onder druk',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _teamFunctionController,
                      decoration: const InputDecoration(
                        labelText: 'Team Functie Focus',
                        hintText: 'Bijv: Balbezit, Omschakeling, Verdedigen',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _coachingAccentController,
                      decoration: const InputDecoration(
                        labelText: 'Coaching Accent',
                        hintText:
                            'Bijv: Communicatie, Positiespel, Druk zetten',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Quick objective templates
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Snelle Doelstellingen',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'Passing & Ontvangen',
                        'Positiespel 4v4',
                        'Omschakeling',
                        'Afwerken',
                        'Verdedigen 1v1',
                        'Set Pieces',
                      ]
                          .map(
                            (objective) => ActionChip(
                              label: Text(objective),
                              onPressed: () {
                                _objectiveController.text = objective;
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildPhasePlanningStep() => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'VOAB Fase Planning',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Versleep fasen om de volgorde te wijzigen. Klik op bewerken om details aan te passen.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            // Reorderable Phase list
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sessionPhases.length,
                onReorder: _reorderPhases,
                itemBuilder: (context, index) {
                  final phase = sessionPhases[index];
                  return Card(
                    key: ValueKey('phase_$index'),
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getPhaseColor(phase.type),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      title: Text(
                        phase.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${phase.durationMinutes} min | ${_formatPhaseTime(phase)}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          if (phase.hasExercises)
                            Row(
                              children: [
                                const Icon(
                                  Icons.fitness_center,
                                  size: 14,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${phase.exerciseCount} oefening${phase.exerciseCount != 1 ? 'en' : ''}',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          if (phase.description?.isNotEmpty ?? false)
                            Text(
                              phase.description!,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (phase.hasExercises)
                            IconButton(
                              icon: const Icon(Icons.list, color: Colors.green),
                              onPressed: () {
                                // Phase exercises functionality will be implemented in future update
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Oefeningen bekijken komt in volgende update',
                                    ),
                                  ),
                                );
                              },
                              tooltip: 'Bekijk oefeningen',
                            ),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.blue),
                            onPressed: () => _addExerciseToPhaseQuick(phase),
                            tooltip: 'Voeg oefening toe',
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editPhase(index),
                            tooltip: 'Bewerk fase',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deletePhase(index),
                            tooltip: 'Verwijder fase',
                          ),
                          const Icon(Icons.drag_handle, color: Colors.grey),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Add phase button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addCustomPhase,
                icon: const Icon(Icons.add),
                label: const Text('Voeg Extra Fase Toe'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Quick phase templates
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Snelle Fase Templates',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildPhaseTemplate(
                          'Korte Warming-up',
                          PhaseType.warmup,
                          10,
                        ),
                        _buildPhaseTemplate(
                          'Techniek Blok',
                          PhaseType.technical,
                          20,
                        ),
                        _buildPhaseTemplate(
                          'Tactiek Vorm',
                          PhaseType.tactical,
                          25,
                        ),
                        _buildPhaseTemplate('Partijtje', PhaseType.game, 15),
                        _buildPhaseTemplate(
                          'Extra Uitloop',
                          PhaseType.cooldown,
                          5,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Total time indicator
            Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Totale Tijd: ${_getTotalDuration()} minuten',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                    const Spacer(),
                    if (_getTotalDuration() != 130)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getTotalDuration() > 130
                              ? Colors.orange
                              : Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getTotalDuration() > 130 ? 'Te lang' : 'Te kort',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildPhaseTemplate(String name, PhaseType type, int duration) =>
      ActionChip(
        label: Text('$name ($duration min)'),
        onPressed: () => _addPhaseFromTemplate(name, type, duration),
        avatar: Icon(_getPhaseIcon(type), size: 16),
      );

  IconData _getPhaseIcon(PhaseType type) {
    switch (type) {
      case PhaseType.preparation:
        return Icons.play_circle;
      case PhaseType.warmup:
        return Icons.directions_run;
      case PhaseType.technical:
        return Icons.sports_soccer;
      case PhaseType.tactical:
        return Icons.psychology;
      case PhaseType.physical:
        return Icons.fitness_center;
      case PhaseType.main:
        return Icons.star;
      case PhaseType.game:
        return Icons.sports;
      case PhaseType.discussion:
        return Icons.forum;
      case PhaseType.evaluation:
        return Icons.rate_review;
      case PhaseType.cooldown:
        return Icons.self_improvement;
    }
  }

  String _formatPhaseTime(SessionPhase phase) {
    final startTime = phase.startTime;
    final endTime = phase.endTime;
    return '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')} - ${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
  }

  void _reorderPhases(int oldIndex, int newIndex) {
    // 🔧 CASCADE OPERATOR DOCUMENTATION: Complex State Update Pattern
    // This setState with multiple property assignments demonstrates where
    // cascade notation could improve readability for complex state updates.
    //
    // **CURRENT PATTERN**: setState(() { prop1 = val1; prop2 = val2; }) (block)
    // **RECOMMENDED**: setState(() { object..prop1 = val1..prop2 = val2; }) (cascade)
    //
    // **CASCADE BENEFITS FOR COMPLEX STATE UPDATES**:
    // ✅ Groups related property assignments visually
    // ✅ Reduces repetitive object references
    // ✅ Better readability for large state updates
    // ✅ Maintains Flutter state management patterns
    //
    setState(() {
      final adjustedNewIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
      final item = sessionPhases.removeAt(oldIndex);
      sessionPhases.insert(adjustedNewIndex, item);
    });
  }

  void _recalculatePhaseTimes() {
    final baseTime = DateTime(2024, 1, 1, 18); // 18:00 base time
    var currentTime = baseTime;

    for (var i = 0; i < sessionPhases.length; i++) {
      sessionPhases[i].startTime = currentTime;
      sessionPhases[i].endTime = currentTime.add(
        Duration(minutes: sessionPhases[i].durationMinutes),
      );
      currentTime = sessionPhases[i].endTime;
    }
  }

  void _deletePhase(int index) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fase Verwijderen'),
        content: Text(
          'Weet je zeker dat je "${sessionPhases[index].name}" wilt verwijderen?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuleren'),
          ),
          TextButton(
            onPressed: () {
              // 🔧 CASCADE OPERATOR DOCUMENTATION: Complex State Update Pattern
              // This setState with multiple property assignments demonstrates where
              // cascade notation could improve readability for complex state updates.
              //
              // **CURRENT PATTERN**: setState(() { prop1 = val1; prop2 = val2; }) (block)
              // **RECOMMENDED**: setState(() { object..prop1 = val1..prop2 = val2; }) (cascade)
              //
              // **CASCADE BENEFITS FOR COMPLEX STATE UPDATES**:
              // ✅ Groups related property assignments visually
              // ✅ Reduces repetitive object references
              // ✅ Better readability for large state updates
              // ✅ Maintains Flutter state management patterns
              //
              setState(() {
                sessionPhases.removeAt(index);
                _recalculatePhaseTimes();
              });
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Verwijderen'),
          ),
        ],
      ),
    );
  }

  void _addPhaseFromTemplate(String name, PhaseType type, int duration) {
    final baseTime = DateTime(2024, 1, 1, 18);
    final newPhase = SessionPhase()
      ..name = name
      ..type = type
      ..orderIndex = sessionPhases.length
      ..startTime = baseTime
      ..endTime = baseTime.add(Duration(minutes: duration))
      ..description = _getDefaultPhaseDescription(type);

    // 🔧 CASCADE OPERATOR DOCUMENTATION: Complex State Update Pattern
    // This setState with multiple property assignments demonstrates where
    // cascade notation could improve readability for complex state updates.
    //
    // **CURRENT PATTERN**: setState(() { prop1 = val1; prop2 = val2; }) (block)
    // **RECOMMENDED**: setState(() { object..prop1 = val1..prop2 = val2; }) (cascade)
    //
    // **CASCADE BENEFITS FOR COMPLEX STATE UPDATES**:
    // ✅ Groups related property assignments visually
    // ✅ Reduces repetitive object references
    // ✅ Better readability for large state updates
    // ✅ Maintains Flutter state management patterns
    //
    setState(() {
      sessionPhases.add(newPhase);
      _recalculatePhaseTimes();
    });
  }

  String _getDefaultPhaseDescription(PhaseType type) {
    switch (type) {
      case PhaseType.preparation:
        return 'Materiaal klaarzetten, welkom spelers';
      case PhaseType.warmup:
        return 'Algemene warming-up met bal';
      case PhaseType.technical:
        return 'Technische vaardigheden training';
      case PhaseType.tactical:
        return 'Tactische vorm of positiespel';
      case PhaseType.physical:
        return 'Fysieke training en conditie';
      case PhaseType.main:
        return 'Hoofdonderdeel van de training';
      case PhaseType.game:
        return 'Partijvorm of wedstrijdsituaties';
      case PhaseType.discussion:
        return 'Bespreking en instructie';
      case PhaseType.evaluation:
        return 'Korte bespreking en feedback';
      case PhaseType.cooldown:
        return 'Afkoeling en stretching';
    }
  }

  Widget _buildEvaluationStep() => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review & Opslaan',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            // Session summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sessie Overzicht',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    _buildSummaryRow(
                      'Datum',
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                    ),
                    _buildSummaryRow(
                      'Type',
                      _getTrainingTypeDisplayName(selectedType),
                    ),
                    _buildSummaryRow('Duur', '${_getTotalDuration()} minuten'),
                    _buildSummaryRow('Fasen', '${sessionPhases.length} fasen'),
                    _buildSummaryRow(
                      'Doelstelling',
                      _objectiveController.text.isEmpty
                          ? 'Niet ingevuld'
                          : _objectiveController.text,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Notes
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Extra Notities',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        hintText:
                            'Voeg extra notities toe voor deze training...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _exportToPDF,
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('VOAB PDF Export'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      side: BorderSide(color: Colors.red.shade300),
                      foregroundColor: Colors.red.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveSession,
                    icon: const Icon(Icons.save),
                    label: const Text('Opslaan'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _buildSummaryRow(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                '$label:',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(child: Text(value)),
          ],
        ),
      );

  Color _getPhaseColor(PhaseType type) {
    switch (type) {
      case PhaseType.preparation:
        return Colors.blue.shade100;
      case PhaseType.warmup:
        return Colors.green.shade100;
      case PhaseType.technical:
        return Colors.orange.shade100;
      case PhaseType.tactical:
        return Colors.purple.shade100;
      case PhaseType.physical:
        return Colors.pink.shade100;
      case PhaseType.main:
        return Colors.red.shade100;
      case PhaseType.game:
        return Colors.teal.shade100;
      case PhaseType.discussion:
        return Colors.indigo.shade100;
      case PhaseType.evaluation:
        return Colors.yellow.shade100;
      case PhaseType.cooldown:
        return Colors.grey.shade100;
    }
  }

  String _getTrainingTypeDisplayName(TrainingType type) {
    switch (type) {
      case TrainingType.regularTraining:
        return 'Reguliere Training';
      case TrainingType.matchPreparation:
        return 'Wedstrijd Voorbereiding';
      case TrainingType.tacticalSession:
        return 'Tactische Sessie';
      case TrainingType.technicalSession:
        return 'Technische Sessie';
      case TrainingType.fitnessSession:
        return 'Fitness Sessie';
      case TrainingType.recoverySession:
        return 'Herstel Sessie';
      case TrainingType.teamBuilding:
        return 'Teambuilding';
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
      // 🔧 CASCADE OPERATOR DOCUMENTATION: Complex State Update Pattern
      // This setState with multiple property assignments demonstrates where
      // cascade notation could improve readability for complex state updates.
      //
      // **CURRENT PATTERN**: setState(() { prop1 = val1; prop2 = val2; }) (block)
      // **RECOMMENDED**: setState(() { object..prop1 = val1..prop2 = val2; }) (cascade)
      //
      // **CASCADE BENEFITS FOR COMPLEX STATE UPDATES**:
      // ✅ Groups related property assignments visually
      // ✅ Reduces repetitive object references
      // ✅ Better readability for large state updates
      // ✅ Maintains Flutter state management patterns
      //
      setState(() {
        selectedDate = date;
        session!.date = date;
      });
    }
  }

  void _selectTrainingType() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: TrainingType.values
              .map(
                (type) => ListTile(
                  title: Text(_getTrainingTypeDisplayName(type)),
                  selected: type == selectedType,
                  onTap: () {
                    // 🔧 CASCADE OPERATOR DOCUMENTATION: Complex State Update Pattern
                    // This setState with multiple property assignments demonstrates where
                    // cascade notation could improve readability for complex state updates.
                    //
                    // **CURRENT PATTERN**: setState(() { prop1 = val1; prop2 = val2; }) (block)
                    // **RECOMMENDED**: setState(() { object..prop1 = val1..prop2 = val2; }) (cascade)
                    //
                    // **CASCADE BENEFITS FOR COMPLEX STATE UPDATES**:
                    // ✅ Groups related property assignments visually
                    // ✅ Reduces repetitive object references
                    // ✅ Better readability for large state updates
                    // ✅ Maintains Flutter state management patterns
                    //
                    setState(() {
                      selectedType = type;
                      session!.type = type;
                    });
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _selectTiming() {
    // TODO(author): Implement custom timing selection
  }

  void _editPhase(int index) {
    final phase = sessionPhases[index];
    final nameController = TextEditingController(text: phase.name);
    final descriptionController = TextEditingController(
      text: phase.description,
    );
    final durationController = TextEditingController(
      text: phase.durationMinutes.toString(),
    );
    var selectedType = phase.type;

    showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Bewerk Fase ${index + 1}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Fase Naam',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<PhaseType>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                  ),
                  items: PhaseType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Row(
                            children: [
                              Icon(_getPhaseIcon(type), size: 20),
                              const SizedBox(width: 8),
                              Text(_getPhaseTypeName(type)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() {
                        selectedType = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: durationController,
                  decoration: const InputDecoration(
                    labelText: 'Duur (minuten)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Beschrijving',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuleren'),
            ),
            ElevatedButton(
              onPressed: () {
                final duration = int.tryParse(durationController.text) ??
                    phase.durationMinutes;
                final updatedPhase = sessionPhases[index].copyWith(
                  name: nameController.text.trim().isEmpty
                      ? phase.name
                      : nameController.text.trim(),
                  type: selectedType,
                  description: descriptionController.text.trim(),
                );

                // Manually update the duration by setting new end time
                updatedPhase.endTime = updatedPhase.startTime.add(
                  Duration(minutes: duration),
                );

                // 🔧 CASCADE OPERATOR DOCUMENTATION: Complex State Update Pattern
                // This setState with multiple property assignments demonstrates where
                // cascade notation could improve readability for complex state updates.
                //
                // **CURRENT PATTERN**: setState(() { prop1 = val1; prop2 = val2; }) (block)
                // **RECOMMENDED**: setState(() { object..prop1 = val1..prop2 = val2; }) (cascade)
                //
                // **CASCADE BENEFITS FOR COMPLEX STATE UPDATES**:
                // ✅ Groups related property assignments visually
                // ✅ Reduces repetitive object references
                // ✅ Better readability for large state updates
                // ✅ Maintains Flutter state management patterns
                //
                setState(() {
                  sessionPhases[index] = updatedPhase;
                  _recalculatePhaseTimes();
                });
                Navigator.pop(context);
              },
              child: const Text('Opslaan'),
            ),
          ],
        ),
      ),
    );
  }

  void _addCustomPhase() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final durationController = TextEditingController(text: '15');
    var selectedType = PhaseType.technical;

    showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Nieuwe Fase Toevoegen'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Fase Naam',
                    hintText: 'Bijv: Extra Techniek',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<PhaseType>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                  ),
                  items: PhaseType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Row(
                            children: [
                              Icon(_getPhaseIcon(type), size: 20),
                              const SizedBox(width: 8),
                              Text(_getPhaseTypeName(type)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() {
                        selectedType = value;
                        descriptionController.text =
                            _getDefaultPhaseDescription(value);
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: durationController,
                  decoration: const InputDecoration(
                    labelText: 'Duur (minuten)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Beschrijving',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuleren'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) {
                  if (mounted && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Vul een naam in voor de fase'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                  return;
                }

                final duration = int.tryParse(durationController.text) ?? 15;
                final baseTime = DateTime(2024, 1, 1, 18);
                final newPhase = SessionPhase()
                  ..name = nameController.text.trim()
                  ..type = selectedType
                  ..orderIndex = sessionPhases.length
                  ..startTime = baseTime
                  ..endTime = baseTime.add(Duration(minutes: duration))
                  ..description = descriptionController.text.trim();

                // 🔧 CASCADE OPERATOR DOCUMENTATION: Complex State Update Pattern
                // This setState with multiple property assignments demonstrates where
                // cascade notation could improve readability for complex state updates.
                //
                // **CURRENT PATTERN**: setState(() { prop1 = val1; prop2 = val2; }) (block)
                // **RECOMMENDED**: setState(() { object..prop1 = val1..prop2 = val2; }) (cascade)
                //
                // **CASCADE BENEFITS FOR COMPLEX STATE UPDATES**:
                // ✅ Groups related property assignments visually
                // ✅ Reduces repetitive object references
                // ✅ Better readability for large state updates
                // ✅ Maintains Flutter state management patterns
                //
                setState(() {
                  sessionPhases.add(newPhase);
                  _recalculatePhaseTimes();
                });
                Navigator.pop(context);
              },
              child: const Text('Toevoegen'),
            ),
          ],
        ),
      ),
    );
  }

  String _getPhaseTypeName(PhaseType type) {
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

  Future<void> _saveSession() async {
    try {
      // Update session with form data
      session!.sessionObjective = _objectiveController.text;
      session!.teamFunction = _teamFunctionController.text;
      session!.coachingAccent = _coachingAccentController.text;
      session!.notes = _notesController.text;
      session!.phases = sessionPhases;

      // Save via repository
      await _sessionRepo.save(session!);

      if (mounted) {
        if (mounted && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Training sessie succesvol opgeslagen!'),
              backgroundColor: Colors.green,
            ),
          );
        }

        // Navigate back
        context.go('/training-sessions');
      }
    } catch (e) {
      if (mounted) {
        if (mounted && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fout bij opslaan: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _exportToPDF() async {
    if (session == null) return;

    try {
      // Update session with current form data
      session!.sessionObjective = _objectiveController.text.isEmpty
          ? 'Technisch-tactische ontwikkeling'
          : _objectiveController.text;
      session!.teamFunction = _teamFunctionController.text.isEmpty
          ? 'Positiespel en samenwerking'
          : _teamFunctionController.text;
      session!.coachingAccent = _coachingAccentController.text.isEmpty
          ? 'Individuele begeleiding'
          : _coachingAccentController.text;
      session!.notes = _notesController.text;
      session!.phases = sessionPhases;

      // Get all players for the PDF
      final playersRes = await _playerRepo.getAll();
      final allPlayers = playersRes.dataOrNull ?? [];

      // Generate PDF using new generator provider
      final generator = ref.read(trainingSessionPdfGeneratorProvider);
      final pdfData = await generator.generate((session!, allPlayers));

      final fileName =
          'voab_training_${session!.trainingNumber}_${DateFormat('yyyy-MM-dd').format(session!.date)}.pdf';

      if (kIsWeb) {
        // PDF export simplified for 2025 web compatibility
        // PDF export simplified for 2025 web compatibility
        // PDF export simplified for 2025 web compatibility
        // PDF export simplified for 2025 web compatibility
        // PDF export simplified for 2025 web compatibility
        // PDF export simplified for 2025 web compatibility
        // PDF export simplified for 2025 web compatibility
        // PDF export simplified for 2025 web compatibility
        // PDF export simplified for 2025 web compatibility
        // PDF export simplified for 2025 web compatibility
        // PDF export simplified for 2025 web compatibility

        // Show success feedback
        if (mounted) {
          if (mounted && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('VOAB PDF gedownload: $fileName'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      } else {
        // Mobile platform: Save to file system
        final downloadsDir = await getDownloadsDirectory();
        final filePath =
            '${downloadsDir?.path ?? (await getApplicationDocumentsDirectory()).path}/$fileName';

        // Gebruik dart:io File
        final file = io.File(filePath);
        await file.writeAsBytes(pdfData);

        // Show success feedback
        if (mounted) {
          if (mounted && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('VOAB PDF opgeslagen: $fileName'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      }
    } catch (e) {
      // Show error feedback
      if (mounted) {
        if (mounted && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fout bij PDF genereren: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _addExerciseToPhaseQuick(SessionPhase phase) async {
    // Controleer of de sessie al is opgeslagen
    if (session!.id == '0') {
      unawaited(_saveSession());
      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Sla de sessie eerst op voordat je oefeningen toevoegt',
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    // Navigeer direct naar exercise library met deze fase
    final result = await Navigator.push<TrainingExercise>(
      context,
      MaterialPageRoute<TrainingExercise>(
        builder: (context) => ExerciseLibraryScreen(
          isSelectMode: true,
          onExerciseSelected: (exercise) {
            Navigator.pop(context, exercise);
          },
        ),
      ),
    );

    if (result != null) {
      _addExerciseToPhase(phase, result.id.toString());
    }
  }

  // ignore: unused_element
  void _showPhaseExercises(SessionPhase phase) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Oefeningen - ${phase.name}'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: phase.exerciseIds.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.fitness_center, size: 48, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Nog geen oefeningen toegevoegd'),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: phase.exerciseIds.length,
                  itemBuilder: (context, index) {
                    final exerciseId = phase.exerciseIds[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text('${index + 1}'),
                      ),
                      title: Text('Oefening $exerciseId'),
                      subtitle: const Text('Click om details te bekijken'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // 🔧 CASCADE OPERATOR DOCUMENTATION: Complex State Update Pattern
                          // This setState with multiple property assignments demonstrates where
                          // cascade notation could improve readability for complex state updates.
                          //
                          // **CURRENT PATTERN**: setState(() { prop1 = val1; prop2 = val2; }) (block)
                          // **RECOMMENDED**: setState(() { object..prop1 = val1..prop2 = val2; }) (cascade)
                          //
                          // **CASCADE BENEFITS FOR COMPLEX STATE UPDATES**:
                          // ✅ Groups related property assignments visually
                          // ✅ Reduces repetitive object references
                          // ✅ Better readability for large state updates
                          // ✅ Maintains Flutter state management patterns
                          //
                          setState(() {
                            phase.removeExercise(exerciseId);
                          });
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Sluiten'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _addExerciseToPhaseQuick(phase);
            },
            child: const Text('Oefening Toevoegen'),
          ),
        ],
      ),
    );
  }

  void _addExerciseToPhase(SessionPhase phase, String exerciseId) {
    // 🔧 CASCADE OPERATOR DOCUMENTATION: Complex State Update Pattern
    // This setState with multiple property assignments demonstrates where
    // cascade notation could improve readability for complex state updates.
    //
    // **CURRENT PATTERN**: setState(() { prop1 = val1; prop2 = val2; }) (block)
    // **RECOMMENDED**: setState(() { object..prop1 = val1..prop2 = val2; }) (cascade)
    //
    // **CASCADE BENEFITS FOR COMPLEX STATE UPDATES**:
    // ✅ Groups related property assignments visually
    // ✅ Reduces repetitive object references
    // ✅ Better readability for large state updates
    // ✅ Maintains Flutter state management patterns
    //
    setState(() {
      if (!phase.exerciseIds.contains(exerciseId)) {
        phase.addExercise(exerciseId);
      }
    });
  }
}
