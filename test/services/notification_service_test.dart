// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:jo17_tactical_manager/services/notification_service.dart';

void main() {
  test('topic naming: tenant/user scoping pattern', () {
    // Validate pure helpers
    expect(NotificationService.tenantTopic('org123'), 'tenant_org123');
    expect(NotificationService.userTopic('u1'), 'user_u1');
  });

  test('topic validation enforces conservative constraints', () {
    expect(NotificationService.isValidTopic('tenant_org'), true);
    expect(NotificationService.isValidTopic('user_u-1'), true);
    expect(NotificationService.isValidTopic('invalid topic'), false);
    expect(NotificationService.isValidTopic(''), false);
  });

  // Note: avoid instantiating NotificationService here to prevent Firebase init during unit tests.
}
