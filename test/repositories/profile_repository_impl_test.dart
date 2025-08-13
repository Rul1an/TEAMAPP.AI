// Dart imports:
import 'dart:io';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:jo17_tactical_manager/core/result.dart';
import 'package:jo17_tactical_manager/data/supabase_profile_data_source.dart';
import 'package:jo17_tactical_manager/hive/hive_profile_cache.dart';
import 'package:jo17_tactical_manager/models/profile.dart';
import 'package:jo17_tactical_manager/repositories/profile_repository_impl.dart';

class _FakeRemote extends Mock implements SupabaseProfileDataSource {}

class _FakeCache extends Mock implements HiveProfileCache {}

void main() {
  setUpAll(() {
    // Needed because we use any() with Profile and File in mocktail
    registerFallbackValue(Profile(
      userId: 'x',
      organizationId: 'org',
      username: 'u',
      avatarUrl: null,
      website: null,
      createdAt: DateTime.utc(2024),
      updatedAt: DateTime.utc(2024),
    ));
    registerFallbackValue(File('dummy'));
  });
  late _FakeRemote remote;
  late _FakeCache cache;
  late ProfileRepositoryImpl repo;

  final profile = Profile(
    userId: 'u1',
    organizationId: 'org1',
    username: 'user',
    avatarUrl: null,
    website: null,
    createdAt: DateTime.utc(2024, 1, 1),
    updatedAt: DateTime.utc(2024, 1, 1),
  );

  setUp(() {
    remote = _FakeRemote();
    cache = _FakeCache();
    repo = ProfileRepositoryImpl(remote: remote, cache: cache);
  });

  group('getCurrent', () {
    test('returns remote profile and writes cache on success', () async {
      when(() => remote.fetchCurrent()).thenAnswer((_) async => profile);
      when(() => cache.write(any())).thenAnswer((_) async {});

      final res = await repo.getCurrent();

      expect(res.isSuccess, true);
      expect(res.dataOrNull, profile);
      verify(() => cache.write(profile)).called(1);
    });

    test('falls back to cache when network fails', () async {
      when(() => remote.fetchCurrent())
          .thenThrow(const SocketException('down'));
      when(() => cache.read()).thenAnswer((_) async => profile);

      final res = await repo.getCurrent();
      expect(res.isSuccess, true);
      expect(res.dataOrNull, profile);
    });

    test('returns Failure(NetworkFailure) when both remote and cache fail',
        () async {
      when(() => remote.fetchCurrent())
          .thenThrow(const SocketException('down'));
      when(() => cache.read()).thenAnswer((_) async => null);

      final res = await repo.getCurrent();

      expect(res.isFailure, true);
      expect(res.errorOrNull, isA<NetworkFailure>());
    });
  });

  group('update & uploadAvatar', () {
    test('update writes cache and returns Success', () async {
      when(() => remote.update(
          username: any(named: 'username'),
          avatarUrl: any(named: 'avatarUrl'),
          website: any(named: 'website'))).thenAnswer((_) async => profile);
      when(() => cache.write(any())).thenAnswer((_) async {});

      final res = await repo.update(username: 'new');
      expect(res.isSuccess, true);
      verify(() => cache.write(profile)).called(1);
    });

    test('uploadAvatar writes cache and returns Success', () async {
      when(() => remote.uploadAvatar(any())).thenAnswer((_) async => profile);
      when(() => cache.write(any())).thenAnswer((_) async {});

      final res = await repo.uploadAvatar(File('x'));
      expect(res.isSuccess, true);
      verify(() => cache.write(profile)).called(1);
    });
  });
}
