// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../controllers/video_tagging_controller.dart';
import '../../models/video.dart';
import '../../models/video_tag.dart';
import '../../providers/video_tag_repository_provider.dart';

/// Provider for video tagging controller
final videoTaggingControllerProvider = StateNotifierProvider.family<
    VideoTaggingController, VideoTaggingState, String>(
  (ref, videoId) {
    final repository = ref.watch(videoTagRepositoryProvider);
    final controller = VideoTaggingController(repository);

    // Auto-load tags when controller is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadVideoTags(videoId);
    });

    return controller;
  },
);

/// Widget for video tagging interface
class VideoTaggingWidget extends ConsumerStatefulWidget {
  const VideoTaggingWidget({
    required this.video,
    required this.currentTime,
    super.key,
    this.onTagCreated,
    this.onTagSelected,
  });

  final Video video;
  final double currentTime;
  final VoidCallback? onTagCreated;
  final void Function(VideoTag)? onTagSelected;

  @override
  ConsumerState<VideoTaggingWidget> createState() => _VideoTaggingWidgetState();
}

class _VideoTaggingWidgetState extends ConsumerState<VideoTaggingWidget> {
  VideoTagType? _selectedTagType;
  String? _selectedPlayerId;
  final _notesController = TextEditingController();
  bool _showTagForm = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(videoTaggingControllerProvider(widget.video.id));
    final controller =
        ref.read(videoTaggingControllerProvider(widget.video.id).notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.label_outline),
                const SizedBox(width: 8),
                Text(
                  'Video Tags',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(_showTagForm ? Icons.close : Icons.add),
                  onPressed: () => setState(() => _showTagForm = !_showTagForm),
                  tooltip: _showTagForm ? 'Cancel' : 'Add Tag',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Tag creation form
            if (_showTagForm) ...[
              _buildTagForm(context, controller),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
            ],

            // Tags list
            Expanded(
              child: _buildTagsList(context, state, controller),
            ),

            // Analytics summary
            if (state.analytics != null) ...[
              const Divider(),
              const SizedBox(height: 8),
              _buildAnalyticsSummary(context, state.analytics!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTagForm(
      BuildContext context, VideoTaggingController controller) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Tag at ${_formatTime(widget.currentTime)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            // Tag type selection
            Text('Tag Type:', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: VideoTagType.values.map((tagType) {
                final isSelected = _selectedTagType == tagType;
                return FilterChip(
                  label: Text(tagType.name.toUpperCase()),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedTagType = selected ? tagType : null;
                    });
                  },
                  backgroundColor:
                      isSelected ? _getTagTypeColor(tagType) : null,
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Player selection (optional)
            Text('Player (Optional):',
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            // TODO(players): Implement player selection dropdown
            TextField(
              decoration: const InputDecoration(
                hintText: 'Select player...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) =>
                  _selectedPlayerId = value.isEmpty ? null : value,
            ),

            const SizedBox(height: 16),

            // Notes
            Text('Notes (Optional):',
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                hintText: 'Add notes...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                ElevatedButton(
                  onPressed: _selectedTagType != null
                      ? () => _createTag(controller)
                      : null,
                  child: const Text('Create Tag'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _resetForm,
                  child: const Text('Clear'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsList(BuildContext context, VideoTaggingState state,
      VideoTaggingController controller) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: ${state.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.loadVideoTags(widget.video.id),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.tags.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.label_outline, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text('No tags yet'),
            SizedBox(height: 8),
            Text(
              'Create your first tag using the + button above',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Sort tags by timestamp
    final sortedTags = List<VideoTag>.from(state.tags)
      ..sort((a, b) => a.timestampSeconds.compareTo(b.timestampSeconds));

    return ListView.builder(
      itemCount: sortedTags.length,
      itemBuilder: (context, index) {
        final tag = sortedTags[index];
        return _buildTagItem(context, tag, controller);
      },
    );
  }

  Widget _buildTagItem(
      BuildContext context, VideoTag tag, VideoTaggingController controller) {
    final tagColor = _getTagTypeColor(tag.tagType);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: tagColor,
          child: Icon(
            _getTagTypeIcon(tag.tagType),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(tag.tagTypeDisplayName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Time: ${_formatTime(tag.timestampSeconds)}'),
            if (tag.playerId != null) Text('Player: ${tag.playerId}'),
            if (tag.description != null && tag.description!.isNotEmpty)
              Text('Notes: ${tag.description}',
                  maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) => _handleTagAction(action, tag, controller),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        onTap: () => widget.onTagSelected?.call(tag),
      ),
    );
  }

  Widget _buildAnalyticsSummary(
      BuildContext context, VideoTagAnalytics analytics) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildAnalyticsStat(
            context, 'Total Tags', analytics.totalTags.toString()),
        _buildAnalyticsStat(
            context, 'Types', analytics.tagsByType.length.toString()),
        _buildAnalyticsStat(context, 'Tags/Min',
            analytics.averageTagsPerMinute.toStringAsFixed(1)),
      ],
    );
  }

  Widget _buildAnalyticsStat(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Future<void> _createTag(VideoTaggingController controller) async {
    if (_selectedTagType == null) return;

    final request = CreateVideoTagRequest(
      videoId: widget.video.id,
      organizationId: 'temp-org', // TODO(context): Get from context
      tagType: _selectedTagType!,
      timestampSeconds: widget.currentTime,
      description: _notesController.text.isEmpty ? null : _notesController.text,
      tagData: _selectedPlayerId != null ? {'playerId': _selectedPlayerId} : {},
    );

    final success = await controller.createTag(request);
    if (success && mounted) {
      _resetForm();
      widget.onTagCreated?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tag created successfully!')),
      );
    }
  }

  void _resetForm() {
    setState(() {
      _selectedTagType = null;
      _selectedPlayerId = null;
      _showTagForm = false;
    });
    _notesController.clear();
  }

  void _handleTagAction(
      String action, VideoTag tag, VideoTaggingController controller) {
    switch (action) {
      case 'edit':
        // TODO(edit): Implement tag editing
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Edit functionality coming soon')),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(tag, controller);
        break;
    }
  }

  void _showDeleteConfirmation(
      VideoTag tag, VideoTaggingController controller) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Tag'),
        content: Text(
            'Are you sure you want to delete this ${tag.tagTypeDisplayName} tag?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await controller.deleteTag(tag.id);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tag deleted successfully!')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Color _getTagTypeColor(VideoTagType tagType) {
    switch (tagType) {
      case VideoTagType.drill:
        return Colors.green;
      case VideoTagType.moment:
        return Colors.blue;
      case VideoTagType.player:
        return Colors.orange;
      case VideoTagType.tactic:
        return Colors.purple;
      case VideoTagType.mistake:
        return Colors.red;
      case VideoTagType.skill:
        return Colors.cyan;
    }
  }

  IconData _getTagTypeIcon(VideoTagType tagType) {
    switch (tagType) {
      case VideoTagType.drill:
        return Icons.sports_soccer;
      case VideoTagType.moment:
        return Icons.star;
      case VideoTagType.player:
        return Icons.person;
      case VideoTagType.tactic:
        return Icons.analytics;
      case VideoTagType.mistake:
        return Icons.warning;
      case VideoTagType.skill:
        return Icons.emoji_objects;
    }
  }

  String _formatTime(double seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = (seconds % 60).floor();
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
