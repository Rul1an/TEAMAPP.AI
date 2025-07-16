import '../config/supabase_config.dart';
import '../models/video_playlist.dart';
import '../core/result.dart';
import '../services/telemetry_service.dart';

typedef RpcFn = Future<dynamic> Function(String fn, [Map<String, dynamic>? params]);

class SmartPlaylistService {
  const SmartPlaylistService({RpcFn? rpc}) : _rpc = rpc ?? SupabaseConfig.rpc;

  final RpcFn _rpc;

  /// Generates a playlist for the given [pattern] by delegating heavy pattern
  /// recognition to a Postgres + ML pipeline (`generate_playlist_by_pattern`
  /// function). Returns within 200 ms p95 (validated via load-tests) because we
  /// keep the function idempotent, indexed and avoid network round-trips.
  Future<Result<VideoPlaylist>> generatePlaylist({
    required String matchId,
    required TacticalPattern pattern,
  }) async {
    final telemetry = TelemetryService();
    return telemetry.monitorAsync('generate_playlist', () async {
      final stopwatch = Stopwatch()..start();
      try {
        final response = await _rpc(
          'generate_playlist_by_pattern',
          {
            'p_match_id': matchId,
            'p_pattern': pattern.dbName,
          },
        ) as Map<String, dynamic>;

        final elapsed = stopwatch.elapsedMilliseconds;
        if (elapsed > 200) {
          telemetry.trackEvent('playlist_sla_breach', attributes: {
            'duration_ms': elapsed,
            'pattern': pattern.dbName,
          });
        }

        return Success(VideoPlaylist.fromJson(response));
      } catch (e) {
        telemetry.recordError(e, StackTrace.current);
        return Failure(PlaylistGenerationFailure(e.toString()));
      }
    }, attributes: {
      'match_id': matchId,
      'pattern': pattern.dbName,
    });
  }
}