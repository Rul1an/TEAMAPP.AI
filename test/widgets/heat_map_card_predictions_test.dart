import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jo17_tactical_manager/controllers/heat_map_controller.dart';
import 'package:jo17_tactical_manager/models/action_event.dart';
import 'package:jo17_tactical_manager/screens/analytics/widgets/heat_map_card.dart';
import 'package:jo17_tactical_manager/widgets/analytics/heat_map_painter.dart';

class _StubHeatMapController extends HeatMapController {
  @override
  Future<List<ActionEvent>> build() async => <ActionEvent>[
        ActionEvent(
          id: 's1',
          matchId: 'm',
          x: 0.9,
          y: 0.5,
          type: ActionType.shot,
          timestamp: DateTime(2025),
        ),
        ActionEvent(
          id: 'k1',
          matchId: 'm',
          x: 0.8,
          y: 0.4,
          type: ActionType.passKey,
          timestamp: DateTime(2025),
        ),
      ];
}

void main() {
  testWidgets('HeatMapCard predictions toggle renders without error',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          heatMapControllerProvider.overrideWith(_StubHeatMapController.new),
        ],
        child: const MaterialApp(home: Scaffold(body: HeatMapCard())),
      ),
    );

    // Initial render
    await tester.pumpAndSettle();

    // Toggle predictions on
    final Finder toggle = find.byType(Switch);
    expect(toggle, findsOneWidget);
    await tester.tap(toggle);
    await tester.pumpAndSettle();

    // If we reached here, predictions rendering path did not throw
    // Assert that at least one CustomPaint uses our HeatMapPainter
    final painterFinder = find.byWidgetPredicate(
      (w) => w is CustomPaint && w.painter is HeatMapPainter,
    );
    expect(painterFinder, findsWidgets);
  });
}
