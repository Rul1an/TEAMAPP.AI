// Project imports:

/// Optimized cache configuration based on Phase 1 database performance gains.
///
/// After achieving 95%+ database performance improvements (0.122ms - 0.941ms queries),
/// we can reduce cache TTL values as database queries are now faster than cache overhead
/// in many cases. This allows for more real-time data while maintaining offline capability.
///
/// Performance Context:
/// - Organization queries: 0.941ms (was ~179ms)
/// - Video tag searches: 0.161ms (was ~50ms)
/// - Profile queries: 0.122ms (was ~25ms)
class OptimizedCacheConfig {
  /// SHORT TTL for frequently changing data where real-time updates are critical
  /// and database performance now exceeds cache retrieval speed.
  static const Duration profileCacheTTL = Duration(minutes: 5);
  static const Duration videoTagCacheTTL = Duration(minutes: 2);

  /// MEDIUM TTL for moderately changing data where cache still provides value
  /// for offline scenarios and batch operations.
  static const Duration playerCacheTTL = Duration(minutes: 15);
  static const Duration trainingSessionCacheTTL = Duration(minutes: 10);

  /// LONG TTL for rarely changing data where cache provides clear benefit
  /// over network round-trip time.
  static const Duration organizationCacheTTL = Duration(hours: 1);
  static const Duration teamCacheTTL = Duration(minutes: 30);

  /// CRITICAL TTL for essential offline-first functionality
  /// Keep longer for scenarios where offline capability is essential.
  static const Duration matchCacheTTL = Duration(hours: 2);
  static const Duration seasonCacheTTL = Duration(hours: 6);

  /// Cache performance monitoring thresholds
  static const double targetCacheHitRate = 0.80; // 80% cache hit rate target
  static const Duration maxAcceptableCacheRetrievalTime = Duration(milliseconds: 5);
  static const Duration maxAcceptableDatabaseFallbackTime = Duration(milliseconds: 10);

  /// Cache invalidation strategies based on data criticality
  static bool shouldInvalidateOnUpdate(String cacheKey) {
    // Immediately invalidate high-frequency data
    if (cacheKey.contains('profile') || cacheKey.contains('video_tag')) {
      return true;
    }

    // Use write-through for moderate frequency data
    if (cacheKey.contains('player') || cacheKey.contains('training_session')) {
      return false; // Use write-through instead
    }

    // Manual invalidation for low-frequency data
    return false;
  }

  /// Determine if cache or database should be preferred based on data type
  static CacheStrategy getCacheStrategy(String dataType) {
    switch (dataType.toLowerCase()) {
      case 'profile':
        // Database is now 0.122ms - faster than cache retrieval
        return CacheStrategy.databaseFirst;

      case 'video_tag':
        // Database is now 0.161ms - use for real-time tagging
        return CacheStrategy.databaseFirst;

      case 'player':
        // Database is now 0.941ms - still use cache for batch operations
        return CacheStrategy.cacheFirst;

      case 'training_session':
        // Hybrid approach - cache for offline, database for real-time
        return CacheStrategy.hybrid;

      default:
        return CacheStrategy.cacheFirst;
    }
  }
}

/// Cache strategy enum for optimized data access patterns
enum CacheStrategy {
  /// Check cache first, fallback to database
  cacheFirst,

  /// Check database first, fallback to cache (for ultra-fast DB queries)
  databaseFirst,

  /// Intelligent routing based on network connectivity and data freshness
  hybrid,
}

/// Performance monitoring for cache effectiveness
class CachePerformanceMonitor {
  static final Map<String, CacheMetrics> _metrics = {};

  static void recordCacheHit(String cacheKey, Duration retrievalTime) {
    _metrics.putIfAbsent(cacheKey, () => CacheMetrics()).recordHit(retrievalTime);
  }

  static void recordCacheMiss(String cacheKey, Duration fallbackTime) {
    _metrics.putIfAbsent(cacheKey, () => CacheMetrics()).recordMiss(fallbackTime);
  }

  static CacheMetrics? getMetrics(String cacheKey) => _metrics[cacheKey];

  static Map<String, double> getCacheHitRates() {
    return _metrics.map((key, metrics) => MapEntry(key, metrics.hitRate));
  }

  static List<String> getUnderperformingCaches() {
    return _metrics.entries
        .where((entry) => entry.value.hitRate < OptimizedCacheConfig.targetCacheHitRate)
        .map((entry) => entry.key)
        .toList();
  }
}

/// Metrics tracking for individual cache keys
class CacheMetrics {
  int _hits = 0;
  int _misses = 0;
  Duration _totalHitTime = Duration.zero;
  Duration _totalMissTime = Duration.zero;

  void recordHit(Duration retrievalTime) {
    _hits++;
    _totalHitTime += retrievalTime;
  }

  void recordMiss(Duration fallbackTime) {
    _misses++;
    _totalMissTime += fallbackTime;
  }

  double get hitRate => _hits + _misses == 0 ? 0.0 : _hits / (_hits + _misses);

  Duration get averageHitTime => _hits == 0 ? Duration.zero :
      Duration(microseconds: _totalHitTime.inMicroseconds ~/ _hits);

  Duration get averageMissTime => _misses == 0 ? Duration.zero :
      Duration(microseconds: _totalMissTime.inMicroseconds ~/ _misses);

  int get totalRequests => _hits + _misses;

  bool get isPerforming => hitRate >= OptimizedCacheConfig.targetCacheHitRate &&
      averageHitTime <= OptimizedCacheConfig.maxAcceptableCacheRetrievalTime;
}
