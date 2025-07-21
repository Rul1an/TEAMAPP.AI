/// Global test configuration executed **before** any test files.
///
/// Here we perform lightweight setup that many widget/integration tests
/// rely on, such as initialising the Supabase singleton with dummy
/// credentials so that any "`Supabase.instance` not initialised" assertion is
/// avoided while still keeping the production behaviour intact.
///
/// See: https://dart.dev/guides/testing/pending#the-testexecutablesetup

// Flutter imports:
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

// Package imports:
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

// Mock the app_links plugin channel to avoid MissingPluginException in widget tests.
void _registerMockAppLinks() {
  const MethodChannel channel = MethodChannel('com.llfbandit.app_links/events');
  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    // Return null or appropriate fake data for tests.
    return null;
  });
}

// Ensure binding initialised and register mocks at test startup (only once).
void _initTestEnvironment() {
  _registerMockAppLinks();
}

_initTestEnvironment();

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Ensures widgets binding is initialised before we call into any Flutter
  // plugins (SupabaseFlutter registers a MethodChannel).
  TestWidgetsFlutterBinding.ensureInitialized();

  // Make the Supabase initialisation run **inside** the test zone so that
  // the `package:test` invoker is ready (otherwise `HttpOverrides` complains
  // with “There is no current invoker”).
  setUpAll(() async {
    // Ensure the `shared_preferences` MethodChannel is mocked so
    // SupabaseFlutter can create its SharedPreferences storage without
    // throwing a MissingPluginException.
    SharedPreferences.setMockInitialValues({});

    // A full network-enabled Supabase backend isn’t required for most unit/
    // widget tests.  We can therefore initialise the client with dummy
    // values and, importantly, disable the automatic token-refresh mechanism
    // which would otherwise spawn periodic timers that cause the test
    // framework to complain about "a Timer is still pending".
    await Supabase.initialize(
      url: 'https://dummy.supabase.co',
      anonKey: 'public-anon-key',
      authOptions: const FlutterAuthClientOptions(autoRefreshToken: false),
    );
  });

  // Continue with the normal test suite after our global setup has been
  // registered.
  await testMain();
}
