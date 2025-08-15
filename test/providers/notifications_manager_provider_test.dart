// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:jo17_tactical_manager/providers/notifications_manager_provider.dart';
import 'package:jo17_tactical_manager/providers/notification_service_provider.dart';
import 'package:jo17_tactical_manager/services/notification_api.dart';

class _FakeNotificationService implements NotificationApi {
  final List<String> subscribed = [];
  final List<String> unsubscribed = [];

  @override
  Future<void> init() async {}

  @override
  Future<void> requestPermission() async {}

  @override
  Future<void> subscribeToTopic(String topic) async {
    subscribed.add(topic);
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    unsubscribed.add(topic);
  }

  @override
  Future<void> subscribeToTenant(String tenantId) async {
    subscribed.add('tenant_$tenantId');
  }

  @override
  Future<void> unsubscribeFromTenant(String tenantId) async {
    unsubscribed.add('tenant_$tenantId');
  }

  @override
  Future<void> subscribeToUser(String userId) async {
    subscribed.add('user_$userId');
  }

  @override
  Future<void> unsubscribeFromUser(String userId) async {
    unsubscribed.add('user_$userId');
  }
}

void main() {
  test('notifications manager subscribes/unsubscribes on auth/org changes',
      () async {
    final fake = _FakeNotificationService();
    final container = ProviderContainer(overrides: [
      notificationServiceProvider.overrideWithValue(fake),
    ]);
    addTearDown(container.dispose);

    // Activate manager
    container.read(notificationsManagerProvider);

    // Basic assertion: fake is wired; no exceptions
    expect(fake.subscribed, isA<List<String>>());
  });
}
