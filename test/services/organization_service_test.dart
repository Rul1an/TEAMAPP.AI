// ignore_for_file: directives_ordering

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import 'package:jo17_tactical_manager/models/organization.dart';
import 'package:jo17_tactical_manager/services/organization_service.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockPostgrestQueryBuilder extends Mock
    implements
        PostgrestQueryBuilder,
        PostgrestFilterBuilder,
        PostgrestTransformBuilder {}

void main() {
  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  group('OrganizationService', () {
    late MockSupabaseClient client;
    late OrganizationService service;

    setUp(() {
      client = MockSupabaseClient();
      service = OrganizationService(client: client);
    });

    test('createOrganization inserts data into organizations table', () async {
      final builder = MockPostgrestQueryBuilder();
      when(() => client.from('organizations')).thenReturn(builder);
      when(() => builder.insert(any())).thenReturn(builder);
      when(() => builder.select()).thenReturn(builder);
      when(() => builder.single()).thenAnswer(
        (_) async => {
          'id': '1',
          'name': 'Test Club',
          'slug': 'test-club',
          'tier': 'basic',
          'createdAt': '2023-01-01T00:00:00Z',
          'updatedAt': '2023-01-01T00:00:00Z',
          'settings': <String, dynamic>{},
        },
      );

      final org = await service.createOrganization(
        name: 'Test Club',
        slug: 'test-club',
      );

      expect(org.id, '1');
      verify(() => client.from('organizations')).called(1);
      verify(() => builder.insert(any())).called(1);
    });

    test('getOrganization returns organization when found', () async {
      final builder = MockPostgrestQueryBuilder();
      when(() => client.from('organizations')).thenReturn(builder);
      when(() => builder.select()).thenReturn(builder);
      when(() => builder.eq('id', '1')).thenReturn(builder);
      when(() => builder.maybeSingle()).thenAnswer(
        (_) async => {
          'id': '1',
          'name': 'Test Club',
          'slug': 'test-club',
          'tier': 'basic',
          'createdAt': '2023-01-01T00:00:00Z',
          'updatedAt': '2023-01-01T00:00:00Z',
          'settings': <String, dynamic>{},
        },
      );

      final org = await service.getOrganization('1');

      expect(org?.id, '1');
      verify(() => builder.eq('id', '1')).called(1);
    });

    test('getUserOrganizations joins through organization_members', () async {
      final builder = MockPostgrestQueryBuilder();
      when(() => client.from('organization_members')).thenReturn(builder);
      when(() => builder.select('organizations(*)')).thenReturn(builder);
      when(() => builder.eq('user_id', 'user-1')).thenAnswer(
        (_) async => [
          {
            'organizations': {
              'id': '1',
              'name': 'Test Club',
              'slug': 'test-club',
              'tier': 'basic',
              'createdAt': '2023-01-01T00:00:00Z',
              'updatedAt': '2023-01-01T00:00:00Z',
              'settings': <String, dynamic>{},
            }
          }
        ],
      );

      final orgs = await service.getUserOrganizations('user-1');

      expect(orgs, hasLength(1));
      expect(orgs.first.id, '1');
      verify(() => builder.eq('user_id', 'user-1')).called(1);
    });

    test('updateOrganization updates record in organizations table', () async {
      final org = Organization(
        id: '1',
        name: 'Test Club',
        slug: 'test-club',
        tier: OrganizationTier.basic,
        createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
        updatedAt: DateTime.parse('2023-01-01T00:00:00Z'),
      );
      final builder = MockPostgrestQueryBuilder();
      when(() => client.from('organizations')).thenReturn(builder);
      when(() => builder.update(any())).thenReturn(builder);
      when(() => builder.eq('id', '1')).thenReturn(builder);
      when(() => builder.select()).thenReturn(builder);
      when(() => builder.single()).thenAnswer(
        (_) async => {
          'id': '1',
          'name': 'Test Club',
          'slug': 'test-club',
          'tier': 'basic',
          'createdAt': '2023-01-01T00:00:00Z',
          'updatedAt': '2023-01-02T00:00:00Z',
          'settings': <String, dynamic>{},
        },
      );

      final updated = await service.updateOrganization(org);

      expect(updated.updatedAt.isAfter(org.updatedAt), isTrue);
      verify(() => builder.update(any())).called(1);
    });

    test('isSlugAvailable checks organizations table', () async {
      final builder = MockPostgrestQueryBuilder();
      when(() => client.from('organizations')).thenReturn(builder);
      when(() => builder.select('id')).thenReturn(builder);
      when(() => builder.eq('slug', 'taken')).thenReturn(builder);
      when(() => builder.maybeSingle()).thenAnswer(
        (_) async => {'id': '1'},
      );

      final taken = await service.isSlugAvailable('taken');
      expect(taken, isFalse);

      when(() => builder.eq('slug', 'free')).thenReturn(builder);
      when(() => builder.maybeSingle()).thenAnswer((_) async => null);
      final free = await service.isSlugAvailable('free');
      expect(free, isTrue);
    });
  });
}

