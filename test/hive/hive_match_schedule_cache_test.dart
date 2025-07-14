// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

// Project imports:
import 'package:jo17_tactical_manager/hive/hive_match_schedule_cache.dart';
import 'package:jo17_tactical_manager/models/match.dart';
import 'package:jo17_tactical_manager/models/match_schedule.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock secure storage & path provider to avoid platform dependencies.
  const secureStorageChannel = MethodChannel(
    'plugins.it_nomads.com/flutter_secure_storage',
  );
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(secureStorageChannel, (call) async => null);

  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    pathProviderChannel,
    (call) async => Directory.systemTemp.path,
  );

  group('HiveMatchScheduleCache', () {
    setUp(() {
      Hive.init(Directory.systemTemp.path);
    });

    test('write & read list', () async {
      final cache = HiveMatchScheduleCache();
      final schedules = [
        MatchSchedule()
          ..id = '1'
          ..dateTime = DateTime.utc(2025, 9, 12, 19, 30)
          ..opponent = 'Ajax U17'
          ..location = Location.away
          ..competition = Competition.league,
      ];
      await cache.write(schedules);
      final read = await cache.read();
      expect(read?.first.id, '1');
      expect(read?.first.location, Location.away);
    });

    test('returns null after TTL expiry', () async {
      final cache = HiveMatchScheduleCache();
      final schedules = [
        MatchSchedule()
          ..id = '2'
          ..dateTime = DateTime.utc(2025, 10, 1, 18, 0)
          ..opponent = 'PSV U17'
          ..location = Location.home
          ..competition = Competition.cup,
      ];
      await cache.write(schedules);
      expect(
        await cache.read(ttl: const Duration(milliseconds: 50)),
        isNotNull,
      );
      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(await cache.read(ttl: const Duration(milliseconds: 50)), isNull);
    });
  });
}