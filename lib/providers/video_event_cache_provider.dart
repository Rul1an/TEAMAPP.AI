import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../hive/video_event_cache.dart';

final videoEventCacheProvider = Provider<VideoEventCache>((ref) {
  return const VideoEventCache();
});