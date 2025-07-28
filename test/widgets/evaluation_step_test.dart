import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/models/training_session/training_session.dart';
import 'package:jo17_tactical_manager/screens/training_sessions/widgets/evaluation_step.dart';

void main() {
  testWidgets('EvaluationStep shows summary info', (tester) async {
    final notesController = TextEditingController();
    await tester.pumpWidget(
      MaterialApp(
        home: EvaluationStep(
          selectedDate: DateTime(2025, 1, 1),
          trainingType: TrainingType.regularTraining,
          objective: 'Passing onder druk',
          totalDuration: 90,
          phaseCount: 5,
          notesController: notesController,
          onExportPdf: () {},
          onSave: () {},
        ),
      ),
    );

    expect(find.text('Sessie Overzicht'), findsOneWidget);
    expect(find.text('Reguliere Training'), findsOneWidget);
    expect(find.text('90 minuten'), findsOneWidget);
    expect(find.text('5 fasen'), findsOneWidget);
    expect(find.text('Passing onder druk'), findsOneWidget);
  });
}
