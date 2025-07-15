import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../providers/video_upload_provider.dart';
import '../services/video_upload_service.dart';
import 'video_status_chip.dart';

class VideoListItem extends ConsumerWidget {
  const VideoListItem(this.file, {super.key});

  final File file;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncStatus = ref.watch(videoUploadStatusProvider(file));

    return asyncStatus.when(
      data: (status) {
        // Show one-off snackbar on completion/failure
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (status.stage == UploadStage.complete) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${p.basename(file.path)} klaar voor weergave')),);
          } else if (status.stage == UploadStage.failed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Upload mislukt voor ${p.basename(file.path)}')),);
          }
        });
        return ListTile(
          leading: VideoStatusChip(status: status),
          title: Text(p.basename(file.path)),
          subtitle: _buildSubtitle(status),
        );
      },
      loading: () => ListTile(
        leading: const CircularProgressIndicator(),
        title: Text(p.basename(file.path)),
        subtitle: const Text('Starting...'),
      ),
      error: (e, st) => ListTile(
        leading: const Icon(Icons.error, color: Colors.red),
        title: Text(p.basename(file.path)),
        subtitle: Text('Error: $e'),
      ),
    );
  }

  Widget? _buildSubtitle(UploadStatus status) {
    if (status.stage == UploadStage.precompressing ||
        status.stage == UploadStage.uploading) {
      final percent = (status.progress * 100).toStringAsFixed(0);
      return Text('${status.stage.name} • $percent%');
    }
    if (status.stage == UploadStage.retrying) {
      return Text('Retry ${status.retryCount}');
    }
    if (status.message != null) {
      return Text(status.message!);
    }
    return null;
  }
}