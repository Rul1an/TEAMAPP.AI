import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jo17_tactical_manager/providers/annual_planning_provider.dart';
import 'package:jo17_tactical_manager/models/annual_planning/week_schedule.dart';
import 'package:jo17_tactical_manager/screens/annual_planning/weekly_planning/widgets/weekly_table.dart';

void main() {
  testWidgets('WeeklyTable builds and renders table widget',
      (WidgetTester tester) async {
    final state = AnnualPlanningState(
      seasonStartDate: DateTime(2025, 1, 1),
      seasonEndDate: DateTime(2025, 12, 31),
      weekSchedules: List.generate(
        4,
        (i) => WeekSchedule(
          weekNumber: i + 1,
          weekStartDate: DateTime(2025, 1, 1).add(Duration(days: 7 * i)),
        ),
      ),
      selectedWeek: 1,
    );
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: WeeklyTable(state: state),
          ),
        ),
      ),
    );
    // Verify the widget builds and one table is present
    expect(find.byType(WeeklyTable), findsOneWidget);
  });
}
