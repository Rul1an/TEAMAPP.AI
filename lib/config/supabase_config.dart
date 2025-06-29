import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'environment.dart';

/// 🚀 Supabase Configuration & Client Setup
/// Voor multi-tenant SaaS architectuur
class SupabaseConfig {
  static late final SupabaseClient _client;

  /// Initialize Supabase with environment-specific settings
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: Environment.current.supabaseUrl,
      anonKey: Environment.current.supabaseAnonKey,
      debug: Environment.current.enableDebugFeatures,
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
    );

    _client = Supabase.instance.client;

    // Setup auth state listener
    _setupAuthListener();
  }

  /// Get the Supabase client instance
  static SupabaseClient get client => _client;

  /// Get current user
  static User? get currentUser => _client.auth.currentUser;

  /// Get current user ID
  static String? get currentUserId => currentUser?.id;

  /// Check if user is authenticated
  static bool get isAuthenticated => currentUser != null;

  /// Setup authentication state listener
  static void _setupAuthListener() {
    _client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      switch (event) {
        case AuthChangeEvent.signedIn:
          debugPrint('✅ User signed in: ${session?.user.email}');
          break;
        case AuthChangeEvent.signedOut:
          debugPrint('👋 User signed out');
          break;
        case AuthChangeEvent.tokenRefreshed:
          debugPrint('🔄 Token refreshed');
          break;
        case AuthChangeEvent.userUpdated:
          debugPrint('👤 User updated');
          break;
        case AuthChangeEvent.passwordRecovery:
          debugPrint('🔐 Password recovery initiated');
          break;
        default:
          debugPrint('🔄 Auth state changed: $event');
      }
    });
  }

  /// Sign up new user
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async =>
      _client.auth.signUp(
        email: email,
        password: password,
        data: data,
      );

  /// Sign in user
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async =>
      _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

  /// Sign out user
  static Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Reset password
  static Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  /// Get user's organizations
  static Future<List<Map<String, dynamic>>> getUserOrganizations() async {
    if (!isAuthenticated) return [];

    final response = await _client.from('organization_members').select('''
          organization_id,
          role,
          organizations (
            id,
            name,
            slug,
            subscription_tier,
            subscription_status,
            max_players,
            max_teams,
            max_coaches,
            settings,
            branding
          )
        ''').eq('user_id', currentUserId!);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Get user's current organization (first one for now)
  static Future<Map<String, dynamic>?> getCurrentOrganization() async {
    final orgs = await getUserOrganizations();
    return orgs.isNotEmpty
        ? orgs.first['organizations'] as Map<String, dynamic>?
        : null;
  }

  /// Create new organization (for onboarding)
  static Future<Map<String, dynamic>> createOrganization({
    required String name,
    required String slug,
    final String subscriptionTier = 'basic',
    Map<String, dynamic>? settings,
  }) async {
    if (!isAuthenticated) {
      throw Exception('User must be authenticated to create organization');
    }

    // Create organization
    final orgResponse = await _client
        .from('organizations')
        .insert({
          'name': name,
          'slug': slug,
          'subscription_tier': subscriptionTier,
          'settings': settings ?? {},
        })
        .select()
        .single();

    // Add user as owner
    await _client.from('organization_members').insert({
      'organization_id': orgResponse['id'],
      'user_id': currentUserId,
      'role': 'owner',
    });

    return orgResponse;
  }

  /// Get organization subscription info
  static Future<Map<String, dynamic>?> getSubscriptionInfo(
      String organizationId,) async {
    final response = await _client
        .from('organizations')
        .select(
            'subscription_tier, subscription_status, trial_ends_at, max_players, max_teams, max_coaches',)
        .eq('id', organizationId)
        .single();

    return response;
  }

  /// Update organization subscription
  static Future<void> updateSubscription({
    required String organizationId,
    required String tier,
    required String status,
    DateTime? trialEndsAt,
  }) async {
    await _client.from('organizations').update({
      'subscription_tier': tier,
      'subscription_status': status,
      'trial_ends_at': trialEndsAt?.toIso8601String(),
      // Update limits based on tier
      'max_players': _getMaxPlayers(tier),
      'max_teams': _getMaxTeams(tier),
      'max_coaches': _getMaxCoaches(tier),
    }).eq('id', organizationId);
  }

  /// Helper: Get max players for subscription tier
  static int _getMaxPlayers(String tier) {
    switch (tier) {
      case 'basic':
        return 25;
      case 'pro':
        return 50;
      case 'enterprise':
        return 999999; // Unlimited
      default:
        return 25;
    }
  }

  /// Helper: Get max teams for subscription tier
  static int _getMaxTeams(String tier) {
    switch (tier) {
      case 'basic':
        return 1;
      case 'pro':
        return 3;
      case 'enterprise':
        return 999999; // Unlimited
      default:
        return 1;
    }
  }

  /// Helper: Get max coaches for subscription tier
  static int _getMaxCoaches(String tier) {
    switch (tier) {
      case 'basic':
        return 3;
      case 'pro':
        return 5;
      case 'enterprise':
        return 999999; // Unlimited
      default:
        return 3;
    }
  }

  /// Execute RPC (Remote Procedure Call) functions
  static Future<dynamic> rpc(String functionName,
          [Map<String, dynamic>? params,]) async =>
      await _client.rpc(functionName, params: params);

  /// Realtime subscription for organization data
  static RealtimeChannel subscribeToOrganization(String organizationId,
          void void Function(PostgresChangePayload) callback,) =>
      _client
          .channel('organization_$organizationId')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'organization_id',
              value: organizationId,
            ),
            callback: callback,
          )
          .subscribe();
}

/// Extension for easier access to Supabase client
extension SupabaseExtension on SupabaseClient {
  /// Quick access to current organization ID (stored in user metadata)
  String? get currentOrganizationId =>
      auth.currentUser?.userMetadata?['organization_id'] as String?;

  /// Set current organization ID in user metadata
  Future<void> setCurrentOrganizationId(String organizationId) async {
    await auth.updateUser(
      UserAttributes(
        data: {
          ...auth.currentUser?.userMetadata ?? {},
          'organization_id': organizationId,
        },
      ),
    );
  }
}
