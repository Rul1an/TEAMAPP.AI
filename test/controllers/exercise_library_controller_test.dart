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
        intensityLevel: 2,
      ),
      TrainingExercise.create(
        name: 'High Pass Drill',
        description: 'Intense passing sequence',
        durationMinutes: 20,
        playerCount: 12,
        intensityLevel: 8,
      ),
    ];

    setUp(() async {
      container = ProviderContainer();
      controller = container.read(exerciseLibraryControllerProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('search filter returns matching results', () {
      controller.updateSearchQuery('pass');
      final result = controller.getFilteredExercises(exercises);
      expect(result.length, 1);
      expect(result.first.name, contains('Pass'));
    });

    test('intensity filter returns low intensity exercise', () {
      controller.resetFilters();
      controller.updateIntensityFilter(TrainingIntensity.recovery);
      final result = controller.getFilteredExercises(exercises);
      expect(result.length, 1);
      expect(result.first.intensityLevel, lessThanOrEqualTo(3));
    });

    test('resetFilters clears all filters', () {
      controller.updateSearchQuery('Low');
      controller.updateIntensityFilter(TrainingIntensity.development);
      controller.resetFilters();
      final state = container.read(exerciseLibraryControllerProvider);
      expect(state.searchQuery, isEmpty);
      expect(state.filterCriteria.intensityFilter, isNull);
      expect(controller.getFilteredExercises(exercises).length, exercises.length);
    });
  });
}
