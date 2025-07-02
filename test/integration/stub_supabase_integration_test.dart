import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:jo17_tactical_manager/config/supabase_config.dart';
import 'package:jo17_tactical_manager/services/organization_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/stub_http_client.dart';

void main() {
  group('Supabase + StubHttpClient integration', () {
    late SupabaseClient client;

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
                  'aud': 'authenticated',
                  'email': 'test@example.com',
                  'created_at': DateTime.now().toIso8601String(),
                },
              }),
              200,
              headers: {'content-type': 'application/json'},
            ),
        // organization_members view
        'organization_members': (_) => http.Response(
              jsonEncode([
                {
                  'organization_id': 'org1',
                  'role': 'owner',
                  'organizations': {
                    'id': 'org1',
                    'name': 'Test Org',
                    'slug': 'test-org',
                    'subscription_tier': 'basic',
                    'subscription_status': 'active',
                    'max_players': 25,
                    'max_teams': 2,
                    'max_coaches': 4,
                    'settings': <String, dynamic>{},
                    'branding': null,
                  },
                }
              ]),
              200,
              headers: {'content-type': 'application/json'},
            ),
      };

      client = SupabaseClient(
        'http://stub.supabase.co',
        'public-anon-key',
        httpClient: StubHttpClient(routes),
      );

      // Authenticate to populate currentUser
      await client.auth.signInWithPassword(
        email: 'test@example.com',
        password: 'password',
      );

      // Inject into global config used by app code
      SupabaseConfig.setClientForTest(client);
    });

    test('SupabaseConfig.getUserOrganizations returns stubbed data', () async {
      final orgs = await SupabaseConfig.getUserOrganizations();
      expect(orgs, hasLength(1));
      expect(orgs.first['organizations']['name'], 'Test Org');
    });

    test('OrganizationService.createOrganization works with stubbed client', () async {
      final service = OrganizationService(client: client);
      final org = await service.createOrganization(
        name: 'My Org',
        slug: 'my-org',
      );
      expect(org.name, 'My Org');
      expect(org.slug, 'my-org');
    });
  });
}
