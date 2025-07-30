// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../models/video.dart';
import '../../models/video_tag.dart' as models;
import '../../providers/video_repository_provider.dart';
import '../../widgets/video/video_player_widget.dart';
import '../../widgets/video/video_tagging_widget.dart';

/// Provider for video data
final videoProvider =
    FutureProvider.family<Video, String>((ref, videoId) async {
  final repository = ref.watch(videoRepositoryProvider);
  final result = await repository.getVideoById(videoId);

  return result.fold(
    (error) => throw Exception('Failed to load video: $error'),
    (video) => video,
  );
});

/// Screen for comprehensive video analysis
class VideoAnalysisScreen extends ConsumerStatefulWidget {
  const VideoAnalysisScreen({
    required this.videoId,
    super.key,
  });

  final String videoId;

  static const routeName = '/video-analysis';

  @override
  ConsumerState<VideoAnalysisScreen> createState() =>
      _VideoAnalysisScreenState();
}

class _VideoAnalysisScreenState extends ConsumerState<VideoAnalysisScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double _currentVideoTime = 0.0;
  bool _isTaggingMode = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoAsync = ref.watch(videoProvider(widget.videoId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Analysis'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(_isTaggingMode ? Icons.videocam : Icons.label),
            onPressed: () => setState(() => _isTaggingMode = !_isTaggingMode),
            tooltip:
                _isTaggingMode ? 'Exit Tagging Mode' : 'Enter Tagging Mode',
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export_tags',
                child: Row(
                  children: [
                    Icon(Icons.download),
                    SizedBox(width: 8),
                    Text('Export Tags'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share_analysis',
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 8),
                    Text('Share Analysis'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'video_info',
                child: Row(
                  children: [
                    Icon(Icons.info),
                    SizedBox(width: 8),
                    Text('Video Info'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.play_arrow), text: 'Player'),
            Tab(icon: Icon(Icons.label), text: 'Tags'),
            Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
          ],
        ),
      ),
      body: videoAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _buildErrorView(error),
        data: _buildVideoAnalysisView,
      ),
    );
  }

  Widget _buildErrorView(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error loading video',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => ref.invalidate(videoProvider(widget.videoId)),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoAnalysisView(Video video) {
    return Column(
      children: [
        // Video player section
        Container(
          height: 300,
          color: Colors.black,
          child: Stack(
            children: [
              VideoPlayerWidget(
                video: video,
                onTimeUpdate: (time) =>
                    setState(() => _currentVideoTime = time),
                showControls: true,
              ),

              // Tagging mode overlay
              if (_isTaggingMode)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.fiber_manual_record,
                            color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'TAGGING MODE',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Video timeline with hotspots
        _buildVideoTimeline(video),

        // Content tabs
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildPlayerTab(video),
              _buildTagsTab(video),
              _buildAnalyticsTab(video),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVideoTimeline(Video video) {
    final taggingState = ref.watch(videoTaggingControllerProvider(video.id));

    return Container(
      height: 60,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Timeline with hotspots
          Container(
            height: 20,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                // Hotspots
                ...taggingState.hotspots.map((hotspot) {
                  final position = (hotspot.startSeconds /
                          video.durationSeconds.toDouble()) *
                      MediaQuery.of(context).size.width;

                  return Positioned(
                    left: position,
                    child: Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: _getHotspotColor(hotspot.tagCount),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),

                // Current position indicator
                Positioned(
                  left: (_currentVideoTime /
                          video.durationSeconds.toDouble()) *
                      MediaQuery.of(context).size.width,
                  child: Container(
                    width: 2,
                    height: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Time display
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatTime(_currentVideoTime),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                _formatTime(video.durationSeconds.toDouble()),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerTab(Video video) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Video Information',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Title', video.title),
                  _buildInfoRow('Duration',
                      _formatTime(video.durationSeconds.toDouble())),
                  _buildInfoRow(
                      'Size', _formatFileSize(video.fileSizeBytes)),
                  _buildInfoRow('Status', video.status.name.toUpperCase()),
                  if (video.description != null &&
                      video.description!.isNotEmpty)
                    _buildInfoRow('Description', video.description!),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Quick actions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildActionChip(
                        'Add Tag',
                        Icons.add,
                        () => setState(() => _isTaggingMode = true),
                      ),
                      _buildActionChip(
                        'Jump to Start',
                        Icons.skip_previous,
                        () => _jumpToTime(0),
                      ),
                      _buildActionChip(
                        'Jump to End',
                        Icons.skip_next,
                        () => _jumpToTime(
                            video.durationSeconds.toDouble()),
                      ),
                      _buildActionChip(
                        'Rewind 10s',
                        Icons.replay_10,
                        () => _jumpToTime(_currentVideoTime - 10),
                      ),
                      _buildActionChip(
                        'Forward 10s',
                        Icons.forward_10,
                        () => _jumpToTime(_currentVideoTime + 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsTab(Video video) {
    return VideoTaggingWidget(
      video: video,
      currentTime: _currentVideoTime,
      onTagCreated: () {
        // Optionally switch out of tagging mode after creating a tag
        if (_isTaggingMode) {
          setState(() => _isTaggingMode = false);
        }
      },
      onTagSelected: (tag) => _jumpToTime(tag.timestampSeconds),
    );
  }

  Widget _buildAnalyticsTab(Video video) {
    final taggingState = ref.watch(videoTaggingControllerProvider(video.id));

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Video Analytics',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          if (taggingState.analytics != null) ...[
            _buildAnalyticsCards(taggingState.analytics!),
            const SizedBox(height: 16),
            _buildEventTypeChart(taggingState.analytics!),
          ] else
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.analytics_outlined, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No analytics data available'),
                  SizedBox(height: 8),
                  Text(
                    'Create some tags to see analytics',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildActionChip(String label, IconData icon, VoidCallback onPressed) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onPressed,
    );
  }

  Widget _buildAnalyticsCards(models.VideoTagAnalytics analytics) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.label,
                      size: 32, color: Theme.of(context).primaryColor),
                  const SizedBox(height: 8),
                  Text(
                    analytics.totalTags.toString(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Text('Total Tags'),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.event,
                      size: 32, color: Theme.of(context).primaryColor),
                  const SizedBox(height: 8),
                  Text(
                    analytics.tagsByType.length.toString(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Text('Tag Types'),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.speed,
                      size: 32, color: Theme.of(context).primaryColor),
                  const SizedBox(height: 8),
                  Text(
                    analytics.averageTagsPerMinute.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Text('Tags/Min'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventTypeChart(models.VideoTagAnalytics analytics) {
    if (analytics.tagsByType.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tag Type Distribution',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ...analytics.tagsByType.entries.map((entry) {
              final percentage = (entry.value / analytics.totalTags) * 100;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(entry.key.name.toUpperCase()),
                    ),
                    Expanded(
                      flex: 3,
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('${entry.value} (${percentage.toStringAsFixed(1)}%)'),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getHotspotColor(int tagCount) {
    if (tagCount >= 5) return Colors.red;
    if (tagCount >= 3) return Colors.orange;
    if (tagCount >= 2) return Colors.yellow;
    return Colors.green;
  }

  void _jumpToTime(double seconds) {
    // TODO(video-player): Implement video seeking
    setState(() => _currentVideoTime = seconds.clamp(0.0, double.infinity));
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'export_tags':
        _exportTags();
        break;
      case 'share_analysis':
        _shareAnalysis();
        break;
      case 'video_info':
        _showVideoInfo();
        break;
    }
  }

  void _exportTags() {
    // TODO(export): Implement tag export
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export functionality coming soon')),
    );
  }

  void _shareAnalysis() {
    // TODO(share): Implement analysis sharing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon')),
    );
  }

  void _showVideoInfo() {
    // TODO(info): Show detailed video info dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Video info dialog coming soon')),
    );
  }

  String _formatTime(double seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = (seconds % 60).floor();
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
