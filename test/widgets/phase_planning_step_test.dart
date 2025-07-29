import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:jo17_tactical_manager/screens/training_sessions/widgets/phase_planning_step.dart';
import 'package:jo17_tactical_manager/models/training_session/session_phase.dart';

void main() {
  testWidgets('PhasePlanningStep shows phases and total time', (tester) async {
    final phases = [
      SessionPhase()
        ..name = 'Warming-up'
        ..type = PhaseType.warmup
        ..startTime = DateTime(2024, 1, 1, 18)
        ..endTime = DateTime(2024, 1, 1, 18, 10),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: PhasePlanningStep(
          phases: phases,
          onReorder: (_, __) {},
          onAddPhase: () {},
          onEditPhase: (_) {},
          onDeletePhase: (_) {},
          totalDuration: 10,
        ),
      ),
    );

    expect(find.text('Fase Planning'), findsOneWidget);
    expect(find.text('Totale Tijd: 10 minuten'), findsOneWidget);
    expect(find.text('Warming-up'), findsOneWidget);
  });
}
