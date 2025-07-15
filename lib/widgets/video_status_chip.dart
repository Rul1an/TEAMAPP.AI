import 'package:flutter/material.dart';
import '../services/video_upload_service.dart';

class VideoStatusChip extends StatelessWidget {
  const VideoStatusChip({
    required this.status,
    super.key,
  });

  final UploadStatus status;

  Color _colorForStage(UploadStage stage, BuildContext context) {
    switch (stage) {
      case UploadStage.precompressing:
      case UploadStage.uploading:
        return Colors.blue.shade400;
      case UploadStage.processing:
        return Colors.orangeAccent;
      case UploadStage.complete:
        return Colors.green.shade600;
      case UploadStage.failed:
        return Colors.redAccent;
      case UploadStage.retrying:
        return Colors.amber.shade700;
      case UploadStage.queued:
      default:
        return Theme.of(context).disabledColor;
    }
  }

  String _labelForStage(UploadStage stage) {
    switch (stage) {
      case UploadStage.precompressing:
        return 'Compressing';
      case UploadStage.uploading:
        return 'Uploading';
      case UploadStage.processing:
        return 'Processing';
      case UploadStage.complete:
        return 'Ready';
      case UploadStage.failed:
        return 'Failed';
      case UploadStage.retrying:
        return 'Retrying';
      case UploadStage.queued:
      default:
        return 'Queued';
    }
  }

  @override
  Widget build(BuildContext context) {
    final stage = status.stage;
    return Chip(
      label: Text(
        _labelForStage(stage),
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: _colorForStage(stage, context),
    );
  }
}