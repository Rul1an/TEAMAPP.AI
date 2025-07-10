// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../models/training_session/training_exercise.dart';
import '../../screens/training_sessions/exercise_library_screen.dart';

// import 'package:go_router/go_router.dart';

class ExerciseSelector extends StatefulWidget {
  const ExerciseSelector({
    required this.availableExercises,
    required this.selectedExercises,
    required this.onExerciseSelected,
    required this.onExerciseRemoved,
    super.key,
  });
  final List<TrainingExercise> availableExercises;
  final List<TrainingExercise> selectedExercises;
  final void Function(TrainingExercise) onExerciseSelected;
  final void Function(TrainingExercise) onExerciseRemoved;

  @override
  State<ExerciseSelector> createState() => _ExerciseSelectorState();
}

class _ExerciseSelectorState extends State<ExerciseSelector> {
  String searchQuery = '';
  ExerciseType? selectedType;

  @override
  Widget build(BuildContext context) {
    final filteredExercises = _filterExercises();

    return Column(
      children: [
        // Browse Exercise Library button
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _openExerciseLibrary,
              icon: const Icon(Icons.library_books),
              label: const Text('Browse Exercise Library'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),

        // Search and filter bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Search field
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Zoek oefeningen...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 8),

              // Type filter
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    FilterChip(
                      label: const Text('Alle'),
                      selected: selectedType == null,
                      onSelected: (selected) {
                        setState(() {
                          selectedType = null;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    ...ExerciseType.values.map(
                      (type) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(_getTypeDisplayName(type)),
                          selected: selectedType == type,
                          onSelected: (selected) {
                            setState(() {
                              selectedType = selected ? type : null;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Exercise list
        Expanded(
          child: ListView.builder(
            itemCount: filteredExercises.length,
            itemBuilder: (context, index) {
              final exercise = filteredExercises[index];
              final isSelected = widget.selectedExercises.contains(exercise);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getTypeColor(exercise.type),
                    child: Icon(
                      _getTypeIcon(exercise.type),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: Text(exercise.name),
                  subtitle: Text(
                    '${exercise.durationMinutes} min | ${_getTypeDisplayName(exercise.type)}',
                  ),
                  trailing: isSelected
                      ? IconButton(
                          icon: const Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                          onPressed: () => widget.onExerciseRemoved(exercise),
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.add_circle,
                            color: Colors.green,
                          ),
                          onPressed: () => widget.onExerciseSelected(exercise),
                        ),
                  onTap: () => _showExercisePreview(exercise),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<TrainingExercise> _filterExercises() => widget.availableExercises.where((
    exercise,
  ) {
    // Search filter
    if (searchQuery.isNotEmpty) {
      if (!exercise.name.toLowerCase().contains(searchQuery.toLowerCase()) &&
          !exercise.description.toLowerCase().contains(
            searchQuery.toLowerCase(),
          )) {
        return false;
      }
    }

    // Type filter
    if (selectedType != null && exercise.type != selectedType) {
      return false;
    }

    return true;
  }).toList();

  String _getTypeDisplayName(ExerciseType type) {
    switch (type) {
      case ExerciseType.technical:
        return 'Technisch';
      case ExerciseType.tactical:
        return 'Tactisch';
      case ExerciseType.physical:
        return 'Fysiek';
      case ExerciseType.goalkeeping:
        return 'Keeperswerk';
      case ExerciseType.psychological:
        return 'Mentaal';
      case ExerciseType.warmUp:
        return 'Warming-up';
      case ExerciseType.coolDown:
        return 'Cooling-down';
      case ExerciseType.smallSidedGame:
        return 'Klein Spel';
      case ExerciseType.smallSidedGames:
        return 'Klein Spel';
      case ExerciseType.conditioning:
        return 'Conditie';
      case ExerciseType.possession:
        return 'Balbezit';
      case ExerciseType.finishing:
        return 'Afwerken';
      case ExerciseType.defending:
        return 'Verdedigen';
      case ExerciseType.transition:
        return 'Omschakeling';
      case ExerciseType.warmup:
        return 'Warming-up';
      case ExerciseType.cooldown:
        return 'Cooling-down';
    }
  }

  Color _getTypeColor(ExerciseType type) {
    switch (type) {
      case ExerciseType.technical:
        return Colors.blue;
      case ExerciseType.tactical:
        return Colors.purple;
      case ExerciseType.physical:
        return Colors.red;
      case ExerciseType.goalkeeping:
        return Colors.yellow[700]!;
      case ExerciseType.psychological:
        return Colors.deepPurple;
      case ExerciseType.warmUp:
        return Colors.orange[300]!;
      case ExerciseType.coolDown:
        return Colors.lightBlue;
      case ExerciseType.smallSidedGame:
        return Colors.green;
      case ExerciseType.smallSidedGames:
        return Colors.green;
      case ExerciseType.conditioning:
        return Colors.orange;
      case ExerciseType.possession:
        return Colors.teal;
      case ExerciseType.finishing:
        return Colors.amber;
      case ExerciseType.defending:
        return Colors.indigo;
      case ExerciseType.transition:
        return Colors.pink;
      case ExerciseType.warmup:
        return Colors.orange[300]!;
      case ExerciseType.cooldown:
        return Colors.lightBlue;
    }
  }

  IconData _getTypeIcon(ExerciseType type) {
    switch (type) {
      case ExerciseType.technical:
        return Icons.precision_manufacturing;
      case ExerciseType.tactical:
        return Icons.psychology;
      case ExerciseType.physical:
        return Icons.fitness_center;
      case ExerciseType.goalkeeping:
        return Icons.sports_handball;
      case ExerciseType.psychological:
        return Icons.psychology_outlined;
      case ExerciseType.warmUp:
        return Icons.whatshot;
      case ExerciseType.coolDown:
        return Icons.ac_unit;
      case ExerciseType.smallSidedGame:
        return Icons.sports_soccer;
      case ExerciseType.smallSidedGames:
        return Icons.sports_soccer;
      case ExerciseType.conditioning:
        return Icons.directions_run;
      case ExerciseType.possession:
        return Icons.control_camera;
      case ExerciseType.finishing:
        return Icons.sports_score;
      case ExerciseType.defending:
        return Icons.shield;
      case ExerciseType.transition:
        return Icons.swap_horiz;
      case ExerciseType.warmup:
        return Icons.whatshot;
      case ExerciseType.cooldown:
        return Icons.ac_unit;
    }
  }

  void _showExercisePreview(TrainingExercise exercise) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(exercise.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (exercise.description.isNotEmpty) ...[
                Text(
                  'Beschrijving:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(exercise.description),
                const SizedBox(height: 12),
              ],
              Row(
                children: [
                  const Icon(Icons.timer, size: 16),
                  const SizedBox(width: 4),
                  Text('${exercise.durationMinutes} minuten'),
                  const SizedBox(width: 16),
                  Icon(_getTypeIcon(exercise.type), size: 16),
                  const SizedBox(width: 4),
                  Text(_getTypeDisplayName(exercise.type)),
                ],
              ),
              ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.trending_up, size: 16),
                    const SizedBox(width: 4),
                    Text('Intensiteit: ${exercise.intensityLevel}/10'),
                  ],
                ),
              ],
              if (exercise.coachingPoints.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Coaching Points:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                ...exercise.coachingPoints.map(
                  (point) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text('• $point'),
                  ),
                ),
              ],
              if (exercise.equipment.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Equipment:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(exercise.equipment),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Sluiten'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onExerciseSelected(exercise);
              Navigator.pop(context);
            },
            child: const Text('Toevoegen'),
          ),
        ],
      ),
    );
  }

  void _openExerciseLibrary() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ExerciseLibraryScreen(
          isSelectMode: true,
          onExerciseSelected: (exercise) {
            widget.onExerciseSelected(exercise);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
