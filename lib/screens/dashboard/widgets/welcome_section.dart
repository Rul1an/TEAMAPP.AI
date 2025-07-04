import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/annual_planning/season_plan.dart';
import '../../../services/permission_service.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({
    required this.season,
    required this.userRole,
    super.key,
  });

  final SeasonPlan? season;
  final String? userRole;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE d MMMM', 'nl_NL');
    final todayStr = formatter.format(now);

    String title;
    if (PermissionService.isPlayer(userRole)) {
      title = 'Welkom speler!';
    } else if (PermissionService.isParent(userRole)) {
      title = 'Welkom ouder!';
    } else if (PermissionService.canAccessAdmin(userRole)) {
      title = 'Welkom bestuurder!';
    } else {
      title = 'Welkom coach!';
    }

    final subtitle = season != null
        ? 'Seizoen ${season!.season} | Vandaag is $todayStr'
        : 'Vandaag is $todayStr';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
