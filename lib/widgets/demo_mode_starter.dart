// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../providers/demo_mode_provider.dart';

/// 🚀 Demo Mode Starter - Automatically activates demo mode for testing
class DemoModeStarter extends ConsumerStatefulWidget {
  const DemoModeStarter({required this.child, super.key});
  final Widget child;

  @override
  ConsumerState<DemoModeStarter> createState() => _DemoModeStarterState();
}

class _DemoModeStarterState extends ConsumerState<DemoModeStarter> {
  @override
  void initState() {
    super.initState();

    // 🔧 CASCADE OPERATOR DOCUMENTATION: Widget Callback Pattern
    // This WidgetsBinding.instance.addPostFrameCallback pattern demonstrates
    // a common Flutter pattern where cascade notation could improve readability.
    //
    // **CURRENT PATTERN**: method(callback) (single method call)
    // **RECOMMENDED**: object..method(callback) (cascade notation)
    //
    // **CASCADE BENEFITS FOR WIDGET CALLBACKS**:
    // ✅ Creates visual flow for post-frame operations
    // ✅ Easier to chain multiple post-frame callbacks
    // ✅ Better readability in initialization sequences
    // ✅ Maintains Flutter widget lifecycle patterns
    //
    // Start demo mode automatically for testing RBAC
    WidgetsBinding.instance.addPostFrameCallback((_) => _startDemoMode());
  }

  void _startDemoMode() {
    // Start demo mode with hoofdcoach role
    ref.read(demoModeProvider.notifier).startDemo(
          role: DemoRole.coach, // hoofdcoach
          organizationId: 'demo-voab-jo17',
          userId: 'demo-user-coach',
          userName: 'Demo Hoofdcoach',
          durationMinutes: 60, // 1 hour demo session
        );

    // SAFE SNACKBAR: Only show if ScaffoldMessenger is available
    // This prevents "No ScaffoldMessenger widget found" errors
    if (mounted) {
      try {
        // Check if ScaffoldMessenger is available before using it
        final messenger = ScaffoldMessenger.maybeOf(context);
        if (messenger != null) {
          messenger.showSnackBar(
            const SnackBar(
              content: Text(
                '🎭 Demo Mode Actief! Wissel tussen rollen in het gebruikersmenu.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.blue,
            ),
          );
        } else {
          // Fallback: Log the demo mode activation
          if (kDebugMode) {
            print('🎭 Demo Mode Actief! ScaffoldMessenger not available yet.');
          }
        }
      } catch (e) {
        // Graceful fallback if ScaffoldMessenger access fails
        if (kDebugMode) {
          print('🎭 Demo Mode Actief! (ScaffoldMessenger error: $e)');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
