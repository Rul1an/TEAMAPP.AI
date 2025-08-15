// ignore_for_file: flutter_style_todos
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  NotificationService._();

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

  Future<void> init() async {
    if (!_enabled) return;
    // Web support requires explicit Firebase web setup; skip by default
    if (kIsWeb) return;
    // Request permission on iOS / Web
    await requestPermission();

    // Ensure a token is generated (helpful for debug logs)
    final token = await _messaging.getToken();
    if (kDebugMode) {
      debugPrint('FCM token: $token');
    }

    // Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Background messages – needs a top-level handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> requestPermission() async {
    await _messaging.requestPermission();
  }

  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  Future<void> subscribeToTenant(String tenantId) async {
    final topic = tenantTopic(tenantId);
    if (isValidTopic(topic)) {
      await subscribeToTopic(topic);
    } else if (kDebugMode) {
      debugPrint('Invalid tenant topic: $topic');
    }
  }

  Future<void> subscribeToUser(String userId) async {
    final topic = userTopic(userId);
    if (isValidTopic(topic)) {
      await subscribeToTopic(topic);
    } else if (kDebugMode) {
      debugPrint('Invalid user topic: $topic');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // TODO: Display local notification or analytics.
    if (kDebugMode) {
      debugPrint('Received foreground message: ${message.messageId}');
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    // Handle background/terminated state messages.
    // Currently just logs; extend later with local_notif integration.
    debugPrint('Handling background message: ${message.messageId}');
  }
}
