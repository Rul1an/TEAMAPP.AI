// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Team Overview Dialog - Placeholder
///
/// Shows team overview analytics in a modal dialog.
/// This is a placeholder that will be fully implemented in Phase 4.
///
/// Part of the Clean Architecture refactor from 892 LOC performance_analytics_screen.dart
class TeamOverviewDialog extends ConsumerWidget {
  const TeamOverviewDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.pie_chart, color: Colors.orange),
          SizedBox(width: 8),
          Text('Team Overzicht'),
        ],
      ),
      content: const SizedBox(
        width: 400,
        height: 300,
        child: Center(
          child: Text('Team Overview Dialog - To be implemented'),
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
