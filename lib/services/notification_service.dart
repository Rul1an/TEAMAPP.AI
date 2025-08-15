// ignore_for_file: flutter_style_todos
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'notification_api.dart';

// Top-level background handler as required by Firebase Messaging (2025 best practice)
// Must be a static entry point for background isolates
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling background message: ${message.messageId}');
}

class NotificationService implements NotificationApi {
  NotificationService._();
  // Keep class final in prod; tests should use NotificationApi + provider override

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Feature toggle via dart-define: --dart-define=ENABLE_NOTIFICATIONS=true
  static const bool _enabled =
      bool.fromEnvironment('ENABLE_NOTIFICATIONS', defaultValue: false);

  // Topic helpers (pure, testable, no Firebase dependency)
  static String tenantTopic(String tenantId) => 'tenant_$tenantId';
  static String userTopic(String userId) => 'user_$userId';

  // Conservative validation based on FCM topic constraints
  static bool isValidTopic(String topic) {
    if (topic.isEmpty || topic.length > 128) return false;
    final pattern = RegExp(r'^[A-Za-z0-9_\-]+$');
    return pattern.hasMatch(topic);
  }

  @override
  Future<void> init() async {
    if (!_enabled) return;
    // Web support requires explicit Firebase web setup; skip by default
    if (kIsWeb) return;

    // Request permission on iOS / Android
    await requestPermission();

    // Ensure a token is generated (helpful for debug logs)
    final token = await _messaging.getToken();
    if (kDebugMode) {
      debugPrint('FCM token: $token');
    }

    // Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Background messages – requires a top-level handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  @override
  Future<void> requestPermission() async {
    await _messaging.requestPermission();
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }

  @override
  Future<void> subscribeToTenant(String tenantId) async {
    final topic = tenantTopic(tenantId);
    if (isValidTopic(topic)) {
      await subscribeToTopic(topic);
    } else if (kDebugMode) {
      debugPrint('Invalid tenant topic: $topic');
    }
  }

  @override
  Future<void> unsubscribeFromTenant(String tenantId) async {
    final topic = tenantTopic(tenantId);
    if (isValidTopic(topic)) {
      await unsubscribeFromTopic(topic);
    }
  }

  @override
  Future<void> subscribeToUser(String userId) async {
    final topic = userTopic(userId);
    if (isValidTopic(topic)) {
      await subscribeToTopic(topic);
    } else if (kDebugMode) {
      debugPrint('Invalid user topic: $topic');
    }
  }

  @override
  Future<void> unsubscribeFromUser(String userId) async {
    final topic = userTopic(userId);
    if (isValidTopic(topic)) {
      await unsubscribeFromTopic(topic);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // TODO: Display local notification or analytics.
    if (kDebugMode) {
      debugPrint('Received foreground message: ${message.messageId}');
    }
  }

  // Background handling is implemented as a top-level function above.
}
