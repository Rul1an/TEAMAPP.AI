import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../models/video.dart';
import '../../controllers/video_player_controller.dart';

/// Professional video player widget with full controls and error handling
class VideoPlayerWidget extends ConsumerStatefulWidget {
  final Video video;
  final bool autoPlay;
  final bool showControls;
  final bool allowFullscreen;
  final VoidCallback? onFullscreen;
  final VoidCallback? onVideoEnd;
  final double aspectRatio;

  const VideoPlayerWidget({
    super.key,
    required this.video,
    this.autoPlay = false,
    this.showControls = true,
    this.allowFullscreen = true,
    this.onFullscreen,
    this.onVideoEnd,
    this.aspectRatio = 16 / 9,
  });

  @override
  ConsumerState<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends ConsumerState<VideoPlayerWidget> {
  @override
  void initState() {
    super.initState();

    // Initialize video player after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(videoPlayerProvider.notifier);
      notifier.initializeVideo(widget.video, autoPlay: widget.autoPlay);
    });
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reinitialize if video changes
    if (oldWidget.video.id != widget.video.id) {
      final notifier = ref.read(videoPlayerProvider.notifier);
      notifier.initializeVideo(widget.video, autoPlay: widget.autoPlay);
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(videoPlayerProvider);
    final playerNotifier = ref.read(videoPlayerProvider.notifier);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _buildPlayerContent(context, playerState, playerNotifier),
      ),
    );
  }

  Widget _buildPlayerContent(
    BuildContext context,
    VideoPlayerState state,
    VideoPlayerNotifier notifier,
  ) {
    if (state.hasError) {
      return _buildErrorWidget(state.errorMessage);
    }

    if (!state.isInitialized) {
      return _buildLoadingWidget();
    }

    return GestureDetector(
      onTap: () {
        if (widget.showControls) {
          if (state.showControls) {
            notifier.hideControls();
          } else {
            notifier.showControls();
          }
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Video player
          AspectRatio(
            aspectRatio:
                state.controller?.value.aspectRatio ?? widget.aspectRatio,
            child: VideoPlayer(state.controller!),
          ),

          // Video controls overlay
          if (widget.showControls && state.showControls)
            _buildVideoControls(context, state, notifier),

          // Buffering indicator
          if (state.isBuffering) _buildBufferingIndicator(),

          // Play button overlay (when paused and controls are hidden)
          if (!state.isPlaying && !state.showControls && !state.isBuffering)
            _buildPlayButtonOverlay(notifier),
        ],
      ),
    );
  }

  Widget _buildVideoControls(
    BuildContext context,
    VideoPlayerState state,
    VideoPlayerNotifier notifier,
  ) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.7),
              Colors.transparent,
              Colors.transparent,
              Colors.black.withValues(alpha: 0.7),
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Column(
          children: [
            // Top controls bar
            _buildTopControlsBar(context, state, notifier),

            // Center play/pause button
            Expanded(
              child: Center(
                child: _buildCenterPlayButton(state, notifier),
              ),
            ),

            // Bottom controls bar
            _buildBottomControlsBar(context, state, notifier),
          ],
        ),
      ),
    );
  }

  Widget _buildTopControlsBar(
    BuildContext context,
    VideoPlayerState state,
    VideoPlayerNotifier notifier,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Video title
          Expanded(
            child: Text(
              widget.video.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Controls lock button
          IconButton(
            icon: Icon(
              state.isControlsLocked ? Icons.lock : Icons.lock_open,
              color: Colors.white,
            ),
            onPressed: notifier.toggleControlsLock,
          ),

          // Fullscreen button
          if (widget.allowFullscreen)
            IconButton(
              icon: Icon(
                state.isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                color: Colors.white,
              ),
              onPressed: () {
                notifier.toggleFullscreen();
                widget.onFullscreen?.call();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCenterPlayButton(
    VideoPlayerState state,
    VideoPlayerNotifier notifier,
  ) {
    return GestureDetector(
      onTap: notifier.togglePlayPause,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          shape: BoxShape.circle,
        ),
        child: Icon(
          state.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildBottomControlsBar(
    BuildContext context,
    VideoPlayerState state,
    VideoPlayerNotifier notifier,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress bar
          _buildProgressBar(state, notifier),

          const SizedBox(height: 12),

          // Control buttons row
          Row(
            children: [
              // Skip backward button
              IconButton(
                icon: const Icon(Icons.replay_10, color: Colors.white),
                onPressed: () => notifier.skipBackward(seconds: 10),
              ),

              // Play/pause button
              IconButton(
                icon: Icon(
                  state.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: notifier.togglePlayPause,
              ),

              // Skip forward button
              IconButton(
                icon: const Icon(Icons.forward_10, color: Colors.white),
                onPressed: () => notifier.skipForward(seconds: 10),
              ),

              // Time display
              Expanded(
                child: Center(
                  child: Text(
                    '${state.positionFormatted} / ${state.durationFormatted}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

              // Volume/mute button
              IconButton(
                icon: Icon(
                  state.isMuted ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white,
                ),
                onPressed: notifier.toggleMute,
              ),

              // Speed control button
              _buildSpeedButton(context, state, notifier),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(
    VideoPlayerState state,
    VideoPlayerNotifier notifier,
  ) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
        activeTrackColor: Theme.of(context).primaryColor,
        inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
        thumbColor: Theme.of(context).primaryColor,
      ),
      child: Slider(
        value: state.position.inMilliseconds.toDouble(),
        max: state.duration.inMilliseconds
            .toDouble()
            .clamp(1.0, double.infinity),
        onChanged: (double value) {
          notifier.seekTo(Duration(milliseconds: value.round()));
        },
      ),
    );
  }

  Widget _buildSpeedButton(
    BuildContext context,
    VideoPlayerState state,
    VideoPlayerNotifier notifier,
  ) {
    return PopupMenuButton<VideoPlaybackSpeed>(
      icon: const Icon(Icons.speed, color: Colors.white),
      onSelected: (speed) => notifier.setPlaybackSpeed(speed.value),
      itemBuilder: (context) => VideoPlaybackSpeed.values
          .map((speed) => PopupMenuItem(
                value: speed,
                child: Row(
                  children: [
                    Text(speed.label),
                    if (state.playbackSpeed == speed.value)
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(Icons.check, size: 16),
                      ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildPlayButtonOverlay(VideoPlayerNotifier notifier) {
    return GestureDetector(
      onTap: notifier.play,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.play_arrow,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.white),
          const SizedBox(height: 16),
          Text(
            'Loading ${widget.video.title}...',
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Duration: ${widget.video.durationFormatted} • ${widget.video.fileSizeFormatted}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String? error) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.white, size: 48),
          const SizedBox(height: 16),
          const Text(
            'Error playing video',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            error ?? 'Unknown error occurred',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              final notifier = ref.read(videoPlayerProvider.notifier);
              notifier.initializeVideo(widget.video);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.red[900],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBufferingIndicator() {
    return const ColoredBox(
      color: Colors.black26,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 8),
            Text(
              'Buffering...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact video player for previews and thumbnails
class CompactVideoPlayer extends ConsumerWidget {
  final Video video;
  final double height;
  final bool autoPlay;
  final VoidCallback? onTap;

  const CompactVideoPlayer({
    super.key,
    required this.video,
    this.height = 120,
    this.autoPlay = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
          image: video.thumbnailUrl != null
              ? DecorationImage(
                  image: NetworkImage(video.thumbnailUrl!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Stack(
          children: [
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),

            // Play button
            const Center(
              child: Icon(
                Icons.play_circle_filled,
                color: Colors.white,
                size: 48,
              ),
            ),

            // Video info
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    video.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        video.durationFormatted,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(video.processingStatus),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          video.processingStatus.displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(VideoProcessingStatus status) {
    switch (status) {
      case VideoProcessingStatus.ready:
        return Colors.green;
      case VideoProcessingStatus.processing:
        return Colors.orange;
      case VideoProcessingStatus.error:
        return Colors.red;
      case VideoProcessingStatus.pending:
        return Colors.blue;
      case VideoProcessingStatus.archived:
        return Colors.grey;
    }
  }
}
