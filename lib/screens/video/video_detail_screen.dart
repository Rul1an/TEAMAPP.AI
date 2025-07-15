// Dart imports:
// (none)

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:chewie/chewie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

// Project imports:
import '../../providers/video_provider.dart';

class VideoDetailScreen extends ConsumerStatefulWidget {
  const VideoDetailScreen({super.key, required this.videoId});

  final String videoId;

  @override
  ConsumerState<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends ConsumerState<VideoDetailScreen> {
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(videoRepositoryProvider);
    final res = await repo.getById(widget.videoId);
    final video = res.dataOrNull;
    if (video == null) return;
    final controller = VideoPlayerController.networkUrl(Uri.parse(video.videoUrl));
    await controller.initialize();

    _chewieController = ChewieController(
      videoPlayerController: controller,
      autoPlay: true,
      looping: false,
      allowMuting: true,
      allowFullScreen: true,
    );
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video')), // might show title later
      body: _chewieController == null
          ? const Center(child: CircularProgressIndicator())
          : Chewie(controller: _chewieController!),
    );
  }
}