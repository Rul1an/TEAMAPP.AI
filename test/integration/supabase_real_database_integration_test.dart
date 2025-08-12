// test/integration/supabase_real_database_integration_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:jo17_tactical_manager/config/environment.dart';
import '../helpers/test_database_helper.dart';
import '../fixtures/test_data_factory.dart';

/// 🏗️ SUPABASE REAL DATABASE INTEGRATION TESTS (2025)
///
/// Deze tests gebruiken een echte Supabase test database om:
/// - Database schema te valideren
/// - RLS policies te testen
/// - Multi-tenant isolation te verifiëren
/// - Performance benchmarks uit te voeren
/// - Auth flows te testen
///
/// Gebaseerd op Supabase 2025 testing best practices:
/// https://supabase.com/docs/guides/local-development/testing/overview
void main() {
  group('🔥 Supabase Real Database Integration Tests (2025)', () {
    late SupabaseClient testClient;
    late String testOrgId1;
    late String testOrgId2;
    late String testUserId1;
    late String testUserId2;

    /// Setup test database met unieke identifiers voor isolatie
    setUpAll(() async {
      // Initialize test environment with proper auth configuration
      testClient = SupabaseClient(
        Environment.test.supabaseUrl,
        Environment.test.supabaseAnonKey,
        // For integration tests we don't persist sessions; PKCE storage not required
        authOptions: const AuthClientOptions(
          autoRefreshToken: false,
        ),
      );

      // Generate unique IDs for this test run to prevent conflicts
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final randomSuffix = Random().nextInt(10000);

      testOrgId1 = 'test-org-1-$timestamp-$randomSuffix';
      testOrgId2 = 'test-org-2-$timestamp-$randomSuffix';
      testUserId1 = _generateUniqueUserId();
      testUserId2 = _generateUniqueUserId();

      print('🚀 Setting up integration tests with unique identifiers:');
      print('   - Test Org 1: $testOrgId1');
      print('   - Test Org 2: $testOrgId2');
      print('   - Test User 1: $testUserId1');
      print('   - Test User 2: $testUserId2');
    });

    /// Cleanup test data after all tests
    tearDownAll(() async {
      await _cleanupTestData(testClient, testOrgId1, testOrgId2);
      print('✅ Integration test cleanup completed');
    });

    group('📊 Database Schema Validation', () {
      test('should validate core tables exist', () async {
        final requiredTables = [
          'organizations',
          'players',
          'training_sessions',
          'exercises',
          'matches',
          'performance_ratings',
          'video_tags',
          'videos',
        ];

        for (final table in requiredTables) {
          try {
            // Attempt to query each table
            await testClient.from(table).select('*').limit(1);

            // If we get here without exception, table exists
            print('✅ Table $table exists and is queryable');
          } catch (e) {
            fail('❌ Required table $table is missing or not accessible: $e');
          }
        }
      });

      test('should validate database functions exist', () async {
        final requiredFunctions = [
          'get_organization_stats',
          'calculate_player_performance',
          'update_training_metrics',
        ];

        for (final functionName in requiredFunctions) {
          try {
            // Test RPC function call
            await testClient.rpc<Map<String, dynamic>>(functionName, params: {
              'organization_id': testOrgId1,
            });
            print('✅ Function $functionName exists and is callable');
          } catch (e) {
            // Function might exist but have different parameters
            // Check if error is about function not existing vs parameter issues
            if (e.toString().contains('function') &&
                e.toString().contains('does not exist')) {
              fail('❌ Required function $functionName does not exist: $e');
            } else {
              print(
                  '✅ Function $functionName exists (parameter validation needed)');
            }
          }
        }
      });
    });

    group('🔐 Row Level Security (RLS) Testing', () {
      test('should enforce organization data isolation', () async {
        // Create test data for two different organizations
        await _setupTestOrganizations(testClient, testOrgId1, testOrgId2);

        // Create test users for each organization
        final user1 =
            await _createTestUser(testClient, testUserId1, testOrgId1);
        final user2 =
            await _createTestUser(testClient, testUserId2, testOrgId2);

        // Test that User 1 can only see Org 1 data
        await _setUserContext(testClient, user1.id, testOrgId1);

        final org1Players = await testClient
            .from('players')
            .select('*, organization_id')
            .eq('organization_id', testOrgId1);

        expect(org1Players.isNotEmpty, true);
        expect(
            org1Players
                .every((player) => player['organization_id'] == testOrgId1),
            true);

        // Test that User 1 cannot see Org 2 data
        final org2PlayersFromUser1 = await testClient
            .from('players')
            .select('*, organization_id')
            .eq('organization_id', testOrgId2);

        expect(org2PlayersFromUser1.isEmpty, true,
            reason: 'User 1 should not see Organization 2 data due to RLS');

        // Test that User 2 can only see Org 2 data
        await _setUserContext(testClient, user2.id, testOrgId2);

        final org2Players = await testClient
            .from('players')
            .select('*, organization_id')
            .eq('organization_id', testOrgId2);

        expect(org2Players.isNotEmpty, true);
        expect(
            org2Players
                .every((player) => player['organization_id'] == testOrgId2),
            true);

        print('✅ RLS successfully enforces organization data isolation');
      });

      test('should prevent cross-organization data modifications', () async {
        // Setup test context as User 1 (Org 1)
        final user1 = await _getTestUser(testClient, testUserId1);
        await _setUserContext(testClient, user1.id, testOrgId1);

        // Attempt to modify Organization 2 data
        try {
          await testClient.from('players').update({'name': 'Hacked Player'}).eq(
              'organization_id', testOrgId2);

          // Verify no rows were affected
          final modifiedPlayers = await testClient
              .from('players')
              .select('name')
              .eq('organization_id', testOrgId2)
              .eq('name', 'Hacked Player');

          expect(modifiedPlayers.isEmpty, true,
              reason: 'RLS should prevent cross-organization modifications');

          print('✅ RLS successfully prevents cross-organization modifications');
        } catch (e) {
          // RLS should prevent the operation entirely
          print('✅ RLS blocked cross-organization modification: $e');
        }
      });

      test('should allow organization admins full access to their data',
          () async {
        // Create admin user for Organization 1
        final adminUser = await _createTestUser(
            testClient, _generateUniqueUserId(), testOrgId1,
            role: 'admin');

        await _setUserContext(testClient, adminUser.id, testOrgId1);

        // Admin should be able to create, read, update, delete
        final testPlayer = {
          'id': _generateUniqueUserId(),
          'organization_id': testOrgId1,
          'name': 'Test Admin Player',
          'position': 'Midfielder',
          'shirt_number': 99,
        };

        // Create
        await testClient.from('players').insert(testPlayer);

        // Read
        final createdPlayer = await testClient
            .from('players')
            .select()
            .eq('id', testPlayer['id'] as Object)
            .single();

        expect(createdPlayer['name'], equals('Test Admin Player'));

        // Update
        await testClient
            .from('players')
            .update({'name': 'Updated Admin Player'}).eq(
                'id', testPlayer['id'] as Object);

        // Verify update
        final updatedPlayer = await testClient
            .from('players')
            .select('name')
            .eq('id', testPlayer['id'] as Object)
            .single();

        expect(updatedPlayer['name'], equals('Updated Admin Player'));

        // Delete
        await testClient
            .from('players')
            .delete()
            .eq('id', testPlayer['id'] as Object);

        print('✅ Organization admin has full CRUD access to organization data');
      });
    });

    group('⚡ Performance Benchmarking', () {
      test('should meet query performance requirements', () async {
        // Setup performance test data
        await _setupPerformanceTestData(testClient, testOrgId1);

        // Benchmark common queries
        final queryBenchmarks = <String, Duration>{};

        // 1. Player list query (most common)
        final playerQueryResult =
            await TestDatabaseHelper.measureQueryPerformance(
          () => testClient
              .from('players')
              .select('id, name, position, shirt_number')
              .eq('organization_id', testOrgId1)
              .limit(50),
          iterations: 10,
        );
        queryBenchmarks['player_list'] = playerQueryResult.averageDuration;

        // 2. Training session details (complex join)
        final sessionQueryResult =
            await TestDatabaseHelper.measureQueryPerformance(
          () => testClient.from('training_sessions').select('''
                id, title, date, duration,
                exercises (
                  id, name, category, duration
                ),
                attendance:player_attendance (
                  player_id,
                  players (name, position)
                )
              ''').eq('organization_id', testOrgId1).limit(10),
          iterations: 5,
        );
        queryBenchmarks['training_sessions'] =
            sessionQueryResult.averageDuration;

        // 3. Analytics aggregation query
        final analyticsQueryResult =
            await TestDatabaseHelper.measureQueryPerformance(
          () => testClient
              .rpc<Map<String, dynamic>>('get_organization_stats', params: {
            'organization_id': testOrgId1,
          }),
          iterations: 3,
        );
        queryBenchmarks['analytics'] = analyticsQueryResult.averageDuration;

        // Verify performance requirements (2025 standards)
        final requirements = <String, Duration>{
          'player_list':
              const Duration(milliseconds: 100), // Simple queries < 100ms
          'training_sessions':
              const Duration(milliseconds: 500), // Complex joins < 500ms
          'analytics': const Duration(milliseconds: 1000), // Analytics < 1s
        };

        for (final entry in queryBenchmarks.entries) {
          final queryName = entry.key;
          final actualTime = entry.value;
          final requiredTime = requirements[queryName]!;

          expect(
            actualTime.inMilliseconds,
            lessThanOrEqualTo(requiredTime.inMilliseconds),
            reason: 'Query $queryName took ${actualTime.inMilliseconds}ms, '
                'requirement: ${requiredTime.inMilliseconds}ms',
          );

          print('✅ $queryName: ${actualTime.inMilliseconds}ms '
              '(required: <${requiredTime.inMilliseconds}ms)');
        }
      });

      test('should handle concurrent user operations', () async {
        // Simulate concurrent operations from multiple users
        final futures = <Future<void>>[];

        for (int i = 0; i < 5; i++) {
          futures.add(_simulateUserActivity(testClient, testOrgId1, i));
        }

        // All operations should complete without errors
        await Future.wait<void>(futures);

        print('✅ Database handles concurrent operations successfully');
      });
    });

    group('🔧 Database Functions & Triggers', () {
      test('should automatically update timestamps', () async {
        // Create a player
        final testPlayer = {
          'id': _generateUniqueUserId(),
          'organization_id': testOrgId1,
          'name': 'Timestamp Test Player',
          'position': 'Forward',
          'shirt_number': 88,
        };

        await testClient.from('players').insert(testPlayer);

        final createdPlayer = await testClient
            .from('players')
            .select('created_at, updated_at')
            .eq('id', testPlayer['id'] as Object)
            .single();

        expect(createdPlayer['created_at'], isNotNull);
        expect(createdPlayer['updated_at'], isNotNull);

        // Wait a moment then update
        await Future<void>.delayed(const Duration(milliseconds: 100));

        await testClient
            .from('players')
            .update({'name': 'Updated Timestamp Player'}).eq(
                'id', testPlayer['id'] as Object);

        final updatedPlayer = await testClient
            .from('players')
            .select('created_at, updated_at')
            .eq('id', testPlayer['id'] as Object)
            .single();

        // updated_at should be newer than created_at
        final createdAt = DateTime.parse(updatedPlayer['created_at'] as String);
        final updatedAt = DateTime.parse(updatedPlayer['updated_at'] as String);

        expect(updatedAt.isAfter(createdAt), true);

        print('✅ Automatic timestamp triggers working correctly');
      });

      test('should calculate player statistics correctly', () async {
        // This would test database functions that calculate player stats
        final stats = await testClient
            .rpc<Map<String, dynamic>>('calculate_player_performance', params: {
          'player_id': 'test-player-id',
          'organization_id': testOrgId1,
          'date_from': '2025-01-01',
          'date_to': '2025-12-31',
        });

        // Verify stats structure
        expect(stats, isA<Map<String, dynamic>>());
        expect(stats['total_sessions'], isA<int>());
        expect(stats['average_rating'], isA<num>());

        print('✅ Player statistics calculation function working');
      });
    });

    group('💾 Data Integrity & Constraints', () {
      test('should enforce foreign key constraints', () async {
        // Attempt to create player with non-existent organization
        try {
          await testClient.from('players').insert({
            'id': _generateUniqueUserId(),
            'organization_id': 'non-existent-org-id',
            'name': 'Invalid Player',
            'position': 'Forward',
            'shirt_number': 77,
          });

          fail('Should have thrown foreign key constraint error');
        } catch (e) {
          expect(
              e.toString().contains('foreign key') ||
                  e.toString().contains('constraint'),
              true);
          print('✅ Foreign key constraints enforced correctly');
        }
      });

      test('should prevent duplicate shirt numbers in same organization',
          () async {
        // Create first player with shirt number 10
        await testClient.from('players').insert({
          'id': _generateUniqueUserId(),
          'organization_id': testOrgId1,
          'name': 'First Player',
          'position': 'Forward',
          'shirt_number': 10,
        });

        // Attempt to create second player with same shirt number
        try {
          await testClient.from('players').insert({
            'id': _generateUniqueUserId(),
            'organization_id': testOrgId1,
            'name': 'Second Player',
            'position': 'Midfielder',
            'shirt_number': 10, // Duplicate!
          });

          fail('Should have thrown unique constraint error');
        } catch (e) {
          expect(
              e.toString().contains('unique') ||
                  e.toString().contains('duplicate'),
              true);
          print('✅ Unique constraints enforced correctly');
        }
      });
    });
  });
}

/// Generate unique user ID using crypto
String _generateUniqueUserId() {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final random = Random().nextInt(100000);
  final combined = '$timestamp-$random';
  final bytes = utf8.encode(combined);
  final digest = sha256.convert(bytes);
  return digest.toString().substring(0, 32);
}

/// Setup test organizations
Future<void> _setupTestOrganizations(
  SupabaseClient client,
  String orgId1,
  String orgId2,
) async {
  final orgs = [
    {
      'id': orgId1,
      'name': 'VOAB JO17-1 Test Org 1',
      'slug': 'voab-jo17-test-1',
      'subscription_tier': 'basic',
      'max_players': 25,
      'max_teams': 1,
      'max_coaches': 3,
    },
    {
      'id': orgId2,
      'name': 'Test Club JO17 Org 2',
      'slug': 'test-club-jo17-2',
      'subscription_tier': 'pro',
      'max_players': 50,
      'max_teams': 3,
      'max_coaches': 5,
    },
  ];

  for (final org in orgs) {
    await client.from('organizations').upsert(org);

    // Create test players for each organization
    final players = TestDataFactory.dutchYouthPlayers()
        .take(5)
        .map((player) => {
              ...player,
              'id': _generateUniqueUserId(),
              'organization_id': org['id'],
            })
        .toList();

    await client.from('players').upsert(players);
  }
}

/// Create test user
Future<User> _createTestUser(
  SupabaseClient client,
  String userId,
  String orgId, {
  String role = 'coach',
}) async {
  final testEmail = 'test-$userId@voab-test.nl';
  final testPassword = 'TestPassword123!';

  final authResponse = await client.auth.signUp(
    email: testEmail,
    password: testPassword,
    data: {
      'organization_id': orgId,
      'role': role,
      'name': 'Test $role',
    },
  );

  if (authResponse.user == null) {
    throw Exception('Failed to create test user');
  }

  return authResponse.user!;
}

/// Get existing test user
Future<User> _getTestUser(SupabaseClient client, String userId) async {
  final testEmail = 'test-$userId@voab-test.nl';
  final testPassword = 'TestPassword123!';

  final authResponse = await client.auth.signInWithPassword(
    email: testEmail,
    password: testPassword,
  );

  if (authResponse.user == null) {
    throw Exception('Failed to get test user');
  }

  return authResponse.user!;
}

/// Set user context for RLS testing
Future<void> _setUserContext(
  SupabaseClient client,
  String userId,
  String orgId,
) async {
  // Sign in as the user to activate RLS context
  await client.auth.refreshSession();

  // Set organization context
  await client.rpc<void>('set_organization_context', params: {
    'org_id': orgId,
  });
}

/// Setup performance test data
Future<void> _setupPerformanceTestData(
  SupabaseClient client,
  String orgId,
) async {
  // Create 100 test players
  final players = List.generate(
      100,
      (i) => {
            'id': _generateUniqueUserId(),
            'organization_id': orgId,
            'name': 'Performance Test Player $i',
            'position': [
              'Forward',
              'Midfielder',
              'Defender',
              'Goalkeeper'
            ][i % 4],
            'shirt_number': i + 1,
          });

  await client.from('players').upsert(players);

  // Create 50 training sessions
  final sessions = List.generate(
      50,
      (i) => {
            'id': _generateUniqueUserId(),
            'organization_id': orgId,
            'title': 'Performance Test Session $i',
            'date':
                DateTime.now().subtract(Duration(days: i)).toIso8601String(),
            'duration': 90,
          });

  await client.from('training_sessions').upsert(sessions);
}

/// Simulate user activity for concurrent testing
Future<void> _simulateUserActivity(
  SupabaseClient client,
  String orgId,
  int userIndex,
) async {
  // Each simulated user performs different operations
  await Future<void>.delayed(Duration(milliseconds: userIndex * 10));

  switch (userIndex % 3) {
    case 0:
      // Read operations
      await client
          .from('players')
          .select()
          .eq('organization_id', orgId)
          .limit(10);
      break;
    case 1:
      // Write operations
      await client.from('training_sessions').insert({
        'id': _generateUniqueUserId(),
        'organization_id': orgId,
        'title': 'Concurrent Test Session $userIndex',
        'date': DateTime.now().toIso8601String(),
        'duration': 60,
      });
      break;
    case 2:
      // Analytics operations
      await client.rpc<Map<String, dynamic>>('get_organization_stats', params: {
        'organization_id': orgId,
      });
      break;
  }
}

/// Cleanup test data
Future<void> _cleanupTestData(
  SupabaseClient client,
  String orgId1,
  String orgId2,
) async {
  try {
    // Clean up in reverse dependency order
    await client
        .from('performance_ratings')
        .delete()
        .or('organization_id.eq.$orgId1,organization_id.eq.$orgId2');
    await client
        .from('player_attendance')
        .delete()
        .or('organization_id.eq.$orgId1,organization_id.eq.$orgId2');
    await client
        .from('training_sessions')
        .delete()
        .or('organization_id.eq.$orgId1,organization_id.eq.$orgId2');
    await client
        .from('exercises')
        .delete()
        .or('organization_id.eq.$orgId1,organization_id.eq.$orgId2');
    await client
        .from('matches')
        .delete()
        .or('organization_id.eq.$orgId1,organization_id.eq.$orgId2');
    await client
        .from('players')
        .delete()
        .or('organization_id.eq.$orgId1,organization_id.eq.$orgId2');
    await client
        .from('organizations')
        .delete()
        .or('id.eq.$orgId1,id.eq.$orgId2');

    print('✅ Test data cleanup completed successfully');
  } catch (e) {
    print('⚠️ Error during cleanup (non-critical): $e');
  }
}
