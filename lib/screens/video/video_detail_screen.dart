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
import '../../providers/auth_provider.dart';
import '../../services/permission_service.dart';

class VideoDetailScreen extends ConsumerStatefulWidget {
  const VideoDetailScreen({super.key, required this.videoId});

  final String videoId;

  @override
  ConsumerState<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends ConsumerState<VideoDetailScreen> {
  ChewieController? _chewieController;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _error = null;
    });
    try {
      final repo = ref.read(videoRepositoryProvider);
      final res = await repo.getById(widget.videoId);
      final video = res.dataOrNull;
      if (video == null) {
        throw Exception('Video niet gevonden');
      }
      final controller = VideoPlayerController.networkUrl(Uri.parse(video.videoUrl));
      await controller.initialize();

      _chewieController?.dispose();
      _chewieController = ChewieController(
        videoPlayerController: controller,
        autoPlay: true,
        looping: false,
        allowMuting: true,
        allowFullScreen: true,
      );
      if (mounted) setState(() {});
    } catch (e) {
      setState(() => _error = e);
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_error != null) {
      body = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error, size: 48, color: Colors.red),
            const SizedBox(height: 8),
            Text(_error.toString()),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _load,
              child: const Text('Opnieuw proberen'),
            ),
          ],
        ),
      );
    } else if (_chewieController == null) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = Chewie(controller: _chewieController!);
    }

    final userRole = ref.watch(userRoleProvider);
    final canManage = PermissionService.canManageVideos(userRole);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video'),
        actions: [
          if (canManage && _chewieController != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: body,
    );
  }

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Video verwijderen?'),
        content: const Text('Deze actie kan niet ongedaan worden gemaakt.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuleren')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Verwijderen')),
        ],
      ),
    );
    if (confirm != true) return;
    final repo = ref.read(videoRepositoryProvider);
    final res = await repo.getById(widget.videoId);
    final video = res.dataOrNull;
    if (video == null) return;
    final delRes = await repo.delete(video);
    delRes.when(
      success: (_) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Video verwijderd.')),
          );
        }
      },
      failure: (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verwijderen mislukt: ${err.message}')),
        );
      },
    );
  }
}