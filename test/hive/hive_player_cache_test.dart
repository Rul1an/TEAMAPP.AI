// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

// Project imports:
import 'package:jo17_tactical_manager/hive/hive_player_cache.dart';
import 'package:jo17_tactical_manager/models/player.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const secureStorageChannel =
      MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(secureStorageChannel, (call) async => null);

  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    pathProviderChannel,
    (call) async => Directory.systemTemp.path,
  );

  group('HivePlayerCache', () {
    setUp(() {
      Hive.init(Directory.systemTemp.path);
    });

    test('write & read list', () async {
      final cache = HivePlayerCache();
      final players = [
        Player()
          ..id = '1'
          ..firstName = 'A'
          ..lastName = 'B'
          ..jerseyNumber = 10
          ..birthDate = DateTime(2005)
          ..position = Position.forward
          ..preferredFoot = PreferredFoot.right
          ..height = 180
          ..weight = 70,
      ];
      await cache.write(players);
      final read = await cache.read();
      expect(read?.first.id, '1');
    });

    test('returns null after TTL expiry', () async {
      final cache = HivePlayerCache();
      final players = [
        Player()
          ..id = '2'
          ..firstName = 'C'
          ..lastName = 'D'
          ..jerseyNumber = 11
          ..birthDate = DateTime(2006, 2, 2)
          ..position = Position.midfielder
          ..preferredFoot = PreferredFoot.left
          ..height = 175
          ..weight = 68,
      ];
      await cache.write(players);
      expect(
        await cache.read(ttl: const Duration(milliseconds: 50)),
        isNotNull,
      );
      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(await cache.read(ttl: const Duration(milliseconds: 50)), isNull);
    });
  });
}
