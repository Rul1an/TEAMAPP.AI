// Package imports:
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper class to setup Firebase mocking for tests
class FirebaseTestHelper {
  static bool _initialized = false;

  /// Initialize Firebase mocking for tests
  static Future<void> setupFirebaseMocking() async {
    if (_initialized) return;

    TestWidgetsFlutterBinding.ensureInitialized();

    // Mock Firebase Core
    setupFirebaseCoreMocks();

    // Mock Firebase Performance
    setupFirebasePerformanceMocks();

    _initialized = true;
  }

  /// Setup Firebase Core mocks
  static void setupFirebaseCoreMocks() {
    const MethodChannel channel =
        MethodChannel('plugins.flutter.io/firebase_core');

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'Firebase#initializeCore':
          return [
            {
              'name': '[DEFAULT]',
              'options': {
                'apiKey': 'test-api-key',
                'appId': 'test-app-id',
                'messagingSenderId': 'test-sender-id',
                'projectId': 'test-project-id',
              },
              'pluginConstants': <String, String>{},
            }
          ];
        case 'Firebase#apps':
          return [
            {
              'name': '[DEFAULT]',
              'options': {
                'apiKey': 'test-api-key',
                'appId': 'test-app-id',
                'messagingSenderId': 'test-sender-id',
                'projectId': 'test-project-id',
              },
              'pluginConstants': <String, String>{},
            }
          ];
        default:
          return null;
      }
    });
  }

  /// Setup Firebase Performance mocks
  static void setupFirebasePerformanceMocks() {
    const MethodChannel channel =
        MethodChannel('plugins.flutter.io/firebase_performance');

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'FirebasePerformance#isPerformanceCollectionEnabled':
          return true;
        case 'Trace#start':
          return null;
        case 'Trace#stop':
          return null;
        case 'HttpMetric#start':
          return null;
        case 'HttpMetric#stop':
          return null;
        default:
          return null;
      }
    });
  }

  /// Clean up Firebase mocks
  static void cleanup() {
    const MethodChannel coreChannel =
        MethodChannel('plugins.flutter.io/firebase_core');
    const MethodChannel perfChannel =
        MethodChannel('plugins.flutter.io/firebase_performance');

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(coreChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(perfChannel, null);

    _initialized = false;
  }
}
