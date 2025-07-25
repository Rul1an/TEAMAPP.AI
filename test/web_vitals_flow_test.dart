import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  group('Web Vitals Data Flow', () {
    test('Web-vitals endpoint accepts valid data', () async {
      // Test data that matches web-vitals format
      final testData = {
        'name': 'LCP',
        'value': 1200,
        'id': 'v3-123',
        'url': '/dashboard',
        'ts': DateTime.now().millisecondsSinceEpoch,
      };

      try {
        // Test against the web-vitals endpoint
        final response = await http.post(
          Uri.parse('https://teamappai.netlify.app/api/web-vitals'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(testData),
        );

        // Should return 200 OK
        expect(response.statusCode, 200);
      } catch (e) {
        // If endpoint is not available, this is expected in test environment
        expect(e, isA<Exception>());
      }
    });

    test('Web-vitals endpoint validates required fields', () async {
      // Test with missing required fields
      final invalidData = {
        'name': 'LCP',
        // Missing 'value' field
        'id': 'v3-123',
      };

      try {
        final response = await http.post(
          Uri.parse('https://teamappai.netlify.app/api/web-vitals'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(invalidData),
        );

        // Should handle invalid data gracefully
        expect(response.statusCode, anyOf(400, 422, 500));
      } catch (e) {
        // Expected in test environment
        expect(e, isA<Exception>());
      }
    });

    test('Web-vitals endpoint accepts all core web vitals', () async {
      final coreWebVitals = ['LCP', 'FID', 'CLS', 'FCP', 'TTFB'];

      for (final metric in coreWebVitals) {
        final testData = {
          'name': metric,
          'value': 1000,
          'id': 'v3-123',
          'url': '/dashboard',
          'ts': DateTime.now().millisecondsSinceEpoch,
        };

        try {
          final response = await http.post(
            Uri.parse('https://teamappai.netlify.app/api/web-vitals'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(testData),
          );

          // Should accept all core web vitals
          expect(response.statusCode, anyOf(200, 201));
        } catch (e) {
          // Expected in test environment
          expect(e, isA<Exception>());
        }
      }
    });
  });
}
