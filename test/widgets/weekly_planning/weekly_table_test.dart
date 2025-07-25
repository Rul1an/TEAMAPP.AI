import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jo17_tactical_manager/providers/annual_planning_provider.dart';
import 'package:jo17_tactical_manager/models/annual_planning/week_schedule.dart';
import 'package:jo17_tactical_manager/screens/annual_planning/weekly_planning/widgets/weekly_table.dart';

void main() {
  testWidgets('WeeklyTable renders correct number of rows',
      (WidgetTester tester) async {
    final state = AnnualPlanningState(
      seasonStartDate: DateTime(2025, 1, 1),
      seasonEndDate: DateTime(2025, 12, 31),
      weekSchedules: List.generate(
          4,
          (i) => WeekSchedule(
                weekNumber: i + 1,
                weekStartDate: DateTime(2025, 1, 1).add(Duration(days: 7 * i)),
              )),
      selectedWeek: 1,
    );

    final notifier = AnnualPlanningNotifier();
    notifier.state = state;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: WeeklyTable(state: state),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsNWidgets(4));
    for (var i = 1; i <= 4; i++) {
      expect(find.text('Week $i'), findsOneWidget);
    }
  });
}
