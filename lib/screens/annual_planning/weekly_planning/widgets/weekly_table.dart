// ignore_for_file: flutter_style_todos, unused_element_parameter
// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../../../models/annual_planning/week_schedule.dart';
import '../../../../providers/annual_planning_provider.dart';

/// Widget to display a table of week schedules
class WeeklyTable extends ConsumerWidget {
  final AnnualPlanningState state;
  const WeeklyTable({required this.state, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startWeek = ((state.selectedWeek - 1) ~/ 8) * 8 + 1;
    final endWeek = (startWeek + 7).clamp(1, state.totalWeeks);
    final weeksToShow = state.weekSchedules
        .where((w) => w.weekNumber >= startWeek && w.weekNumber <= endWeek)
        .toList();

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            // TODO(weekly_table): Replace with extracted header widget
            const SizedBox(height: 48),
            // Table rows
            ...weeksToShow.map((week) => _WeeklyTableRow(week: week)),
          ],
        ),
      ),
    );
  }
}

/// Placeholder for individual week row
class _WeeklyTableRow extends StatelessWidget {
  final WeekSchedule week;
  const _WeeklyTableRow({required this.week, super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(weekly_table): Render week schedule row
    return ListTile(
      title: Text('Week ${week.weekNumber}'),
      subtitle: Text(week.notes ?? ''),
    );
  }
}
