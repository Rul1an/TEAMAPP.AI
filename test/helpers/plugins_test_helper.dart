// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Global plugin mocks for unit/widget tests that run without real platform code.
///
/// This prevents MissingPluginException for common plugins like
/// shared_preferences, package_info_plus and newer firebase_core (Pigeon).
class PluginsTestHelper {
  static bool _initialized = false;

  /// Call once before tests (preferably from test/flutter_test_config.dart)
  static Future<void> setupPluginMocks() async {
    if (_initialized) return;
    TestWidgetsFlutterBinding.ensureInitialized();

    _mockSharedPreferences();
    _mockPackageInfoPlus();
    _mockFirebaseCorePigeon();

    _initialized = true;
  }

  static void _mockSharedPreferences() {
    const MethodChannel channel =
        MethodChannel('plugins.flutter.io/shared_preferences');

    final Map<String, Object?> store = <String, Object?>{};

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'getAll':
          return Map<String, Object?>.from(store);
        case 'clear':
          store.clear();
          return true;
        case 'remove':
          final String key = methodCall.arguments['key'] as String;
          store.remove(key);
          return true;
        case 'setString':
        case 'setBool':
        case 'setDouble':
        case 'setInt':
        case 'setStringList':
          final String key = methodCall.arguments['key'] as String;
          final Object? value = methodCall.arguments['value'];
          store[key] = value;
          return true;
        default:
          return null;
      }
    });
  }

  static void _mockPackageInfoPlus() {
    const MethodChannel channel =
        MethodChannel('dev.fluttercommunity.plus/package_info');

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, Object?>{
          'appName': 'TestApp',
          'packageName': 'com.example.test',
          'version': '1.0.0',
          'buildNumber': '1',
          'buildSignature': '',
          'installerStore': null,
        };
      }
      return null;
    });
  }

  /// Mock for newer firebase_core which uses Pigeon message channels on web/desktop tests.
  static void _mockFirebaseCorePigeon() {
    // Pigeon channel for initializeCore
    const BasicMessageChannel<
        Object?> initializeCoreChannel = BasicMessageChannel<
            Object?>(
        'dev.flutter.pigeon.firebase_core_platform_interface.FirebaseCoreHostApi.initializeCore',
        StandardMessageCodec());

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockDecodedMessageHandler<Object?>(initializeCoreChannel,
            (Object? message) async {
      // Mimic a successful initializeCore response: list of installed apps
      return <Object?>[
        <String, Object?>{
          'name': '[DEFAULT]',
          'options': <String, Object?>{
            'apiKey': 'test-api-key',
            'appId': 'test-app-id',
            'messagingSenderId': 'test-sender-id',
            'projectId': 'test-project-id',
          },
          'pluginConstants': <String, Object?>{},
        }
      ];
    });

    // Optional: Pigeon channel for initializeApp
    const BasicMessageChannel<
        Object?> initializeAppChannel = BasicMessageChannel<
            Object?>(
        'dev.flutter.pigeon.firebase_core_platform_interface.FirebaseAppHostApi.initializeApp',
        StandardMessageCodec());

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockDecodedMessageHandler<Object?>(initializeAppChannel,
            (Object? message) async {
      return <String, Object?>{
        'name': '[DEFAULT]',
        'options': <String, Object?>{
          'apiKey': 'test-api-key',
          'appId': 'test-app-id',
          'messagingSenderId': 'test-sender-id',
          'projectId': 'test-project-id',
        },
        'pluginConstants': <String, Object?>{},
      };
    });
  }
}
