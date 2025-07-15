import 'dart:io' as io;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/video_upload_manager.dart';

/// Possible states for the video upload flow.
enum VideoUploadStatus {
  idle,
  selecting,
  compressing,
  uploading,
  success,
  error,
}

class VideoUploadState {
  const VideoUploadState({
    required this.status,
    this.progress = 0,
    this.message,
  });

  final VideoUploadStatus status;
  final double progress; // 0-1, only relevant in uploading state
  final String? message;

  VideoUploadState copyWith({
    VideoUploadStatus? status,
    double? progress,
    String? message,
  }) {
    return VideoUploadState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      message: message ?? this.message,
    );
  }
}

class VideoUploadNotifier extends StateNotifier<VideoUploadState> {
  VideoUploadNotifier(this._manager) : super(const VideoUploadState(status: VideoUploadStatus.idle));

  final VideoUploadManager _manager;

  /// Uploads the provided [file] via [_manager]. Intended for unit tests.
  Future<void> upload(io.File file) async {
    try {
      state = state.copyWith(status: VideoUploadStatus.compressing, progress: 0);
      final url = await _manager.compressAndUpload(file, onProgress: (pct) {
        state = state.copyWith(status: VideoUploadStatus.uploading, progress: pct);
      });
      state = state.copyWith(status: VideoUploadStatus.success, progress: 1, message: url);
    } catch (e) {
      state = state.copyWith(status: VideoUploadStatus.error, message: e.toString());
    }
  }

  void startSelecting() {
    state = state.copyWith(status: VideoUploadStatus.selecting);
  }
}

final videoUploadProvider = StateNotifierProvider<VideoUploadNotifier, VideoUploadState>((ref) {
  final manager = VideoUploadManager();
  return VideoUploadNotifier(manager);
});