// Dart imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:jo17_tactical_manager/hive/hive_match_schedule_cache.dart';
import 'package:jo17_tactical_manager/models/match.dart';
import 'package:jo17_tactical_manager/models/match_schedule.dart';
import 'package:jo17_tactical_manager/repositories/local_match_schedule_repository.dart';

class _Cache extends Mock implements HiveMatchScheduleCache {}

void main() {
  setUpAll(() {
    registerFallbackValue(MatchSchedule());
  });

  late _Cache cache;
  late LocalMatchScheduleRepository repo;

  final upcoming = MatchSchedule()
    ..id = 'u1'
    ..dateTime = DateTime.now().add(const Duration(days: 1));
  final past = MatchSchedule()
    ..id = 'p1'
    ..dateTime = DateTime.now().subtract(const Duration(days: 1));

  setUp(() {
    cache = _Cache();
    repo = LocalMatchScheduleRepository(cache: cache);
  });

  test('getUpcoming filters future schedules', () async {
    when(() => cache.read()).thenAnswer((_) async => [past, upcoming]);

    final res = await repo.getUpcoming();

    expect(res.isSuccess, true);
    expect(res.dataOrNull, [upcoming]);
  });

  test('getRecent filters past schedules', () async {
    when(() => cache.read()).thenAnswer((_) async => [past, upcoming]);

    final res = await repo.getRecent();

    expect(res.isSuccess, true);
    expect(res.dataOrNull, [past]);
  });

  test('add writes through to cache', () async {
    when(() => cache.read()).thenAnswer((_) async => []);
    when(() => cache.write(any())).thenAnswer((_) async {});

    final res = await repo.add(upcoming);

    expect(res.isSuccess, true);
    verify(() => cache.write([upcoming])).called(1);
  });
}