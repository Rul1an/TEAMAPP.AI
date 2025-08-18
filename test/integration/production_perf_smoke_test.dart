// dart run flutter test test/integration/production_perf_smoke_test.dart

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase/supabase.dart' as s;

void main() {
  // Only run on explicit request for production perf checks
  final enableProd = Platform.environment['ENABLE_PROD_TESTS'] == '1';
  if (!enableProd) {
    return; // Skip in CI/staging by default
  }

  final url = Platform.environment['SUPABASE_URL'];
  final anon = Platform.environment['SUPABASE_ANON_KEY'];

  if (url == null || url.isEmpty || anon == null || anon.isEmpty) {
    // Skip silently if not configured
    return;
  }

  group('Production perf smoke', () {
    late s.SupabaseClient client;
    setUpAll(() {
      client = s.SupabaseClient(url, anon);
    });

    test('trainings view returns within 2s', () async {
      final sw = Stopwatch()..start();
      final data = await client.from('trainings').select().limit(1);
      sw.stop();
      expect(data, isA<List<dynamic>>());
      expect(sw.elapsedMilliseconds, lessThan(2000));
    }, timeout: const Timeout(Duration(seconds: 10)));

    test('matches returns within 2s', () async {
      final sw = Stopwatch()..start();
      final data = await client.from('matches').select().limit(1);
      sw.stop();
      expect(data, isA<List<dynamic>>());
      expect(sw.elapsedMilliseconds, lessThan(2000));
    }, timeout: const Timeout(Duration(seconds: 10)));
  });
}
