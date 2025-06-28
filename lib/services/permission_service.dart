import '../models/organization.dart';

/// Permission service for role-based access control
/// Enhanced with strict view-only access for players and parents
class PermissionService {
  /// Check if user can access admin features
  static bool canAccessAdmin(String? userRole) => userRole == 'bestuurder' || userRole == 'admin';

  /// Check if user can manage players (add, edit, delete)
  static bool canManagePlayers(String? userRole) => userRole == 'bestuurder' ||
           userRole == 'hoofdcoach' ||
           userRole == 'admin';

  /// Check if user can edit players
  static bool canEditPlayers(String? userRole) => userRole == 'bestuurder' ||
           userRole == 'hoofdcoach' ||
           userRole == 'admin';

  /// Check if user can manage training sessions (create, edit, delete)
  static bool canManageTraining(String? userRole) => userRole == 'bestuurder' ||
           userRole == 'hoofdcoach' ||
           userRole == 'assistent' ||
           userRole == 'admin';

  /// Check if user can create/edit training sessions
  static bool canCreateTraining(String? userRole) => userRole == 'bestuurder' ||
           userRole == 'hoofdcoach' ||
           userRole == 'admin';

  /// Check if user can manage matches (create, edit, delete)
  static bool canManageMatches(String? userRole) => userRole == 'bestuurder' ||
           userRole == 'hoofdcoach' ||
           userRole == 'admin';

  /// Check if user can view analytics
  static bool canViewAnalytics(String? userRole) => userRole == 'bestuurder' ||
           userRole == 'hoofdcoach' ||
           userRole == 'admin';

  /// Check if user can access SVS (Pro/Enterprise only)
  static bool canAccessSVS(String? userRole, OrganizationTier? tier) {
    if (tier == OrganizationTier.basic) return false;

    return userRole == 'bestuurder' ||
           userRole == 'hoofdcoach' ||
           userRole == 'admin';
  }

  /// Check if user can access annual planning
  static bool canAccessAnnualPlanning(String? userRole) => userRole == 'bestuurder' ||
           userRole == 'hoofdcoach' ||
           userRole == 'admin';

  /// Check if user can access exercise library management
  static bool canManageExerciseLibrary(String? userRole) => userRole == 'bestuurder' ||
           userRole == 'hoofdcoach' ||
           userRole == 'assistent' ||
           userRole == 'admin';

  /// Check if user can access field diagram editor
  static bool canAccessFieldDiagramEditor(String? userRole) => userRole == 'bestuurder' ||
           userRole == 'hoofdcoach' ||
           userRole == 'assistent' ||
           userRole == 'admin';

  /// Check if user can access exercise designer
  static bool canAccessExerciseDesigner(String? userRole) => userRole == 'bestuurder' ||
           userRole == 'hoofdcoach' ||
           userRole == 'assistent' ||
           userRole == 'admin';

  /// Check if user is a player (view-only access)
  static bool isPlayer(String? userRole) => userRole == 'speler';

  /// Check if user is a parent (limited view access)
  static bool isParent(String? userRole) => userRole == 'ouder';

  /// Check if user has view-only access (players and parents)
  static bool isViewOnlyUser(String? userRole) => isPlayer(userRole) || isParent(userRole);

  /// Get accessible routes for a role with strict permissions
  static List<String> getAccessibleRoutes(String? userRole, OrganizationTier? tier) {
    final routes = <String>['/dashboard']; // Everyone can see dashboard

    if (userRole == null) return routes;

    // Players and parents have STRICT view-only access
    if (isViewOnlyUser(userRole)) {
      routes.addAll([
        '/players', // Can ONLY view player list (no edit)
        '/training', // Can ONLY view training schedule (no management)
        '/matches', // Can ONLY view matches (no management)
      ]);
      return routes; // NO ACCESS to management features
    }

    // Assistants have limited management access
    if (userRole == 'assistent') {
      routes.addAll([
        '/players', // Can view players (limited edit)
        '/training', // Can view training
        '/training-sessions', // Can assist with sessions
        '/exercise-library', // Can view/use exercises
        '/matches', // Can view matches
      ]);
      return routes;
    }

    // Coaches and admins have full management access
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

    if (canAccessSVS(userRole, tier)) {
      routes.add('/svs');
    }

    if (canAccessAdmin(userRole)) {
      routes.add('/admin');
    }

    return routes;
  }

  /// Check if user can perform a specific action with enhanced granularity
  static bool canPerformAction(String action, String? userRole, OrganizationTier? tier) {
    // View-only users (players/parents) can ONLY view
    if (isViewOnlyUser(userRole)) {
      switch (action) {
        case 'view_player':
        case 'view_training':
        case 'view_match':
        case 'view_schedule':
        case 'view_own_stats':
          return true;
        default:
          return false; // NO create/edit/delete actions
      }
    }

    // Management actions for coaches/admins
    switch (action) {
      case 'create_player':
      case 'edit_player':
      case 'delete_player':
        return canEditPlayers(userRole);

      case 'view_player':
        return true; // Everyone can view players

      case 'create_training':
      case 'edit_training':
      case 'delete_training':
        return canCreateTraining(userRole);

      case 'manage_training_sessions':
        return canManageTraining(userRole);

      case 'view_training':
        return true; // Everyone can view training

      case 'create_match':
      case 'edit_match':
      case 'delete_match':
        return canManageMatches(userRole);

      case 'view_match':
        return true; // Everyone can view matches

      case 'manage_exercise_library':
        return canManageExerciseLibrary(userRole);

      case 'access_field_diagram_editor':
        return canAccessFieldDiagramEditor(userRole);

      case 'access_exercise_designer':
        return canAccessExerciseDesigner(userRole);

      case 'manage_organization':
        return canAccessAdmin(userRole);

      case 'view_analytics':
        return canViewAnalytics(userRole);

      case 'access_annual_planning':
        return canAccessAnnualPlanning(userRole);

      default:
        return false;
    }
  }

  /// Get user capabilities summary for UI display
  static Map<String, bool> getUserCapabilities(String? userRole, OrganizationTier? tier) => {
      'can_view_dashboard': true,
      'can_view_players': true,
      'can_manage_players': canManagePlayers(userRole),
      'can_edit_players': canEditPlayers(userRole),
      'can_view_training': true,
      'can_manage_training': canManageTraining(userRole),
      'can_create_training': canCreateTraining(userRole),
      'can_view_matches': true,
      'can_manage_matches': canManageMatches(userRole),
      'can_view_analytics': canViewAnalytics(userRole),
      'can_access_svs': canAccessSVS(userRole, tier),
      'can_access_annual_planning': canAccessAnnualPlanning(userRole),
      'can_manage_exercise_library': canManageExerciseLibrary(userRole),
      'can_access_field_diagram_editor': canAccessFieldDiagramEditor(userRole),
      'can_access_exercise_designer': canAccessExerciseDesigner(userRole),
      'can_access_admin': canAccessAdmin(userRole),
      'is_view_only': isViewOnlyUser(userRole),
    };

  /// Get role display information
  static Map<String, dynamic> getRoleInfo(String? userRole) {
    switch (userRole) {
      case 'bestuurder':
        return {
          'name': 'Bestuurder',
          'description': 'Volledige admin toegang',
          'color': 'red',
          'icon': 'admin_panel_settings',
          'access_level': 'full',
        };
      case 'hoofdcoach':
        return {
          'name': 'Hoofdcoach',
          'description': 'Team management en training',
          'color': 'blue',
          'icon': 'sports',
          'access_level': 'management',
        };
      case 'assistent':
        return {
          'name': 'Assistent Coach',
          'description': 'Beperkte management toegang',
          'color': 'green',
          'icon': 'assistant',
          'access_level': 'limited',
        };
      case 'speler':
        return {
          'name': 'Speler',
          'description': 'Alleen bekijken toegestaan',
          'color': 'orange',
          'icon': 'person',
          'access_level': 'view_only',
        };
      case 'ouder':
        return {
          'name': 'Ouder',
          'description': 'Beperkte bekijk toegang',
          'color': 'purple',
          'icon': 'family_restroom',
          'access_level': 'view_only',
        };
      case 'admin':
        return {
          'name': 'System Admin',
          'description': 'Technische admin toegang',
          'color': 'red',
          'icon': 'admin_panel_settings',
          'access_level': 'full',
        };
      default:
        return {
          'name': 'Onbekend',
          'description': 'Geen toegang',
          'color': 'grey',
          'icon': 'help',
          'access_level': 'none',
        };
    }
  }
}
