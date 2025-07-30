// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../exercise_library_controller.dart';

/// Dialog for filtering exercises
class ExerciseFilterDialog extends ConsumerStatefulWidget {
  const ExerciseFilterDialog({super.key});

  @override
  ConsumerState<ExerciseFilterDialog> createState() =>
      _ExerciseFilterDialogState();
}

class _ExerciseFilterDialogState extends ConsumerState<ExerciseFilterDialog> {
  late int _playerCount;
  late int _minDuration;
  late int _maxDuration;

  @override
  void initState() {
    super.initState();
    final state = ref.read(exerciseLibraryControllerProvider);
    final criteria = state.filterCriteria;
    _playerCount = criteria.playerCount;
    _minDuration = criteria.minDuration;
    _maxDuration = criteria.maxDuration;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Exercises'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPlayerCountSlider(),
          const SizedBox(height: 16),
          _buildDurationRangeSlider(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _resetFilters,
          child: const Text('Reset'),
        ),
        ElevatedButton(
          onPressed: _applyFilters,
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Widget _buildPlayerCountSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Player Count: $_playerCount'),
        Slider(
          value: _playerCount.toDouble(),
          min: 6,
          max: 22,
          divisions: 16,
          onChanged: (value) => setState(() => _playerCount = value.round()),
        ),
      ],
    );
  }

  Widget _buildDurationRangeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Duration: $_minDuration - $_maxDuration minutes'),
        RangeSlider(
          values: RangeValues(_minDuration.toDouble(), _maxDuration.toDouble()),
          min: 5,
          max: 120,
          divisions: 23,
          onChanged: (values) => setState(() {
            _minDuration = values.start.round();
            _maxDuration = values.end.round();
          }),
        ),
      ],
    );
  }

  void _resetFilters() {
    ref.read(exerciseLibraryControllerProvider.notifier).resetFilters();
    Navigator.pop(context);
  }

  void _applyFilters() {
    final controller = ref.read(exerciseLibraryControllerProvider.notifier);
    controller.updatePlayerCount(_playerCount);
    controller.updateDurationRange(_minDuration, _maxDuration);
    Navigator.pop(context);
  }
}
