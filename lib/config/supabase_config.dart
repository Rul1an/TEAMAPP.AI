// ignore_for_file: use_setters_to_change_properties

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import '../utils/app_logger.dart';
import 'environment.dart';

/// 🚀 Supabase Configuration & Client Setup
/// Voor multi-tenant SaaS architectuur
class SupabaseConfig {
  static SupabaseClient? _client;

  /// Initialize Supabase with environment-specific settings (includes Supabase.initialize)
  static Future<void> initialize() async {
    // Check if already initialized to prevent double initialization
    try {
      // Try to access the client - if this works, Supabase is already initialized
      _client = Supabase.instance.client;
      _setupAuthListener();
      return;
    } catch (e) {
      // Supabase not initialized yet, continue with initialization
    }

    await Supabase.initialize(
      url: Environment.current.supabaseUrl,
      anonKey: Environment.current.supabaseAnonKey,
      debug: Environment.current.enableDebugFeatures,
      // Keep default FlutterAuthClientOptions; tests use non-PKCE clients explicitly
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
    );

    _client = Supabase.instance.client;

    // Setup auth state listener
    _setupAuthListener();

    // Ensure org context is available as early as possible for authenticated users
    // (used by data sources to scope queries and avoid 400s when missing)
    // Best-effort; do not await to avoid blocking app startup
    // ignore: unawaited_futures
    ensureOrganizationContext();
  }

  /// Initialize only our SupabaseConfig wrapper (assumes Supabase.initialize already called)
  static Future<void> initializeClient() async {
    try {
      // Try to access Supabase instance - will throw if not initialized
      // ignore: unnecessary_statements
      Supabase.instance.client;
      // If we get here, Supabase is initialized
    } catch (e) {
      throw StateError(
          'Supabase must be initialized before calling initializeClient()');
    }

    _client = Supabase.instance.client;

    // Setup auth state listener
    _setupAuthListener();

    // Ensure org context if possible
    // ignore: unawaited_futures
    ensureOrganizationContext();
  }

  /// Get the Supabase client instance - with null safety
  static SupabaseClient get client {
    if (_client == null) {
      throw StateError(
        'Supabase client not initialized. Call SupabaseConfig.initialize() first.',
      );
    }
    return _client!;
  }

  /// Safe getter that returns null if not initialized
  static SupabaseClient? get clientOrNull => _client;

  /// Check if Supabase is properly initialized
  static bool get isInitialized => _client != null;

  /// Testing hook – allows injecting a fake client without running full initialization.
  @visibleForTesting
  static void setClientForTest(SupabaseClient client) {
    _client = client;
  }

  /// Get current user
  static User? get currentUser => _client?.auth.currentUser;

  /// Get current user ID
  static String? get currentUserId => currentUser?.id;

  /// Check if user is authenticated
  static bool get isAuthenticated => currentUser != null;

  /// Setup authentication state listener
  static void _setupAuthListener() {
    _client?.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;

      switch (event) {
        case AuthChangeEvent.signedIn:
          AppLogger.i('✅ User signed in: ${session?.user.email}');
          // After sign-in, try to populate missing organization context
          // ignore: unawaited_futures
          ensureOrganizationContext();
        case AuthChangeEvent.signedOut:
          AppLogger.i('👋 User signed out');
        case AuthChangeEvent.tokenRefreshed:
          AppLogger.i('🔄 Token refreshed');
        case AuthChangeEvent.userUpdated:
          AppLogger.i('👤 User updated');
        case AuthChangeEvent.passwordRecovery:
          AppLogger.i('🔐 Password recovery initiated');
        default:
          AppLogger.i('🔄 Auth state changed: $event');
      }
    });
  }

  /// Ensure a valid organization context is set for the authenticated user.
  /// If user metadata lacks `organization_id`, pick the first membership and set it.
  static Future<void> ensureOrganizationContext() async {
    if (!isInitialized || !isAuthenticated) return;

    final currentOrgId = client.currentOrganizationId;
    if (currentOrgId != null && currentOrgId.isNotEmpty) {
      return; // Already set
    }

    try {
      final orgs = await getUserOrganizations();
      if (orgs.isNotEmpty) {
        final first = orgs.first['organizations'] as Map<String, dynamic>?;
        final String? orgId = first?['id'] as String?;
        if (orgId != null && orgId.isNotEmpty) {
          await client.setCurrentOrganizationId(orgId);
          AppLogger.i(
              '🏢 Organization context set to first membership: $orgId');
        }
      } else {
        AppLogger.w(
            'No organizations found for user; organization context remains unset');
      }
    } catch (e) {
      AppLogger.e('Failed to ensure organization context: $e');
    }
  }

  /// Sign up new user
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    if (!isInitialized) {
      throw StateError('Supabase client not initialized');
    }
    return _client!.auth.signUp(email: email, password: password, data: data);
  }

  /// Sign in user
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) {
      throw StateError('Supabase client not initialized');
    }
    return _client!.auth.signInWithPassword(email: email, password: password);
  }

  /// Sign out user
  static Future<void> signOut() async {
    await _client?.auth.signOut();
  }

  /// Reset password
  static Future<void> resetPassword(String email) async {
    await _client?.auth.resetPasswordForEmail(email);
  }

  /// Get user's organizations
  static Future<List<Map<String, dynamic>>> getUserOrganizations() async {
    if (!isAuthenticated || !isInitialized) return [];

    try {
      final response = await client.from('organization_members').select('''
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
    } catch (e) {
      AppLogger.e('Error fetching user organizations: $e');
      return [];
    }
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
    final orgResponse = await _client!
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
    await _client!.from('organization_members').insert({
      'organization_id': orgResponse['id'],
      'user_id': currentUserId,
      'role': 'owner',
    });

    return orgResponse;
  }

  /// Get organization subscription info
  static Future<Map<String, dynamic>?> getSubscriptionInfo(
    String organizationId,
  ) async {
    final response = await _client!
        .from('organizations')
        .select(
          'subscription_tier, subscription_status, trial_ends_at, max_players, max_teams, max_coaches',
        )
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
    await _client!.from('organizations').update({
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
  static Future<dynamic> rpc(
    String functionName, [
    Map<String, dynamic>? params,
  ]) async =>
      await _client!.rpc(functionName, params: params);

  /// Realtime subscription for organization data
  static RealtimeChannel subscribeToOrganization(
    String organizationId,
    void Function(PostgresChangePayload) callback,
  ) =>
      _client!
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
    // Force token refresh so that updated metadata propagates and RLS picks up
    await auth.refreshSession();
  }
}

/// Additional helpers related to organization context.
extension SupabaseOrganizationHelpers on SupabaseClient {
  /// Try to resolve the current organization id via RPC first, then fallback to user metadata.
  /// Returns null if neither source provides an id.
  Future<String?> getOrganizationIdWithFallback() async {
    // Demo mode support: use demo organization ID when in SaaS mode without auth
    if (Environment.isSaasMode && auth.currentUser == null) {
      return '123e4567-e89b-12d3-a456-426614174000'; // Demo organization UUID
    }

    // Fast-path: if not authenticated, avoid RPC/network entirely
    if (auth.currentUser == null) {
      return null;
    }

    // 1) Prefer RPC for server-authoritative value (and to benefit from DB-side caching)
    try {
      final String? orgId = await rpc<String?>(
        'get_user_organization_id',
      );
      if (orgId != null && orgId.isNotEmpty) {
        return orgId;
      }
    } catch (_) {
      // Ignore and fallback to metadata
    }

    // 2) Fallback to metadata on the auth user
    final String? metadataOrgId = currentOrganizationId;
    if (metadataOrgId != null && metadataOrgId.isNotEmpty) {
      return metadataOrgId;
    }

    return null;
  }
}
