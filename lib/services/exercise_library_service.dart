// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../models/annual_planning/morphocycle.dart';
import '../models/training_session/training_exercise.dart';
import '../screens/training_sessions/exercise_library/exercise_library_controller.dart';

/// Service class for exercise library business logic
class ExerciseLibraryService {
  /// Filter exercises based on provided criteria
  static List<TrainingExercise> filterExercises(
    List<TrainingExercise> exercises,
    ExerciseFilterCriteria criteria,
  ) {
    return exercises.where((exercise) {
      // Search query filter
      if (criteria.searchQuery.isNotEmpty) {
        final searchLower = criteria.searchQuery.toLowerCase();
        if (!exercise.name.toLowerCase().contains(searchLower) &&
            !exercise.description.toLowerCase().contains(searchLower)) {
          return false;
        }
      }

      // Duration filter
      if (exercise.durationMinutes < criteria.minDuration ||
          exercise.durationMinutes > criteria.maxDuration) {
        return false;
      }

      // Player count filter
      if (exercise.playerCount > criteria.playerCount) {
        return false;
      }

      // Intensity filter
      if (criteria.intensityFilter != null) {
        final intensityRange = _getIntensityRangeForFilter(criteria.intensityFilter!);
        if (exercise.intensityLevel < intensityRange.$1 ||
            exercise.intensityLevel > intensityRange.$2) {
          return false;
        }
      }

      // Type filter
      if (criteria.typeFilter != null && exercise.type != criteria.typeFilter) {
        return false;
      }

      return true;
    }).toList();
  }

  /// Group exercises by intensity level
  static Map<String, List<TrainingExercise>> groupByIntensity(
    List<TrainingExercise> exercises,
  ) {
    return {
      'Recovery (1-3)': exercises.where((e) => e.intensityLevel <= 3.0).toList(),
      'Activation (4-6)': exercises
          .where((e) => e.intensityLevel >= 4.0 && e.intensityLevel <= 6.0)
          .toList(),
      'Development (5-7)': exercises
          .where((e) => e.intensityLevel >= 5.0 && e.intensityLevel <= 7.0)
          .toList(),
      'Acquisition (8-10)': exercises.where((e) => e.intensityLevel >= 8.0).toList(),
    };
  }

  /// Group exercises by focus type
  static Map<String, List<TrainingExercise>> groupByFocus(
    List<TrainingExercise> exercises,
  ) {
    return {
      'Technical': exercises.where((e) => e.type == ExerciseType.technical).toList(),
      'Tactical': exercises.where((e) => e.type == ExerciseType.tactical).toList(),
      'Physical': exercises.where((e) => e.type == ExerciseType.physical).toList(),
      'Small Sided Games': exercises
          .where((e) => e.type == ExerciseType.smallSidedGames)
          .toList(),
    };
  }

  /// Get exercises recommended for specific morphocycle
  static Map<String, List<TrainingExercise>> getRecommendationsForMorphocycle(
    List<TrainingExercise> exercises,
    Morphocycle morphocycle,
  ) {
    return {
      'Recovery Day (Day +1)': exercises.where((e) => e.intensityLevel <= 3.0).toList(),
      'Acquisition Day (Day +2)': exercises.where((e) => e.intensityLevel >= 8.0).toList(),
      'Development Day (Day +3)': exercises
          .where((e) => e.intensityLevel >= 5.0 && e.intensityLevel <= 7.0)
          .toList(),
      'Activation Day (Day +4)': exercises
          .where((e) => e.intensityLevel >= 4.0 && e.intensityLevel <= 6.0)
          .toList(),
    };
  }

  /// Calculate total duration of exercises
  static int calculateTotalDuration(List<TrainingExercise> exercises) {
    return exercises.fold(0, (sum, exercise) => sum + exercise.durationMinutes.round());
  }

  /// Get color for intensity level
  static Color getIntensityColorFromLevel(double level) {
    if (level <= 3.0) return Colors.green;
    if (level <= 6.0) return Colors.blue;
    if (level <= 7.0) return Colors.orange;
    return Colors.red;
  }

  /// Get color for intensity name
  static Color getIntensityColorFromName(String name) {
    if (name.contains('Recovery')) return Colors.green;
    if (name.contains('Activation')) return Colors.blue;
    if (name.contains('Development')) return Colors.orange;
    return Colors.red;
  }

  /// Get color for focus name
  static Color getFocusColorFromName(String name) {
    switch (name.toLowerCase()) {
      case 'technical':
        return Colors.blue;
      case 'tactical':
        return Colors.red;
      case 'physical':
        return Colors.orange;
      case 'small sided games':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// Get color for exercise type
  static Color getTypeColor(ExerciseType type) {
    switch (type) {
      case ExerciseType.technical:
        return Colors.blue;
      case ExerciseType.tactical:
        return Colors.red;
      case ExerciseType.physical:
        return Colors.orange;
      case ExerciseType.smallSidedGames:
        return Colors.green;
      case ExerciseType.warmUp:
        return Colors.cyan;
      case ExerciseType.coolDown:
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  /// Get icon for morphocycle day type
  static IconData getIconForDayType(String dayType) {
    if (dayType.contains('Recovery')) return Icons.nature;
    if (dayType.contains('Acquisition')) return Icons.bolt;
    if (dayType.contains('Development')) return Icons.trending_up;
    if (dayType.contains('Activation')) return Icons.play_arrow;
    return Icons.fitness_center;
  }

  /// Get description for morphocycle day type
  static String getDescriptionForDayType(String dayType) {
    if (dayType.contains('Recovery')) return 'Low intensity, technical skills';
    if (dayType.contains('Acquisition')) return 'High intensity tactical work';
    if (dayType.contains('Development')) return 'Medium intensity development';
    if (dayType.contains('Activation')) return 'Match preparation';
    return 'Training exercises';
  }

  /// Get intensity range for filter
  static (double, double) _getIntensityRangeForFilter(TrainingIntensity intensity) {
    switch (intensity) {
      case TrainingIntensity.recovery:
        return (0.0, 3.0);
      case TrainingIntensity.activation:
        return (4.0, 6.0);
      case TrainingIntensity.development:
        return (5.0, 7.0);
      case TrainingIntensity.acquisition:
        return (8.0, 10.0);
      case TrainingIntensity.competition:
        return (9.0, 10.0);
    }
  }
}
