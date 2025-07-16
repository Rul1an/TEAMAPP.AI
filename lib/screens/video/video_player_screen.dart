import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({
    required this.url,
    required this.title,
    required this.path,
    super.key,
  });

  final String url;
  final String title;
  final String path; // storage path to refresh signed URL

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  Timer? _refreshTimer;

  Future<void> _refreshSignedUrl() async {
    try {
      final fnRes = await Supabase.instance.client.functions.invoke(
        'video_signedurl_refresh',
        body: {'path': widget.path},
      );
      final newUrl = (fnRes.data as Map<String, dynamic>)['signedUrl'] as String?;
      if (newUrl != null) {
        await _videoController.pause();
        await _videoController.dispose();
        _videoController = VideoPlayerController.networkUrl(Uri.parse(newUrl));
        await _videoController.initialize();
        setState(() {});
      }
    } catch (e) {
      debugPrint('Signed URL refresh failed: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _videoController.initialize().then((_) {
      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: true,
        looping: false,
        allowMuting: true,
        allowPlaybackSpeedChanging: true,
      );
      // Schedule refresh 23h55m later
      _refreshTimer = Timer(const Duration(hours: 23, minutes: 55), _refreshSignedUrl);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(controller: _chewieController!)
            : const CircularProgressIndicator(),
      ),
    );
  }
}