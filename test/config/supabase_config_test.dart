// ignore_for_file: directives_ordering

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import 'package:jo17_tactical_manager/config/supabase_config.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {}

void main() {
  group('SupabaseConfig', () {
    late MockSupabaseClient client;
    late MockGoTrueClient auth;

    setUp(() {
      client = MockSupabaseClient();
      auth = MockGoTrueClient();
      when(() => client.auth).thenReturn(auth);
      SupabaseConfig.setClientForTest(client);
    });

    test('isAuthenticated returns false when currentUser is null', () {
      when(() => auth.currentUser).thenReturn(null);
      expect(SupabaseConfig.isAuthenticated, isFalse);
    });

    test('isAuthenticated returns true when currentUser is not null', () {
      final user = MockUser();
      when(() => auth.currentUser).thenReturn(user);
      expect(SupabaseConfig.isAuthenticated, isTrue);
    });
  });
}
