import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:jo17_tactical_manager/config/supabase_config.dart';
import 'package:jo17_tactical_manager/services/supabase_extensions.dart';

import '../utils/stub_http_client.dart';

void main() {
  group('Row-Level-Security – organization isolation', () {
    late SupabaseClient client;
    // Holds the organization id that the stub backend should respond with.
    String currentOrgId = 'org1';

    setUp(() async {
      final routes = <Pattern, http.Response Function(http.BaseRequest)>{
        // Stub token exchange for sign-in.
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
        // User metadata update / fetch
        'auth/v1/user': (_) => http.Response(
              jsonEncode({
                'user': {
                  'id': 'user123',
                  'email': 'test@example.com',
                  'user_metadata': {
                    'organization_id': 'org1',
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
        // Teams endpoint returns a single record for the currently selected organization.
        '/rest/v1/teams': (_) => http.Response(
              jsonEncode([
                {
                  'id': currentOrgId == 'org1' ? 1 : 2,
                  'name': currentOrgId == 'org1' ? 'Team A' : 'Team B',
                  'organization_id': currentOrgId,
                }
              ]),
              200,
              headers: {'content-type': 'application/json'},
            ),
        // Any unfiltered access should be denied → simulate RLS error.
        RegExp(r'/rest/v1/teams(\?|\b)(?!.*organization_id=eq\.).*'): (_) =>
            http.Response('Row level security violation', 403),
      };

      client = SupabaseClient(
        'http://stub.supabase.co',
        'public-anon-key',
        httpClient: StubHttpClient(routes),
      );

      // Authenticate to populate currentUser.
      await client.auth.signInWithPassword(
        email: 'test@example.com',
        password: 'password',
      );

      // Expose client to application layer.
      SupabaseConfig.setClientForTest(client);
    });

    test('fromOrg throws when no organization selected', () {
      expect(() => client.fromOrg('teams'), throwsA(isA<StateError>()));
    });

    test('Query returns data only for selected organization', () async {
      await client.setCurrentOrganizationId('org1');
      currentOrgId = 'org1';
      // Ensure stub user metadata contains the organization_id claim
      (client.auth.currentUser?.userMetadata
          as Map<String, dynamic>)['organization_id'] = 'org1';

      final data = await client.fromOrg('teams');

      expect(data, hasLength(1));
      expect(data.first['organization_id'], 'org1');
    });

    test('Switching organization returns isolated dataset', () async {
      await client.setCurrentOrganizationId('org2');
      currentOrgId = 'org2';
      (client.auth.currentUser?.userMetadata
          as Map<String, dynamic>)['organization_id'] = 'org2';

      final data = await client.fromOrg('teams');

      expect(data, hasLength(1));
      expect(data.first['organization_id'], 'org2');
    });
  });
}
