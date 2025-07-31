import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../models/video.dart';
import '../../models/video_tag.dart';
import '../../services/performance_monitor.dart';

/// Enhanced video player with tag timeline integration
///
/// Replaces placeholder implementation with actual video playback
/// Following Video Production Readiness Plan 2025 - Phase 3B
class EnhancedVideoPlayer extends StatefulWidget {
  final Video video;
  final List<VideoTag> tags;
  final void Function(Duration)? onSeek;
  final void Function(VideoTag)? onTagSelected;
  final VoidCallback? onAddTag;

  const EnhancedVideoPlayer({
    Key? key,
    required this.video,
    this.tags = const [],
    this.onSeek,
    this.onTagSelected,
    this.onAddTag,
  }) : super(key: key);

  @override
  State<EnhancedVideoPlayer> createState() => _EnhancedVideoPlayerState();
}

class _EnhancedVideoPlayerState extends State<EnhancedVideoPlayer> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> _initializePlayer() async {
    final performanceMonitor = PerformanceMonitor();
    performanceMonitor.startTimer('video_load');

    try {
      // Validate video URL
      final videoUrl = widget.video.fileUrl;
      if (videoUrl.isEmpty) {
        throw Exception('Video URL is empty');
      }

      // Initialize video player controller
      _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));

      // Add error listener
      _controller!.addListener(_onVideoError);

      // Initialize controller
      await _controller!.initialize();

      // Setup Chewie controller for enhanced UI
      _chewieController = ChewieController(
        videoPlayerController: _controller!,
        aspectRatio: _controller!.value.aspectRatio,
        autoPlay: false,
        looping: false,
        allowMuting: true,
        allowFullScreen: true,
        allowPlaybackSpeedChanging: true,
        showControlsOnInitialize: false,
        placeholder: const ColoredBox(
          color: Colors.black,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorBuilder: (context, errorMessage) {
          return ColoredBox(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Video Error',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    errorMessage,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      );

      performanceMonitor.endTimer('video_load');

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _hasError = false;
        });
      }
    } catch (e) {
      performanceMonitor.endTimer('video_load');

      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = e.toString();
        });
      }

      debugPrint('Video initialization error: $e');
    }
  }

  void _onVideoError() {
    if (_controller?.value.hasError ?? false) {
      final error = _controller?.value.errorDescription;
      setState(() {
        _hasError = true;
        _errorMessage = error ?? 'Unknown video error';
      });
    }
  }

  void _seekToTag(VideoTag tag) {
    if (_controller != null && _isInitialized) {
      final position = Duration(seconds: tag.timestampSeconds.toInt());
      _controller!.seekTo(position);
      widget.onTagSelected?.call(tag);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildErrorState();
    }

    if (!_isInitialized) {
      return _buildLoadingState();
    }

    return Column(
      children: [
        // Video player
        AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: Stack(
            children: [
              Chewie(controller: _chewieController!),

              // Add tag button overlay
              if (widget.onAddTag != null)
                Positioned(
                  top: 16,
                  right: 16,
                  child: FloatingActionButton(
                    mini: true,
                    onPressed: widget.onAddTag,
                    backgroundColor: Colors.blue.withValues(alpha: 0.8),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),

        // Tag timeline
        if (widget.tags.isNotEmpty)
          _VideoTagTimeline(
            tags: widget.tags,
            duration: _controller!.value.duration,
            controller: _controller!,
            onTagSelected: _seekToTag,
            onSeek: widget.onSeek,
          ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 200,
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Loading video...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      height: 200,
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load video',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Unknown error',
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _hasError = false;
                  _isInitialized = false;
                });
                _initializePlayer();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Video tag timeline widget showing tag positions and allowing navigation
class _VideoTagTimeline extends StatefulWidget {
  final List<VideoTag> tags;
  final Duration duration;
  final VideoPlayerController controller;
  final void Function(VideoTag) onTagSelected;
  final void Function(Duration)? onSeek;

  const _VideoTagTimeline({
    required this.tags,
    required this.duration,
    required this.controller,
    required this.onTagSelected,
    this.onSeek,
  });

  @override
  State<_VideoTagTimeline> createState() => _VideoTagTimelineState();
}

class _VideoTagTimelineState extends State<_VideoTagTimeline> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onVideoPositionChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onVideoPositionChanged);
    super.dispose();
  }

  void _onVideoPositionChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Color _getTagColor(VideoTag tag) {
    return Color(tag.tagColor);
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final currentPosition = widget.controller.value.position;
    final progress = widget.duration.inMilliseconds > 0
        ? currentPosition.inMilliseconds / widget.duration.inMilliseconds
        : 0.0;

    return Container(
      height: 80,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Progress bar with tag indicators
          SizedBox(
            height: 20,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    // Background progress bar
                    Container(
                      width: constraints.maxWidth,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Current progress
                    Container(
                      width: constraints.maxWidth * progress,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Tag hotspots
                    ...widget.tags.map((tag) {
                      final tagProgress = widget.duration.inSeconds > 0
                          ? tag.timestampSeconds / widget.duration.inSeconds
                          : 0.0;

                      return Positioned(
                        left: (constraints.maxWidth * tagProgress) - 6,
                        top: -4,
                        child: GestureDetector(
                          onTap: () => widget.onTagSelected(tag),
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _getTagColor(tag),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),

                    // Seek interaction overlay
                    Positioned.fill(
                      child: GestureDetector(
                        onTapDown: (details) {
                          final percentage =
                              details.localPosition.dx / constraints.maxWidth;
                          final newPosition = Duration(
                            milliseconds:
                                (widget.duration.inMilliseconds * percentage)
                                    .round(),
                          );
                          widget.controller.seekTo(newPosition);
                          widget.onSeek?.call(newPosition);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Time display
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(currentPosition),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '${widget.tags.length} tags',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              Text(
                _formatDuration(widget.duration),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
