import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../models/video_tag.dart';
import '../../core/result.dart';
import 'video_tag_timeline.dart';
import 'video_tag_creation_dialog.dart';

/// Enhanced video player with tag integration and custom controls
/// Implements Phase 3A: Video Player Foundation
class EnhancedVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final List<VideoTag> tags;
  final void Function(Duration) onTagTimelineSeek;
  final void Function(VideoTag) onTagCreated;
  final void Function(String) onError;

  const EnhancedVideoPlayer({
    Key? key,
    required this.videoUrl,
    required this.tags,
    required this.onTagTimelineSeek,
    required this.onTagCreated,
    required this.onError,
  }) : super(key: key);

  @override
  State<EnhancedVideoPlayer> createState() => _EnhancedVideoPlayerState();
}

class _EnhancedVideoPlayerState extends State<EnhancedVideoPlayer> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _isLoading = true;
  String? _errorMessage;
  Duration _currentPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _chewieController?.dispose();
    _controller?.dispose();
  }

  Future<void> _initializePlayer() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Validate video URL
      final urlValidation = _validateVideoUrl(widget.videoUrl);
      if (urlValidation.isFailure) {
        throw Exception('Invalid video URL');
      }

      // Initialize video player controller
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

      // Add position listener for timeline updates
      _controller!.addListener(_onVideoPositionChanged);

      await _controller!.initialize();

      if (!mounted) return;

      // Initialize Chewie controller with custom options
      _chewieController = ChewieController(
        videoPlayerController: _controller!,
        aspectRatio: _controller!.value.aspectRatio,
        autoPlay: false,
        looping: false,
        allowMuting: true,
        allowFullScreen: true,
        allowPlaybackSpeedChanging: true,
        showControlsOnInitialize: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: Theme.of(context).primaryColor,
          handleColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.grey[300]!,
          bufferedColor: Colors.grey[400]!,
        ),
        additionalOptions: (context) => [
          OptionItem(
            onTap: (context) => _showTagCreationDialog(),
            iconData: Icons.add_circle,
            title: 'Add Tag',
          ),
          OptionItem(
            onTap: (context) => _showTagList(),
            iconData: Icons.list,
            title: 'View Tags',
          ),
        ],
      );

      setState(() {
        _isInitialized = true;
        _isLoading = false;
      });

      debugPrint('✅ Video player initialized successfully');
    } catch (e) {
      debugPrint('❌ Video player initialization failed: $e');

      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });

      widget.onError('Failed to load video: $e');
    }
  }

  void _onVideoPositionChanged() {
    if (_controller?.value.isInitialized ?? false) {
      setState(() {
        _currentPosition = _controller!.value.position;
      });
    }
  }

  Result<String> _validateVideoUrl(String url) {
    if (url.isEmpty) {
      return Result.failure(Exception('Video URL cannot be empty'));
    }

    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) {
      return Result.failure(Exception('Invalid video URL format'));
    }

    final allowedSchemes = ['http', 'https', 'file'];
    if (!allowedSchemes.contains(uri.scheme)) {
      return Result.failure(Exception('Unsupported URL scheme: ${uri.scheme}'));
    }

    return Result.success(url);
  }

  void _showTagCreationDialog() {
    if (_controller?.value.isInitialized != true) {
      _showSnackBar('Video must be loaded before creating tags');
      return;
    }

    showDialog<void>(
      context: context,
      builder: (context) => VideoTagCreationDialog(
        currentTimestamp: _currentPosition,
        onTagCreated: (tag) {
          widget.onTagCreated(tag);
          Navigator.of(context).pop();
          _showSnackBar('Tag created successfully');
        },
      ),
    );
  }

  void _showTagList() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Video Tags (${widget.tags.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (widget.tags.isEmpty)
              const Center(
                child: Text('No tags created yet'),
              )
            else
              ...widget.tags.map((tag) => ListTile(
                    leading: Icon(
                      _getTagIcon(tag.tagType),
                      color: _getTagColor(tag.tagType),
                    ),
                    title: Text(tag.description ?? 'Untitled tag'),
                    subtitle: Text(_formatDuration(
                        Duration(seconds: tag.timestampSeconds.toInt()))),
                    onTap: () {
                      Navigator.of(context).pop();
                      _seekToTag(tag);
                    },
                  )),
          ],
        ),
      ),
    );
  }

  void _seekToTag(VideoTag tag) {
    final position = Duration(seconds: tag.timestampSeconds.toInt());
    _controller?.seekTo(position);
    widget.onTagTimelineSeek(position);
    _showSnackBar('Jumped to ${tag.description ?? 'tag'}');
  }

  void _showSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  IconData _getTagIcon(VideoTagType tagType) {
    switch (tagType) {
      case VideoTagType.drill:
        return Icons.sports_soccer;
      case VideoTagType.moment:
        return Icons.star;
      case VideoTagType.player:
        return Icons.person;
      case VideoTagType.tactic:
        return Icons.analytics;
      case VideoTagType.mistake:
        return Icons.warning;
      case VideoTagType.skill:
        return Icons.star_border;
    }
  }

  Color _getTagColor(VideoTagType tagType) {
    switch (tagType) {
      case VideoTagType.drill:
        return Colors.green;
      case VideoTagType.moment:
        return Colors.orange;
      case VideoTagType.player:
        return Colors.blue;
      case VideoTagType.tactic:
        return Colors.purple;
      case VideoTagType.mistake:
        return Colors.red;
      case VideoTagType.skill:
        return Colors.cyan;
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Widget _buildLoadingState() {
    return Container(
      height: 200,
      color: Colors.black12,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading video...'),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      height: 200,
      color: Colors.red[50],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              size: 48,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Failed to load video',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red[700]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initializePlayer,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Column(
      children: [
        // Video player
        AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: Chewie(controller: _chewieController!),
        ),

        // Tag timeline
        VideoTagTimeline(
          tags: widget.tags,
          duration: _controller!.value.duration,
          currentPosition: _currentPosition,
          onSeek: (position) {
            _controller!.seekTo(position);
            widget.onTagTimelineSeek(position);
          },
          onTagTap: _seekToTag,
        ),

        // Quick actions
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: _showTagCreationDialog,
                icon: const Icon(Icons.add_circle),
                tooltip: 'Add Tag',
              ),
              IconButton(
                onPressed: _showTagList,
                icon: const Icon(Icons.list),
                tooltip: 'View Tags',
              ),
              IconButton(
                onPressed: () {
                  if (_controller?.value.isPlaying ?? false) {
                    _controller?.pause();
                  } else {
                    _controller?.play();
                  }
                },
                icon: Icon(
                  _controller?.value.isPlaying ?? false
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
                tooltip:
                    _controller?.value.isPlaying ?? false ? 'Pause' : 'Play',
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (!_isInitialized || _controller == null || _chewieController == null) {
      return _buildLoadingState();
    }

    return _buildVideoPlayer();
  }
}
