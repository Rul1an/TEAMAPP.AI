// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Training Effectiveness Dialog - Placeholder
///
/// Shows training effectiveness analytics in a modal dialog.
/// This is a placeholder that will be fully implemented in Phase 4.
///
/// Part of the Clean Architecture refactor from 892 LOC performance_analytics_screen.dart
class TrainingEffectivenessDialog extends ConsumerWidget {
  const TrainingEffectivenessDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.fitness_center, color: Colors.green),
          SizedBox(width: 8),
          Text('Training Effectiviteit'),
        ],
      ),
      content: const SizedBox(
        width: 400,
        height: 300,
        child: Center(
          child: Text('Training Effectiveness Dialog - To be implemented'),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Sluiten'),
        ),
      ],
    );
  }
}
