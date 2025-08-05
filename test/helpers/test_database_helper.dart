// test/helpers/test_database_helper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../fixtures/test_data_factory.dart';

/// Testing modes voor verschillende test scenarios
enum TestingMode {
  mock, // Mock client voor widget tests
  database, // Echte database voor integration tests
}

/// Test database helper voor Supabase test setup volgens 2025 best practices
///
/// Ondersteunt twee testing modes:
/// 1. Mock Client - Voor snelle widget tests zonder database dependency
/// 2. Real Database - Voor integration tests met echte Supabase database
///
/// Deze helper configureerd test-specifieke Supabase instances
/// en beheert test data lifecycle voor Nederlandse voetbal context
class TestDatabaseHelper {
  static late SupabaseClient testSupabase;
  static bool _isInitialized = false;
  static bool _isMockClient = false;

  /// Setup test database met mock configuratie voor Flutter tests
  static Future<void> setupTestDatabase() async {
    if (_isInitialized) return;

    try {
      // Voor Flutter tests - gebruik mock client
      testSupabase = _createMockSupabaseClient();
      _isMockClient = true;
      _isInitialized = true;

      // Setup mock test data
      await seedTestData();
    } catch (e) {
      // Als Supabase initialization faalt, gebruik mock
      testSupabase = _createMockSupabaseClient();
      _isMockClient = true;
      _isInitialized = true;
      print('⚠️  Using mock Supabase client for tests');
    }
  }

  /// Create mock Supabase client voor testing
  static SupabaseClient _createMockSupabaseClient() {
    // Mock client die geen echte database calls maakt
    return SupabaseClient(
      'http://localhost:54321',
      'test-anon-key-for-local-development',
    );
  }

  /// Seed test database met Nederlandse voetbal data (Mock version voor Flutter tests)
  static Future<void> seedTestData() async {
    try {
      // Mock data seeding - geen echte database calls voor Flutter tests
      final orgData = TestDataFactory.voabOrganization();
      final players = TestDataFactory.dutchYouthPlayers();
      final exercises = TestDataFactory.dutchExercises();
      final session = TestDataFactory.voabTrainingSession();
      final ratings = TestDataFactory.performanceRatings();
      final match = TestDataFactory.testMatch();

      // Simuleer database seeding zonder echte calls
      print('✅ Mock test data seeded successfully');
      print('   - Organization: ${orgData['name']}');
      print('   - Players: ${players.length} Nederlandse JO17 spelers');
      print('   - Exercises: ${exercises.length} VOAB oefeningen');
      print('   - Training session: ${session['title']}');
      print('   - Performance ratings: ${ratings.length} ratings');
      print('   - Test match: ${match['opponent']}');
    } catch (e) {
      print('❌ Error seeding mock test data: $e');
      // Niet rethrown - mock data seeding is best effort
    }
  }

  /// Cleanup test data na tests
  static Future<void> cleanupTestData() async {
    if (!_isInitialized) return;

    // Voor mock client - geen echte database cleanup nodig
    if (_isMockClient) {
      print('✅ Mock test data cleanup completed (no database calls needed)');
      return;
    }

    try {
      // Clean up in reverse dependency order om foreign key constraints te respecteren
      await testSupabase.from('performance_ratings').delete().neq('id', '');
      await testSupabase.from('matches').delete().neq('id', '');
      await testSupabase.from('training_sessions').delete().neq('id', '');
      await testSupabase.from('exercises').delete().neq('id', '');
      await testSupabase.from('players').delete().neq('id', '');
      await testSupabase.from('organizations').delete().neq('id', '');

      print('✅ Test data cleaned up successfully');
    } catch (e) {
      print('❌ Error cleaning up test data: $e');
      // Don't rethrow - cleanup should be best effort
    }
  }

  /// Reset test database naar clean state
  static Future<void> resetDatabase() async {
    await cleanupTestData();
    await seedTestData();
  }

  /// Verify database connectivity
  static Future<bool> verifyConnection() async {
    try {
      final response =
          await testSupabase.from('organizations').select('id').limit(1);

      return response.isNotEmpty;
    } catch (e) {
      print('❌ Database connection failed: $e');
      return false;
    }
  }

  /// Create test user session voor auth testing
  static Future<User?> createTestUserSession({
    String? email,
    String? organizationId,
  }) async {
    try {
      final testEmail = email ?? 'coach@voab-jo17-test.nl';
      final testPassword = 'TestPassword123!';

      // Sign up test user
      final authResponse = await testSupabase.auth.signUp(
        email: testEmail,
        password: testPassword,
        data: {
          'organization_id':
              organizationId ?? TestDataFactory.voabOrganizationId,
          'role': 'coach',
          'name': 'Test Coach',
        },
      );

      if (authResponse.user == null) {
        throw Exception('Failed to create test user');
      }

      return authResponse.user;
    } catch (e) {
      print('❌ Error creating test user session: $e');
      rethrow;
    }
  }

  /// Sign out test user
  static Future<void> signOutTestUser() async {
    try {
      await testSupabase.auth.signOut();
    } catch (e) {
      print('❌ Error signing out test user: $e');
    }
  }

  /// Get current test user
  static User? getCurrentTestUser() {
    return testSupabase.auth.currentUser;
  }

  /// Execute raw SQL voor advanced testing scenarios
  static Future<List<Map<String, dynamic>>> executeRawSQL(String sql) async {
    try {
      final response = await testSupabase
          .rpc<List<dynamic>>('execute_sql', params: {'sql': sql});
      return response.cast<Map<String, dynamic>>();
    } catch (e) {
      print('❌ Error executing raw SQL: $e');
      rethrow;
    }
  }

  /// Setup Row Level Security test context
  static Future<void> setupRLSTestContext(String organizationId) async {
    // Set organization context voor RLS testing
    await testSupabase.rpc<void>('set_claim', params: {
      'claim': 'organization_id',
      'value': organizationId,
    });
  }

  /// Verify RLS isolation tussen organizations
  static Future<bool> verifyRLSIsolation(
    String table,
    String userAOrgId,
    String userBOrgId,
  ) async {
    try {
      // Setup context voor user A
      await setupRLSTestContext(userAOrgId);
      final userAData = await testSupabase.from(table).select();

      // Setup context voor user B
      await setupRLSTestContext(userBOrgId);
      final userBData = await testSupabase.from(table).select();

      // Verify dat users alleen hun eigen organization data zien
      final userAHasUserBData =
          userAData.any((row) => row['organization_id'] == userBOrgId);
      final userBHasUserAData =
          userBData.any((row) => row['organization_id'] == userAOrgId);

      return !userAHasUserBData && !userBHasUserAData;
    } catch (e) {
      print('❌ Error verifying RLS isolation: $e');
      return false;
    }
  }

  /// Performance test helper - measure query execution time
  static Future<QueryPerformanceResult> measureQueryPerformance(
      Future<dynamic> Function() query,
      {int iterations = 10}) async {
    final durations = <Duration>[];

    for (int i = 0; i < iterations; i++) {
      final stopwatch = Stopwatch()..start();
      await query();
      stopwatch.stop();
      durations.add(stopwatch.elapsed);
    }

    final totalDuration = durations.reduce((a, b) => a + b);
    final averageDuration = Duration(
      microseconds: totalDuration.inMicroseconds ~/ iterations,
    );

    durations.sort((a, b) => a.inMicroseconds.compareTo(b.inMicroseconds));
    final medianDuration = durations[iterations ~/ 2];

    return QueryPerformanceResult(
      iterations: iterations,
      totalDuration: totalDuration,
      averageDuration: averageDuration,
      medianDuration: medianDuration,
      minDuration: durations.first,
      maxDuration: durations.last,
    );
  }

  /// Dispose test database resources
  static Future<void> dispose() async {
    if (_isInitialized) {
      await cleanupTestData();
      await signOutTestUser();
      _isInitialized = false;
    }
  }
}

/// Query performance measurement result
class QueryPerformanceResult {
  final int iterations;
  final Duration totalDuration;
  final Duration averageDuration;
  final Duration medianDuration;
  final Duration minDuration;
  final Duration maxDuration;

  const QueryPerformanceResult({
    required this.iterations,
    required this.totalDuration,
    required this.averageDuration,
    required this.medianDuration,
    required this.minDuration,
    required this.maxDuration,
  });

  @override
  String toString() {
    return '''
Query Performance Results ($iterations iterations):
  Average: ${averageDuration.inMilliseconds}ms
  Median: ${medianDuration.inMilliseconds}ms
  Min: ${minDuration.inMilliseconds}ms
  Max: ${maxDuration.inMilliseconds}ms
  Total: ${totalDuration.inMilliseconds}ms
''';
  }

  /// Check if performance meets requirements
  bool meetsPerformanceRequirements({
    Duration? maxAverageTime,
    Duration? maxMedianTime,
  }) {
    if (maxAverageTime != null && averageDuration > maxAverageTime) {
      return false;
    }
    if (maxMedianTime != null && medianDuration > maxMedianTime) {
      return false;
    }
    return true;
  }
}
