// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../../../models/training_session/training_exercise.dart';
import '../../../../services/exercise_library_service.dart';
import '../exercise_library_controller.dart';
import 'exercise_card.dart';

/// Tab showing exercises grouped by intensity level
class IntensityExercisesTab extends ConsumerWidget {
  const IntensityExercisesTab({
    super.key,
    required this.exercises,
    required this.onViewAllTap,
  });

  final List<TrainingExercise> exercises;
  final VoidCallback onViewAllTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exerciseLibraryControllerProvider);
    final intensityGroups = ExerciseLibraryService.groupByIntensity(exercises);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: intensityGroups.entries
          .map(
            (entry) => _buildIntensitySection(
              context,
              entry.key,
              ExerciseLibraryService.filterExercises(entry.value, state.filterCriteria),
            ),
          )
          .toList(),
    );
  }

  Widget _buildIntensitySection(
    BuildContext context,
    String intensityName,
    List<TrainingExercise> exercises,
  ) {
    final color = ExerciseLibraryService.getIntensityColorFromName(intensityName);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(intensityName, exercises.length, color),
          const SizedBox(height: 12),
          _buildExerciseGrid(exercises),
          if (exercises.length > 4) _buildViewAllButton(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String intensityName, int count, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            intensityName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseGrid(List<TrainingExercise> exercises) {
    if (exercises.isEmpty) {
      return const Text('No exercises found');
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: exercises.length > 4 ? 4 : exercises.length,
      itemBuilder: (context, index) => ExerciseCard(exercise: exercises[index]),
    );
  }

  Widget _buildViewAllButton() {
    return TextButton(
      onPressed: onViewAllTap,
      child: const Text('View all exercises'),
    );
  }
}
