// Dart imports:
import 'dart:async';

// Package imports:
import 'package:opentelemetry/api.dart' as api;
import 'package:opentelemetry/sdk.dart' as sdk;
import 'package:http/http.dart' as http;

// Project imports:
import '../config/environment.dart';

/// TelemetryService wraps OpenTelemetry tracing & metrics for the app.
/// It exposes simple helpers similar to the legacy MonitoringService so we can
/// refactor incrementally.
class TelemetryService {
  factory TelemetryService() => _instance;
  TelemetryService._internal();
  static final TelemetryService _instance = TelemetryService._internal();

  late final api.Tracer _tracer;

  bool _initialized = false;
  bool get isEnabled => _initialized;

  Future<void> init() async {
    if (_initialized) return;

    // Get telemetry endpoint from Environment configuration
    final endpoint = Environment.otlpEndpoint;
    if (endpoint == null || endpoint.isEmpty) {
      // No endpoint – skip initialization (e.g. local dev).
      assert(() {
        // Visible in debug logs only
        // ignore: avoid_print
        print('OTLP disabled: no endpoint configured for this environment');
        return true;
      }());
      return;
    }

    // Validate endpoint reachability (best-effort, non-fatal)
    final ok = await _validateOtlpEndpoint(endpoint);
    if (!ok) {
      // Skip OTLP setup to avoid noisy errors in console/CI
      assert(() {
        // ignore: avoid_print
        print('OTLP endpoint not reachable, skipping OpenTelemetry init: ' +
            endpoint);
        return true;
      }());
      return;
    }

    final exporter = sdk.CollectorExporter(Uri.parse(endpoint));

    final resource = sdk.Resource([
      api.Attribute.fromString('service.name', 'jo17-tactical-manager'),
    ]);

    final provider = sdk.TracerProviderBase(
      processors: [sdk.BatchSpanProcessor(exporter)],
      resource: resource,
    );

    api.registerGlobalTracerProvider(provider);
    _tracer = api.globalTracerProvider.getTracer('app');

    _initialized = true;
    assert(() {
      // ignore: avoid_print
      print('OTLP initialized with endpoint: ' + endpoint);
      return true;
    }());
  }

  Future<bool> _validateOtlpEndpoint(String endpoint) async {
    try {
      final uri = Uri.parse(endpoint);
      // HEAD may be blocked; accept 200-405 as reachable
      final resp = await http.head(
        uri,
        headers: const {
          'User-Agent': 'JO17-Tactical-Manager/OTLP-Probe',
        },
      ).timeout(const Duration(seconds: 3));
      final code = resp.statusCode;
      return code >= 200 && code < 500;
    } catch (_) {
      return false;
    }
  }

  /// Records a simple event.
  void trackEvent(String name, {Map<String, Object?> attributes = const {}}) {
    if (!_initialized) return;
    final span = _tracer.startSpan(name);
    _setAttributes(span, attributes);
    span.end();
  }

  /// Wraps an async function in a span and records duration/error.
  Future<T> monitorAsync<T>(
    String name,
    Future<T> Function() action, {
    Map<String, Object?> attributes = const {},
  }) async {
    if (!_initialized) return action();

    final span = _tracer.startSpan(name);
    _setAttributes(span, attributes);
    try {
      final result = await action();
      span.end();
      return result;
    } catch (e, st) {
      span
        ..recordException(e, stackTrace: st)
        ..setStatus(api.StatusCode.error, e.toString())
        ..end();
      rethrow;
    }
  }

  /// Starts a manual span – caller must call `end()` on the returned span.
  api.Span startSpan(
    String name, {
    Map<String, Object?> attributes = const {},
  }) {
    final span =
        (_initialized ? _tracer : api.globalTracerProvider.getTracer('noop'))
            .startSpan(name);
    _setAttributes(span, attributes);
    return span;
  }

  /// Records an error outside of a span context.
  void recordError(Object error, StackTrace st) {
    if (!_initialized) return;
    _tracer.startSpan('error')
      ..recordException(error, stackTrace: st)
      ..setStatus(api.StatusCode.error, error.toString())
      ..end();
  }

  void _setAttributes(api.Span span, Map<String, Object?> attributes) {
    for (final entry in attributes.entries) {
      span.setAttribute(
        api.Attribute.fromString(entry.key, entry.value.toString()),
      );
    }
  }
}
