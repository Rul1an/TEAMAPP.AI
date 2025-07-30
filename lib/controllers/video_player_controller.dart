import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/video.dart';
import '../repositories/video_repository.dart';

part 'video_player_controller.g.dart';

/// Riverpod provider for video player functionality
@riverpod
class VideoPlayerNotifier extends _$VideoPlayerNotifier {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  VideoPlayerState build() {
    return const VideoPlayerState(
      isInitialized: false,
      isPlaying: false,
      isBuffering: false,
      hasError: false,
      errorMessage: null,
      position: Duration.zero,
      duration: Duration.zero,
      volume: 1.0,
      playbackSpeed: 1.0,
      showControls: true,
      isControlsLocked: false,
      isMuted: false,
      isFullscreen: false,
    );
  }

  /// Initialize video player with a video URL
  Future<void> initializeVideo(String videoUrl) async {
    try {
      // Dispose existing controller if any
      await dispose();

      _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));

      state = state.copyWith(isBuffering: true);

      await _controller!.initialize();

      _isInitialized = true;

      state = state.copyWith(
        isInitialized: true,
        isBuffering: false,
        duration: _controller!.value.duration,
        hasError: false,
        errorMessage: null,
      );

      // Listen to controller changes
      _controller!.addListener(_onVideoPlayerChange);

    } catch (e) {
      state = state.copyWith(
        hasError: true,
        errorMessage: 'Failed to initialize video: $e',
        isBuffering: false,
      );
    }
  }

  /// Play video
  Future<void> play() async {
    if (_controller != null && _isInitialized) {
      await _controller!.play();
      state = state.copyWith(isPlaying: true);
    }
  }

  /// Pause video
  Future<void> pause() async {
    if (_controller != null && _isInitialized) {
      await _controller!.pause();
      state = state.copyWith(isPlaying: false);
    }
  }

  /// Toggle play/pause
  Future<void> togglePlayPause() async {
    if (state.isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  /// Seek to specific position
  Future<void> seekTo(Duration position) async {
    if (_controller != null && _isInitialized) {
      await _controller!.seekTo(position);
      state = state.copyWith(position: position);
    }
  }

  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    if (_controller != null && _isInitialized) {
      await _controller!.setVolume(volume);
      state = state.copyWith(
        volume: volume,
        isMuted: volume == 0.0,
      );
    }
  }

  /// Toggle mute
  Future<void> toggleMute() async {
    final newVolume = state.isMuted ? 1.0 : 0.0;
    await setVolume(newVolume);
  }

  /// Set playback speed
  Future<void> setPlaybackSpeed(double speed) async {
    if (_controller != null && _isInitialized) {
      await _controller!.setPlaybackSpeed(speed);
      state = state.copyWith(playbackSpeed: speed);
    }
  }

  /// Toggle controls visibility
  void toggleControls() {
    state = state.copyWith(showControls: !state.showControls);
  }

  /// Lock/unlock controls
  void toggleControlsLock() {
    state = state.copyWith(isControlsLocked: !state.isControlsLocked);
  }

  /// Toggle fullscreen mode
  void toggleFullscreen() {
    state = state.copyWith(isFullscreen: !state.isFullscreen);
  }

  /// Get current video controller
  VideoPlayerController? get controller => _controller;

  /// Check if video is ready for playback
  bool get isReady => _isInitialized && _controller != null;

  /// Get current progress as percentage (0.0 to 1.0)
  double get progress {
    if (!isReady || state.duration == Duration.zero) return 0.0;
    return state.position.inMilliseconds / state.duration.inMilliseconds;
  }

  /// Get formatted time string for position
  String get positionText => _formatDuration(state.position);

  /// Get formatted time string for duration
  String get durationText => _formatDuration(state.duration);

  /// Get remaining time
  String get remainingTimeText {
    final remaining = state.duration - state.position;
    return '-${_formatDuration(remaining)}';
  }

  /// Format duration as MM:SS or HH:MM:SS
  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// Handle video player controller changes
  void _onVideoPlayerChange() {
    if (_controller == null || !mounted) return;

    final value = _controller!.value;

    state = state.copyWith(
      position: value.position,
      isBuffering: value.isBuffering,
      hasError: value.hasError,
      errorMessage: value.hasError ? value.errorDescription : null,
    );
  }

  /// Dispose video controller
  Future<void> dispose() async {
    _controller?.removeListener(_onVideoPlayerChange);
    await _controller?.dispose();
    _controller = null;
    _isInitialized = false;
  }
}

/// Video player state data class
class VideoPlayerState {
  const VideoPlayerState({
    required this.isInitialized,
    required this.isPlaying,
    required this.isBuffering,
    required this.hasError,
    this.errorMessage,
    required this.position,
    required this.duration,
    required this.volume,
    required this.playbackSpeed,
    required this.showControls,
    required this.isControlsLocked,
    required this.isMuted,
    required this.isFullscreen,
  });

  final bool isInitialized;
  final bool isPlaying;
  final bool isBuffering;
  final bool hasError;
  final String? errorMessage;
  final Duration position;
  final Duration duration;
  final double volume;
  final double playbackSpeed;
  final bool showControls;
  final bool isControlsLocked;
  final bool isMuted;
  final bool isFullscreen;

  VideoPlayerState copyWith({
    bool? isInitialized,
    bool? isPlaying,
    bool? isBuffering,
    bool? hasError,
    String? errorMessage,
    Duration? position,
    Duration? duration,
    double? volume,
    double? playbackSpeed,
    bool? showControls,
    bool? isControlsLocked,
    bool? isMuted,
    bool? isFullscreen,
  }) {
    return VideoPlayerState(
      isInitialized: isInitialized ?? this.isInitialized,
      isPlaying: isPlaying ?? this.isPlaying,
      isBuffering: isBuffering ?? this.isBuffering,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      volume: volume ?? this.volume,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      showControls: showControls ?? this.showControls,
      isControlsLocked: isControlsLocked ?? this.isControlsLocked,
      isMuted: isMuted ?? this.isMuted,
      isFullscreen: isFullscreen ?? this.isFullscreen,
    );
  }
}

/// Extension methods for VideoPlayerState
extension VideoPlayerStateExtensions on VideoPlayerState {
  /// Check if video can be played
  bool get canPlay => isInitialized && !hasError;

  /// Check if video is loaded and ready
  bool get isReady => isInitialized && duration > Duration.zero;

  /// Get progress as percentage (0.0 to 1.0)
  double get progress {
    if (duration == Duration.zero) return 0.0;
    return position.inMilliseconds / duration.inMilliseconds;
  }

  /// Get remaining time
  Duration get remainingTime => duration - position;
}

/// Error types for video player
sealed class VideoPlayerError implements Exception {
  const VideoPlayerError(this.message);
  final String message;

  @override
  String toString() => 'VideoPlayerError: $message';
}

class VideoInitializationError extends VideoPlayerError {
  const VideoInitializationError(super.message);
}

class VideoPlaybackError extends VideoPlayerError {
  const VideoPlaybackError(super.message);
}

class VideoNetworkError extends VideoPlayerError {
  const VideoNetworkError(super.message);
}
