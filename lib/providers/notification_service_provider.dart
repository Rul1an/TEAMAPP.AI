// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../services/notification_service.dart';
import '../services/notification_api.dart';

/// Provider to allow overriding the notification API in tests.
final notificationServiceProvider = Provider<NotificationApi>((ref) {
  return NotificationService.instance;
});
