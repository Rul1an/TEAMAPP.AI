// ignore_for_file: avoid_print

// Dart imports:
import 'dart:async';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:jo17_tactical_manager/models/video_playlist.dart';
import 'package:jo17_tactical_manager/services/smart_playlist_service.dart';
import 'package:jo17_tactical_manager/core/result.dart';

class _MockRpc extends Mock {
  Future<dynamic> call(String fn, [Map<String, dynamic>? params]);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SmartPlaylistService', () {
    late _MockRpc rpc;
    late SmartPlaylistService service;

    setUp(() {
      rpc = _MockRpc();
      service = SmartPlaylistService(rpc: rpc);
    });

    test('generates playlist within SLA', () async {
      // Arrange – fake RPC returns immediately
      when(() => rpc('generate_playlist_by_pattern', any())).thenAnswer(
        (_) async => {
          'id': 'pl_1',
          'pattern': 'high_press',
          'clips': [
            {
              'id': 'clip_1',
              'start_ms': 10000,
              'end_ms': 12000,
            },
          ],
        },
      );

      final sw = Stopwatch()..start();

      // Act
      final result = await service.generatePlaylist(
        matchId: 'match_1',
        pattern: TacticalPattern.highPress,
      );

      final elapsed = sw.elapsedMilliseconds;

      // Assert
      expect(result.isSuccess, isTrue);
      expect(elapsed < 200, isTrue, reason: 'SLA 200 ms violated');
    });

    test('returns Failure on rpc error', () async {
      when(() => rpc('generate_playlist_by_pattern', any()))
          .thenThrow(Exception('db-timeout'));

      final result = await service.generatePlaylist(
        matchId: 'match_1',
        pattern: TacticalPattern.highPress,
      );

      expect(result.isSuccess, isFalse);
      expect(result.errorOrNull, isA<PlaylistGenerationFailure>());
    });
  });
}