// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:jo17_tactical_manager/models/statistics.dart';
import 'package:jo17_tactical_manager/providers/profile_provider.dart';
import 'package:jo17_tactical_manager/providers/statistics_provider.dart';
import 'package:jo17_tactical_manager/repositories/profile_repository.dart';
import 'package:jo17_tactical_manager/repositories/statistics_repository.dart';
import 'package:jo17_tactical_manager/core/result.dart';

class _MockProfileRepo extends Mock implements ProfileRepository {}

class _MockStatsRepo extends Mock implements StatisticsRepository {}

void main() {
  test('currentProfileProvider returns null on failure (UI-safe)', () async {
    final repo = _MockProfileRepo();
    when(repo.watch).thenAnswer((_) => const Stream.empty());
    when(repo.getCurrent).thenAnswer((_) async => Failure(GenericFailure('x')));

    final container = ProviderContainer(overrides: [
      profileRepositoryProvider.overrideWithValue(repo),
    ]);

    addTearDown(container.dispose);

    // Build once
    final value = await container.read(currentProfileProvider.future);
    expect(value, isNull);
  });

  test('statisticsProvider returns safe defaults on failure (UI-safe)',
      () async {
    final repo = _MockStatsRepo();
    when(repo.getStatistics)
        .thenAnswer((_) async => Failure(GenericFailure('x')));

    final container = ProviderContainer(overrides: [
      statisticsRepositoryProvider.overrideWithValue(repo),
    ]);
    addTearDown(container.dispose);

    final legacy = await container.read(statisticsProvider.future);
    expect(legacy['totalMatches'], isA<int>());
  });

  test('typeSafeStatisticsProvider always returns a Statistics object',
      () async {
    final repo = _MockStatsRepo();
    when(repo.getStatistics)
        .thenAnswer((_) async => Failure(GenericFailure('x')));

    final container = ProviderContainer(overrides: [
      statisticsRepositoryProvider.overrideWithValue(repo),
    ]);
    addTearDown(container.dispose);

    final stats = await container.read(typeSafeStatisticsProvider.future);
    expect(stats, isA<Statistics>());
  });
}
