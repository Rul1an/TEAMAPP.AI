import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jo17_tactical_manager/providers/annual_planning_provider.dart';
import 'package:jo17_tactical_manager/models/annual_planning/week_schedule.dart';
import 'package:jo17_tactical_manager/screens/annual_planning/weekly_planning/widgets/weekly_week_selector.dart';

void main() {
  testWidgets('WeeklyWeekSelector displays correct week labels',
      (WidgetTester tester) async {
    final state = AnnualPlanningState(
      seasonStartDate: DateTime(2025, 1, 1),
      seasonEndDate: DateTime(2025, 12, 31),
      weekSchedules: List.generate(
          3,
          (i) => WeekSchedule(
                weekNumber: i + 1,
                weekStartDate: DateTime(2025, 1, 1).add(Duration(days: 7 * i)),
              )),
      selectedWeek: 2,
    );

    final notifier = AnnualPlanningNotifier();
    notifier.state = state;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: WeeklyWeekSelector(
              state: state,
              scrollController: ScrollController(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('W1'), findsOneWidget);
    expect(find.text('W2'), findsOneWidget);
    expect(find.text('W3'), findsOneWidget);
  });
}
