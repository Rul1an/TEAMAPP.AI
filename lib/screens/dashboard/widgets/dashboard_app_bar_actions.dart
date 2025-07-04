import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../services/permission_service.dart';

/// App-bar action buttons for the dashboard.
///
/// Visibility rules:
/// * Training add button – coaches & admins (manage training)
/// * Line-up button – coaches (manage matches)
class DashboardAppBarActions extends StatelessWidget {
  const DashboardAppBarActions({
    required this.userRole,
    super.key,
  });

  final String? userRole;

  @override
  Widget build(BuildContext context) {
    final actions = <Widget>[];

    if (PermissionService.canManageTraining(userRole)) {
      actions.add(
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          tooltip: 'Nieuwe Training',
          onPressed: () => context.push('/session-builder'),
        ),
      );
    }

    if (PermissionService.canManageMatches(userRole)) {
      actions.add(
        IconButton(
          icon: const Icon(Icons.sports_soccer),
          tooltip: 'Opstelling Maken',
          onPressed: () => context.go('/lineup'),
        ),
      );
    }

    return Row(children: actions);
  }
}
