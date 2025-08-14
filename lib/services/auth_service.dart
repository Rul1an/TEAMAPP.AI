// Package imports:
import 'dart:async' show unawaited;
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import 'analytics_events.dart';

class AuthService {
  /// Allow dependency injection for testing by passing a custom [SupabaseClient].
  AuthService({SupabaseClient? client})
      : _supabase = client ?? Supabase.instance.client;

  final SupabaseClient _supabase;
  final AnalyticsLogger _analytics = const AnalyticsLogger();

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
      // Log intent (no user id yet)
      unawaited(_analytics.log(
        AnalyticsEvent.authLogin,
        parameters: {'method': 'magic_link'},
      ));
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
      final res = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final userId = res.user?.id;
      unawaited(_analytics.log(
        AnalyticsEvent.authLogin,
        parameters: {'method': 'password'},
        userId: userId,
      ));
      return res;
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
      final res = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: metadata,
      );
      final userId = res.user?.id;
      unawaited(_analytics.log(
        AnalyticsEvent.authLogin,
        parameters: {'method': 'signup'},
        userId: userId,
      ));
      return res;
    } catch (e) {
      throw AuthException('Failed to sign up: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      final userId = currentUser?.id;
      await _supabase.auth.signOut();
      unawaited(_analytics.log(
        AnalyticsEvent.authLogout,
        userId: userId,
      ));
    } catch (e) {
      throw AuthException('Failed to sign out: $e');
    }
  }

  // Update user metadata
  Future<UserResponse> updateUserMetadata(Map<String, dynamic> metadata) async {
    try {
      final res =
          await _supabase.auth.updateUser(UserAttributes(data: metadata));
      // Track role switch when applicable
      final role = metadata['role'] as String?;
      if (role != null) {
        final userId = res.user?.id ?? currentUser?.id;
        unawaited(_analytics.log(
          AnalyticsEvent.roleSwitch,
          parameters: {'role': role},
          userId: userId,
        ));
      }
      return res;
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
    // For web, use hosted app callback
    if (kIsWeb) {
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
