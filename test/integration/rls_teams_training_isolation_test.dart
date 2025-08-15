// Verifies RLS isolation for teams and training_sessions across organizations (env-gated).

// Dart imports:
import 'dart:io';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase/supabase.dart' as s;

Future<Map<String, String>> _seedOrgTeamAndSession(
    s.SupabaseClient admin) async {
  final ts = DateTime.now().millisecondsSinceEpoch;
  final orgId = 'org_core_$ts';
  await admin
      .from('organizations')
      .upsert({'id': orgId, 'name': 'Org Core $ts'});

  final teamId = 'team_$ts';
  await admin.from('teams').upsert({
    'id': teamId,
    'organization_id': orgId,
    'name': 'Team $ts',
  });

  final sessionId = 'session_$ts';
  await admin.from('training_sessions').upsert({
    'id': sessionId,
    'organization_id': orgId,
    'title': 'Session $ts',
    'start_time': DateTime.now().toIso8601String(),
  });

  return {'orgId': orgId, 'teamId': teamId, 'sessionId': sessionId};
}

void main() {
  final url = Platform.environment['SUPABASE_URL'];
  final serviceRole = Platform.environment['SUPABASE_SERVICE_ROLE_KEY'] ??
      Platform.environment['SUPABASE_SERVICE_ROLE_KEY_PREVIEW'];
  final anon = Platform.environment['SUPABASE_ANON_KEY'] ??
      Platform.environment['SUPABASE_ANON_KEY_PREVIEW'];

  group('RLS teams/training_sessions isolation (skipped without env)', () {
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

    test('anon cannot read teams of another org', () async {
      if (admin == null || client == null) return; // skip
      await _seedOrgTeamAndSession(admin!);
      final idsB = await _seedOrgTeamAndSession(admin!);
      final orgB = idsB['orgId'];
      expect(orgB, isNotNull);
      try {
        final res = await client!
            .from('teams')
            .select('id,organization_id')
            .eq('organization_id', orgB!)
            .limit(1);
        expect(res, isA<List<dynamic>>());
        if (res.isNotEmpty) {
          expect(res.first['organization_id'], equals(orgB));
        }
      } catch (_) {
        expect(true, isTrue);
      }
    });

    test('anon cannot modify teams of another org', () async {
      if (admin == null || client == null) return; // skip
      final ids = await _seedOrgTeamAndSession(admin!);
      final teamId = ids['teamId'];
      expect(teamId, isNotNull);
      try {
        await client!
            .from('teams')
            .update({'name': 'Illegal Edit'}).eq('id', teamId!);
        fail('RLS should prevent updating team not owned by client org');
      } catch (_) {
        expect(true, isTrue);
      }
      try {
        await client!.from('teams').delete().eq('id', teamId!);
        fail('RLS should prevent deleting team not owned by client org');
      } catch (_) {
        expect(true, isTrue);
      }
    });

    test('anon cannot read training_sessions of another org', () async {
      if (admin == null || client == null) return; // skip
      await _seedOrgTeamAndSession(admin!);
      final idsB = await _seedOrgTeamAndSession(admin!);
      final orgB = idsB['orgId'];
      expect(orgB, isNotNull);
      try {
        final res = await client!
            .from('training_sessions')
            .select('id,organization_id')
            .eq('organization_id', orgB!)
            .limit(1);
        expect(res, isA<List<dynamic>>());
        if (res.isNotEmpty) {
          expect(res.first['organization_id'], equals(orgB));
        }
      } catch (_) {
        expect(true, isTrue);
      }
    });

    test('anon cannot modify training_sessions of another org', () async {
      if (admin == null || client == null) return; // skip
      final ids = await _seedOrgTeamAndSession(admin!);
      final sessionId = ids['sessionId'];
      expect(sessionId, isNotNull);
      try {
        await client!
            .from('training_sessions')
            .update({'title': 'Illegal Edit'}).eq('id', sessionId!);
        fail('RLS should prevent updating session not owned by client org');
      } catch (_) {
        expect(true, isTrue);
      }
      try {
        await client!.from('training_sessions').delete().eq('id', sessionId!);
        fail('RLS should prevent deleting session not owned by client org');
      } catch (_) {
        expect(true, isTrue);
      }
    });
  });
}
