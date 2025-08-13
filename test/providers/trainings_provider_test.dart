import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jo17_tactical_manager/core/result.dart';
import 'package:jo17_tactical_manager/models/training.dart';
import 'package:jo17_tactical_manager/providers/trainings_provider.dart';
import 'package:jo17_tactical_manager/repositories/training_repository.dart';

class _FakeRepo implements TrainingRepository {
  _FakeRepo(this._list);
  List<Training>? _list;
  @override
  Future<Result<void>> add(Training training) async => const Success(null);
  @override
  Future<Result<void>> delete(String id) async => const Success(null);
  @override
  Future<Result<List<Training>>> getAll() async =>
      _list == null ? const Failure(NetworkFailure('x')) : Success(_list!);
  @override
  Future<Result<Training?>> getById(String id) async => const Success(null);
  @override
  Future<Result<List<Training>>> getByDateRange(DateTime s, DateTime e) async =>
      const Success([]);
  @override
  Future<Result<List<Training>>> getUpcoming() async => const Success([]);
  @override
  Future<Result<void>> update(Training training) async => const Success(null);
}

void main() {
  test('trainingsProvider returns empty list on failure (UI-safe)', () async {
    final container = ProviderContainer(
      overrides: [
        trainingRepositoryProvider.overrideWithValue(_FakeRepo(null)),
      ],
    );
    addTearDown(container.dispose);

    final result = await container.read(trainingsProvider.future);
    expect(result, isA<List<Training>>());
    expect(result, isEmpty);
  });
}
