// Notification service – handles Firebase Cloud Messaging setup
// This is a minimal integration used for MVP pilot; advanced topics like
// topic subscriptions, foreground service handling and background isolates can
// be layered later.

// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'analytics_service.dart';

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _messaging = FirebaseMessaging.instance;

  /// Call once on app startup *after* widgets binding & Firebase.initializeApp.
  Future<void> init() async {
    // Request permissions (iOS & Web)
    if (!kIsWeb && (Platform.isIOS || Platform.isMacOS)) {
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
    }

    // For Android 13+ notification runtime permission
    if (Platform.isAndroid) {
      await _messaging.requestPermission();
    }

    // Obtain FCM token for debugging / future topic subscription
    final token = await _messaging.getToken();
    debugPrint('FCM Token: $token');

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    // Handle messages that opened the app from background/terminated state
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Background handler must be a top-level function; see below.
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  }

  void _onForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground message: ${message.messageId}');
    AnalyticsService.instance.logEvent('push_foreground', params: {'id': message.messageId ?? ''});
    // TODO: show in-app banner or local notification
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    debugPrint('Notification interaction: ${message.messageId}');
    AnalyticsService.instance.logEvent('push_open', params: {'id': message.messageId ?? ''});
    // TODO: Navigate based on deep link in message.data
  }
}

// Must be top-level / static function
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('BG message: ${message.messageId}');
  // TODO: background processing (analytics, etc.)
}