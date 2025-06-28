import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

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
      throw AuthException('Failed to send magic link: ${e.toString()}');
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
      throw AuthException('Failed to sign in: ${e.toString()}');
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
      throw AuthException('Failed to sign up: ${e.toString()}');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw AuthException('Failed to sign out: ${e.toString()}');
    }
  }

  // Update user metadata
  Future<UserResponse> updateUserMetadata(Map<String, dynamic> metadata) async {
    try {
      return await _supabase.auth.updateUser(
        UserAttributes(data: metadata),
      );
    } catch (e) {
      throw AuthException('Failed to update user: ${e.toString()}');
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
    if (identical(0, 0.0)) { // Check if running on web
      return 'https://app.jo17manager.nl/auth/callback';
    }
    // For mobile, use deep link
    return 'io.supabase.jo17tacticalmanager://login-callback/';
  }
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => message;
}
