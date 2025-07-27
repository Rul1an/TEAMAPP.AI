import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jo17_tactical_manager/models/training_session/training_exercise.dart';
import 'package:jo17_tactical_manager/models/annual_planning/morphocycle.dart';
import 'package:jo17_tactical_manager/screens/training_sessions/exercise_library/exercise_library_controller.dart';
import 'package:jo17_tactical_manager/providers/exercise_designer_provider.dart';

void main() {
  group('ExerciseLibraryController', () {
    late ProviderContainer container;
    late ExerciseLibraryController controller;

    // Sample exercise fixtures
    final exercises = [
      TrainingExercise.create(
        name: 'Low Intensity Drill',
        description: 'Recovery passing',
        durationMinutes: 10,
        playerCount: 8,
        primaryIntensity: 2,
      ),
      TrainingExercise.create(
        name: 'High Pass Drill',
        description: 'Intense passing sequence',
        durationMinutes: 20,
        playerCount: 12,
        primaryIntensity: 8,
      ),
    ];

    setUp(() async {
      container = ProviderContainer(overrides: [
        exerciseLibraryProvider.overrideWith((ref) async => exercises),
      ]);
      controller = container.read(exerciseLibraryControllerProvider);
      await controller.loadExercises();
    });

    tearDown(() {
      container.dispose();
    });

    test('search filter returns matching results', () {
      controller.setSearch('pass');
      final result = controller.filteredExercises;
      expect(result.length, 1);
      expect(result.first.name, contains('Pass'));
    });

    test('intensity filter returns low intensity exercise', () {
      controller.resetFilters();
      controller.setIntensity(TrainingIntensity.recovery);
      final result = controller.filteredExercises;
      expect(result.length, 1);
      expect(result.first.primaryIntensity, lessThanOrEqualTo(3));
    });

    test('resetFilters clears all filters', () {
      controller.setSearch('Low');
      controller.setIntensity(TrainingIntensity.development);
      controller.resetFilters();
      expect(controller.search, isEmpty);
      expect(controller.intensity, isNull);
      expect(controller.filteredExercises.length, exercises.length);
    });
  });
}
