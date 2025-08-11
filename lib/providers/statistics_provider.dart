// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../models/statistics.dart';
import '../repositories/local_statistics_repository.dart';
import '../repositories/statistics_repository.dart';

/// 2025 Best Practice: Statistics Repository Provider
final statisticsRepositoryProvider = Provider<StatisticsRepository>((ref) {
  return LocalStatisticsRepository();
});

/// Legacy provider for backwards compatibility
/// Returns Map<String, dynamic> but now with safe defaults
final statisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repo = ref.read(statisticsRepositoryProvider);
  final res = await repo.getStatistics();
  return res.dataOrNull ?? const Statistics().toLegacyMap();
});

/// 2025 Best Practice: Type-safe Statistics Provider
/// Always returns valid Statistics object, never null
final typeSafeStatisticsProvider = FutureProvider<Statistics>((ref) async {
  final repo = ref.read(statisticsRepositoryProvider);
  final res = await repo.getStatistics();
  final legacy = res.dataOrNull;
  return legacy != null ? Statistics.fromLegacyMap(legacy) : const Statistics();
});

/// 2025 Best Practice: Statistics State Provider
/// Provides both data and loading/error states with proper type safety
final statisticsStateProvider =
    StateNotifierProvider<StatisticsNotifier, StatisticsState>((ref) {
  final repo = ref.read(statisticsRepositoryProvider);
  return StatisticsNotifier(repo);
});

/// 2025 Best Practice: Statistics State Management
class StatisticsState {
  const StatisticsState({
    required this.statistics,
    this.isLoading = false,
    this.error,
  });

  final Statistics statistics;
  final bool isLoading;
  final String? error;

  StatisticsState copyWith({
    Statistics? statistics,
    bool? isLoading,
    String? error,
  }) =>
      StatisticsState(
        statistics: statistics ?? this.statistics,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

/// 2025 Best Practice: Statistics State Notifier
class StatisticsNotifier extends StateNotifier<StatisticsState> {
  StatisticsNotifier(this._repository)
      : super(const StatisticsState(statistics: Statistics())) {
    refresh();
  }

  final StatisticsRepository _repository;

  /// Refresh statistics from repository
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _repository.getStatistics();
      final statistics = Statistics.fromLegacyMap(result.dataOrNull);
      state = state.copyWith(statistics: statistics, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load statistics: $e',
        statistics: const Statistics(), // Always provide safe fallback
      );
    }
  }

  /// Update statistics
  Future<void> updateStatistics(Statistics statistics) async {
    // Local-only update for now; repository is read-only interface
    state =
        state.copyWith(statistics: statistics, isLoading: false, error: null);
  }
}
