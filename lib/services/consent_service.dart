// User consent management: persist locally (Hive) and propagate to Supabase user metadata when authenticated.

import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';

class ConsentService {
  static const String _boxName = 'consent';
  static const String _flagsKey = 'flags';

  /// Default consent flags (all disabled until opt-in)
  static const Map<String, bool> defaultFlags = {
    'analytics': false,
    'performance': false,
    'marketing': false,
  };

  /// Get current consent flags; returns defaults if none stored.
  Future<Map<String, bool>> getConsent() async {
    final box = await _openBox();
    final Map<String, bool>? stored = box.get(_flagsKey);
    if (stored == null) return Map<String, bool>.from(defaultFlags);
    return Map<String, bool>.from(stored);
  }

  /// Update consent flags locally and, if authenticated, in Supabase user metadata.
  Future<void> setConsent(Map<String, bool> flags) async {
    final sanitized = Map<String, bool>.from(defaultFlags)..addAll(flags);
    final box = await _openBox();
    await box.put(_flagsKey, sanitized);

    // Propagate to Supabase user metadata when logged in
    final client = SupabaseConfig.clientOrNull;
    final user = client?.auth.currentUser;
    if (client != null && user != null) {
      await client.auth.updateUser(
        UserAttributes(
          data: {
            ...user.userMetadata ?? {},
            'consent': sanitized,
          },
        ),
      );
      await client.auth.refreshSession();
    }
  }

  Future<Box<Map<String, bool>>> _openBox() async {
    try {
      // Ensure Hive is initialized on web/mobile before opening
      await Hive.initFlutter();
    } catch (_) {
      // Safe to ignore if already initialized or not needed on this platform
    }
    if (!Hive.isBoxOpen(_boxName)) {
      return Hive.openBox<Map<String, bool>>(_boxName);
    }
    return Hive.box<Map<String, bool>>(_boxName);
  }
}
