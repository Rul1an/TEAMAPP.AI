// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../models/annual_planning/morphocycle.dart';
import 'exercise_library/exercise_library_view.dart';

/// Enhanced Exercise Library Screen - Refactored for maintainability
///
/// This screen has been refactored from 916 LOC to <100 LOC using the proven
/// SessionBuilder widget extraction pattern. All UI logic has been moved to
/// specialized widgets in the exercise_library/ folder.
class EnhancedExerciseLibraryScreen extends ConsumerWidget {
  const EnhancedExerciseLibraryScreen({
    super.key,
    this.filterIntensity,
    this.weekNumber = 1,
  });

  final TrainingIntensity? filterIntensity;
  final int weekNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ExerciseLibraryView(
      filterIntensity: filterIntensity,
      weekNumber: weekNumber,
    );
  }
}
