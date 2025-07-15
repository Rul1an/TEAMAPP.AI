import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jo17_tactical_manager/widgets/import/player_roster_review_table.dart';
import 'package:jo17_tactical_manager/services/player_roster_import_service.dart';
import 'package:jo17_tactical_manager/models/player.dart';

void main() {
  testWidgets('PlayerRosterReviewTable renders rows correctly', (tester) async {
    final preview = PlayerImportPreview(rows: [
      PlayerImportRowPreview(
        rowNumber: 2,
        state: ImportRowState.newRecord,
        player: Player()
          ..firstName = 'Jan'
          ..lastName = 'Jansen'
          ..jerseyNumber = 10
          ..birthDate = DateTime(2008, 3, 15)
          ..position = Position.midfielder
          ..preferredFoot = PreferredFoot.right,
      ),
      PlayerImportRowPreview(
        rowNumber: 3,
        state: ImportRowState.error,
        error: 'Onvoldoende kolommen',
      ),
    ]);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: PlayerRosterReviewTable(preview: preview)),
      ),
    );

    expect(find.text('Jan'), findsOneWidget);
    expect(find.text('Jansen'), findsOneWidget);
    expect(find.text('Onvoldoende kolommen'), findsOneWidget);
  });
}