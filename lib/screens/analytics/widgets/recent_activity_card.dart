import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/assessment.dart';
import '../../../models/training_session/training_session.dart';

class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({
    super.key,
    required this.assessmentsAsync,
    required this.trainingsAsync,
  });

  final AsyncValue<List<PlayerAssessment>> assessmentsAsync;
  final AsyncValue<List<TrainingSession>> trainingsAsync;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recente Activiteit', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _label(context, 'Laatste beoordelingen', assessmentsAsync)),
                Expanded(child: _label(context, 'Trainingen', trainingsAsync)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(BuildContext ctx, String caption, AsyncValue<List<dynamic>> async) => async.when(
        data: (list) => Text('$caption: ${list.length}', style: const TextStyle(fontSize: 14)),
        loading: () => const Text('Laden...'),
        error: (_, __) => const Text('Error'),
      );
}