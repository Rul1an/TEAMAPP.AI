import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:jo17_tactical_manager/models/match.dart';
import 'package:jo17_tactical_manager/providers/matches_provider.dart';
import 'package:jo17_tactical_manager/data/supabase_match_data_source.dart';
import 'package:jo17_tactical_manager/hive/hive_match_cache.dart';
import 'package:jo17_tactical_manager/repositories/match_repository_impl.dart';

class _MockRemote extends Mock implements SupabaseMatchDataSource {}

class _FakeCache extends Fake implements HiveMatchCache {
  _FakeCache(this._seed);
  final List<Match>? _seed;

  @override
  Future<List<Match>?> read({Duration? ttl}) async => _seed;

  @override
  Future<void> write(List<Match> matches) async {}

  @override
  Future<void> clear() async {}
}

void main() {
  final sample = [
    Match()
      ..id = 'm1'
      ..opponent = 'Ajax'
      ..date = DateTime.now()
  ];
  registerFallbackValue(Match());

  group('Offline/online flow', () {
    test('falls back to cache when remote fails', () async {
      final remote = _MockRemote();
      when(() => remote.fetchAll()).thenThrow(Exception('network'));
      final cache = _FakeCache(sample);

      final repo = MatchRepositoryImpl(remote: remote, cache: cache);
      final container = ProviderContainer(overrides: [
        matchRepositoryProvider.overrideWith((ref) => repo),
      ]);

      final list = await container.read(matchesProvider.future);
      expect(list, sample);
    });

    test('returns remote when available and updates cache', () async {
      final remote = _MockRemote();
      when(() => remote.fetchAll()).thenAnswer((_) async => sample);
      final cache = _FakeCache(null);

      final repo = MatchRepositoryImpl(remote: remote, cache: cache);
      final container = ProviderContainer(overrides: [
        matchRepositoryProvider.overrideWith((ref) => repo),
      ]);

      final list = await container.read(matchesProvider.future);
      expect(list, sample);
      verify(() => remote.fetchAll()).called(1);
    });
  });
}
