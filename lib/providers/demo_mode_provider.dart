// Dart imports:
import 'dart:async';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DemoRole {
  clubAdmin,
  boardMember, // Bestuurder
  technicalCommittee, // Technische Commissie
  coach,
  assistantCoach,
  player,
}

class DemoModeState {
  DemoModeState({
    this.isActive = false,
    this.role,
    this.organizationId,
    this.userId,
    this.userName,
    this.expiresAt,
  });
  final bool isActive;
  final DemoRole? role;
  final String? organizationId;
  final String? userId;
  final String? userName;
  final DateTime? expiresAt;

  DemoModeState copyWith({
    bool? isActive,
    DemoRole? role,
    String? organizationId,
    String? userId,
    String? userName,
    DateTime? expiresAt,
  }) =>
      DemoModeState(
        isActive: isActive ?? this.isActive,
        role: role ?? this.role,
        organizationId: organizationId ?? this.organizationId,
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        expiresAt: expiresAt ?? this.expiresAt,
      );

  bool get isDemo => isActive;
  bool get isAdmin =>
      role == DemoRole.boardMember || role == DemoRole.clubAdmin;
  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
}

class DemoModeNotifier extends StateNotifier<DemoModeState> {
  DemoModeNotifier() : super(DemoModeState());
  Timer? _expirationTimer;

  void startDemo({
    required DemoRole role,
    String? organizationId,
    String? userId,
    String? userName,
    int durationMinutes = 30,
  }) {
    final expiresAt = DateTime.now().add(Duration(minutes: durationMinutes));

    state = DemoModeState(
      isActive: true,
      role: role,
      organizationId: organizationId ?? 'demo-org-1',
      userId: userId ?? r'demo-user-${role.name}',
      userName: userName ?? _getDefaultUserName(role),
      expiresAt: expiresAt,
    );

    _startExpirationTimer(durationMinutes);
  }

  void setRole(String roleName) {
    final demoRole = _stringToRole(roleName);
    if (demoRole != null) {
      state = state.copyWith(
        role: demoRole,
        userId: r'demo-user-${demoRole.name}',
        userName: _getDefaultUserName(demoRole),
      );
    }
  }

  void setDemoMode({
    required bool isDemo,
    required bool isAdmin,
    required String tier,
  }) {
    if (isDemo) {
      final role = isAdmin ? DemoRole.boardMember : DemoRole.coach;
      startDemo(role: role, organizationId: r'demo-org-$tier');
    } else {
      endDemo();
    }
  }

  void extendDemo(int additionalMinutes) {
    if (state.isActive && state.expiresAt != null) {
      final newExpiresAt = state.expiresAt!.add(
        Duration(minutes: additionalMinutes),
      );
      state = state.copyWith(expiresAt: newExpiresAt);

      _expirationTimer?.cancel();
      final remainingMinutes =
          newExpiresAt.difference(DateTime.now()).inMinutes;
      _startExpirationTimer(remainingMinutes);
    }
  }

  void endDemo() {
    _expirationTimer?.cancel();
    state = DemoModeState();
  }

  void logout() {
    endDemo();
  }

  /// Get the current demo role as string
  String? getDemoRole() {
    switch (state.role) {
      case DemoRole.boardMember:
        return 'bestuurder';
      case DemoRole.coach:
        return 'hoofdcoach';
      case DemoRole.assistantCoach:
        return 'assistent';
      case DemoRole.player:
        return 'speler';
      case DemoRole.clubAdmin:
        return 'admin';
      case DemoRole.technicalCommittee:
        return 'technisch';
      default:
        return null;
    }
  }

  void _startExpirationTimer(int minutes) {
    _expirationTimer?.cancel();
    _expirationTimer = Timer(Duration(minutes: minutes), endDemo);
  }

  String _getDefaultUserName(DemoRole role) {
    switch (role) {
      case DemoRole.boardMember:
        return 'Demo Bestuurder';
      case DemoRole.coach:
        return 'Demo Hoofdcoach';
      case DemoRole.assistantCoach:
        return 'Demo Assistent';
      case DemoRole.player:
        return 'Demo Speler';
      case DemoRole.clubAdmin:
        return 'Demo Admin';
      case DemoRole.technicalCommittee:
        return 'Demo Technisch';
    }
  }

  DemoRole? _stringToRole(String roleName) {
    switch (roleName) {
      case 'bestuurder':
        return DemoRole.boardMember;
      case 'hoofdcoach':
        return DemoRole.coach;
      case 'assistent':
        return DemoRole.assistantCoach;
      case 'speler':
        return DemoRole.player;
      case 'ouder':
        return DemoRole.player; // Map parent to player for demo
      case 'admin':
        return DemoRole.clubAdmin;
      case 'technisch':
        return DemoRole.technicalCommittee;
      default:
        return null;
    }
  }

  @override
  void dispose() {
    _expirationTimer?.cancel();
    super.dispose();
  }
}

// Provider - Remove autoDispose to prevent state loss during navigation
final demoModeProvider = StateNotifierProvider<DemoModeNotifier, DemoModeState>(
  (ref) {
    final notifier = DemoModeNotifier();
    ref.onDispose(() {
      notifier._expirationTimer?.cancel();
    });
    return notifier;
  },
);

// Helper providers
final isDemoModeProvider = Provider<bool>(
  (ref) => ref.watch(demoModeProvider).isDemo,
);

final currentDemoRoleProvider = Provider<String?>(
  (ref) => ref.watch(demoModeProvider.notifier).getDemoRole(),
);

final demoTimeRemainingProvider = Provider<Duration?>((ref) {
  final state = ref.watch(demoModeProvider);
  if (!state.isActive || state.expiresAt == null) return null;

  final remaining = state.expiresAt!.difference(DateTime.now());
  return remaining.isNegative ? Duration.zero : remaining;
});
