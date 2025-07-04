import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jo17_tactical_manager/core/result.dart';
import 'package:jo17_tactical_manager/models/match.dart';
import 'package:jo17_tactical_manager/repositories/match_repository_impl.dart';
import 'package:jo17_tactical_manager/data/supabase_match_data_source.dart';
import 'package:jo17_tactical_manager/hive/hive_match_cache.dart';

class _Remote extends Mock implements SupabaseMatchDataSource {}

class _Cache extends Mock implements HiveMatchCache {}

void main() {
  setUpAll(() {
    registerFallbackValue(Match()..id = 'fallback'..date = DateTime.now());
  });
  late _Remote remote;
  late _Cache cache;
  late MatchRepositoryImpl repo;

  final matchNow = Match()
    ..id = 'm1'
    ..date = DateTime.now().add(const Duration(days: 1));
  final matchPast = Match()
    ..id = 'm2'
    ..date = DateTime.now().subtract(const Duration(days: 1));

  setUp(() {
    remote = _Remote();
    cache = _Cache();
    repo = MatchRepositoryImpl(remote: remote, cache: cache);
  });

  test('getUpcoming filters correctly', () async {
    when(() => remote.fetchAll()).thenAnswer((_) async => [matchPast, matchNow]);
    when(() => cache.write(any())).thenAnswer((_) async {});

    final res = await repo.getUpcoming();

    expect(res.isSuccess, true);
    expect(res.dataOrNull, [matchNow]);
  });

  test('getRecent filters correctly with cache fallback', () async {
    when(() => remote.fetchAll()).thenThrow(const SocketException('x'));
    when(() => cache.read()).thenAnswer((_) async => [matchPast, matchNow]);

    final res = await repo.getRecent();

    expect(res.isSuccess, true);
    expect(res.dataOrNull, [matchPast]);
  });

  test('mutation clears cache', () async {
    when(() => remote.add(any())).thenAnswer((_) async {});
    when(() => cache.clear()).thenAnswer((_) async {});

    final res = await repo.add(matchNow);

    expect(res.isSuccess, true);
    verify(() => cache.clear()).called(1);
  });
}
