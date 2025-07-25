import 'package:firebase_performance/firebase_performance.dart';

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
    // Firebase Trace names must be <= 100 chars and match allowed pattern.
    final traceName = _sanitize(name);
    await _currentTrace?.stop();
    _currentTrace = FirebasePerformance.instance.newTrace(traceName);
    await _currentTrace?.start();
  }

  /// Stops the current active trace, if any.
  Future<void> stopCurrentTrace() async {
    await _currentTrace?.stop();
    _currentTrace = null;
  }

  String _sanitize(String name) {
    // Replace slashes & spaces, limit length to 100 as per Firebase docs.
    final clean = name.replaceAll('/', '-').replaceAll(' ', '_');
    return clean.length > 100 ? clean.substring(0, 100) : clean;
  }
}
