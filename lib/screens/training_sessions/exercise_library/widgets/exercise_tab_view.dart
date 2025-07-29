// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../../../models/annual_planning/morphocycle.dart';
import '../../../../models/training_session/training_exercise.dart';
import '../exercise_library_controller.dart';

/// Displays the tab content for the Exercise Library (Recommended, Intensity,
/// Tactical Focus, All) using the currently filtered exercises from
/// [ExerciseLibraryController].
class ExerciseTabView extends ConsumerWidget {
  const ExerciseTabView({
    required this.tabController,
    required this.morphocycle,
    super.key,
    this.onExerciseSelected,
    this.isSelectMode = false,
  });

  final TabController tabController;
  final Morphocycle? morphocycle;
  final void Function(TrainingExercise)? onExerciseSelected;
  final bool isSelectMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(exerciseLibraryControllerProvider.notifier);

    // FIXED: Get exercises from the exercise library service directly
    final allExercises =
        <TrainingExercise>[]; // TODO(exercise-library): Connect to exercise library service
    final exercises = controller.getFilteredExercises(allExercises);

    return TabBarView(
      controller: tabController,
      children: [
        _buildRecommendedTab(context, exercises),
        _buildIntensityTab(context, exercises),
        _buildFocusTab(context, exercises),
        _buildAllTab(context, exercises),
      ],
    );
  }

  Widget _buildRecommendedTab(
    BuildContext context,
    List<TrainingExercise> exercises,
  ) {
    if (morphocycle == null) {
      return const Center(child: Text('No morphocycle data'));
    }

    // Simple grouping by training intensity thresholds.
    final groups = <String, List<TrainingExercise>>{
      'Recovery (≤3)': exercises.where((e) => e.primaryIntensity <= 3).toList(),
      'Activation (4–6)': exercises
          .where((e) => e.primaryIntensity >= 4 && e.primaryIntensity <= 6)
          .toList(),
      'Development (5–7)': exercises
          .where((e) => e.primaryIntensity >= 5 && e.primaryIntensity <= 7)
          .toList(),
      'Acquisition (≥8)':
          exercises.where((e) => e.primaryIntensity >= 8).toList(),
    };

    return _buildGroupedList(context, groups);
  }

  Widget _buildIntensityTab(
    BuildContext context,
    List<TrainingExercise> exercises,
  ) {
    final groups = <String, List<TrainingExercise>>{};
    for (final intensity in TrainingIntensity.values) {
      final label = _intensityLabel(intensity);
      groups[label] = exercises.where((e) {
        switch (intensity) {
          case TrainingIntensity.recovery:
            return e.primaryIntensity <= 3;
          case TrainingIntensity.acquisition:
            return e.primaryIntensity >= 8;
          case TrainingIntensity.development:
            return e.primaryIntensity >= 5 && e.primaryIntensity <= 7;
          case TrainingIntensity.activation:
            return e.primaryIntensity >= 4 && e.primaryIntensity <= 6;
          case TrainingIntensity.competition:
            return e.primaryIntensity >= 9;
        }
      }).toList();
    }
    return _buildGroupedList(context, groups);
  }

  Widget _buildFocusTab(
    BuildContext context,
    List<TrainingExercise> exercises,
  ) {
    final groups = <String, List<TrainingExercise>>{};
    for (final focus in TacticalFocus.values) {
      groups[focus.displayName] =
          exercises.where((e) => e.tacticalFocus == focus).toList();
    }
    return _buildGroupedList(context, groups);
  }

  Widget _buildAllTab(BuildContext context, List<TrainingExercise> exercises) {
    return _buildExerciseList(context, exercises);
  }

  Widget _buildGroupedList(
    BuildContext context,
    Map<String, List<TrainingExercise>> groups,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: groups.entries.where((e) => e.value.isNotEmpty).map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.key,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildExerciseList(context, entry.value),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildExerciseList(
    BuildContext context,
    List<TrainingExercise> exercises,
  ) {
    if (exercises.isEmpty) {
      return const Center(child: Text('No exercises'));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: exercises.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        return ListTile(
          title: Text(exercise.name),
          subtitle: Text(
            '${exercise.durationMinutes} min • ${exercise.category.displayName}',
          ),
          onTap: isSelectMode ? () => onExerciseSelected?.call(exercise) : null,
          trailing: isSelectMode ? const Icon(Icons.check) : null,
        );
      },
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
