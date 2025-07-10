// ignore_for_file: always_put_required_named_parameters_first
// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../providers/annual_planning_provider.dart';

/// Header displaying season info and quick links for the Weekly Planning view.
class SeasonHeader extends StatelessWidget {
  const SeasonHeader({required this.state, super.key});

  final AnnualPlanningState state;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.green.shade600, Colors.green.shade700],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border(bottom: BorderSide(color: Colors.green.shade200)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seizoen ${state.seasonStartDate.year}/${state.seasonEndDate.year}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Week ${state.selectedWeek} van ${state.totalWeeks}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              _formatCurrentDate(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  static String _formatCurrentDate() {
    final now = DateTime.now();
    return '${now.day}-${now.month}-${now.year}';
  }
}
