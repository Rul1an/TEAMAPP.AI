// Project imports:
import '../core/result.dart';

/// CachePolicy provides shared SWR (stale-while-revalidate) helpers for
/// repositories to keep behavior consistent across the codebase.
class CachePolicy {
  /// SWR for read flows:
  /// - Try remote; on success write-through to cache and return data
  /// - On remote error, return cached value when present; otherwise map error
  static Future<Result<T>> getSWR<T>({
    required Future<T> Function() fetchRemote,
    required Future<T?> Function() readCache,
    required Future<void> Function(T data) writeCache,
    required AppFailure Function(Object error) mapError,
  }) async {
    try {
      // Guard against hanging remote calls (e.g., flaky network on web)
      final T data = await fetchRemote().timeout(const Duration(seconds: 8));
      await writeCache(data);
      return Success<T>(data);
    } catch (e) {
      final T? cached = await readCache();
      if (cached != null) {
        return Success<T>(cached);
      }
      return Failure<T>(mapError(e));
    }
  }

  /// Mutation policy:
  /// - Attempt remote change; on success clear/invalidate cache
  /// - On error map to a consistent AppFailure
  static Future<Result<void>> mutate({
    required Future<void> Function() remoteCall,
    required Future<void> Function() clearCache,
    required AppFailure Function(Object error) mapError,
  }) async {
    try {
      await remoteCall();
      await clearCache();
      return const Success<void>(null);
    } catch (e) {
      return Failure<void>(mapError(e));
    }
  }
}
