// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../models/training_session/training_exercise.dart';
import '../../../../services/exercise_library_service.dart';
import 'exercise_detail_dialog.dart';

/// Reusable exercise card widget
class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    super.key,
    required this.exercise,
    this.onTap,
  });

  final TrainingExercise exercise;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap ?? () => _showExerciseDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 8),
              _buildTitle(),
              const SizedBox(height: 4),
              _buildDescription(),
              const Spacer(),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: ExerciseLibraryService.getIntensityColorFromLevel(
              exercise.intensityLevel,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${exercise.intensityLevel.toInt()}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: ExerciseLibraryService.getTypeColor(exercise.type),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            exercise.type.name[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Spacer(),
        Text(
          '${exercise.durationMinutes}m',
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      exercise.name,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription() {
    return Text(
      exercise.description.isEmpty ? 'No description' : exercise.description,
      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${exercise.playerCount} players',
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
        const Row(
          children: [
            Icon(Icons.star, size: 12, color: Colors.amber),
            Text(
              '4.2',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  void _showExerciseDetails(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => ExerciseDetailDialog(exercise: exercise),
    );
  }
}
