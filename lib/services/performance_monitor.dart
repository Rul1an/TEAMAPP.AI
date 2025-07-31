import 'package:flutter/foundation.dart';

/// Performance monitoring service for video functionality testing
///
/// This service provides real-time performance metrics collection and validation
/// for video operations, tag creation, and other critical app functions.
///
/// Based on: Video Production Readiness Plan 2025 - Phase 2C
class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();

  final Map<String, Stopwatch> _timers = {};
  final Map<String, List<PerformanceMetric>> _metrics = {};

  /// Start timing an operation
  void startTimer(String operation) {
    _timers[operation] = Stopwatch()..start();
  }

  /// End timing an operation and record the metric
  void endTimer(String operation) {
    final timer = _timers[operation];
    if (timer != null) {
      timer.stop();
      _recordMetric(PerformanceMetric(
        operation: operation,
        duration: timer.elapsedMilliseconds,
        timestamp: DateTime.now(),
      ));
      _timers.remove(operation);
    }
  }

  /// Get all metrics for a specific operation
  List<PerformanceMetric> getMetrics(String operation) {
    return _metrics[operation] ?? [];
  }

  /// Record a performance metric
  void _recordMetric(PerformanceMetric metric) {
    _metrics[metric.operation] ??= [];
    _metrics[metric.operation]!.add(metric);

    // Alert on performance issues
    if (metric.duration > _getThreshold(metric.operation)) {
      debugPrint(
          'PERFORMANCE WARNING: ${metric.operation} took ${metric.duration}ms');
    }
  }

  /// Get performance threshold for operation
  int _getThreshold(String operation) {
    switch (operation) {
      case 'video_load':
      case 'video_initialization':
        return 3000; // 3 seconds
      case 'tag_creation':
        return 500; // 500ms
      case 'tag_query':
        return 200; // 200ms
      case 'bulk_tag_creation':
        return 5000; // 5 seconds
      case 'concurrent_tag_creation':
        return 2000; // 2 seconds
      default:
        return 1000; // 1 second default
    }
  }

  /// Reset all metrics and timers
  void reset() {
    _timers.clear();
    _metrics.clear();
  }

  /// Get summary of all performance metrics
  Map<String, PerformanceMetricSummary> getPerformanceSummary() {
    final summary = <String, PerformanceMetricSummary>{};

    for (final entry in _metrics.entries) {
      final metrics = entry.value;
      if (metrics.isNotEmpty) {
        final durations = metrics.map((m) => m.duration).toList();
        durations.sort();

        summary[entry.key] = PerformanceMetricSummary(
          operation: entry.key,
          count: metrics.length,
          averageDuration: durations.reduce((a, b) => a + b) / durations.length,
          minDuration: durations.first,
          maxDuration: durations.last,
          medianDuration: durations[durations.length ~/ 2].toDouble(),
        );
      }
    }

    return summary;
  }
}

/// Performance metric data class
class PerformanceMetric {
  final String operation;
  final int duration;
  final DateTime timestamp;

  const PerformanceMetric({
    required this.operation,
    required this.duration,
    required this.timestamp,
  });

  @override
  String toString() =>
      'PerformanceMetric(operation: $operation, duration: ${duration}ms, timestamp: $timestamp)';
}

/// Performance metric summary for analysis
class PerformanceMetricSummary {
  final String operation;
  final int count;
  final double averageDuration;
  final int minDuration;
  final int maxDuration;
  final double medianDuration;

  const PerformanceMetricSummary({
    required this.operation,
    required this.count,
    required this.averageDuration,
    required this.minDuration,
    required this.maxDuration,
    required this.medianDuration,
  });

  @override
  String toString() =>
      'PerformanceMetricSummary(operation: $operation, count: $count, '
      'avg: ${averageDuration.toStringAsFixed(1)}ms, '
      'min: ${minDuration}ms, max: ${maxDuration}ms, '
      'median: ${medianDuration.toStringAsFixed(1)}ms)';
}
