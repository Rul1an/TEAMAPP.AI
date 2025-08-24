// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import '../services/auth_service.dart';
import '../config/environment.dart';
import 'demo_mode_provider.dart';

// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  // In standalone mode, return null since we don't need actual Supabase User object
  if (Environment.isStandaloneMode) {
    // Return null since we don't need actual Supabase User object in standalone mode
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

// Is logged in provider - Enhanced with multi-mode support (2025)
final isLoggedInProvider = Provider<bool>((ref) {
  // In standalone mode, always consider user as "logged in"
  if (Environment.isStandaloneMode) {
    return true;
  }

  // In demo mode, check demo state
  if (Environment.isDemoMode) {
    final demoState = ref.watch(demoModeProvider);
    return demoState.isActive;
  }

  // In SaaS mode, accept demo state as valid authentication for development
  if (Environment.isSaasMode) {
    final demoState = ref.watch(demoModeProvider);
    if (demoState.isActive) {
      return true; // Allow demo admin access in SaaS mode
    }
    final user = ref.watch(currentUserProvider);
    return user != null;
  }

  // Default fallback (should not reach here)
  return false;
});

// User role provider
final userRoleProvider = Provider<String?>((ref) {
  // In standalone mode, always return 'coach' role
  if (Environment.isStandaloneMode) {
    return 'coach';
  }

  // In SaaS mode, check demo state first
  if (Environment.isSaasMode) {
    final demoState = ref.watch(demoModeProvider);
    if (demoState.isActive) {
      return ref.read(demoModeProvider.notifier).getDemoRole(); // Use demo role
    }
  }

  final authService = ref.watch(authServiceProvider);
  return authService.getUserRole();
});

// Organization ID provider
final organizationIdProvider = Provider<String?>((ref) {
  // In standalone mode, return a mock organization ID
  if (Environment.isStandaloneMode) {
    return 'standalone-org-local';
  }

  // In SaaS mode, check demo state first
  if (Environment.isSaasMode) {
    final demoState = ref.watch(demoModeProvider);
    if (demoState.isActive && demoState.organizationId != null) {
      return demoState.organizationId; // Use demo organization ID
    }
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
