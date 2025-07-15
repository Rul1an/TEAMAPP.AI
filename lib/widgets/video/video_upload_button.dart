import 'dart:io' as io;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/video_upload_provider.dart';

class VideoUploadButton extends ConsumerWidget {
  const VideoUploadButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(videoUploadProvider.notifier);

    return ElevatedButton.icon(
      icon: const Icon(Icons.upload_file),
      label: const Text('Upload video'),
      onPressed: () async {
        notifier.startSelecting();
        final result = await FilePicker.platform.pickFiles(type: FileType.video);
        if (result == null || result.files.isEmpty) {
          // No file selected; reset to idle
          // (Could introduce a dedicated method, for now we set idle directly)
          notifier.state = notifier.state.copyWith(status: VideoUploadStatus.idle);
          return;
        }
        final path = result.files.single.path;
        if (path == null) return;
        final file = io.File(path);
        await notifier.upload(file);
      },
    );
  }
}