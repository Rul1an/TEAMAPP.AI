import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Boots the Flutter application inside a guarded zone and initialises
/// Sentry error/performance monitoring.
Future<void> runAppWithGuards(Widget app) async {
  // Capture any errors that might occur during runApp by executing within
  // a zone and delegating to Sentry.
  await runZonedGuarded(() async {
    // Ensure Flutter binding is initialised.
    WidgetsFlutterBinding.ensureInitialized();

    // Initialise Sentry only if a DSN is provided via env (avoid crashes in
    // dev if secrets are absent).
    final dsn = const String.fromEnvironment('SENTRY_DSN', defaultValue: '');
    if (dsn.isNotEmpty) {
      await SentryFlutter.init(
        (options) {
          options.dsn = dsn;
          options.tracesSampleRate = 0.2; // 20% sampling by default.
        },
        appRunner: () => runApp(app),
      );
    } else {
      runApp(app);
    }
  }, (error, stack) async {
    // Forward any uncaught errors to Sentry.
    await Sentry.captureException(error, stackTrace: stack);
  });

  // Also wire Flutter framework errors.
  FlutterError.onError = (details) async {
    FlutterError.presentError(details);
    await Sentry.captureException(details.exception, stackTrace: details.stack);
  };
}
