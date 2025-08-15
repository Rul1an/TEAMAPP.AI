// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Project imports:
import '../../services/monitoring_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

typedef ErrorFallbackBuilder = Widget Function(
  BuildContext context,
  FlutterErrorDetails? details,
  VoidCallback retry,
);

/// AppErrorBoundary
/// 2025 best practice: graceful error containment per-subtree with Sentry reporting.
class AppErrorBoundary extends StatefulWidget {
  const AppErrorBoundary({
    super.key,
    required this.child,
    this.fallbackBuilder,
  });

  final Widget child;
  final ErrorFallbackBuilder? fallbackBuilder;

  @override
  State<AppErrorBoundary> createState() => _AppErrorBoundaryState();
}

class _AppErrorBoundaryState extends State<AppErrorBoundary> {
  FlutterErrorDetails? _lastError;
  Key _subtreeKey = UniqueKey();

  late final FlutterExceptionHandler? _prevOnError;
  late final ErrorWidgetBuilder _prevErrorBuilder;

  @override
  void initState() {
    super.initState();
    _prevOnError = FlutterError.onError;
    _prevErrorBuilder = ErrorWidget.builder;

    // Intercept errors that bubble up during build/layout/paint in this lifecycle
    FlutterError.onError = (FlutterErrorDetails details) async {
      _capture(details);
      // Forward to previous handler for logging/console
      _prevOnError?.call(details);
    };

    ErrorWidget.builder = (FlutterErrorDetails details) {
      _capture(details);
      // Render minimal inline placeholder to avoid red screen
      return const SizedBox.shrink();
    };
  }

  @override
  void dispose() {
    // Restore globals
    FlutterError.onError = _prevOnError;
    ErrorWidget.builder = _prevErrorBuilder;
    super.dispose();
  }

  void _capture(FlutterErrorDetails details) {
    // Keep latest details for fallback UI
    _lastError = details;
    // Report to Sentry
    MonitoringService.reportError(
      error: details.exception,
      stackTrace: details.stack,
      context: details.library,
      level: SentryLevel.error,
    );
    if (mounted) {
      setState(() {});
    }
  }

  void _retry() {
    setState(() {
      _lastError = null;
      _subtreeKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_lastError != null) {
      final fb = widget.fallbackBuilder ?? _defaultFallback;
      return fb(context, _lastError, _retry);
    }

    return KeyedSubtree(
      key: _subtreeKey,
      child: widget.child,
    );
  }

  Widget _defaultFallback(
    BuildContext context,
    FlutterErrorDetails? details,
    VoidCallback retry,
  ) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text('Er ging iets mis', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            if (kDebugMode && details != null)
              Text(
                details.exceptionAsString(),
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: retry,
              icon: const Icon(Icons.refresh),
              label: const Text('Opnieuw proberen'),
            ),
          ],
        ),
      ),
    );
  }
}
