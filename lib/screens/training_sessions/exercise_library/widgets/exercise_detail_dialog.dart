// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../models/training_session/training_exercise.dart';

/// Dialog showing detailed exercise information
class ExerciseDetailDialog extends StatelessWidget {
  const ExerciseDetailDialog({
    super.key,
    required this.exercise,
  });

  final TrainingExercise exercise;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(exercise.name),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              exercise.description.isEmpty
                  ? 'No description available'
                  : exercise.description,
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Duration', '${exercise.durationMinutes} minutes'),
            _buildDetailRow('Players', '${exercise.playerCount}'),
            _buildDetailRow('Intensity', '${exercise.intensityLevel}/10'),
            _buildDetailRow('Type', exercise.type.name),
            if (exercise.equipment.isNotEmpty)
              _buildDetailRow('Equipment', exercise.equipment),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: () => _addExerciseToSession(context),
          child: const Text('Add to Session'),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _addExerciseToSession(BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${exercise.name} added to session (demo)'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
