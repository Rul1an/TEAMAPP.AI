// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import 'package:jo17_tactical_manager/services/auth_service.dart';
import 'package:jo17_tactical_manager/providers/auth_provider.dart';

// Generate mocks
import 'auth_test_helper.mocks.dart';

/// Helper class for mocking auth services in tests
@GenerateMocks([SupabaseClient, GoTrueClient])
class AuthTestHelper {
  static MockSupabaseClient? _mockClient;
  static MockGoTrueClient? _mockAuth;
  static AuthService? _testAuthService;

  /// Setup mock Supabase client for tests
  static void setupAuthMocking() {
    _mockClient = MockSupabaseClient();
    _mockAuth = MockGoTrueClient();

    // Mock the auth client - this should be set up first
    when(_mockClient!.auth).thenReturn(_mockAuth!);

    // Mock auth state stream for standalone mode
    when(_mockAuth!.onAuthStateChange).thenAnswer(
      (_) => Stream.value(AuthState(AuthChangeEvent.signedOut, null)),
    );

    // Mock current user and session (null for standalone mode)
    when(_mockAuth!.currentUser).thenReturn(null);
    when(_mockAuth!.currentSession).thenReturn(null);

    // Create test auth service with mocked client - but we won't use it in standalone mode
    // _testAuthService = AuthService(client: _mockClient!);
  }

  /// Get the test auth service provider override
  static Override getAuthServiceProviderOverride() {
    if (_testAuthService == null) {
      throw StateError(
          'Auth mocking not set up. Call setupAuthMocking() first.');
    }
    return authServiceProvider.overrideWithValue(_testAuthService!);
  }

  /// Get auth provider overrides for standalone mode testing
  static List<Override> getStandaloneModeOverrides() {
    return [
      // For standalone mode, we don't need actual auth service since we bypass it
      // Current user provider (null in standalone)
      currentUserProvider.overrideWithValue(null),
      // Is logged in (true in standalone)
      isLoggedInProvider.overrideWithValue(true),
      // User role (coach in standalone)
      userRoleProvider.overrideWithValue('coach'),
      // Organization ID (standalone-org-local in standalone)
      organizationIdProvider.overrideWithValue('standalone-org-local'),
    ];
  }

  /// Clean up mocks
  static void cleanup() {
    _mockClient = null;
    _mockAuth = null;
    _testAuthService = null;
  }
}
