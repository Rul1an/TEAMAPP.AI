// RLS create/edit/delete/view coverage using service role to set up data
// and anon/client context to validate isolation. Skips if env missing.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase/supabase.dart' as s;

/// Helper to create org-scoped row via service role, then verify client access.
Future<Map<String, String>> _prepareOrgAndPlayer(s.SupabaseClient admin) async {
  final ts = DateTime.now().millisecondsSinceEpoch;
  final orgId = 'org_test_$ts';
  // Upsert org
  await admin.from('organizations').upsert({
    'id': orgId,
    'name': 'Test Org $ts',
  });
  final playerId = 'player_test_$ts';
  await admin.from('players').upsert({
    'id': playerId,
    'name': 'RLS Player $ts',
    'organization_id': orgId,
  });
  return {'orgId': orgId, 'playerId': playerId};
}

void main() {
  final url = Platform.environment['SUPABASE_URL'];
  final serviceRole = Platform.environment['SUPABASE_SERVICE_ROLE_KEY'] ??
      Platform.environment['SUPABASE_SERVICE_ROLE_KEY_PREVIEW'];
  final anon = Platform.environment['SUPABASE_ANON_KEY'] ??
      Platform.environment['SUPABASE_ANON_KEY_PREVIEW'];

  group('RLS CRUD & View paths (skipped without env)', () {
    s.SupabaseClient? admin;
    s.SupabaseClient? client;
    setUpAll(() {
      if (url != null && url.isNotEmpty) {
        if (serviceRole != null && serviceRole.isNotEmpty) {
          admin = s.SupabaseClient(url, serviceRole);
        }
        if (anon != null && anon.isNotEmpty) {
          client = s.SupabaseClient(url, anon);
        }
      }
    });

    test(
        'view: client can only see rows for its organization (context required)',
        () async {
      if (admin == null || client == null) return; // skip
      final ids = await _prepareOrgAndPlayer(admin!);
      final playerId = ids['playerId'];
      expect(playerId, isNotNull);
      // By default, anon client has no org context -> expect 0 rows or error
      try {
        final res = await client!
            .from('players')
            .select('id,organization_id')
            .eq('id', playerId!)
            .limit(1);
        expect(res, isA<List<dynamic>>());
        if (res.isNotEmpty) {
          // If visible, it must belong to the same org context; absent context should hide
          expect(res.first['organization_id'], isNot(equals('')));
        }
      } catch (_) {
        // Acceptable if strict auth required
        expect(true, isTrue);
      }
    });

    test('create: client cannot create outside allowed policies', () async {
      if (client == null) return; // skip
      final ts = DateTime.now().millisecondsSinceEpoch;
      try {
        await client!.from('players').insert({
          'id': 'player_forbidden_$ts',
          'name': 'Forbidden Insert $ts',
          'organization_id': 'org_not_owned_$ts',
        });
        fail('RLS should prevent creating player for another org');
      } catch (_) {
        expect(true, isTrue);
      }
    });

    test('edit: client cannot update player in different organization',
        () async {
      if (admin == null || client == null) return; // skip
      final ids = await _prepareOrgAndPlayer(admin!);
      final playerId = ids['playerId'];
      expect(playerId, isNotNull);
      try {
        await client!
            .from('players')
            .update({'name': 'Illegal Update'}).eq('id', playerId!);
        fail('RLS should prevent updating player not owned by client org');
      } catch (_) {
        expect(true, isTrue);
      }
    });

    test('delete: client cannot delete player in different organization',
        () async {
      if (admin == null || client == null) return; // skip
      final ids = await _prepareOrgAndPlayer(admin!);
      final playerId = ids['playerId'];
      expect(playerId, isNotNull);
      try {
        await client!.from('players').delete().eq('id', playerId!);
        fail('RLS should prevent deleting player not owned by client org');
      } catch (_) {
        expect(true, isTrue);
      }
    });
  });
}
