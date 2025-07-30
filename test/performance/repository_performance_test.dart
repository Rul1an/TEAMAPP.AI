// Package imports:
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:jo17_tactical_manager/core/optimized_cache_config.dart';
import 'package:jo17_tactical_manager/config/supabase_config.dart';

// Mock classes
class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

/// Performance configuration and monitoring tests.
///
/// These tests validate that our cache configuration and monitoring systems
/// are properly configured without requiring actual database connections.
void main() {
  group('Repository Performance Tests - Phase 2 Validation', () {
    setUpAll(() async {
      // Initialize mock Supabase client for testing
      final mockClient = MockSupabaseClient();
      final mockAuth = MockGoTrueClient();

      // Set up the mock client with basic stubs
      when(() => mockClient.auth).thenReturn(mockAuth);

      // Initialize SupabaseConfig with test client to prevent "client not initialized" error
      SupabaseConfig.setClientForTest(mockClient);
    });

    group('Cache Strategy Validation', () {
      test('should use correct cache strategy for each data type', () {
        expect(OptimizedCacheConfig.getCacheStrategy('profile'),
            equals(CacheStrategy.databaseFirst),
            reason:
                'Profile queries (0.122ms) should prefer database over cache');

        expect(OptimizedCacheConfig.getCacheStrategy('video_tag'),
            equals(CacheStrategy.databaseFirst),
            reason:
                'Video tag queries (0.161ms) should prefer database over cache');

        expect(OptimizedCacheConfig.getCacheStrategy('player'),
            equals(CacheStrategy.cacheFirst),
            reason:
                'Player queries (0.941ms) should still use cache for batch operations');

        expect(OptimizedCacheConfig.getCacheStrategy('training_session'),
            equals(CacheStrategy.hybrid),
            reason:
                'Training sessions should use hybrid strategy for offline capability');
      });

      test(
          'should have appropriate TTL values for optimized database performance',
          () {
        // Short TTL for ultra-fast database queries
        expect(OptimizedCacheConfig.profileCacheTTL.inMinutes, equals(5));
        expect(OptimizedCacheConfig.videoTagCacheTTL.inMinutes, equals(2));

        // Medium TTL for moderate performance queries
        expect(OptimizedCacheConfig.playerCacheTTL.inMinutes, equals(15));
        expect(
            OptimizedCacheConfig.trainingSessionCacheTTL.inMinutes, equals(10));

        // Long TTL for rarely changing data
        expect(OptimizedCacheConfig.organizationCacheTTL.inHours, equals(1));
        expect(OptimizedCacheConfig.teamCacheTTL.inMinutes, equals(30));
      });
    });

    group('Performance Monitoring', () {
      test('should track cache hit rates accurately', () {
        // Simulate cache operations
        CachePerformanceMonitor.recordCacheHit(
            'test_key', const Duration(milliseconds: 2));
        CachePerformanceMonitor.recordCacheHit(
            'test_key', const Duration(milliseconds: 3));
        CachePerformanceMonitor.recordCacheMiss(
            'test_key', const Duration(milliseconds: 10));

        final metrics = CachePerformanceMonitor.getMetrics('test_key');
        expect(metrics, isNotNull);
        expect(metrics!.hitRate, closeTo(0.67, 0.01)); // 2 hits out of 3 total
        expect(metrics.totalRequests, equals(3));
      });

      test('should identify underperforming caches', () {
        // Simulate poor cache performance
        CachePerformanceMonitor.recordCacheMiss(
            'poor_cache', const Duration(milliseconds: 50));
        CachePerformanceMonitor.recordCacheMiss(
            'poor_cache', const Duration(milliseconds: 45));
        CachePerformanceMonitor.recordCacheHit(
            'poor_cache', const Duration(milliseconds: 2));

        final underperforming =
            CachePerformanceMonitor.getUnderperformingCaches();
        expect(underperforming, contains('poor_cache'),
            reason: 'Should identify caches with hit rate below 80%');
      });

      test('should provide cache performance metrics', () {
        // Test metrics collection
        final hitRates = CachePerformanceMonitor.getCacheHitRates();
        expect(hitRates, isA<Map<String, double>>());
        expect(hitRates.isNotEmpty, isTrue);
      });
    });

    group('Configuration Validation', () {
      test('should have valid performance thresholds', () {
        // Validate that performance targets are realistic
        expect(OptimizedCacheConfig.profileCacheTTL.inSeconds, greaterThan(0));
        expect(OptimizedCacheConfig.videoTagCacheTTL.inSeconds, greaterThan(0));
        expect(OptimizedCacheConfig.playerCacheTTL.inSeconds, greaterThan(0));
        expect(OptimizedCacheConfig.trainingSessionCacheTTL.inSeconds,
            greaterThan(0));
      });

      test('should provide sensible cache sizes', () {
        // Verify cache configurations are reasonable
        expect(OptimizedCacheConfig.profileCacheTTL.inMinutes, lessThan(60));
        expect(OptimizedCacheConfig.videoTagCacheTTL.inMinutes, lessThan(30));
        expect(OptimizedCacheConfig.playerCacheTTL.inMinutes, lessThan(120));
        expect(OptimizedCacheConfig.trainingSessionCacheTTL.inMinutes,
            lessThan(60));
      });
    });

    tearDownAll(() async {
      // Cleanup test resources
      debugPrint('\n=== Performance Test Summary ===');
      final hitRates = CachePerformanceMonitor.getCacheHitRates();
      for (final entry in hitRates.entries) {
        debugPrint(
            '${entry.key}: ${(entry.value * 100).toStringAsFixed(1)}% hit rate');
      }

      final underperforming =
          CachePerformanceMonitor.getUnderperformingCaches();
      if (underperforming.isNotEmpty) {
        debugPrint('Underperforming caches: ${underperforming.join(', ')}');
      }
      debugPrint('================================\n');
    });
  });
}
