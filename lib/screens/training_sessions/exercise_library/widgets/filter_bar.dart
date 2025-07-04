import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/training_session/training_exercise.dart';
import '../../../../models/annual_planning/morphocycle.dart';
import '../exercise_library_controller.dart';

/// A horizontal bar that shows active exercise filters as chips and provides
/// a button to open a bottom-sheet filter configurator.
class ExerciseFilterBar extends ConsumerWidget {
  const ExerciseFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.watch(exerciseLibraryControllerProvider);

    // Build a list of chips for the currently active filters.
    final chips = <Widget>[];
    if (ctrl.category != null) {
      chips.add(
        _buildChip(
          context,
          label: ctrl.category!.displayName,
          onDeleted: () => ctrl.setCategory(null),
        ),
      );
    }
    if (ctrl.complexity != null) {
      chips.add(
        _buildChip(
          context,
          label: ctrl.complexity!.displayName,
          onDeleted: () => ctrl.setComplexity(null),
        ),
      );
    }
    if (ctrl.intensity != null) {
      chips.add(
        _buildChip(
          context,
          label: _intensityLabel(ctrl.intensity!),
          onDeleted: () => ctrl.setIntensity(null),
        ),
      );
    }
    if (ctrl.tacticalFocus != null) {
      chips.add(
        _buildChip(
          context,
          label: ctrl.tacticalFocus!.displayName,
          onDeleted: () => ctrl.setTacticalFocus(null),
        ),
      );
    }
    if (ctrl.minDuration != null || ctrl.maxDuration != null) {
      final min = ctrl.minDuration ?? 0;
      final max = ctrl.maxDuration ?? 120;
      chips.add(
        _buildChip(
          context,
          label: '$min-$max min',
          onDeleted: () => ctrl.setDurationRange(null, null),
        ),
      );
    }
    if (ctrl.playerCount != null) {
      chips.add(
        _buildChip(
          context,
          label: '${ctrl.playerCount} players',
          onDeleted: () => ctrl.setPlayerCount(null),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          ElevatedButton.icon(
            key: const Key('open_filter_dialog_button'),
            onPressed: () => _openFilterDialog(context, ctrl),
            icon: const Icon(Icons.filter_list),
            label: const Text('Filters'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.orange[600],
            ),
          ),
          const SizedBox(width: 8),
          // Wrap chips so they can flow if overflowed.
          Wrap(spacing: 6, children: chips),
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required String label,
    required VoidCallback onDeleted,
  }) {
    return InputChip(
      label: Text(label),
      onDeleted: onDeleted,
      deleteIcon: const Icon(Icons.close, size: 18),
      backgroundColor: Theme.of(context).chipTheme.backgroundColor,
    );
  }

  // Opens the bottom sheet that lets the user configure exercise filters.
  Future<void> _openFilterDialog(
    BuildContext context,
    ExerciseLibraryController ctrl,
  ) async {
    // Local mutable copies of current values
    var category = ctrl.category;
    var complexity = ctrl.complexity;
    var intensity = ctrl.intensity;
    var tacticalFocus = ctrl.tacticalFocus;
    var minDuration = ctrl.minDuration ?? 0;
    var maxDuration = ctrl.maxDuration ?? 120;
    var playerCount = ctrl.playerCount ?? 18;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text(
                    'Filter Exercises',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Category
              DropdownButtonFormField<ExerciseCategory?>(
                decoration: const InputDecoration(labelText: 'Category'),
                value: category,
                items: [
                  const DropdownMenuItem<ExerciseCategory?>(
                    child: Text('All'),
                  ),
                  ...ExerciseCategory.values.map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.displayName),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => category = value),
              ),
              const SizedBox(height: 12),
              // Complexity
              DropdownButtonFormField<ExerciseComplexity?>(
                decoration: const InputDecoration(labelText: 'Complexity'),
                value: complexity,
                items: [
                  const DropdownMenuItem<ExerciseComplexity?>(
                    child: Text('All'),
                  ),
                  ...ExerciseComplexity.values.map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.displayName),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => complexity = value),
              ),
              const SizedBox(height: 12),
              // Intensity
              DropdownButtonFormField<TrainingIntensity?>(
                decoration: const InputDecoration(labelText: 'Intensity'),
                value: intensity,
                items: [
                  const DropdownMenuItem<TrainingIntensity?>(
                    child: Text('All'),
                  ),
                  ...TrainingIntensity.values.map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(_intensityLabel(e)),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => intensity = value),
              ),
              const SizedBox(height: 12),
              // Tactical Focus
              DropdownButtonFormField<TacticalFocus?>(
                decoration: const InputDecoration(labelText: 'Tactical Focus'),
                value: tacticalFocus,
                items: [
                  const DropdownMenuItem<TacticalFocus?>(
                    child: Text('All'),
                  ),
                  ...TacticalFocus.values.map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.displayName),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => tacticalFocus = value),
              ),
              const SizedBox(height: 12),
              // Player count slider
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Player Count: $playerCount'),
                  Slider(
                    value: playerCount.toDouble(),
                    min: 6,
                    max: 22,
                    divisions: 16,
                    label: '$playerCount',
                    onChanged: (value) =>
                        setState(() => playerCount = value.round()),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Duration range
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Duration: $minDuration – $maxDuration min'),
                  RangeSlider(
                    values: RangeValues(
                      minDuration.toDouble(),
                      maxDuration.toDouble(),
                    ),
                    min: 5,
                    max: 120,
                    divisions: 23,
                    onChanged: (values) => setState(() {
                      minDuration = values.start.round();
                      maxDuration = values.end.round();
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        category = null;
                        complexity = null;
                        intensity = null;
                        tacticalFocus = null;
                        minDuration = 0;
                        maxDuration = 120;
                        playerCount = 18;
                      });
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ctrl.setCategory(category);
                      ctrl.setComplexity(complexity);
                      ctrl.setIntensity(intensity);
                      ctrl.setTacticalFocus(tacticalFocus);
                      ctrl.setDurationRange(minDuration, maxDuration);
                      ctrl.setPlayerCount(playerCount);
                      Navigator.pop(context);
                    },
                    child: const Text('Apply'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  static String _intensityLabel(TrainingIntensity intensity) {
    switch (intensity) {
      case TrainingIntensity.recovery:
        return 'Recovery';
      case TrainingIntensity.acquisition:
        return 'Acquisition';
      case TrainingIntensity.development:
        return 'Development';
      case TrainingIntensity.activation:
        return 'Activation';
      case TrainingIntensity.competition:
        return 'Competition';
    }
  }
}
