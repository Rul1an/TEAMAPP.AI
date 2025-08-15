// Dart imports:
import 'dart:async';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../services/notification_service.dart';
import 'auth_provider.dart';

/// Notifications manager: subscribes/unsubscribes to tenant/user topics
/// based on authentication and organization changes.
///
/// 2025 Best practice:
/// - Fully gated by ENABLE_NOTIFICATIONS
/// - Skip on web and demo/standalone modes
final notificationsManagerProvider = Provider<void>((ref) {
  // Init FCM (internally gated & skipped on web)
  unawaited(NotificationService.instance.init());

  // Subscribe/unsubscribe on login state changes
  ref.listen<bool>(isLoggedInProvider, (prev, next) async {
    if (!next) {
      // Logged out, best-effort unsubscribe from previous topics if known
      final prevUser = ref.read(currentUserProvider);
      final prevOrgId = ref.read(organizationIdProvider);
      if (prevUser != null) {
        unawaited(
            NotificationService.instance.unsubscribeFromUser(prevUser.id));
      }
      if (prevOrgId != null) {
        unawaited(
            NotificationService.instance.unsubscribeFromTenant(prevOrgId));
      }
      return;
    }

    // Logged in → subscribe to current user and org topics
    final user = ref.read(currentUserProvider);
    final orgId = ref.read(organizationIdProvider);
    if (user != null) {
      unawaited(NotificationService.instance.subscribeToUser(user.id));
    }
    if (orgId != null) {
      unawaited(NotificationService.instance.subscribeToTenant(orgId));
    }
  });

  // Update tenant subscription when org changes
  ref.listen<String?>(organizationIdProvider, (prev, next) async {
    // No change
    if (prev == next) return;

    // Only proceed when logged in
    final loggedIn = ref.read(isLoggedInProvider);
    if (!loggedIn) return;

    // Swap topics
    if (prev != null) {
      unawaited(NotificationService.instance.unsubscribeFromTenant(prev));
    }
    if (next != null) {
      unawaited(NotificationService.instance.subscribeToTenant(next));
    }
  });
});
