import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';
import '../models/video_event.dart';

/// Service responsible for detecting & streaming tactical video events in one
/// second or less after a video tag is inserted. Implementation relies on
/// Supabase Realtime (Postgres CDC) so that the heavy lifting can be done on
/// the database side or via Postgres triggers / ML inference pipelines.
class VideoEventDetectorService {
  VideoEventDetectorService({SupabaseClient? client})
      : _client = client ?? SupabaseConfig.client;

  final SupabaseClient _client;

  /// Creates a broadcast [Stream] of [VideoEvent]s for the given [matchId].
  ///
  /// Internally this opens a dedicated Realtime channel that listens for
  /// `INSERT` changes on the `video_tags` table filtered by the provided
  /// `match_id`. Each change is mapped to a [VideoEvent] when the incoming
  /// row has a supported `tag_type` (goal, corner, foul).
  ///
  /// The stream finishes (and resources are cleaned up) once the listener
  /// cancels.
  Stream<VideoEvent> streamEvents({required String matchId}) {
    final controller = StreamController<VideoEvent>.broadcast();

    // Build a uniquely named channel so it can be disposed independently.
    final channelName = 'video_events_match_$matchId';

    final channel = _client
        .channel(channelName)
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'video_tags',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'match_id',
            value: matchId,
          ),
          callback: (payload) {
            try {
              final record = payload.newRecord;
              final tagType = record['tag_type'] as String?;

              if (tagType == null || !_typeMap.containsKey(tagType)) return;

              final event = VideoEvent(
                id: record['id'].toString(),
                matchId: matchId,
                timestampMs: record['timestamp_ms'] as int,
                type: _typeMap[tagType]!,
                createdAt: DateTime.parse(record['created_at'] as String),
              );
              controller.add(event);
            } catch (e, s) {
              // Swallow parsing errors but report via telemetry to avoid
              // crashing the stream.
              // ignore: avoid_print
              print('⚠️ VideoEventDetectorService error: $e, $s');
            }
          },
        )
        .subscribe();

    // Auto-clean-up when the listener cancels.
    controller.onCancel = () async {
      await _client.removeChannel(channel);
    };

    return controller.stream;
  }

  // Mapping from raw DB `tag_type` to strongly typed enum.
  static const _typeMap = <String, VideoEventType>{
    'goal': VideoEventType.goal,
    'corner': VideoEventType.corner,
    'foul': VideoEventType.foul,
  };
}