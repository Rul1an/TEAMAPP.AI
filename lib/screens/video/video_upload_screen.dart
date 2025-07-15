import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/video_upload_button.dart';
import '../../widgets/video_list_item.dart';

class VideoUploadScreen extends ConsumerStatefulWidget {
  const VideoUploadScreen({super.key});

  @override
  ConsumerState<VideoUploadScreen> createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends ConsumerState<VideoUploadScreen> {
  final List<File> _uploads = [];

  void _addUploads(List<File> files) {
    setState(() {
      _uploads.addAll(files);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Upload Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            VideoUploadButton(onFilesSelected: _addUploads),
            const SizedBox(height: 16),
            Expanded(
              child: _uploads.isEmpty
                  ? const Center(child: Text('Selecteer video’s om te uploaden'))
                  : ListView.separated(
                      itemCount: _uploads.length,
                      itemBuilder: (context, index) => VideoListItem(_uploads[index]),
                      separatorBuilder: (_, __) => const Divider(height: 0),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}