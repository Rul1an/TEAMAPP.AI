// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Player Development Dialog - Placeholder
///
/// Shows player development analytics in a modal dialog.
/// This is a placeholder that will be fully implemented in Phase 4.
///
/// Part of the Clean Architecture refactor from 892 LOC performance_analytics_screen.dart
class PlayerDevelopmentDialog extends ConsumerWidget {
  const PlayerDevelopmentDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.trending_up, color: Colors.blue),
          SizedBox(width: 8),
          Text('Speler Ontwikkeling'),
        ],
      ),
      content: const SizedBox(
        width: 400,
        height: 300,
        child: Center(
          child: Text('Player Development Dialog - To be implemented'),
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
