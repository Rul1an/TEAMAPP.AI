import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/data/supabase_profile_data_source.dart';
import 'package:jo17_tactical_manager/hive/hive_profile_cache.dart';
import 'package:jo17_tactical_manager/models/profile.dart';
import 'package:jo17_tactical_manager/repositories/profile_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemote extends Mock implements SupabaseProfileDataSource {}

class _MockCache extends Mock implements HiveProfileCache {}

void main() {
  // Shared dummy profile
  final profile = Profile(
    userId: 'u1',
    organizationId: 'org1',
    username: 'john',
    createdAt: DateTime.utc(2024),
    updatedAt: DateTime.utc(2024),
  );

  group('ProfileRepositoryImpl', () {
    late _MockRemote remote;
    late _MockCache cache;
    late ProfileRepositoryImpl repo;

    setUpAll(() {
      registerFallbackValue(profile);
    });

    setUp(() {
      remote = _MockRemote();
      cache = _MockCache();
      repo = ProfileRepositoryImpl(remote: remote, cache: cache);
    });

    test('getCurrent returns remote data and writes to cache', () async {
      when(() => remote.fetchCurrent()).thenAnswer((_) async => profile);
      when(() => cache.write(profile)).thenAnswer((_) async {});

      final res = await repo.getCurrent();

      expect(res.dataOrNull, profile);
      verify(() => cache.write(profile)).called(1);
    });

    test('getCurrent falls back to cache on error', () async {
      when(() => remote.fetchCurrent()).thenThrow(Exception('network'));
      when(() => cache.read()).thenAnswer((_) async => profile);

      final res = await repo.getCurrent();

      expect(res.dataOrNull, profile);
      verify(() => cache.read()).called(1);
    });

    test('watch emits cached then remote updates', () async {
      when(() => cache.read()).thenAnswer((_) async => profile);

      // Stream controller for remote updates
      final controller = StreamController<Profile>();
      when(() => remote.subscribe()).thenAnswer((_) => controller.stream);
      when(() => cache.write(any())).thenAnswer((_) async {});

      // Collect first two events then cancel
      final stream = repo.watch().take(2).toList();

      // Emit remote update
      final updated = profile.copyWith(username: 'doe');
      controller.add(updated);
      await controller.close();

      final events = await stream;
      expect(events, [profile, updated]);
    });
  });
}
