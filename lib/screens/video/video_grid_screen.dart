// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import '../../providers/video_provider.dart';
import '../../widgets/video/video_card.dart';
import '../../widgets/video/video_upload_button.dart';

class VideoGridScreen extends ConsumerWidget {
  const VideoGridScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFanFlavor = const String.fromEnvironment('FLAVOR') == 'fan_family';
    final videosAsync = ref.watch(videosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Video’s')),
      floatingActionButton: const VideoUploadButton(),
      body: videosAsync.when(
        data: (videos) {
          final filtered = isFanFlavor
              ? videos.where((v) => v.visibility == VideoVisibility.publicHighlight).toList()
              : videos;
          return Padding(
            padding: const EdgeInsets.all(8),
            child: GridView.builder(
              itemCount: filtered.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 16 / 10,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final v = filtered[index];
                return VideoCard(
                  video: v,
                  onTap: () => context.push('/videos/${v.id}'),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(
          child: Text('Fout bij laden: $err'),
        ),
      ),
    );
  }
}