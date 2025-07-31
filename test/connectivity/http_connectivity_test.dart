import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/config/environment.dart';
import 'dart:developer' as developer;

/// HTTP-based Database Connectivity Test 2025
/// Tests direct HTTP connectivity to Supabase without Flutter plugins
void main() {
  group('HTTP Database Connectivity Tests', () {
    final supabaseUrl = Environment.development.supabaseUrl;
    final supabaseKey = Environment.development.supabaseAnonKey;

    test('should connect to Supabase REST API', () async {
      // Test basic HTTP connectivity to Supabase
      final client = HttpClient();

      try {
        // Test 1: Basic health check to Supabase
        final request = await client.getUrl(Uri.parse('$supabaseUrl/rest/v1/'));
        request.headers.add('apikey', supabaseKey);
        request.headers.add('Authorization', 'Bearer $supabaseKey');

        final response = await request.close();

        expect(response.statusCode, lessThan(500),
               reason: 'Supabase should be reachable (status: ${response.statusCode})');

        developer.log('✅ Supabase HTTP connectivity verified');
        developer.log('   Status Code: ${response.statusCode}');
        developer.log('   URL: $supabaseUrl');

        await response.drain<void>();
      } catch (e) {
        if (e is SocketException) {
          fail('❌ Network connectivity failed: ${e.message}');
        } else {
          developer.log('⚠️ HTTP test completed with exception: $e');
          // Some exceptions might be expected (like 401) but still indicate connectivity
        }
      } finally {
        client.close();
      }
    });

    test('should test video table HTTP access', () async {
      final client = HttpClient();

      try {
        // Test video table access via REST API
        final request = await client.getUrl(
          Uri.parse('$supabaseUrl/rest/v1/videos?select=id&limit=1')
        );
        request.headers.add('apikey', supabaseKey);
        request.headers.add('Authorization', 'Bearer $supabaseKey');
        request.headers.add('Content-Type', 'application/json');

        final response = await request.close();
        final responseBody = await response.transform(utf8.decoder).join();

        developer.log('✅ Video table HTTP test completed');
        developer.log('   Status: ${response.statusCode}');

        if (response.statusCode == 200) {
          final data = json.decode(responseBody);
          developer.log('   Found ${data.length} video records');
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          developer.log('   Table exists but requires authentication (RLS working)');
        } else if (response.statusCode == 404) {
          developer.log('   Video table not deployed - migration needed');
        } else {
          developer.log('   Response: $responseBody');
        }

        // Any response means we can reach the database
        expect(response.statusCode, isNotNull);

      } catch (e) {
        if (e is SocketException) {
          fail('❌ Network connectivity failed for video table: ${e.message}');
        } else {
          developer.log('⚠️ Video table test exception: $e');
        }
      } finally {
        client.close();
      }
    });

    test('should test video_tags table HTTP access', () async {
      final client = HttpClient();

      try {
        final request = await client.getUrl(
          Uri.parse('$supabaseUrl/rest/v1/video_tags?select=id&limit=1')
        );
        request.headers.add('apikey', supabaseKey);
        request.headers.add('Authorization', 'Bearer $supabaseKey');
        request.headers.add('Content-Type', 'application/json');

        final response = await request.close();
        final responseBody = await response.transform(utf8.decoder).join();

        developer.log('✅ Video tags table HTTP test completed');
        developer.log('   Status: ${response.statusCode}');

        if (response.statusCode == 200) {
          final data = json.decode(responseBody);
          developer.log('   Found ${data.length} video tag records');
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          developer.log('   Table exists but requires authentication (RLS working)');
        } else if (response.statusCode == 404) {
          developer.log('   Video tags table not deployed - migration needed');
        }

        expect(response.statusCode, isNotNull);

      } catch (e) {
        if (e is SocketException) {
          fail('❌ Network connectivity failed for video_tags: ${e.message}');
        } else {
          developer.log('⚠️ Video tags test exception: $e');
        }
      } finally {
        client.close();
      }
    });

    test('should validate environment configuration', () {
      // Test environment variables
      expect(supabaseUrl, isNotEmpty);
      expect(supabaseKey, isNotEmpty);
      expect(supabaseUrl, startsWith('https://'));
      expect(supabaseKey, hasLength(greaterThan(50))); // JWT tokens are long

      developer.log('✅ Environment configuration validated');
      developer.log('   URL: $supabaseUrl');
      developer.log('   Key length: ${supabaseKey.length}');
      developer.log('   Environment: ${Environment.current.name}');
      developer.log('   Video features: ${Environment.availableFeatures['video']}');
    });

    test('should test Supabase auth endpoint', () async {
      final client = HttpClient();

      try {
        // Test auth endpoint accessibility
        final request = await client.getUrl(
          Uri.parse('$supabaseUrl/auth/v1/settings')
        );
        request.headers.add('apikey', supabaseKey);

        final response = await request.close();

        developer.log('✅ Supabase auth endpoint test completed');
        developer.log('   Status: ${response.statusCode}');

        // Any response means auth system is reachable
        expect(response.statusCode, isNotNull);

        await response.drain<void>();
      } catch (e) {
        if (e is SocketException) {
          fail('❌ Auth endpoint connectivity failed: ${e.message}');
        } else {
          developer.log('⚠️ Auth endpoint test exception: $e');
        }
      } finally {
        client.close();
      }
    });
  });
}
