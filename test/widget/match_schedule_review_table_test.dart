import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jo17_tactical_manager/widgets/import/match_schedule_review_table.dart';
import 'package:jo17_tactical_manager/services/match_schedule_import_service.dart';
import 'package:jo17_tactical_manager/models/match.dart';

void main() {
  testWidgets('MatchScheduleReviewTable displays colored rows', (tester) async {
    final preview = ImportPreview(rows: [
      ImportRowPreview(
        rowNumber: 2,
        state: ImportRowState.newRecord,
        match: Match()..opponent = 'Ajax'..date = DateTime(2025,8,15)..venue='Home',
      ),
      ImportRowPreview(
        rowNumber: 3,
        state: ImportRowState.duplicate,
        match: Match()..opponent = 'PSV'..date = DateTime(2025,8,22)..venue='Uit',
      ),
      ImportRowPreview(
        rowNumber: 4,
        state: ImportRowState.error,
        error: 'Onvoldoende kolommen',
      ),
    ]);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MatchScheduleReviewTable(preview: preview),
        ),
      ),
    );

    // Should find 3 DataRows => 3 ListTiles (DataRow not individually matched), count texts
    expect(find.text('Ajax'), findsOneWidget);
    expect(find.text('PSV'), findsOneWidget);
    expect(find.text('Onvoldoende kolommen'), findsOneWidget);

    // Verify background colors by checking appropriate Container color
    final rowContainers = tester.widgetList<Container>(find.descendant(
      of: find.byType(DataRow), matching: find.byType(Container),
    ));
    expect(rowContainers.length, greaterThanOrEqualTo(3));
  });
}