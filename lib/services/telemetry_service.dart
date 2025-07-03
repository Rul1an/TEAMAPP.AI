import 'dart:async';

import 'package:opentelemetry_sdk/opentelemetry_sdk.dart';
import 'package:opentelemetry_otlp/opentelemetry_otlp.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// TelemetryService wraps OpenTelemetry tracing & metrics for the app.
/// It exposes simple helpers similar to the legacy MonitoringService so we can
/// refactor incrementally.
class TelemetryService {
  TelemetryService._internal();
  static final TelemetryService _instance = TelemetryService._internal();
  factory TelemetryService() => _instance;

  late final OpenTelemetry _otel;
  late final Tracer _tracer;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    // Load env vars (ensure dotenv was initialized in main).
    final endpoint = dotenv.env['OTLP_ENDPOINT'];
    if (endpoint == null || endpoint.isEmpty) {
      // No endpoint – skip initialization (e.g. local dev).
      return;
    }

    final exporter = OtlpTraceExporter(collectorEndpoint: endpoint);
    final provider =
        TracerProviderBase(processors: [SimpleSpanProcessor(exporter)]);

    _otel = OpenTelemetry(provider, ContextManager.zone());
    _tracer = _otel.tracerProvider.getTracer('app');

    _initialized = true;
  }

  /// Records a simple event.
  void trackEvent(String name, {Map<String, Object?> attributes = const {}}) {
    if (!_initialized) return;
    final span = _tracer.startSpan(name, attributes: attributes);
    span.end();
  }

  /// Wraps an async function in a span and records duration/error.
  Future<T> monitorAsync<T>(
    String name,
    Future<T> Function() action, {
    Map<String, Object?> attributes = const {},
  }) async {
    if (!_initialized) return action();

    final span = _tracer.startSpan(name, attributes: attributes);
    try {
      final result = await action();
      span.end();
      return result;
    } catch (e, st) {
      span.recordException(e, stackTrace: st);
      span.setStatus(const SpanStatus.error());
      span.end();
      rethrow;
    }
  }

  /// Starts a manual span – caller must call [end] on returned span.
  Span startSpan(String name, {Map<String, Object?> attributes = const {}}) {
    if (!_initialized) {
      // Return no-op span
      return _NoopSpan();
    }
    return _tracer.startSpan(name, attributes: attributes);
  }

  /// Records an error outside of a span context.
  void recordError(Object error, StackTrace st) {
    if (!_initialized) return;
    final span = _tracer.startSpan('error');
    span.recordException(error, stackTrace: st);
    span.setStatus(const SpanStatus.error());
    span.end();
  }
}

/// Very lightweight no-op span used when TelemetryService not initialized.
class _NoopSpan implements Span {
  @override
  void addEvent(
    String name, {
    Map<String, Object?> attributes = const {},
    DateTime? timestamp,
  }) {}

  @override
  void end({DateTime? timestamp}) {}

  @override
  SpanContext get spanContext => SpanContext.invalid();

  @override
  void recordException(Object exception, {StackTrace? stackTrace}) {}

  @override
  void setAttribute(String key, Object value) {}

  @override
  void setStatus(SpanStatus status) {}
}
