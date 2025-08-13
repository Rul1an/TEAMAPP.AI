// Dart-only harness that SKIPS by default unless SERVICE_ROLE key is provided via env.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase/supabase.dart' as s;

void main() {
  final url = Platform.environment['SUPABASE_URL'];
  final serviceRole = Platform.environment['SUPABASE_SERVICE_ROLE_KEY_PREVIEW'];

  group('RLS Admin Harness (skipped by default)', () {
    test('admin can list core tables', () async {
      if (url == null ||
          url.isEmpty ||
          serviceRole == null ||
          serviceRole.isEmpty) {
        return; // skip silently in CI unless service role provided
      }
      final client = s.SupabaseClient(url, serviceRole);
      // Simple smoke on public tables existing; adjust as needed
      final tables = ['organizations', 'players', 'teams', 'training_sessions'];
      for (final t in tables) {
        final res = await client.from(t).select('*').limit(1);
        expect(res, isA<List<dynamic>>());
      }
    });
  });
}
