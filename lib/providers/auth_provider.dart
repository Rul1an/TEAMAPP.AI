// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import '../services/auth_service.dart';
import '../config/environment.dart';

// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  // In coach mode, return a mock user
  if (Environment.isCoachMode) {
    // Return null since we don't need actual Supabase User object in coach mode
    // The isLoggedInProvider will handle the "logged in" state
    return null;
  }

  final authService = ref.watch(authServiceProvider);
  return authService.currentUser;
});

// Auth state stream provider
final authStateProvider = StreamProvider<AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// Is logged in provider
final isLoggedInProvider = Provider<bool>((ref) {
  // In coach mode, always consider user as "logged in"
  if (Environment.isCoachMode) {
    return true;
  }

  final user = ref.watch(currentUserProvider);
  return user != null;
});

// User role provider
final userRoleProvider = Provider<String?>((ref) {
  // In coach mode, always return 'coach' role
  if (Environment.isCoachMode) {
    return 'coach';
  }

  final authService = ref.watch(authServiceProvider);
  return authService.getUserRole();
});

// Organization ID provider
final organizationIdProvider = Provider<String?>((ref) {
  // In coach mode, return a mock organization ID
  if (Environment.isCoachMode) {
    return 'coach-org-local';
  }

  final authService = ref.watch(authServiceProvider);
  return authService.getOrganizationId();
});

// Auth state notifier for handling auth actions
class AuthNotifier extends StateNotifier<AuthState?> {
  AuthNotifier(this._authService) : super(null) {
    // Listen to auth state changes
    _authService.authStateChanges.listen((authState) {
      state = authState;
    });
  }
  final AuthService _authService;

  Future<void> signInWithEmail(String email) async {
    try {
      await _authService.signInWithEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      rethrow;
    }
  }
}

// Auth notifier provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState?>((
  ref,
) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});
