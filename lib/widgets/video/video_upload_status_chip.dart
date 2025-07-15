import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/video_upload_provider.dart';

class VideoUploadStatusChip extends ConsumerWidget {
  const VideoUploadStatusChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(videoUploadProvider);

    Color background;
    String label;

    switch (state.status) {
      case VideoUploadStatus.idle:
        background = Colors.grey.shade400;
        label = 'Idle';
        break;
      case VideoUploadStatus.selecting:
        background = Colors.blueGrey;
        label = 'Bestand kiezen…';
        break;
      case VideoUploadStatus.compressing:
        background = Colors.orange;
        label = 'Comprimeren…';
        break;
      case VideoUploadStatus.uploading:
        background = Colors.blue;
        label = 'Uploaden ${(_pct(state.progress) * 100).toStringAsFixed(0)}%';
        break;
      case VideoUploadStatus.success:
        background = Colors.green;
        label = 'Voltooid';
        break;
      case VideoUploadStatus.error:
        background = Colors.red;
        label = 'Fout';
        break;
    }

    return Chip(
      label: Text(label),
      backgroundColor: background,
      labelStyle: const TextStyle(color: Colors.white),
    );
  }

  double _pct(double value) => value.clamp(0, 1);
}