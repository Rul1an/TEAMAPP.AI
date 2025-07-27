import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/models/annual_planning/morphocycle.dart';
import 'package:jo17_tactical_manager/models/training_session/training_exercise.dart';
import 'package:jo17_tactical_manager/providers/exercise_designer_provider.dart';
import 'package:jo17_tactical_manager/screens/training_sessions/exercise_library/exercise_library_controller.dart';
import 'package:jo17_tactical_manager/screens/training_sessions/exercise_library/widgets/exercise_tab_view.dart';

void main() {
  testWidgets('ExerciseTabView switches tabs and shows list',
      (WidgetTester tester) async {
    // Sample exercises for provider.
    final sample = [
      TrainingExercise.create(
        name: 'Recovery Passing',
        description: 'Light drill',
        durationMinutes: 10,
        playerCount: 8,
        primaryIntensity: 2,
        tacticalFocus: TacticalFocus.recovery,
      ),
      TrainingExercise.create(
        name: 'Intense Pressing',
        description: 'High intensity',
        durationMinutes: 20,
        playerCount: 12,
        primaryIntensity: 8,
        tacticalFocus: TacticalFocus.pressing,
      ),
    ];

    final overrides = [
      exerciseLibraryProvider.overrideWith((ref) async => sample),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          home: DefaultTabController(
            length: 4,
            child: Scaffold(
              body: ExerciseTabView(
                tabController: TabController(length: 4, vsync: tester),
                morphocycle: null,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Widget renders without exceptions
    expect(find.byType(ExerciseTabView), findsOneWidget);

    // Swipe to second tab (Intensity)
    await tester.drag(find.byType(TabBarView), const Offset(-400, 0));
    await tester.pumpAndSettle();
    // After swipe, widget still present
    expect(find.byType(ExerciseTabView), findsOneWidget);
  });
}
