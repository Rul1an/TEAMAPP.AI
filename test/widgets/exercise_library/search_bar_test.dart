import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/screens/training_sessions/exercise_library/widgets/search_bar.dart';
import 'package:jo17_tactical_manager/screens/training_sessions/exercise_library/exercise_library_controller.dart';
import 'package:jo17_tactical_manager/providers/exercise_designer_provider.dart';
import 'package:jo17_tactical_manager/models/training_session/training_exercise.dart';

void main() {
  testWidgets('ExerciseSearchBar updates controller search value',
      (WidgetTester tester) async {
    // Stub exercise provider so controller loads.
    final overrides = [
      exerciseLibraryProvider.overrideWith((ref) async => <TrainingExercise>[]),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: const MaterialApp(home: Scaffold(body: ExerciseSearchBar())),
      ),
    );

    // Keep controller alive during test
    final container = ProviderScope.containerOf(
      tester.element(find.byType(ExerciseSearchBar)),
    );
    container.listen(exerciseLibraryControllerProvider, (_, __) {},
        fireImmediately: true);

    // Enter text in search field.
    await tester.enterText(
        find.byKey(const Key('exercise_search_field')), 'drill');
    await tester.pumpAndSettle();

    // Verify controller state updated.
    final ctrl = container.read(exerciseLibraryControllerProvider);
    expect(ctrl.search, 'drill');
  });
}
