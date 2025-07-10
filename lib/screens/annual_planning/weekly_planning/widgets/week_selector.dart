// ignore_for_file: always_put_required_named_parameters_first
// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../../../models/annual_planning/week_schedule.dart';
import '../../../../providers/annual_planning_provider.dart';

class WeekSelector extends ConsumerWidget {
  const WeekSelector({
    required this.state,
    required this.scrollController,
    super.key,
  });

  final AnnualPlanningState state;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
    height: 60,
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      controller: scrollController,
      itemCount: state.totalWeeks,
      itemBuilder: (context, index) {
        final weekNumber = index + 1;
        final isSelected = weekNumber == state.selectedWeek;
        final isCurrent = weekNumber == state.currentWeekNumber;
        final weekSchedule = state.weekSchedules
            .where((w) => w.weekNumber == weekNumber)
            .firstOrNull;

        final background = _getWeekColor(weekSchedule, isSelected, isCurrent);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: InkWell(
            onTap: () => ref
                .read(annualPlanningProvider.notifier)
                .selectWeek(weekNumber),
            child: Container(
              width: 60,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(8),
                border: isCurrent
                    ? Border.all(color: Colors.green, width: 2)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'W$weekNumber',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                  if (weekSchedule?.isVacation ?? false)
                    const Icon(
                      Icons.beach_access,
                      size: 12,
                      color: Colors.orange,
                    )
                  else if (weekSchedule?.hasActivities ?? false)
                    const Icon(
                      Icons.sports_soccer,
                      size: 12,
                      color: Colors.green,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );

  Color _getWeekColor(WeekSchedule? week, bool isSelected, bool isCurrent) {
    if (isSelected) return Colors.green[600]!;
    if (week?.isVacation ?? false) return Colors.orange[200]!;
    if (isCurrent) return Colors.green[100]!;
    if (week?.hasActivities ?? false) return Colors.blue[50]!;
    return Colors.grey[100]!;
  }
}
