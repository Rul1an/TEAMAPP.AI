import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../services/smart_playlist_service.dart';
import '../core/result.dart';

/// Riverpod provider that exposes a [SmartPlaylistService] instance.
final smartPlaylistServiceProvider = Provider<SmartPlaylistService>((ref) {
  return const SmartPlaylistService();
});

final smartPlaylistResultProvider = FutureProvider<Result<void>>((ref) async {
  final service = ref.watch(smartPlaylistServiceProvider);
  return service.generateSmartPlaylist();
});