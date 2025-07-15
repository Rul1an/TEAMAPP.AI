import 'dart:io' as io;
// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../repositories/video_repository.dart';
import '../../models/video.dart';
import '../../providers/video_provider.dart';

/// FAB-style button that opens a file picker and uploads a video via [VideoRepository].
class VideoUploadButton extends ConsumerStatefulWidget {
  const VideoUploadButton({super.key, this.onUploaded});

  final void Function(Video)? onUploaded;

  @override
  ConsumerState<VideoUploadButton> createState() => _VideoUploadButtonState();
}

class _VideoUploadButtonState extends ConsumerState<VideoUploadButton> {
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: _isUploading ? null : _pickAndUpload,
      icon: _isUploading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.file_upload),
      label: Text(_isUploading ? 'Uploaden…' : 'Video uploaden'),
    );
  }

  Future<void> _pickAndUpload() async {
    setState(() => _isUploading = true);

    try {
      final res = await FilePicker.platform.pickFiles(type: FileType.video);
      if (res == null || res.files.single.path == null) return;
      final filePath = res.files.single.path!;
      final extension = filePath.split('.').last.toLowerCase();
      const supported = ['mp4', 'mov', 'mkv', 'webm'];
      if (!supported.contains(extension)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Niet-ondersteund videoformaat. Alleen MP4/MOV/MKV/WebM.')),
        );
        return;
      }
      final file = io.File(filePath);

      final repo = ref.read(videoRepositoryProvider);
      final result = await repo.upload(file: file, title: res.files.single.name);
      result.when(
        success: (video) {
          widget.onUploaded?.call(video);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Video geüpload!')),
          );
        },
        failure: (err) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload mislukt: ${err.message}')),
          );
        },
      );
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }
}