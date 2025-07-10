import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:jo17_tactical_manager/services/auth_service.dart';

/// Simple fake that avoids external Supabase calls.
class FakeAuthService implements AuthService {
  @override
  User? get currentUser => null;

  @override
  bool get isLoggedIn => false;

  @override
  Stream<AuthState> get authStateChanges => const Stream.empty();

  @override
  String? getUserRole() => null;

  @override
  String? getOrganizationId() => null;

  @override
  Session? get currentSession => null;

  // The rest throw to highlight unintended usage
  @override
  Future<void> signInWithEmail(String email) async =>
      throw UnimplementedError();

  @override
  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) => throw UnimplementedError();

  @override
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) => throw UnimplementedError();

  @override
  Future<void> signOut() async => throw UnimplementedError();

  @override
  Future<UserResponse> updateUserMetadata(Map<String, dynamic> metadata) =>
      throw UnimplementedError();
}
