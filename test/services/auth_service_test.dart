// ignore_for_file: directives_ordering, avoid_implementing_value_types

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jo17_tactical_manager/services/auth_service.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {}

void main() {
  group('AuthService', () {
    late MockSupabaseClient client;
    late MockGoTrueClient auth;
    late AuthService service;

    setUp(() {
      client = MockSupabaseClient();
      auth = MockGoTrueClient();
      when(() => client.auth).thenReturn(auth);
      service = AuthService(client: client);
    });

    test('signOut delegates to Supabase auth.signOut', () async {
      when(() => auth.signOut()).thenAnswer((_) async {});

      await service.signOut();

      verify(() => auth.signOut()).called(1);
    });

    test('getUserRole reads role from userMetadata', () {
      final user = MockUser();
      when(() => user.userMetadata).thenReturn({'role': 'coach'});
      when(() => auth.currentUser).thenReturn(user);

      expect(service.getUserRole(), 'coach');
    });
  });
}
