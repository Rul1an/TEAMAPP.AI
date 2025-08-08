// Package imports:
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import '../utils/error_sanitizer.dart';

class AuthService {
  /// Allow dependency injection for testing by passing a custom [SupabaseClient].
  AuthService({SupabaseClient? client})
      : _supabase = client ?? Supabase.instance.client;

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
    } on AuthException catch (e, s) {
      throw Exception(ErrorSanitizer.sanitize(e.message ?? e, s));
    } catch (e, s) {
      throw Exception(ErrorSanitizer.sanitize(e, s));
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
    } on AuthException catch (e, s) {
      throw Exception(ErrorSanitizer.sanitize(e.message ?? e, s));
    } catch (e, s) {
      throw Exception(ErrorSanitizer.sanitize(e, s));
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
    } on AuthException catch (e, s) {
      throw Exception(ErrorSanitizer.sanitize(e.message ?? e, s));
    } catch (e, s) {
      throw Exception(ErrorSanitizer.sanitize(e, s));
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } on AuthException catch (e, s) {
      throw Exception(ErrorSanitizer.sanitize(e.message ?? e, s));
    } catch (e, s) {
      throw Exception(ErrorSanitizer.sanitize(e, s));
    }
  }

  // Update user metadata
  Future<UserResponse> updateUserMetadata(Map<String, dynamic> metadata) async {
    try {
      return await _supabase.auth.updateUser(UserAttributes(data: metadata));
    } on AuthException catch (e, s) {
      throw Exception(ErrorSanitizer.sanitize(e.message ?? e, s));
    } catch (e, s) {
      throw Exception(ErrorSanitizer.sanitize(e, s));
    }
  }

  // Helper to get redirect URL based on platform
  String _getRedirectUrl() {
    if (kIsWeb) {
      final origin = Uri.base.origin; // e.g. https://teamappai.netlify.app
      return '$origin/auth';
    }
    return 'io.supabase.jo17tacticalmanager://login-callback/';
  }
}
