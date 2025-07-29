// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../../models/annual_planning/morphocycle.dart';
import '../../../models/training_session/training_exercise.dart';

/// Filter criteria for exercise library
class ExerciseFilterCriteria {
  const ExerciseFilterCriteria({
    this.searchQuery = '',
    this.minDuration = 0,
    this.maxDuration = 120,
    this.playerCount = 18,
    this.intensityFilter,
    this.typeFilter,
  });

  final String searchQuery;
  final int minDuration;
  final int maxDuration;
  final int playerCount;
  final TrainingIntensity? intensityFilter;
  final ExerciseType? typeFilter;

  ExerciseFilterCriteria copyWith({
    String? searchQuery,
    int? minDuration,
    int? maxDuration,
    int? playerCount,
    TrainingIntensity? intensityFilter,
    ExerciseType? typeFilter,
  }) {
    return ExerciseFilterCriteria(
      searchQuery: searchQuery ?? this.searchQuery,
      minDuration: minDuration ?? this.minDuration,
      maxDuration: maxDuration ?? this.maxDuration,
      playerCount: playerCount ?? this.playerCount,
      intensityFilter: intensityFilter ?? this.intensityFilter,
      typeFilter: typeFilter ?? this.typeFilter,
    );
  }
}

/// State for exercise library screen
class ExerciseLibraryState {
  const ExerciseLibraryState({
    this.filterCriteria = const ExerciseFilterCriteria(),
    this.showMorphocycleRecommendations = true,
    this.selectedTabIndex = 0,
  });

  final ExerciseFilterCriteria filterCriteria;
  final bool showMorphocycleRecommendations;
  final int selectedTabIndex;

  // Convenience getters for backward compatibility
  String get searchQuery => filterCriteria.searchQuery;

  ExerciseLibraryState copyWith({
    ExerciseFilterCriteria? filterCriteria,
    bool? showMorphocycleRecommendations,
    int? selectedTabIndex,
  }) {
    return ExerciseLibraryState(
      filterCriteria: filterCriteria ?? this.filterCriteria,
      showMorphocycleRecommendations: showMorphocycleRecommendations ?? this.showMorphocycleRecommendations,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }
}

/// Controller for exercise library screen state management
class ExerciseLibraryController extends StateNotifier<ExerciseLibraryState> {
  ExerciseLibraryController() : super(const ExerciseLibraryState());

  /// Update search query filter
  void updateSearchQuery(String query) {
    state = state.copyWith(
      filterCriteria: state.filterCriteria.copyWith(searchQuery: query),
    );
  }

  /// Update player count filter
  void updatePlayerCount(int count) {
    state = state.copyWith(
      filterCriteria: state.filterCriteria.copyWith(playerCount: count),
    );
  }

  /// Update duration range filter
  void updateDurationRange(int minDuration, int maxDuration) {
    state = state.copyWith(
      filterCriteria: state.filterCriteria.copyWith(
        minDuration: minDuration,
        maxDuration: maxDuration,
      ),
    );
  }

  /// Update intensity filter
  void updateIntensityFilter(TrainingIntensity? intensity) {
    state = state.copyWith(
      filterCriteria: state.filterCriteria.copyWith(intensityFilter: intensity),
    );
  }

  /// Update exercise type filter
  void updateTypeFilter(ExerciseType? type) {
    state = state.copyWith(
      filterCriteria: state.filterCriteria.copyWith(typeFilter: type),
    );
  }

  /// Toggle morphocycle recommendations visibility
  void toggleMorphocycleRecommendations() {
    state = state.copyWith(
      showMorphocycleRecommendations: !state.showMorphocycleRecommendations,
    );
  }

  /// Update selected tab index
  void updateSelectedTab(int index) {
    state = state.copyWith(selectedTabIndex: index);
  }

  /// Reset all filters to default values
  void resetFilters() {
    state = state.copyWith(
      filterCriteria: const ExerciseFilterCriteria(),
    );
  }

  /// Get exercises filtered by current criteria
  List<TrainingExercise> getFilteredExercises(List<TrainingExercise> exercises) {
    return exercises.where((exercise) {
      final criteria = state.filterCriteria;

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
        // Convert TrainingIntensity to intensity level range
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

  /// Get exercises recommended for specific morphocycle
  List<TrainingExercise> getRecommendedForMorphocycle(
    List<TrainingExercise> exercises,
    Morphocycle? morphocycle,
  ) {
    if (morphocycle == null) return [];

    // Group exercises by intensity for morphocycle recommendations
    final recommendations = <String, List<TrainingExercise>>{
      'Recovery': exercises.where((e) => e.intensityLevel <= 3.0).toList(),
      'Acquisition': exercises.where((e) => e.intensityLevel >= 8.0).toList(),
      'Development': exercises
          .where((e) => e.intensityLevel >= 5.0 && e.intensityLevel <= 7.0)
          .toList(),
      'Activation': exercises
          .where((e) => e.intensityLevel >= 4.0 && e.intensityLevel <= 6.0)
          .toList(),
    };

    // Apply current filters to recommendations
    final filtered = <String, List<TrainingExercise>>{};
    for (final entry in recommendations.entries) {
      filtered[entry.key] = getFilteredExercises(entry.value);
    }

    return filtered.values.expand((list) => list).toList();
  }

  /// Calculate total duration of exercises
  int calculateTotalDuration(List<TrainingExercise> exercises) {
    return exercises.fold(0, (sum, exercise) => sum + exercise.durationMinutes.round());
  }

  /// Get intensity range for filter
  (double, double) _getIntensityRangeForFilter(TrainingIntensity intensity) {
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

/// Provider for exercise library controller
final exerciseLibraryControllerProvider =
    StateNotifierProvider<ExerciseLibraryController, ExerciseLibraryState>(
  (ref) => ExerciseLibraryController(),
);
