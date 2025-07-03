import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:jo17_tactical_manager/hive/hive_profile_cache.dart';
import 'package:jo17_tactical_manager/models/profile.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock flutter_secure_storage MethodChannel
  const MethodChannel _secureStorageChannel =
      MethodChannel('plugins.it_nomads.com/flutter_secure_storage');

  _secureStorageChannel.setMockMethodCallHandler((MethodCall methodCall) async {
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
  const MethodChannel _pathProviderChannel =
      MethodChannel('plugins.flutter.io/path_provider');

  _pathProviderChannel.setMockMethodCallHandler((MethodCall methodCall) async {
    // Return a valid temporary directory path for any directory request
    final tmpPath = Directory.systemTemp.path;
    return tmpPath;
  });

  test('write & read profile cache', () async {
    Hive.init(Directory.systemTemp.path);
    final cache = HiveProfileCache();
    final profile = Profile(
      userId: '1',
      organizationId: 'org',
      username: 'john',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await cache.write(profile);
    final fetched = await cache.read();
    expect(fetched?.userId, '1');
  });
}
