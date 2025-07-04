import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jo17_tactical_manager/core/result.dart';
import 'package:jo17_tactical_manager/models/player.dart';
import 'package:jo17_tactical_manager/repositories/player_repository_impl.dart';
import 'package:jo17_tactical_manager/data/supabase_player_data_source.dart';
import 'package:jo17_tactical_manager/hive/hive_player_cache.dart';

class _FakeRemote extends Mock implements SupabasePlayerDataSource {}

class _FakeCache extends Mock implements HivePlayerCache {}

void main() {
  setUpAll(() {
    registerFallbackValue(Player()..id = 'fallback');
  });
  late _FakeRemote remote;
  late _FakeCache cache;
  late PlayerRepositoryImpl repo;

  final samplePlayers = [
    Player()
      ..id = '1'
      ..firstName = 'A',
    Player()
      ..id = '2'
      ..firstName = 'B',
  ];

  setUp(() {
    remote = _FakeRemote();
    cache = _FakeCache();
    repo = PlayerRepositoryImpl(remote: remote, cache: cache);
  });

  group('getAll', () {
    test('returns remote data & writes cache on success', () async {
      when(() => remote.fetchAll()).thenAnswer((_) async => samplePlayers);
      when(() => cache.write(any())).thenAnswer((_) async {});

      final res = await repo.getAll();

      expect(res.isSuccess, true);
      expect(res.dataOrNull, samplePlayers);
      verify(() => cache.write(samplePlayers)).called(1);
      verifyNever(() => cache.read());
    });

    test('falls back to cache when network fails', () async {
      when(() => remote.fetchAll()).thenThrow(const SocketException('down'));
      when(() => cache.read()).thenAnswer((_) async => samplePlayers);

      final res = await repo.getAll();

      expect(res.isSuccess, true);
      expect(res.dataOrNull, samplePlayers);
      verify(() => cache.read()).called(1);
    });

    test('returns failure when network & cache both fail', () async {
      when(() => remote.fetchAll()).thenThrow(const SocketException('down'));
      when(() => cache.read()).thenAnswer((_) async => null);

      final res = await repo.getAll();

      expect(res.isSuccess, false);
      expect(res.errorOrNull, isA<NetworkFailure>());
    });
  });

  group('mutations', () {
    setUp(() {
      when(() => cache.clear()).thenAnswer((_) async {});
    });

    test('add clears cache on success', () async {
      when(() => remote.add(any())).thenAnswer((_) async {});
      final res = await repo.add(samplePlayers.first);
      expect(res.isSuccess, true);
      verify(() => cache.clear()).called(1);
    });

    test('update passes failure', () async {
      when(() => remote.update(any())).thenThrow(const SocketException('down'));
      final res = await repo.update(samplePlayers.first);
      expect(res.isSuccess, false);
      verifyNever(() => cache.clear());
    });
  });
}
