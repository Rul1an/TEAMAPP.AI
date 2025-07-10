import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jo17_tactical_manager/controllers/heat_map_controller.dart';
import 'package:jo17_tactical_manager/models/action_event.dart';
import 'package:jo17_tactical_manager/screens/analytics/widgets/heat_map_card.dart';

class _MockHeatMapNotifier extends StateNotifier<AsyncValue<List<ActionEvent>>> {
  _MockHeatMapNotifier()
      : super(AsyncData([
          ActionEvent(
            id: '1',
            matchId: 'm',
            x: 0.1,
            y: 0.1,
            type: ActionType.touch,
            timestamp: DateTime.now(),
          ),
        ]));

  int loadCalls = 0;

  Future<void> load(HeatMapParams params) async {
    loadCalls += 1;
    // return same state for simplicity
  }
}

void main() {
  testWidgets('HeatMapCard calls load on filter change', (tester) async {
    final mockNotifier = _MockHeatMapNotifier();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          heatMapControllerProvider.overrideWith((ref) => mockNotifier),
        ],
        child: const MaterialApp(home: Scaffold(body: HeatMapCard())),
      ),
    );

    await tester.pumpAndSettle();
    expect(mockNotifier.loadCalls, 0);

    // open category dropdown and select next option
    await tester.tap(find.byType(DropdownButton<ActionCategory>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text(ActionCategory.offensive.name).last);
    await tester.pumpAndSettle();

    expect(mockNotifier.loadCalls, 1);
  });
}