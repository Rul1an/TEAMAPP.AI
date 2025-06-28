import '../models/organization.dart';

/// Permission service for role-based access control
class PermissionService {
  /// Check if user can access admin features
  static bool canAccessAdmin(String? userRole) {
    return userRole == 'bestuurder' || userRole == 'admin';
  }

  /// Check if user is an admin
  static bool isAdmin(String? userRole) {
    return userRole == 'bestuurder' || userRole == 'admin';
  }

  /// Check if user can manage players
  static bool canManagePlayers(String? userRole) {
    return userRole == 'bestuurder' ||
           userRole == 'hoofdcoach' ||
           userRole == 'assistant' ||
           userRole == 'admin';
  }

  /// Check if user can view all players
  static bool canViewAllPlayers(String? userRole) {
    return userRole == 'bestuurder' ||
           userRole == 'hoofdcoach' ||
           userRole == 'assistant' ||
           userRole == 'admin';
  }

  /// Check if user can edit players
  static bool canEditPlayers(String? userRole) {
    return userRole == 'bestuurder' ||
           userRole == 'hoofdcoach' ||
           userRole == 'admin';
  }

  /// Check if user can manage training sessions
  static bool canManageTraining(String? userRole) {
    return userRole == 'bestuurder' ||
           userRole == 'hoofdcoach' ||
           userRole == 'assistant' ||
           userRole == 'admin';
  }

  /// Check if user can manage matches
  static bool canManageMatches(String? userRole) {
    return userRole == 'bestuurder' ||
           userRole == 'hoofdcoach' ||
           userRole == 'admin';
  }

  /// Check if user can view analytics
  static bool canViewAnalytics(String? userRole) {
    return userRole == 'bestuurder' ||
           userRole == 'hoofdcoach' ||
           userRole == 'admin';
  }

  /// Check if user can access SVS (Pro/Enterprise only)
  static bool canAccessSVS(String? userRole, OrganizationTier? tier) {
    if (tier == OrganizationTier.basic) return false;

    return userRole == 'bestuurder' ||
           userRole == 'hoofdcoach' ||
           userRole == 'admin';
  }

  /// Check if user can access annual planning
  static bool canAccessAnnualPlanning(String? userRole) {
    return userRole == 'bestuurder' ||
           userRole == 'hoofdcoach' ||
           userRole == 'admin';
  }

  /// Check if user is a player (limited access)
  static bool isPlayer(String? userRole) {
    return userRole == 'speler';
  }

  /// Check if user is a parent (limited access)
  static bool isParent(String? userRole) {
    return userRole == 'ouder';
  }

  /// Check if user has access to a specific feature based on tier
  static bool hasFeatureAccess(String feature, String? tier) {
    switch (feature) {
      case 'analytics':
        return tier == 'pro' || tier == 'enterprise';
      case 'svs':
        return tier == 'pro' || tier == 'enterprise';
      case 'advanced_training':
        return tier == 'pro' || tier == 'enterprise';
      case 'unlimited_players':
        return tier == 'enterprise';
      default:
        return true; // Basic features available to all
    }
  }

  /// Get accessible routes for a role
  static List<String> getAccessibleRoutes(String? userRole, String? tier) {
    final routes = <String>['/dashboard']; // Everyone can see dashboard

    if (userRole == null) return routes;

    // Players and parents have limited access
    if (isPlayer(userRole) || isParent(userRole)) {
      routes.addAll([
        '/players', // Can view player list
        '/training', // Can view training schedule
        '/matches', // Can view matches
      ]);
      return routes;
    }

    // Coaches and admins have more access
    if (canManagePlayers(userRole)) {
      routes.add('/players');
    }

    if (canManageTraining(userRole)) {
      routes.addAll([
        '/training',
        '/training-sessions',
        '/exercise-library',
        '/field-diagram-editor',
        '/exercise-designer',
      ]);
    }

    if (canManageMatches(userRole)) {
      routes.addAll([
        '/matches',
        '/lineup',
      ]);
    }

    if (canViewAnalytics(userRole)) {
      routes.add('/analytics');
    }

    if (canAccessAnnualPlanning(userRole)) {
      routes.addAll([
        '/annual-planning',
        '/season',
      ]);
    }

    if (hasFeatureAccess('svs', tier) && canViewAnalytics(userRole)) {
      routes.add('/svs');
    }

    if (canAccessAdmin(userRole)) {
      routes.add('/admin');
    }

    return routes;
  }

  /// Check if user can perform a specific action
  static bool canPerformAction(String action, String? userRole, String? tier) {
    switch (action) {
      case 'create_player':
      case 'edit_player':
        return canEditPlayers(userRole);

      case 'view_player':
        return true; // Everyone can view players

      case 'create_training':
      case 'edit_training':
        return canManageTraining(userRole);

      case 'view_training':
        return true; // Everyone can view training

      case 'create_match':
      case 'edit_match':
        return canManageMatches(userRole);

      case 'view_match':
        return true; // Everyone can view matches

      case 'manage_organization':
        return canAccessAdmin(userRole);

      default:
        return false;
    }
  }
}
