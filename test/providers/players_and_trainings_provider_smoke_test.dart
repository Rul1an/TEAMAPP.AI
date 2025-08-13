// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:jo17_tactical_manager/providers/players_provider.dart';
import 'package:jo17_tactical_manager/providers/trainings_provider.dart';
import 'package:jo17_tactical_manager/repositories/player_repository.dart';
import 'package:jo17_tactical_manager/repositories/training_repository.dart';
import 'package:jo17_tactical_manager/core/result.dart';

class _MockPlayerRepo extends Mock implements PlayerRepository {}

class _MockTrainingRepo extends Mock implements TrainingRepository {}

void main() {
  test('playersProvider returns [] on failure (UI-safe)', () async {
    final repo = _MockPlayerRepo();
    when(repo.getAll).thenAnswer((_) async => Failure(GenericFailure('x')));

    final container = ProviderContainer(overrides: [
      playerRepositoryProvider.overrideWithValue(repo),
    ]);
    addTearDown(container.dispose);

    final list = await container.read(playersProvider.future);
    expect(list, isEmpty);
  });

  test('playerByIdProvider returns null on failure (UI-safe)', () async {
    final repo = _MockPlayerRepo();
    when(() => repo.getById(any()))
        .thenAnswer((_) async => Failure(GenericFailure('x')));
    final container = ProviderContainer(overrides: [
      playerRepositoryProvider.overrideWithValue(repo),
    ]);
    addTearDown(container.dispose);
    final value = await container.read(playerByIdProvider('p1').future);
    expect(value, isNull);
  });

  test('trainingsProvider returns [] on failure (UI-safe)', () async {
    final repo = _MockTrainingRepo();
    when(repo.getAll).thenAnswer((_) async => Failure(GenericFailure('x')));
    final container = ProviderContainer(overrides: [
      trainingRepositoryProvider.overrideWithValue(repo),
    ]);
    addTearDown(container.dispose);
    final list = await container.read(trainingsProvider.future);
    expect(list, isEmpty);
  });

  test('upcomingTrainingsProvider returns [] on failure (UI-safe)', () async {
    final repo = _MockTrainingRepo();
    when(repo.getUpcoming)
        .thenAnswer((_) async => Failure(GenericFailure('x')));
    final container = ProviderContainer(overrides: [
      trainingRepositoryProvider.overrideWithValue(repo),
    ]);
    addTearDown(container.dispose);
    final list = await container.read(upcomingTrainingsProvider.future);
    expect(list, isEmpty);
  });
}
