// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../config/theme.dart';

/// 🏆 Tier Badge Widget
/// Displays subscription tier with appropriate styling
class TierBadge extends StatelessWidget {
  const TierBadge({
    required this.tier,
    this.showIcon = true,
    this.fontSize = 12,
    super.key,
  });
  final String tier;
  final bool showIcon;
  final double fontSize;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: AppTheme.getTierBadgeDecoration(tier),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon) ...[
          Icon(_getTierIcon(tier), color: Colors.white, size: fontSize + 2),
          const SizedBox(width: 4),
        ],
        Text(
          _getTierDisplayName(tier),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ],
    ),
  );

  IconData _getTierIcon(String tier) {
    switch (tier.toLowerCase()) {
      case 'basic':
        return Icons.star_border;
      case 'pro':
        return Icons.star_half;
      case 'enterprise':
        return Icons.star;
      default:
        return Icons.star_border;
    }
  }

  String _getTierDisplayName(String tier) {
    switch (tier.toLowerCase()) {
      case 'basic':
        return 'Basic';
      case 'pro':
        return 'Pro';
      case 'enterprise':
        return 'Enterprise';
      default:
        return 'Basic';
    }
  }
}

/// 🔒 Feature Lock Widget
/// Shows when a feature is locked due to subscription tier
class FeatureLockWidget extends StatelessWidget {
  const FeatureLockWidget({
    required this.featureName,
    required this.requiredTier,
    this.onUpgrade,
    super.key,
  });
  final String featureName;
  final String requiredTier;
  final VoidCallback? onUpgrade;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            '$featureName is vergrendeld',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Upgrade naar $requiredTier om deze functie te gebruiken',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Vereist: '),
              TierBadge(tier: requiredTier),
            ],
          ),
          if (onUpgrade != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onUpgrade,
              icon: const Icon(Icons.upgrade),
              label: Text('Upgrade naar $requiredTier'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.getTierColor(requiredTier),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

/// 📈 Upgrade Prompt Widget
/// Encourages users to upgrade their subscription
class UpgradePromptWidget extends StatelessWidget {
  const UpgradePromptWidget({
    required this.currentTier,
    required this.targetTier,
    required this.benefits,
    this.onUpgrade,
    super.key,
  });
  final String currentTier;
  final String targetTier;
  final List<String> benefits;
  final VoidCallback? onUpgrade;

  @override
  Widget build(BuildContext context) => Card(
    elevation: 4,
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.getTierColor(targetTier).withValues(alpha: 0.1),
            AppTheme.getTierColor(targetTier).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.upgrade,
                color: AppTheme.getTierColor(targetTier),
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Upgrade naar $targetTier',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getTierColor(targetTier),
                  ),
                ),
              ),
              TierBadge(tier: targetTier),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Ontgrendel meer functionaliteiten:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          ...benefits.map(
            (benefit) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppTheme.getTierColor(targetTier),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(benefit, style: const TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
          ),
          if (onUpgrade != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onUpgrade,
                icon: const Icon(Icons.upgrade),
                label: Text('Upgrade naar $targetTier'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.getTierColor(targetTier),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
