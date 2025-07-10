// Dart imports:
import 'dart:io';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

// Project imports:
import 'package:jo17_tactical_manager/hive/hive_key_manager.dart';
import 'package:jo17_tactical_manager/hive/hive_profile_cache.dart';
import 'package:jo17_tactical_manager/models/profile.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock flutter_secure_storage MethodChannel
  const secureStorageChannel = MethodChannel(
    'plugins.it_nomads.com/flutter_secure_storage',
  );

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(secureStorageChannel, (
        MethodCall methodCall,
      ) async {
        // We simply ignore all calls and return dummy values so that the plugin
        // never tries to hit the platform layer during unit tests.
        switch (methodCall.method) {
          case 'read':
            return null;
          case 'write':
          case 'delete':
          case 'deleteAll':
            return null;
          case 'readAll':
            return <String, String>{};
          default:
            return null;
        }
      });

  // Mock path_provider MethodChannel used by Hive.initFlutter
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(pathProviderChannel, (
        MethodCall methodCall,
      ) async {
        // Return a valid temporary directory path for any directory request
        final tmpPath = Directory.systemTemp.path;
        return tmpPath;
      });

  group('HiveProfileCache', () {
    late HiveProfileCache cache;

    setUp(() async {
      // In-memory Hive backend, no file IO → fast tests.
      await setUpTestHive();
      cache = HiveProfileCache(keyManager: HiveKeyManager.inMemory());
    });

    tearDown(() async {
      await tearDownTestHive();
    });

    test('writes and reads profile within TTL', () async {
      final profile = Profile(
        userId: 'u1',
        organizationId: 'org1',
        username: 'tester',
        avatarUrl: 'https://example.com/avatar.png',
        website: 'https://example.com',
        createdAt: DateTime.utc(2025, 1, 1),
        updatedAt: DateTime.utc(2025, 1, 1),
      );

      await cache.write(profile);
      final result = await cache.read(ttl: const Duration(minutes: 5));

      expect(result?.userId, equals('u1'));
      expect(result?.username, equals('tester'));
    });

    test('returns null after TTL expiration', () async {
      final profile = Profile(
        userId: 'u2',
        organizationId: 'org2',
        username: 'expired',
        avatarUrl: null,
        website: null,
        createdAt: DateTime.utc(2025, 1, 1),
        updatedAt: DateTime.utc(2025, 1, 1),
      );

      await cache.write(profile);

      // Simulate expired TTL by overriding internal timestamp.
      final box = await Hive.box<String>('profiles_box');
      final pastTs = DateTime.now()
          .subtract(const Duration(hours: 1))
          .millisecondsSinceEpoch
          .toString();
      await box.put('current_profile_ts', pastTs);

      final result = await cache.read(ttl: const Duration(minutes: 1));
      expect(result, isNull);
    });

    test('clear removes cached profile', () async {
      final profileJson = jsonEncode({'foo': 'bar'});
      final box = await Hive.openBox<String>('profiles_box');
      await box.putAll({
        'current_profile_json': profileJson,
        'current_profile_ts': DateTime.now().millisecondsSinceEpoch.toString(),
      });

      cache = HiveProfileCache(keyManager: HiveKeyManager.inMemory());
      await cache.clear();

      expect(box.get('current_profile_json'), isNull);
      expect(box.get('current_profile_ts'), isNull);
    });
  });
}
