import 'dart:convert';

// Package imports:
import 'package:hive_flutter/hive_flutter.dart';

// Project imports:
import 'hive_key_manager.dart';
import '../models/video_event.dart';

/// Caches the list of [VideoEvent]s per match in an encrypted Hive box so that
/// the AnalysisDashboard can work completely offline when needed.
class VideoEventCache {
  const VideoEventCache();

  String _boxName(String matchId) => 'video_events_$matchId';
  static const _kValueKey = 'events_json';

  Future<Box<String>> _openBox(String matchId) async {
    final name = _boxName(matchId);
    if (!Hive.isBoxOpen(name)) {
      final key = await HiveKeyManager().getKey();
      await Hive.initFlutter();
      return Hive.openBox<String>(name, encryptionCipher: HiveAesCipher(key));
    }
    return Hive.box<String>(name);
  }

  Future<List<VideoEvent>> read(String matchId) async {
    final box = await _openBox(matchId);
    final raw = box.get(_kValueKey);
    if (raw == null) return [];

    final list = (jsonDecode(raw) as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(VideoEvent.fromJson)
        .toList();
    return list;
  }

  Future<void> write(String matchId, List<VideoEvent> events) async {
    final box = await _openBox(matchId);
    final jsonStr = jsonEncode(events.map((e) => e.toJson()).toList());
    await box.put(_kValueKey, jsonStr);
  }

  /// Clears cached events for a match (used in tests or hard refresh).
  Future<void> clear(String matchId) async {
    final box = await _openBox(matchId);
    await box.delete(_kValueKey);
  }
}