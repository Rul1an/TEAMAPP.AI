// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/screens/training_sessions/widgets/session_builder_wizard.dart';

void main() {
  group('SessionBuilderWizard', () {
    testWidgets('navigates between steps and calls onFinished', (tester) async {
      var finished = false;
      await tester.pumpWidget(
        MaterialApp(
          home: SessionBuilderWizard(
            stepTitles: ['A', 'B'],
            stepBuilders: [
              (_) => Center(child: Text('StepA')),
              (_) => Center(child: Text('StepB')),
            ],
            onFinished: () => finished = true,
          ),
        ),
      );

      // Initial step visible
      expect(find.text('StepA'), findsOneWidget);

      // Tap next (ElevatedButton)
      await tester.tap(find.text('Volgende'));
      await tester.pumpAndSettle();

      expect(find.text('StepB'), findsOneWidget);

      // Finish
      await tester.tap(find.text('Opslaan'));
      await tester.pumpAndSettle();

      expect(finished, isTrue);
    });
  });
}
