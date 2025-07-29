// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../../../models/training_session/training_exercise.dart';
import '../../../../services/exercise_library_service.dart';
import '../exercise_library_controller.dart';
import 'exercise_card.dart';

/// Tab showing all exercises in a grid
class AllExercisesTab extends ConsumerWidget {
  const AllExercisesTab({
    super.key,
    required this.exercises,
  });

  final List<TrainingExercise> exercises;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exerciseLibraryControllerProvider);
    final filteredExercises = ExerciseLibraryService.filterExercises(
      exercises,
      state.filterCriteria,
    );

    if (filteredExercises.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildHeader(filteredExercises),
        Expanded(child: _buildExerciseGrid(filteredExercises)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No exercises found'),
          Text('Try adjusting your filters'),
        ],
      ),
    );
  }

  Widget _buildHeader(List<TrainingExercise> filteredExercises) {
    final totalDuration = ExerciseLibraryService.calculateTotalDuration(filteredExercises);

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Row(
        children: [
          Text(
            '${filteredExercises.length} exercises found',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text('Total duration: $totalDuration min'),
        ],
      ),
    );
  }

  Widget _buildExerciseGrid(List<TrainingExercise> filteredExercises) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: filteredExercises.length,
      itemBuilder: (context, index) => ExerciseCard(
        exercise: filteredExercises[index],
      ),
    );
  }
}
