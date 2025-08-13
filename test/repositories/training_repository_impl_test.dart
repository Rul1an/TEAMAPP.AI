// Dart imports:
import 'dart:io';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:jo17_tactical_manager/core/result.dart';
import 'package:jo17_tactical_manager/data/supabase_training_data_source.dart';
import 'package:jo17_tactical_manager/hive/hive_training_cache.dart';
import 'package:jo17_tactical_manager/models/training.dart';
import 'package:jo17_tactical_manager/repositories/training_repository_impl.dart';

class _MockRemote extends Mock implements SupabaseTrainingDataSource {}

class _MockCache extends Mock implements HiveTrainingCache {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(
      Training()
        ..id = 'fallback'
        ..date = DateTime.now()
        ..duration = 90
        ..focus = TrainingFocus.technical
        ..intensity = TrainingIntensity.medium
        ..status = TrainingStatus.planned
        ..trainingNumber = 1,
    );
  });

  late _MockRemote remote;
  late _MockCache cache;
  late TrainingRepositoryImpl repo;

  final now = DateTime.now();

  Training makeTraining({required String id, required DateTime date}) {
    return Training()
      ..id = id
      ..date = date
      ..duration = 90
      ..focus = TrainingFocus.technical
      ..intensity = TrainingIntensity.medium
      ..status = TrainingStatus.planned
      ..trainingNumber = 1;
  }

  late Training tUpcoming;
  late Training tPast;

  setUp(() {
    remote = _MockRemote();
    cache = _MockCache();
    repo = TrainingRepositoryImpl(remote: remote, cache: cache);

    tUpcoming = makeTraining(id: 'u1', date: now.add(const Duration(days: 1)));
    tPast = makeTraining(id: 'p1', date: now.subtract(const Duration(days: 1)));
  });

  group('getUpcoming', () {
    test('filters upcoming trainings from remote list', () async {
      when(() => remote.fetchAll()).thenAnswer((_) async => [tPast, tUpcoming]);
      when(() => cache.write(any())).thenAnswer((_) async {});

      final res = await repo.getUpcoming();

      expect(res.isSuccess, true);
      expect(res.dataOrNull, [tUpcoming]);
    });
  });

  group('getByDateRange', () {
    test('returns trainings within range', () async {
      when(() => remote.fetchAll()).thenAnswer((_) async => [tPast, tUpcoming]);
      when(() => cache.write(any())).thenAnswer((_) async {});

      final res = await repo.getByDateRange(
        now.subtract(const Duration(days: 2)),
        now.add(const Duration(days: 2)),
      );

      expect(res.isSuccess, true);
      expect(res.dataOrNull, [tPast, tUpcoming]);
    });
  });

  group('fallback to cache', () {
    test('uses cache on network failure', () async {
      when(() => remote.fetchAll()).thenThrow(const SocketException('down'));
      when(() => cache.read()).thenAnswer((_) async => [tPast]);

      final res = await repo.getAll();

      expect(res.isSuccess, true);
      expect(res.dataOrNull, [tPast]);
      verify(() => cache.read()).called(1);
    });

    test('returns Failure(NetworkFailure) when remote fails and cache miss',
        () async {
      when(() => remote.fetchAll()).thenThrow(const SocketException('down'));
      when(() => cache.read()).thenAnswer((_) async => null);

      final res = await repo.getAll();

      expect(res.isFailure, true);
      expect(res.errorOrNull, isA<NetworkFailure>());
    });
  });

  group('mutations', () {
    setUp(() {
      when(() => cache.clear()).thenAnswer((_) async {});
    });

    test('add clears cache on success', () async {
      when(() => remote.add(any())).thenAnswer((_) async {});

      final res = await repo.add(tUpcoming);

      expect(res.isSuccess, true);
      verify(() => cache.clear()).called(1);
    });
  });

  group('cache writes on success', () {
    test('getAll writes to cache on remote success', () async {
      when(() => remote.fetchAll()).thenAnswer((_) async => [tPast, tUpcoming]);
      when(() => cache.write(any())).thenAnswer((_) async {});

      final res = await repo.getAll();

      expect(res.isSuccess, true);
      verify(() => cache.write(any())).called(1);
    });
  });
}
