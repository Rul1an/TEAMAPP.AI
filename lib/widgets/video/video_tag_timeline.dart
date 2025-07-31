import 'package:flutter/material.dart';
import '../../models/video_tag.dart';

/// Video timeline widget that shows tags along a progress bar
/// Part of Phase 3A: Video Player Foundation
class VideoTagTimeline extends StatelessWidget {
  final List<VideoTag> tags;
  final Duration duration;
  final Duration currentPosition;
  final void Function(Duration) onSeek;
  final void Function(VideoTag) onTagTap;

  const VideoTagTimeline({
    Key? key,
    required this.tags,
    required this.duration,
    required this.currentPosition,
    required this.onSeek,
    required this.onTagTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (duration.inSeconds <= 0) {
      return Container(
        height: 60,
        padding: const EdgeInsets.all(8),
        child: const Center(
          child: Text('Loading timeline...'),
        ),
      );
    }

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Timeline controls
          Row(
            children: [
              Text(
                _formatDuration(currentPosition),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Expanded(
                child: Slider(
                  value: currentPosition.inSeconds
                      .toDouble()
                      .clamp(0.0, duration.inSeconds.toDouble()),
                  min: 0.0,
                  max: duration.inSeconds.toDouble(),
                  onChanged: (value) {
                    onSeek(Duration(seconds: value.toInt()));
                  },
                ),
              ),
              Text(
                _formatDuration(duration),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),

          // Tag markers
          if (tags.isNotEmpty)
            Expanded(
              child: Stack(
                children: [
                  // Timeline background
                  Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Tag markers
                  ...tags.map((tag) => _buildTagMarker(context, tag)),
                ],
              ),
            )
          else
            const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTagMarker(BuildContext context, VideoTag tag) {
    final progress = tag.timestampSeconds / duration.inSeconds;
    final leftPosition = progress.clamp(0.0, 1.0);

    return Positioned(
      left: leftPosition * (MediaQuery.of(context).size.width - 32),
      top: 4,
      child: GestureDetector(
        onTap: () => onTagTap(tag),
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: _getTagColor(tag.tagType),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTagColor(VideoTagType tagType) {
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

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
