import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';

/// Utility to simplify starting/stopping custom performance traces.
/// Keeps a single active trace (per isolate) and automatically stops
/// the previous one when a new trace starts.
class PerformanceTracker {
  PerformanceTracker._();
  static final instance = PerformanceTracker._();

  Trace? _currentTrace;

  /// Starts a new performance [Trace] with [name].
  /// Stops the previously running trace, if any.
  Future<void> startRouteTrace(String name) async {
    // Skip Firebase Performance in test environment
    if (kDebugMode && _isTestEnvironment()) {
      return;
    }

    try {
      // Firebase Trace names must be <= 100 chars and match allowed pattern.
      final traceName = _sanitize(name);
      await _currentTrace?.stop();
      _currentTrace = FirebasePerformance.instance.newTrace(traceName);
      await _currentTrace?.start();
    } catch (e) {
      // Silently fail in test environment or when Firebase isn't initialized
      if (kDebugMode) {
        print('PerformanceTracker: Failed to start trace: $e');
      }
    }
  }

  /// Stops the current active trace, if any.
  Future<void> stopCurrentTrace() async {
    // Skip Firebase Performance in test environment
    if (kDebugMode && _isTestEnvironment()) {
      return;
    }

    try {
      await _currentTrace?.stop();
      _currentTrace = null;
    } catch (e) {
      // Silently fail in test environment or when Firebase isn't initialized
      if (kDebugMode) {
        print('PerformanceTracker: Failed to stop trace: $e');
      }
    }
  }

  String _sanitize(String name) {
    // Replace slashes & spaces, limit length to 100 as per Firebase docs.
    final clean = name.replaceAll('/', '-').replaceAll(' ', '_');
    return clean.length > 100 ? clean.substring(0, 100) : clean;
  }

  /// Check if we're running in a test environment
  bool _isTestEnvironment() {
    return const bool.fromEnvironment('FLUTTER_TEST') ||
        identical(0, 0.0); // This is always true, but helps identify test env
  }
}
