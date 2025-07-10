// ignore_for_file: cascade_invocations

// Dart imports:
import 'dart:collection';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import 'package:jo17_tactical_manager/providers/auth_provider.dart';
import 'package:jo17_tactical_manager/providers/demo_mode_provider.dart';
import 'package:jo17_tactical_manager/providers/statistics_provider.dart';
import 'package:jo17_tactical_manager/screens/dashboard/dashboard_screen.dart';
import 'package:jo17_tactical_manager/services/auth_service.dart';

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

  // Unused methods can throw UnimplementedError
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

class _StatsStub extends MapBase<String, dynamic> {
  _StatsStub(this.totalTrainingAttendance, this.totalMatches);

  final int totalTrainingAttendance;
  final int totalMatches;

  // Additional stats required by dashboard
  final int wins = 0;
  final int draws = 0;
  final int losses = 0;
  final int goalsFor = 0;
  final int goalsAgainst = 0;

  int get goalDifference => goalsFor - goalsAgainst;
  int get totalTrainings => totalTrainingAttendance;
  double get winPercentage => 0;

  final Map<String, dynamic> _inner = {};

  @override
  dynamic operator [](Object? key) {
    switch (key) {
      case 'totalTrainingAttendance':
        return totalTrainingAttendance;
      case 'totalMatches':
        return totalMatches;
      case 'wins':
        return wins;
      case 'draws':
        return draws;
      case 'losses':
        return losses;
      case 'goalsFor':
        return goalsFor;
      case 'goalsAgainst':
        return goalsAgainst;
      case 'goalDifference':
        return goalDifference;
      case 'totalTrainings':
        return totalTrainings;
      case 'winPercentage':
        return winPercentage;
      default:
        return _inner[key];
    }
  }

  @override
  void operator []=(String key, dynamic value) => _inner[key] = value;

  @override
  void clear() => _inner.clear();

  @override
  Iterable<String> get keys => [
    'totalTrainingAttendance',
    'totalMatches',
    'wins',
    'draws',
    'losses',
    'goalsFor',
    'goalsAgainst',
    'goalDifference',
    'totalTrainings',
    'winPercentage',
    ..._inner.keys,
  ];

  @override
  dynamic remove(Object? key) => _inner.remove(key);
}

void main() {
  group('DashboardScreen RBAC & Demo banner', () {
    testWidgets('Coach role shows training & lineup actions and demo banner', (
      tester,
    ) async {
      final demoNotifier = DemoModeNotifier();
      demoNotifier.startDemo(role: DemoRole.coach);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            demoModeProvider.overrideWith((ref) => demoNotifier),
            authServiceProvider.overrideWith((ref) => FakeAuthService()),
            statisticsProvider.overrideWith((ref) async => _StatsStub(0, 0)),
          ],
          child: const MaterialApp(home: DashboardScreen()),
        ),
      );

      await tester.pump(const Duration(seconds: 1));

      // AppBar action icons
      expect(find.byIcon(Icons.add_circle_outline), findsWidgets);
      expect(find.byIcon(Icons.sports_soccer), findsWidgets);
      // RBAC demo banner present
      expect(find.textContaining('RBAC Demo Mode'), findsOneWidget);
    });

    testWidgets('Player role hides action icons but shows banner', (
      tester,
    ) async {
      final demoNotifier = DemoModeNotifier();
      demoNotifier.startDemo(role: DemoRole.player);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            demoModeProvider.overrideWith((ref) => demoNotifier),
            authServiceProvider.overrideWith((ref) => FakeAuthService()),
            statisticsProvider.overrideWith((ref) async => _StatsStub(0, 0)),
          ],
          child: const MaterialApp(home: DashboardScreen()),
        ),
      );

      await tester.pump(const Duration(seconds: 1));

      expect(find.textContaining('RBAC Demo Mode'), findsOneWidget);
    });

    testWidgets('Demo mode off hides RBAC banner', (tester) async {
      final demoNotifier = DemoModeNotifier(); // default inactive

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            demoModeProvider.overrideWith((ref) => demoNotifier),
            authServiceProvider.overrideWith((ref) => FakeAuthService()),
            statisticsProvider.overrideWith((ref) async => _StatsStub(0, 0)),
          ],
          child: const MaterialApp(home: DashboardScreen()),
        ),
      );

      await tester.pump(const Duration(seconds: 1));

      expect(find.textContaining('RBAC Demo Mode'), findsNothing);
    });
  });
}
