import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:cached_network_image/cached_network_image.dart';
import '../screens/video/video_player_screen.dart';

import '../providers/video_upload_provider.dart';
import '../services/video_upload_service.dart';
import 'video_status_chip.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'thumbnail_selector_dialog.dart';

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
          leading: status.stage == UploadStage.complete &&
                  (status.thumbnails?.isNotEmpty ?? false)
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    imageUrl: status.thumbnails!.first,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                )
              : VideoStatusChip(status: status),
          title: Text(p.basename(file.path)),
          subtitle: _buildSubtitle(status),
          onTap: status.stage == UploadStage.complete &&
                  status.signedUrl != null
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => VideoPlayerScreen(
                        url: status.signedUrl!,
                        title: p.basename(file.path),
                        path: status.path ?? '',
                      ),
                    ),
                  );
                }
              : null,
          onLongPress: status.stage == UploadStage.complete &&
                  (status.thumbnails?.isNotEmpty ?? false)
              ? () async {
                  final selected = await showDialog<String>(
                    context: context,
                    builder: (_) => ThumbnailSelectorDialog(
                      thumbnails: status.thumbnails!,
                    ),
                  );
                  if (selected != null && status.path != null) {
                    await Supabase.instance.client
                        .from('video_assets')
                        .update({'thumbnail1': selected})
                        .eq('path', status.path!)
                        .execute();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Thumbnail bijgewerkt')));
                  }
                }
              : null,
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