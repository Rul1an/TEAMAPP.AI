import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

enum DemoRole {
  clubAdmin,
  boardMember,  // Bestuurder
  technicalCommittee,  // Technische Commissie
  coach,
  assistantCoach,
  player
}

class DemoModeState {
  final bool isActive;
  final DemoRole? role;
  final String? organizationId;
  final String? userId;
  final String? userName;
  final DateTime? expiresAt;

  DemoModeState({
    this.isActive = false,
    this.role,
    this.organizationId,
    this.userId,
    this.userName,
    this.expiresAt,
  });

  DemoModeState copyWith({
    bool? isActive,
    DemoRole? role,
    String? organizationId,
    String? userId,
    String? userName,
    DateTime? expiresAt,
  }) {
    return DemoModeState(
      isActive: isActive ?? this.isActive,
      role: role ?? this.role,
      organizationId: organizationId ?? this.organizationId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  bool get isExpired =>
    expiresAt != null && DateTime.now().isAfter(expiresAt!);

  Duration? get remainingTime =>
    expiresAt?.difference(DateTime.now());

  String get roleDisplayName {
    switch (role) {
      case DemoRole.clubAdmin:
        return 'Club Administrator';
      case DemoRole.boardMember:
        return 'Bestuurder';
      case DemoRole.technicalCommittee:
        return 'Technische Commissie';
      case DemoRole.coach:
        return 'Hoofdtrainer';
      case DemoRole.assistantCoach:
        return 'Assistent Trainer';
      case DemoRole.player:
        return 'Speler';
      default:
        return '';
    }
  }
}

class DemoModeNotifier extends StateNotifier<DemoModeState> {
  Timer? _sessionTimer;
  Timer? _warningTimer;

  DemoModeNotifier() : super(DemoModeState());

  void startDemo(DemoRole role) {
    // Cancel existing timers
    _sessionTimer?.cancel();
    _warningTimer?.cancel();

    // Generate demo data
    final now = DateTime.now();
    final expiresAt = now.add(const Duration(minutes: 30));

    // Set demo state
    state = DemoModeState(
      isActive: true,
      role: role,
      organizationId: 'demo-org-voab',
      userId: 'demo-user-${role.name}-${now.millisecondsSinceEpoch}',
      userName: _getDemoUserName(role),
      expiresAt: expiresAt,
    );

    // Start warning timer (5 minutes before expiry)
    _warningTimer = Timer(const Duration(minutes: 25), () {
      // Could trigger a notification here
    });

    // Start session timer
    _sessionTimer = Timer(const Duration(minutes: 30), () {
      endDemo();
    });
  }

  void extendDemo() {
    if (state.isActive && state.role != null) {
      startDemo(state.role!);
    }
  }

  void endDemo() {
    _sessionTimer?.cancel();
    _warningTimer?.cancel();
    state = DemoModeState();
  }

  String _getDemoUserName(DemoRole role) {
    switch (role) {
      case DemoRole.clubAdmin:
        return 'Jan van der Admin';
      case DemoRole.boardMember:
        return 'Piet Bestuurder';
      case DemoRole.technicalCommittee:
        return 'Klaas Technisch';
      case DemoRole.coach:
        return 'Johan Trainer';
      case DemoRole.assistantCoach:
        return 'Henk Assistent';
      case DemoRole.player:
        return 'Robin Speler';
    }
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _warningTimer?.cancel();
    super.dispose();
  }
}

final demoModeProvider = StateNotifierProvider<DemoModeNotifier, DemoModeState>(
  (ref) => DemoModeNotifier(),
);

// Helper providers
final isDemoModeProvider = Provider<bool>((ref) {
  return ref.watch(demoModeProvider).isActive;
});

final demoRoleProvider = Provider<DemoRole?>((ref) {
  return ref.watch(demoModeProvider).role;
});

final demoUserNameProvider = Provider<String?>((ref) {
  return ref.watch(demoModeProvider).userName;
});
