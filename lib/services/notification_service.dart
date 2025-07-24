// ignore_for_file: flutter_style_todos
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
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
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // TODO: Display local notification or analytics.
    if (kDebugMode) {
      debugPrint('Received foreground message: ${message.messageId}');
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // Handle background/terminated state messages.
    // Currently just logs; extend later with local_notif integration.
    debugPrint('Handling background message: ${message.messageId}');
  }
}
