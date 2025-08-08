import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Demo roles supported in the app
enum DemoRole {
  coach,
  assistantCoach,
}

/// Immutable demo mode state
class DemoModeState {
  final bool isActive;
  final DemoRole? role;
  final String? organizationId;
  final String? userId;
  final String? userName;

  const DemoModeState({
    this.isActive = false,
    this.role,
    this.organizationId,
    this.userId,
    this.userName,
  });

  DemoModeState copyWith({
    bool? isActive,
    DemoRole? role,
    String? organizationId,
    String? userId,
    String? userName,
  }) {
    return DemoModeState(
      isActive: isActive ?? this.isActive,
      role: role ?? this.role,
      organizationId: organizationId ?? this.organizationId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
    );
  }
}

/// Notifier for demo mode
class DemoModeNotifier extends StateNotifier<DemoModeState> {
  DemoModeNotifier() : super(const DemoModeState());

  void startDemo({
    required DemoRole role,
    required String organizationId,
    required String userId,
    required String userName,
  }) {
    state = state.copyWith(
      isActive: true,
      role: role,
      organizationId: organizationId,
      userId: userId,
      userName: userName,
    );
  }

  void stopDemo() {
    state = const DemoModeState();
  }
}

/// Public provider
final demoModeProvider =
    StateNotifierProvider<DemoModeNotifier, DemoModeState>(
  (ref) => DemoModeNotifier(),
);
