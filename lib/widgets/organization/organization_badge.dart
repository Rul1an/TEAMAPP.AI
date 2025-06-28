import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/organization_provider.dart';
import '../../models/organization.dart';

class OrganizationBadge extends ConsumerWidget {
  const OrganizationBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final organization = ref.watch(currentOrganizationProvider);

    if (organization == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getTierColor(organization.tier).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getTierColor(organization.tier).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getTierIcon(organization.tier),
            size: 16,
            color: _getTierColor(organization.tier),
          ),
          const SizedBox(width: 6),
          Text(
            organization.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _getTierColor(organization.tier),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '(${organization.tier.displayName})',
            style: TextStyle(
              fontSize: 11,
              color: _getTierColor(organization.tier).withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTierColor(OrganizationTier tier) {
    switch (tier) {
      case OrganizationTier.basic:
        return Colors.blue;
      case OrganizationTier.pro:
        return Colors.purple;
      case OrganizationTier.enterprise:
        return Colors.orange;
    }
  }

  IconData _getTierIcon(OrganizationTier tier) {
    switch (tier) {
      case OrganizationTier.basic:
        return Icons.star_outline;
      case OrganizationTier.pro:
        return Icons.star;
      case OrganizationTier.enterprise:
        return Icons.workspace_premium;
    }
  }
}
