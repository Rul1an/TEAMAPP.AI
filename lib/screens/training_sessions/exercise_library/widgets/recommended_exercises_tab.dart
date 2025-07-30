// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../../../models/annual_planning/morphocycle.dart';
import '../../../../models/training_session/training_exercise.dart';
import '../../../../services/exercise_library_service.dart';
import '../exercise_library_controller.dart';
import 'exercise_card.dart';

/// Tab showing morphocycle-based exercise recommendations
class RecommendedExercisesTab extends ConsumerWidget {
  const RecommendedExercisesTab({
    super.key,
    required this.exercises,
    required this.morphocycle,
    required this.onViewAllTap,
  });

  final List<TrainingExercise> exercises;
  final Morphocycle? morphocycle;
  final VoidCallback onViewAllTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (morphocycle == null) {
      return const Center(
        child: Text('No morphocycle data available'),
      );
    }

    final state = ref.watch(exerciseLibraryControllerProvider);
    final recommendations =
        ExerciseLibraryService.getRecommendationsForMorphocycle(
      exercises,
      morphocycle!,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          ...recommendations.entries.map(
            (entry) => _buildRecommendationSection(
              context,
              entry.key,
              ExerciseLibraryService.filterExercises(
                  entry.value, state.filterCriteria),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      'Morphocycle-Based Recommendations',
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildRecommendationSection(
    BuildContext context,
    String title,
    List<TrainingExercise> exercises,
  ) {
    final color = ExerciseLibraryService.getIntensityColorFromName(title);
    final icon = ExerciseLibraryService.getIconForDayType(title);
    final description = ExerciseLibraryService.getDescriptionForDayType(title);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
              title, description, exercises.length, color, icon),
          const SizedBox(height: 12),
          _buildExerciseList(exercises),
          if (exercises.length > 6) _buildViewAllButton(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    String description,
    int count,
    Color color,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseList(List<TrainingExercise> exercises) {
    if (exercises.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: const Center(
          child: Text(
            'No matching exercises found.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: exercises.length > 6 ? 6 : exercises.length,
        itemBuilder: (context, index) => Container(
          width: 160,
          margin: const EdgeInsets.only(right: 12),
          child: ExerciseCard(exercise: exercises[index]),
        ),
      ),
    );
  }

  Widget _buildViewAllButton() {
    return TextButton(
      onPressed: onViewAllTap,
      child: const Text('View all exercises'),
    );
  }
}
