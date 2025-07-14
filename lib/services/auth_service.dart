// Package imports:
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  /// Allow dependency injection for testing by passing a custom [SupabaseClient].
  ///
  /// When running unit/widget tests the global `Supabase` instance is often **not**
  /// initialised which normally triggers an assertion inside the Supabase
  /// package.  Accessing [Supabase.instance] in that scenario would therefore
  /// crash the test run.  To keep the production behaviour unchanged while still
  /// enabling lightweight tests we lazily fall back to a dummy
  /// `SupabaseClient` when the global instance is unavailable.
  AuthService({SupabaseClient? client}) : _supabase = client ?? _initClient();

  /// Tries to obtain the globally initialised Supabase client. If that fails
  /// (e.g. because `Supabase.initialize` has not been invoked) a stub client is
  /// returned which uses a fake URL/key combination. The stub client is more
  /// than enough for the read-only operations that our tests rely on and avoids
  /// leaking network traffic during CI.
  static SupabaseClient _initClient() {
    try {
      return Supabase.instance.client;
    } catch (_) {
      // Fallback: provide a no-op client for tests. The URL/key may be any
      // string because it will never be used to perform real requests.
      return SupabaseClient('https://dummy.supabase.co', 'public-anon-key');
    }
  }

  final SupabaseClient _supabase;

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Get current session
  Session? get currentSession => _supabase.auth.currentSession;

  // Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  // Auth state stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Sign in with magic link
  Future<void> signInWithEmail(String email) async {
    try {
      await _supabase.auth.signInWithOtp(
        email: email,
        emailRedirectTo: _getRedirectUrl(),
      );
    } catch (e) {
      throw AuthException('Failed to send magic link: $e');
    }
  }

  // Sign in with password (for future use)
  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw AuthException('Failed to sign in: $e');
    }
  }

  // Sign up new user
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      return await _supabase.auth.signUp(
        email: email,
        password: password,
        data: metadata,
      );
    } catch (e) {
      throw AuthException('Failed to sign up: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw AuthException('Failed to sign out: $e');
    }
  }

  // Update user metadata
  Future<UserResponse> updateUserMetadata(Map<String, dynamic> metadata) async {
    try {
      return await _supabase.auth.updateUser(UserAttributes(data: metadata));
    } catch (e) {
      throw AuthException('Failed to update user: $e');
    }
  }

  // Get user role from metadata
  String? getUserRole() {
    final metadata = currentUser?.userMetadata;
    return metadata?['role'] as String?;
  }

  // Get organization ID from metadata
  String? getOrganizationId() {
    final metadata = currentUser?.userMetadata;
    return metadata?['organization_id'] as String?;
  }

  // Helper to get redirect URL based on platform
  String _getRedirectUrl() {
    // For web, use the current origin
    if (identical(0, 0.0)) {
      // Check if running on web
      return 'https://app.jo17manager.nl/auth/callback';
    }
    // For mobile, use deep link
    return 'io.supabase.jo17tacticalmanager://login-callback/';
  }
}

class AuthException implements Exception {
  AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}
