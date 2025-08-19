// Dart imports:
import 'dart:async';
import 'dart:io';

// Package imports:
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import 'helpers/plugins_test_helper.dart';

/// Global test configuration loaded before any test runs.
///
/// - Ensures common plugin channels are mocked to avoid MissingPluginException
/// - Optionally initializes Supabase if SUPABASE_URL and SUPABASE_ANON_KEY are provided
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Initialize plugin mocks for unit/widget tests
  await PluginsTestHelper.setupPluginMocks();

  // If CI provided Supabase env, initialize once for tests that rely on it
  final String? supabaseUrl = Platform.environment['SUPABASE_URL'];
  final String? supabaseAnonKey = Platform.environment['SUPABASE_ANON_KEY'];
  if (supabaseUrl != null &&
      supabaseAnonKey != null &&
      supabaseUrl.isNotEmpty &&
      supabaseAnonKey.isNotEmpty) {
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        debug: false,
      );
    } catch (_) {
      // Ignore if already initialized or if a platform limitation exists
    }
  }

  await testMain();
}
