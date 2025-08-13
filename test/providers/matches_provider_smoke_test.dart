// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:jo17_tactical_manager/providers/matches_provider.dart';
import 'package:jo17_tactical_manager/repositories/match_repository.dart';
import 'package:jo17_tactical_manager/core/result.dart';

class _MockMatchRepo extends Mock implements MatchRepository {}

void main() {
  test('matchesProvider returns [] on failure (UI-safe)', () async {
    final repo = _MockMatchRepo();
    when(repo.getAll).thenAnswer((_) async => Failure(GenericFailure('x')));

    final container = ProviderContainer(overrides: [
      matchRepositoryProvider.overrideWithValue(repo),
    ]);
    addTearDown(container.dispose);

    final list = await container.read(matchesProvider.future);
    expect(list, isEmpty);
  });

  test('upcomingMatchesProvider returns [] on failure (UI-safe)', () async {
    final repo = _MockMatchRepo();
    when(repo.getUpcoming)
        .thenAnswer((_) async => Failure(GenericFailure('x')));

    final container = ProviderContainer(overrides: [
      matchRepositoryProvider.overrideWithValue(repo),
    ]);
    addTearDown(container.dispose);

    final list = await container.read(upcomingMatchesProvider.future);
    expect(list, isEmpty);
  });

  test('recentMatchesProvider returns [] on failure (UI-safe)', () async {
    final repo = _MockMatchRepo();
    when(repo.getRecent).thenAnswer((_) async => Failure(GenericFailure('x')));

    final container = ProviderContainer(overrides: [
      matchRepositoryProvider.overrideWithValue(repo),
    ]);
    addTearDown(container.dispose);

    final list = await container.read(recentMatchesProvider.future);
    expect(list, isEmpty);
  });

  test('matchByIdProvider returns null on failure (UI-safe)', () async {
    final repo = _MockMatchRepo();
    when(() => repo.getById(any()))
        .thenAnswer((_) async => Failure(GenericFailure('x')));

    final container = ProviderContainer(overrides: [
      matchRepositoryProvider.overrideWithValue(repo),
    ]);
    addTearDown(container.dispose);

    final value = await container.read(matchByIdProvider('m1').future);
    expect(value, isNull);
  });
}
