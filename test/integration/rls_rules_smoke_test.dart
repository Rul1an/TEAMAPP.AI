import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase/supabase.dart' as s;

void main() {
  group('RLS Rules Smoke (skipped without service role)', () {
    test('organizations table exists and is readable with service role',
        () async {
      final url = Platform.environment['SUPABASE_URL'];
      final serviceRole = Platform.environment['SUPABASE_SERVICE_ROLE_KEY'] ??
          Platform.environment['SUPABASE_SERVICE_ROLE_KEY_PREVIEW'];
      if (url == null ||
          url.isEmpty ||
          serviceRole == null ||
          serviceRole.isEmpty) {
        return; // skip silently if not configured
      }

      final client = s.SupabaseClient(url, serviceRole);
      final res = await client.from('organizations').select('id').limit(1);
      expect(res, isA<List<dynamic>>());
    });
  });
}
