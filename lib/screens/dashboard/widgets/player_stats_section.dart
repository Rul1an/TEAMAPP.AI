// Basic placeholder implementation
import 'package:flutter/material.dart';

class PlayerStatsSection extends StatelessWidget {
  const PlayerStatsSection({
    super.key,
    required this.trainingCount,
    required this.matchCount,
  });

  final int trainingCount;
  final int matchCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _StatTile(label: 'Trainingen', value: trainingCount.toString()),
            _StatTile(label: 'Wedstrijden', value: matchCount.toString()),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
