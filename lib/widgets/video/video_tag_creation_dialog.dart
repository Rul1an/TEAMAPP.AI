import 'package:flutter/material.dart';
import '../../models/video_tag.dart';

/// Dialog for creating new video tags at specific timestamps
/// Part of Phase 3A: Video Player Foundation
class VideoTagCreationDialog extends StatefulWidget {
  final Duration currentTimestamp;
  final Function(VideoTag) onTagCreated;

  const VideoTagCreationDialog({
    Key? key,
    required this.currentTimestamp,
    required this.onTagCreated,
  }) : super(key: key);

  @override
  State<VideoTagCreationDialog> createState() => _VideoTagCreationDialogState();
}

class _VideoTagCreationDialogState extends State<VideoTagCreationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  VideoTagType _selectedTagType = VideoTagType.drill;
  bool _isCreating = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createTag() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      // Create the tag object - using placeholder values for Phase 3A
      final tag = VideoTag(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        videoId: '', // Will be set by parent component
        organizationId: '', // Will be set by parent component
        tagType: _selectedTagType,
        timestampSeconds: widget.currentTimestamp.inSeconds.toDouble(),
        description: _descriptionController.text.trim(),
        tagData: {}, // Empty for now - will be expanded in Phase 3B
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Call the callback
      widget.onTagCreated(tag);

      // Dialog will be closed by parent
    } catch (e) {
      // Show error if tag creation fails
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create tag: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  String? _validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }

    if (value.trim().length < 3) {
      return 'Description must be at least 3 characters';
    }

    if (value.trim().length > 500) {
      return 'Description must be less than 500 characters';
    }

    return null;
  }

  Color _getTagTypeColor(VideoTagType tagType) {
    switch (tagType) {
      case VideoTagType.drill:
        return Colors.green;
      case VideoTagType.moment:
        return Colors.orange;
      case VideoTagType.player:
        return Colors.blue;
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
        return Icons.star_border;
    }
  }

  String _getTagTypeDescription(VideoTagType tagType) {
    switch (tagType) {
      case VideoTagType.drill:
        return 'Mark training drills and exercises';
      case VideoTagType.moment:
        return 'Highlight key moments in gameplay';
      case VideoTagType.player:
        return 'Tag specific player actions';
      case VideoTagType.tactic:
        return 'Mark tactical situations';
      case VideoTagType.mistake:
        return 'Identify mistakes or errors';
      case VideoTagType.skill:
        return 'Highlight skill demonstrations';
    }
  }

  String _formatTimestamp(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(
          maxWidth: 500,
          maxHeight: 600,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.add_circle,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create New Tag',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'At ${_formatTimestamp(widget.currentTimestamp)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Form
            Flexible(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tag Type Selection
                    Text(
                      'Tag Type',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Tag type cards
                    ...VideoTagType.values.map((tagType) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        onTap: () => setState(() => _selectedTagType = tagType),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _selectedTagType == tagType
                                  ? _getTagTypeColor(tagType)
                                  : Theme.of(context).colorScheme.outline,
                              width: _selectedTagType == tagType ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: _selectedTagType == tagType
                                ? _getTagTypeColor(tagType).withValues(alpha: 0.1)
                                : null,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _getTagTypeIcon(tagType),
                                color: _getTagTypeColor(tagType),
                                size: 28,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tagType.name.toUpperCase(),
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: _selectedTagType == tagType
                                            ? _getTagTypeColor(tagType)
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _getTagTypeDescription(tagType),
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (_selectedTagType == tagType)
                                Icon(
                                  Icons.check_circle,
                                  color: _getTagTypeColor(tagType),
                                ),
                            ],
                          ),
                        ),
                      ),
                    )),

                    const SizedBox(height: 24),

                    // Description Field
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      validator: _validateDescription,
                      maxLines: 3,
                      maxLength: 500,
                      decoration: InputDecoration(
                        hintText: 'Describe what happens at this moment...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.3),
                      ),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _createTag(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isCreating ? null : () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: _isCreating ? null : _createTag,
                    child: _isCreating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Create Tag'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
