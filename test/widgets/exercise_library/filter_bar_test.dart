import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/models/annual_planning/morphocycle.dart';
import 'package:jo17_tactical_manager/models/training_session/training_exercise.dart';
import 'package:jo17_tactical_manager/screens/training_sessions/exercise_library/exercise_library_controller.dart';
import 'package:jo17_tactical_manager/screens/training_sessions/exercise_library/widgets/filter_bar.dart';
import 'package:jo17_tactical_manager/providers/exercise_designer_provider.dart';

void main() {
  testWidgets('ExerciseFilterBar displays intensity chip after setIntensity',
      (WidgetTester tester) async {
    final overrides = [
      exerciseLibraryProvider.overrideWith((ref) async => <TrainingExercise>[]),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: const MaterialApp(home: Scaffold(body: ExerciseFilterBar())),
      ),
    );

    // Update controller intensity.
    final container = ProviderScope.containerOf(
        tester.element(find.byType(ExerciseFilterBar)));
    final controller =
        container.read(exerciseLibraryControllerProvider.notifier);
    controller.updateIntensityFilter(TrainingIntensity.recovery);

    await tester.pumpAndSettle();

    // Expect chip with label 'Recovery'
    expect(find.text('Recovery'), findsOneWidget);
  });
}
