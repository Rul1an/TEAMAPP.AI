import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/assessment.dart';
import '../../../models/player.dart';
import '../../../models/training_session/training_session.dart';

class QuickStatsRow extends StatelessWidget {
  const QuickStatsRow({
    required this.playersAsync,
    required this.assessmentsAsync,
    required this.trainingsAsync,
    super.key,
  });

  final AsyncValue<List<Player>> playersAsync;
  final AsyncValue<List<PlayerAssessment>> assessmentsAsync;
  final AsyncValue<List<TrainingSession>> trainingsAsync;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _statCard(
          context,
          icon: Icons.people,
          color: Colors.blue,
          label: 'Spelers',
          countBuilder: () => playersAsync.when(
            data: (list) => list.length,
            loading: () => null,
            error: (_, __) => 0,
          ),
        ),
        const SizedBox(width: 12),
        _statCard(
          context,
          icon: Icons.assessment,
          color: Colors.green,
          label: 'Beoordelingen',
          countBuilder: () => assessmentsAsync.when(
            data: (list) => list.length,
            loading: () => null,
            error: (_, __) => 0,
          ),
        ),
        const SizedBox(width: 12),
        _statCard(
          context,
          icon: Icons.sports,
          color: Colors.orange,
          label: 'Trainingen',
          countBuilder: () => trainingsAsync.when(
            data: (list) => list.length,
            loading: () => null,
            error: (_, __) => 0,
          ),
        ),
      ],
    );
  }

  Widget _statCard(
    BuildContext ctx, {
    required IconData icon,
    required Color color,
    required String label,
    required int? Function() countBuilder,
  }) {
    final count = countBuilder();
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                count != null ? '$count' : '...',
                style: Theme.of(ctx).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
