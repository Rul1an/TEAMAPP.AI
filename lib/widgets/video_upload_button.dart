import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class VideoUploadButton extends StatelessWidget {
  const VideoUploadButton({
    required this.onFilesSelected,
    super.key,
  });

  final void Function(List<File>) onFilesSelected;

  Future<void> _pickVideos(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: true,
    );
    if (result != null && result.files.isNotEmpty) {
      final files = result.paths
          .whereType<String>()
          .map((p) => File(p))
          .toList(growable: false);
      if (files.isNotEmpty) onFilesSelected(files);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _pickVideos(context),
      icon: const Icon(Icons.upload_file),
      label: const Text('Upload Video'),
    );
  }
}