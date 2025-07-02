// ignore_for_file: directives_ordering, avoid_implementing_value_types

import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/config/supabase_config.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockGoTrueClient extends Mock implements GoTrueClient {}
class MockUser extends Mock implements User {}
class MockPostgrestFilterBuilder extends Mock implements PostgrestFilterBuilder {}

void main() {
  group('SupabaseConfig.getUserOrganizations', () {
    late MockSupabaseClient client;
    late MockGoTrueClient auth;
    late MockPostgrestFilterBuilder builder;
    late MockUser user;

    setUp(() {
      client = MockSupabaseClient();
      auth = MockGoTrueClient();
      builder = MockPostgrestFilterBuilder();
      user = MockUser();

      when(() => client.auth).thenReturn(auth);
      when(() => client.from(any())).thenReturn(builder);
      when(() => builder.select(any())).thenReturn(builder);

      // Return fake response when eq is called
      when(() => builder.eq(any(), any())).thenAnswer((_) async => [
            {
              'organization_id': 'org1',
              'role': 'owner',
              'organizations': {
                'id': 'org1',
                'name': 'Test Org',
              },
            }
          ]);

      when(() => user.id).thenReturn('user1');
      when(() => auth.currentUser).thenReturn(user);

      SupabaseConfig.setClientForTest(client);
    });

    test('returns mapped list', () async {
      final result = await SupabaseConfig.getUserOrganizations();
      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.first['organization_id'], 'org1');
      expect(result.first['organizations']['name'], 'Test Org');
    });
  });
}
