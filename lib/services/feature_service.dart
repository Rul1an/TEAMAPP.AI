/// 🎯 Feature System
/// Manages subscription tiers and feature access control
library;

// Features available in the system
enum Feature {
  // Core features (Basic tier)
  teamManagement,
  basicTraining,
  basicMatches,

  // Pro features
  calendarIntegration,
  analyticsBasic,
  fieldDiagramEditor,
  annualPlanning,
  importExport,
  clubManagement,
  playerTracking,

  // Enterprise features
  analyticsAdvanced,
  videoIntegration,
  apiAccess,
  customBranding,
  multiTeam,
}

// Subscription tiers
enum SubscriptionTier {
  basic,
  pro,
  enterprise,
}

// Feature configuration
class FeatureConfig {
  const FeatureConfig({
    required this.organizationId,
    required this.teamId,
    required this.tier,
    this.overrides = const {},
    this.expiresAt,
  });
  final String organizationId;
  final String teamId;
  final SubscriptionTier tier;
  final Map<Feature, bool> overrides;
  final DateTime? expiresAt;

  bool get isExpired =>
      expiresAt != null && expiresAt!.isBefore(DateTime.now());
}

// SaaS Tier Management Service
class FeatureService {
  static const Map<String, List<String>> _tierFeatures = {
    'basic': [
      'player_management',
      'basic_training_planning',
      'match_scheduling',
      'basic_statistics',
      'team_overview',
    ],
    'pro': [
      'player_management',
      'basic_training_planning',
      'match_scheduling',
      'basic_statistics',
      'team_overview',
      'advanced_training_planning',
      'player_tracking_svs',
      'performance_analytics',
      'annual_planning',
      'advanced_statistics',
      'exercise_library',
      'formation_templates',
    ],
    'enterprise': [
      'player_management',
      'basic_training_planning',
      'match_scheduling',
      'basic_statistics',
      'team_overview',
      'advanced_training_planning',
      'player_tracking_svs',
      'performance_analytics',
      'annual_planning',
      'advanced_statistics',
      'exercise_library',
      'formation_templates',
      'video_analysis',
      'gps_integration',
      'injury_prediction',
      'custom_reports',
      'api_access',
      'multi_team_management',
      'coach_collaboration',
    ],
  };

  static const Map<String, Map<String, dynamic>> _tierLimits = {
    'basic': {
      'max_players': 25,
      'max_teams': 1,
      'max_coaches': 2,
      'max_training_sessions_per_month': 50,
      'max_matches_per_month': 10,
      'storage_gb': 1,
    },
    'pro': {
      'max_players': 100,
      'max_teams': 3,
      'max_coaches': 5,
      'max_training_sessions_per_month': 200,
      'max_matches_per_month': 50,
      'storage_gb': 10,
    },
    'enterprise': {
      'max_players': -1, // Unlimited
      'max_teams': -1,
      'max_coaches': -1,
      'max_training_sessions_per_month': -1,
      'max_matches_per_month': -1,
      'storage_gb': 100,
    },
  };

  // Check if a feature is available for a specific tier
  bool isFeatureAvailable(String feature, String tier) =>
      _tierFeatures[tier]?.contains(feature) ?? false;

  // Get all features for a tier
  List<String> getFeaturesForTier(String tier) => _tierFeatures[tier] ?? [];

  // Get tier limits
  Map<String, dynamic> getTierLimits(String tier) =>
      _tierLimits[tier] ?? _tierLimits['basic']!;

  // Check if a limit is reached
  bool isLimitReached(String tier, String limitType, int currentValue) {
    final limits = getTierLimits(tier);
    final limit = limits[limitType] as int?;

    if (limit == null || limit == -1) return false; // Unlimited
    return currentValue >= limit;
  }

  // Get tier display name
  String getTierDisplayName(String tier) {
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

  // Get tier color
  String getTierColor(String tier) {
    switch (tier.toLowerCase()) {
      case 'basic':
        return '#4CAF50'; // Green
      case 'pro':
        return '#FF9800'; // Orange
      case 'enterprise':
        return '#9C27B0'; // Purple
      default:
        return '#4CAF50';
    }
  }

  // Get next tier
  String? getNextTier(String currentTier) {
    switch (currentTier.toLowerCase()) {
      case 'basic':
        return 'pro';
      case 'pro':
        return 'enterprise';
      case 'enterprise':
        return null; // Already highest tier
      default:
        return 'pro';
    }
  }

  // Role-based permissions
  bool hasPermission(String role, String permission) {
    const rolePermissions = {
      'bestuurder': [
        'manage_club',
        'manage_teams',
        'manage_coaches',
        'manage_players',
        'view_all_data',
        'manage_billing',
        'manage_settings',
        'export_data',
      ],
      'hoofdcoach': [
        'manage_team',
        'manage_training',
        'manage_matches',
        'view_player_data',
        'create_reports',
        'manage_tactics',
        'plan_season',
      ],
      'assistent_coach': [
        'view_team',
        'assist_training',
        'view_player_data',
        'create_basic_reports',
      ],
      'speler': [
        'view_own_data',
        'view_team_schedule',
        'submit_wellness',
      ],
    };

    return rolePermissions[role]?.contains(permission) ?? false;
  }

  // Feature descriptions for upgrade prompts
  Map<String, String> getFeatureDescriptions() => {
        'player_tracking_svs':
            'Geavanceerd speler volg systeem met GPS integratie',
        'performance_analytics': 'Uitgebreide prestatie analyses en rapporten',
        'annual_planning': 'Volledige jaarplanning en periodisering',
        'video_analysis': 'Video analyse tools en integratie',
        'gps_integration': 'GPS tracking en fysieke data analyse',
        'injury_prediction': 'AI-gedreven blessure voorspelling',
        'custom_reports': 'Aangepaste rapporten en dashboards',
        'api_access': 'API toegang voor externe integraties',
        'multi_team_management': 'Beheer meerdere teams binnen één club',
        'coach_collaboration': 'Samenwerking tussen coaches en staff',
      };
}
