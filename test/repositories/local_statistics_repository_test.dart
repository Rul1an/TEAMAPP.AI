// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:jo17_tactical_manager/hive/hive_statistics_cache.dart';
import 'package:jo17_tactical_manager/models/statistics.dart';
import 'package:jo17_tactical_manager/repositories/local_statistics_repository.dart';

class _FakeCache extends Mock implements HiveStatisticsCache {}

void main() {
  late _FakeCache cache;
  late LocalStatisticsRepository repo;

  setUp(() {
    cache = _FakeCache();
    repo = LocalStatisticsRepository(cache: cache);
  });

  test('getStatistics returns legacy map from type-safe model', () async {
    final legacy =
        const Statistics(totalMatches: 10, totalPlayers: 22).toLegacyMap();
    when(() => cache.read()).thenAnswer((_) async => legacy);

    final res = await repo.getStatistics();
    expect(res.isSuccess, true);
    final map = res.dataOrNull!;
    expect(map['totalMatches'], 10);
    expect(map['totalPlayers'], 22);
  });

  test('getStatistics returns safe defaults on cache error', () async {
    when(() => cache.read()).thenThrow(Exception('cache read failed'));
    final res = await repo.getStatistics();
    expect(res.isSuccess, true);
    final map = res.dataOrNull!;
    // Default Statistics() should zero-fill metrics
    expect(map['totalMatches'], 0);
  });

  test('updateStatistics writes cache and returns Success', () async {
    final stats = const Statistics(totalMatches: 5);
    when(() => cache.write(any())).thenAnswer((_) async {});
    final res = await repo.updateStatistics(stats);
    expect(res.isSuccess, true);
    verify(() => cache.write(stats.toLegacyMap())).called(1);
  });
}
