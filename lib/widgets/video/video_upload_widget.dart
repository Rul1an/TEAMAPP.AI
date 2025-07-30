import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

import '../../models/video.dart';
import '../../services/video_upload_service.dart';
import '../../repositories/video_repository.dart';

/// Professional video upload widget with drag-and-drop, progress tracking, and validation
/// Optimized for coaching video uploads with comprehensive UX
class VideoUploadWidget extends ConsumerStatefulWidget {
  final String organizationId;
  final String? playerId;
  final VoidCallback? onUploadComplete;
  final void Function(Video)? onVideoUploaded;
  final bool allowMultiple;
  final double? maxHeight;

  const VideoUploadWidget({
    super.key,
    required this.organizationId,
    this.playerId,
    this.onUploadComplete,
    this.onVideoUploaded,
    this.allowMultiple = false,
    this.maxHeight,
  });

  @override
  ConsumerState<VideoUploadWidget> createState() => _VideoUploadWidgetState();
}

class _VideoUploadWidgetState extends ConsumerState<VideoUploadWidget>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _pulseAnimation;

  VideoUploadProgress? _currentUpload;
  String _titleController = '';
  String _descriptionController = '';
  bool _isDragOver = false;
  String? _errorMessage;

  late final VideoUploadService _uploadService;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);

    // Initialize upload service
    final videoRepository = ref.read(videoRepositoryProvider);
    _uploadService = VideoUploadService(videoRepository);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: widget.maxHeight ?? 600,
      ),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              Expanded(
                child: _currentUpload != null
                    ? _buildUploadProgress()
                    : _buildUploadArea(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(
          Icons.video_camera_back,
          size: 32,
          color: Colors.blue,
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Video Upload',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Upload training videos for analysis and review',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        if (_currentUpload != null &&
            _currentUpload!.status != VideoUploadStatus.completed &&
            _currentUpload!.status != VideoUploadStatus.failed)
          IconButton(
            onPressed: _cancelUpload,
            icon: const Icon(Icons.close),
            tooltip: 'Cancel Upload',
          ),
      ],
    );
  }

  Widget _buildUploadArea() {
    return Column(
      children: [
        // Title and Description Input
        TextField(
          decoration: const InputDecoration(
            labelText: 'Video Title *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.title),
          ),
          onChanged: (value) => setState(() => _titleController = value),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Description (optional)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.description),
          ),
          maxLines: 3,
          onChanged: (value) => setState(() => _descriptionController = value),
        ),
        const SizedBox(height: 24),

        // Drag and Drop Area
        Expanded(
          child: _buildDropZone(),
        ),

        const SizedBox(height: 16),

        // Upload Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _titleController.isNotEmpty ? _pickAndUploadVideo : null,
            icon: const Icon(Icons.upload_file),
            label: const Text('Select Video File'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),

        if (_errorMessage != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              border: Border.all(color: Colors.red.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade600),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _errorMessage = null),
                  icon: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 16),
        _buildSupportedFormats(),
      ],
    );
  }

  Widget _buildDropZone() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isDragOver ? _pulseAnimation.value : 1.0,
          child: DragTarget<List<PlatformFile>>(
            onWillAcceptWithDetails: (details) => details.data.isNotEmpty,
            onAcceptWithDetails: (details) {
              setState(() => _isDragOver = false);
              if (details.data.isNotEmpty) {
                _uploadVideoFile(details.data.first);
              }
            },
            onLeave: (_) => setState(() => _isDragOver = false),
            builder: (context, candidateData, rejectedData) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _isDragOver ? Colors.blue : Colors.grey.shade300,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color:
                      _isDragOver ? Colors.blue.shade50 : Colors.grey.shade50,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 64,
                        color: _isDragOver ? Colors.blue : Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _isDragOver
                            ? 'Drop your video here'
                            : 'Drag and drop your video here',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color:
                              _isDragOver ? Colors.blue : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'or click the button below to browse',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildUploadProgress() {
    final progress = _currentUpload!;
    final isCompleted = progress.status == VideoUploadStatus.completed;
    final isFailed = progress.status == VideoUploadStatus.failed;

    return Column(
      children: [
        // Progress Header
        Row(
          children: [
            Icon(
              isCompleted
                  ? Icons.check_circle
                  : isFailed
                      ? Icons.error
                      : Icons.upload,
              color: isCompleted
                  ? Colors.green
                  : isFailed
                      ? Colors.red
                      : Colors.blue,
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    progress.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _getStatusText(progress.status),
                    style: TextStyle(
                      color: isCompleted
                          ? Colors.green
                          : isFailed
                              ? Colors.red
                              : Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Progress Bar
        if (!isFailed) ...[
          LinearProgressIndicator(
            value: progress.progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              isCompleted ? Colors.green : Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress.progress * 100).toStringAsFixed(1)}%',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              if (progress.fileSizeBytes != null &&
                  progress.uploadedBytes != null)
                Text(
                  '${_formatBytes(progress.uploadedBytes!)} / ${_formatBytes(progress.fileSizeBytes!)}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
            ],
          ),
        ],

        const SizedBox(height: 24),

        // Progress Details
        if (progress.startedAt != null) ...[
          _buildProgressDetail('Started', _formatTime(progress.startedAt!)),
          if (progress.completedAt != null)
            _buildProgressDetail(
                'Completed', _formatTime(progress.completedAt!)),
          if (progress.fileSizeBytes != null)
            _buildProgressDetail(
                'File Size', _formatBytes(progress.fileSizeBytes!)),
        ],

        // Error Message
        if (isFailed && progress.errorMessage != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              border: Border.all(color: Colors.red.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade600),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    progress.errorMessage!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
              ],
            ),
          ),
        ],

        const Spacer(),

        // Action Buttons
        Row(
          children: [
            if (isCompleted) ...[
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _uploadAnother,
                  icon: const Icon(Icons.add),
                  label: const Text('Upload Another'),
                ),
              ),
              const SizedBox(width: 12),
            ],
            if (isFailed) ...[
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _retryUpload,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry Upload'),
                ),
              ),
              const SizedBox(width: 12),
            ],
            if (isCompleted || isFailed)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _resetUpload,
                  icon: const Icon(Icons.close),
                  label: const Text('Close'),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportedFormats() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
              const SizedBox(width: 8),
              Text(
                'Supported Formats',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'MP4, MOV, AVI, WebM • Max size: 500MB • Auto-compression available',
            style: TextStyle(
              fontSize: 13,
              color: Colors.blue.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndUploadVideo() async {
    final result = await _uploadService.pickVideoFile();
    if (result.isSuccess) {
      await _uploadVideoFile(result.dataOrNull!);
    } else {
      setState(() {
        _errorMessage =
            result.errorOrNull?.message ?? 'Failed to pick video file';
      });
    }
  }

  Future<void> _uploadVideoFile(PlatformFile file) async {
    if (_titleController.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a video title before uploading';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    final result = await _uploadService.uploadVideoWithProgress(
      organizationId: widget.organizationId,
      title: _titleController,
      description:
          _descriptionController.isEmpty ? null : _descriptionController,
      playerId: widget.playerId,
      platformFile: file,
      onProgress: (progress) {
        setState(() {
          _currentUpload = progress;
        });
      },
    );

    if (result.isSuccess) {
      final video = result.dataOrNull!;
      widget.onVideoUploaded?.call(video);
      widget.onUploadComplete?.call();
    }
  }

  void _cancelUpload() {
    setState(() {
      _currentUpload = null;
    });
  }

  void _uploadAnother() {
    setState(() {
      _currentUpload = null;
      _titleController = '';
      _descriptionController = '';
      _errorMessage = null;
    });
  }

  void _retryUpload() {
    // Implementation would retry the last upload
    setState(() {
      _currentUpload = null;
    });
  }

  void _resetUpload() {
    setState(() {
      _currentUpload = null;
      _titleController = '';
      _descriptionController = '';
      _errorMessage = null;
    });
    widget.onUploadComplete?.call();
  }

  String _getStatusText(VideoUploadStatus status) {
    switch (status) {
      case VideoUploadStatus.preparing:
        return 'Preparing upload...';
      case VideoUploadStatus.compressing:
        return 'Compressing video...';
      case VideoUploadStatus.uploading:
        return 'Uploading to cloud...';
      case VideoUploadStatus.processing:
        return 'Processing video...';
      case VideoUploadStatus.completed:
        return 'Upload completed successfully!';
      case VideoUploadStatus.failed:
        return 'Upload failed';
      case VideoUploadStatus.cancelled:
        return 'Upload cancelled';
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';

    return '${time.day}/${time.month} ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}

// Provider for video repository
final videoRepositoryProvider = Provider<VideoRepository>((ref) {
  throw UnimplementedError('VideoRepository provider must be overridden');
});
