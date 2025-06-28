import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Current user provider
final currentUserProvider = Provider<User?>((ref) {
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
  final user = ref.watch(currentUserProvider);
  return user != null;
});

// User role provider
final userRoleProvider = Provider<String?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.getUserRole();
});

// Organization ID provider
final organizationIdProvider = Provider<String?>((ref) {
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
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});
