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
    final state = ref.watch(exerciseLibraryControllerProvider);
    final controller = ref.read(exerciseLibraryControllerProvider.notifier);

    // Build a list of chips for the currently active filters.
    final chips = <Widget>[];
    final criteria = state.filterCriteria;

    if (criteria.typeFilter != null) {
      chips.add(
        _buildChip(
          context,
          label: criteria.typeFilter!.toString().split('.').last,
          onDeleted: () => controller.updateTypeFilter(null),
        ),
      );
    }
    if (criteria.intensityFilter != null) {
      chips.add(
        _buildChip(
          context,
          label: _intensityLabel(criteria.intensityFilter!),
          onDeleted: () => controller.updateIntensityFilter(null),
        ),
      );
    }
    if (criteria.minDuration > 0 || criteria.maxDuration < 120) {
      chips.add(
        _buildChip(
          context,
          label: '${criteria.minDuration}-${criteria.maxDuration} min',
          onDeleted: () => controller.updateDurationRange(0, 120),
        ),
      );
    }
    if (criteria.playerCount != 18) {
      chips.add(
        _buildChip(
          context,
          label: '${criteria.playerCount} players',
          onDeleted: () => controller.updatePlayerCount(18),
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
            onPressed: () => _openFilterDialog(context, controller, ref),
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
    ExerciseLibraryController controller,
    WidgetRef ref,
  ) async {
    // FIXED: Initialize with current filter values from controller state
    final currentState = ref.read(exerciseLibraryControllerProvider);
    final currentCriteria = currentState.filterCriteria;
    ExerciseType? typeFilter = currentCriteria.typeFilter;
    TrainingIntensity? intensityFilter = currentCriteria.intensityFilter;
    var minDuration = currentCriteria.minDuration;
    var maxDuration = currentCriteria.maxDuration;
    var playerCount = currentCriteria.playerCount;

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
              // Exercise Type
              DropdownButtonFormField<ExerciseType?>(
                decoration: const InputDecoration(labelText: 'Exercise Type'),
                value: typeFilter,
                items: [
                  const DropdownMenuItem<ExerciseType?>(child: Text('All')),
                  ...ExerciseType.values.map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.toString().split('.').last),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => typeFilter = value),
              ),
              const SizedBox(height: 12),
              // Intensity
              DropdownButtonFormField<TrainingIntensity?>(
                decoration: const InputDecoration(labelText: 'Intensity'),
                value: intensityFilter,
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
                onChanged: (value) => setState(() => intensityFilter = value),
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
                        typeFilter = null;
                        intensityFilter = null;
                        minDuration = 0;
                        maxDuration = 120;
                        playerCount = 18;
                      });
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.updateTypeFilter(typeFilter);
                      controller.updateIntensityFilter(intensityFilter);
                      controller.updateDurationRange(minDuration, maxDuration);
                      controller.updatePlayerCount(playerCount);
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
