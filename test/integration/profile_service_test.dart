import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:jo17_tactical_manager/services/profile_service.dart';

import '../utils/stub_http_client.dart';

void main() {
  group('ProfileService – integration', () {
    late SupabaseClient client;
    late ProfileService service;

    String currentOrgId = 'org1';
    String lastAvatarUrl = '';

    setUp(() async {
      final routes = <Pattern, http.Response Function(http.BaseRequest)>{
        // Auth token exchange
        'auth/v1/token': (_) => http.Response(
              jsonEncode({
                'access_token': 'stub-token',
                'refresh_token': 'stub-refresh',
                'token_type': 'bearer',
                'expires_in': 3600,
                'user': {
                  'id': 'user123',
                  'email': 'test@example.com',
                  'user_metadata': <String, dynamic>{},
                },
              }),
              200,
              headers: {'content-type': 'application/json'},
            ),
        // User endpoint
        'auth/v1/user': (_) => http.Response(
              jsonEncode({
                'user': {
                  'id': 'user123',
                  'email': 'test@example.com',
                  'user_metadata': {
                    'organization_id': currentOrgId,
                  },
                },
                'access_token': 'stub-token',
                'refresh_token': 'stub-refresh',
                'token_type': 'bearer',
                'expires_in': 3600,
              }),
              200,
              headers: {'content-type': 'application/json'},
            ),
        // Select & update profile rows
        '/rest/v1/profiles': (req) {
          if (req.method == 'PATCH') {
            final body = jsonDecode((req as http.Request).body);
            lastAvatarUrl = body['avatar_url'] as String? ?? lastAvatarUrl;
          }

          return http.Response(
            jsonEncode({
              'user_id': 'user123',
              'organization_id': currentOrgId,
              'username': 'tester',
              'avatar_url': lastAvatarUrl.isEmpty ? null : lastAvatarUrl,
              'website': 'https://example.com',
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        },
        // Storage upload – match any object path and return minimal JSON
        RegExp(r'/storage/v1/object'): (_) => http.Response('{"Key":"avatars/user123/12345.png"}', 200, headers: {'content-type': 'application/json'}),
      };

      client = SupabaseClient(
        'http://stub.supabase.co',
        'public-anon-key',
        httpClient: StubHttpClient(routes),
      );

      await client.auth.signInWithPassword(
        email: 'test@example.com',
        password: 'password',
      );

      service = ProfileService(client: client);
    });

    test('getCurrentProfile returns data for selected organization', () async {
      currentOrgId = 'org1';
      final prof1 = await service.getCurrentProfile();
      expect(prof1, isNotNull);
      expect(prof1!.organizationId, 'org1');

      // Switch org
      currentOrgId = 'org2';
      final prof2 = await service.getCurrentProfile();
      expect(prof2, isNotNull);
      expect(prof2!.organizationId, 'org2');
    });

    test('uploadAvatar stores file and updates profile', () async {
      currentOrgId = 'org1';
      // Create temp png
      final tmpDir = io.Directory.systemTemp;
      final tmpFile = io.File(p.join(tmpDir.path, 'avatar.png'));
      await tmpFile.writeAsBytes(List<int>.filled(10, 0));

      final updated = await service.uploadAvatar(tmpFile);

      expect(updated.avatarUrl, isNotNull);
      expect(updated.avatarUrl, contains('/avatars/'));
    });
  });
}
