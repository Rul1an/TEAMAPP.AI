// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../config/supabase_config.dart';

/// Error boundary widget that handles database connection failures
class ErrorBoundary extends StatelessWidget {
  const ErrorBoundary({
    super.key,
    required this.child,
    this.fallback,
  });

  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        // Check if Supabase is properly initialized
        if (!SupabaseConfig.isInitialized) {
          return fallback ?? _buildOfflineMode(context);
        }

        return child;
      },
    );
  }

  Widget _buildOfflineMode(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_off,
                size: 80,
                color: Colors.blue[400],
              ),
              const SizedBox(height: 24),
              Text(
                'Offline Mode',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Unable to connect to the server. Some features may be limited.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.blue[600],
                    ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  // Attempt to reconnect
                  _attemptReconnection(context);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Continue in offline mode
                  Navigator.of(context).pushReplacementNamed('/offline');
                },
                child: const Text('Continue Offline'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _attemptReconnection(BuildContext context) async {
    try {
      // Show loading indicator
      unawaited(
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (context) => const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Reconnecting...'),
              ],
            ),
          ),
        ),
      );

      // Attempt to reinitialize Supabase
      await SupabaseConfig.initialize();

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();

        // If successful, rebuild the widget tree
        if (SupabaseConfig.isInitialized) {
          // Trigger a rebuild by navigating to home
          await Navigator.of(context).pushReplacementNamed('/');
        }
      }
    } catch (e) {
      // Close loading dialog and show error
      if (context.mounted) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _attemptReconnection(context),
            ),
          ),
        );
      }
    }
  }
}

/// Simplified error boundary for widgets that depend on database connection
class DatabaseErrorBoundary extends StatelessWidget {
  const DatabaseErrorBoundary({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!SupabaseConfig.isInitialized) {
      return Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_off,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Database Unavailable',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'This feature requires an internet connection.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return child;
  }
}
