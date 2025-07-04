import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:jo17_tactical_manager/data/supabase_training_data_source.dart';
import 'package:jo17_tactical_manager/hive/hive_training_cache.dart';
import 'package:jo17_tactical_manager/models/training.dart';
import 'package:jo17_tactical_manager/repositories/training_repository_impl.dart';

class _MockRemote extends Mock implements SupabaseTrainingDataSource {}

class _MockCache extends Mock implements HiveTrainingCache {}

void main() {
  group('TrainingRepositoryImpl', () {
    late _MockRemote remote;
    late _MockCache cache;
    late TrainingRepositoryImpl repo;
    final sample = [
      Training()
        ..id = 't1'
        ..date = DateTime.now()
        ..duration = 90
        ..focus = TrainingFocus.technical
        ..intensity = TrainingIntensity.medium,
    ];

    setUp(() {
      remote = _MockRemote();
      cache = _MockCache();
      repo = TrainingRepositoryImpl(remote: remote, cache: cache);
      registerFallbackValue(Training());
    });

    test('returns remote data and writes to cache on success', () async {
      when(() => remote.fetchAll()).thenAnswer((_) async => sample);
      when(() => cache.write(sample)).thenAnswer((_) async {});

      final res = await repo.getAll();

      expect(res.isSuccess, isTrue);
      expect(res.dataOrNull, sample);
      verify(() => cache.write(sample)).called(1);
    });

    test('falls back to cache when remote fails', () async {
      when(() => remote.fetchAll()).thenThrow(Exception('network'));
      when(() => cache.read()).thenAnswer((_) async => sample);

      final res = await repo.getAll();

      expect(res.isSuccess, isTrue);
      expect(res.dataOrNull, sample);
    });

    test('propagates failure when both remote and cache fail', () async {
      when(() => remote.fetchAll()).thenThrow(Exception('network'));
      when(() => cache.read()).thenAnswer((_) async => null);

      final res = await repo.getAll();

      expect(res.isSuccess, isFalse);
      expect(res.errorOrNull, isNotNull);
    });

    test('add clears cache on success', () async {
      final t = sample.first;
      when(() => remote.add(t)).thenAnswer((_) async {});
      when(() => cache.clear()).thenAnswer((_) async {});

      final res = await repo.add(t);

      expect(res.isSuccess, isTrue);
      verify(() => cache.clear()).called(1);
    });
  });
}
