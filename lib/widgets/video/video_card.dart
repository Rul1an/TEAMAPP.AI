// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../models/video.dart';

class VideoCard extends StatelessWidget {
  const VideoCard({super.key, required this.video, this.onTap});

  final Video video;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Thumbnail
            AspectRatio(
              aspectRatio: 16 / 9,
              child: video.thumbnailUrl != null
                  ? Image.network(
                      video.thumbnailUrl!,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey.shade300,
                      child: const Center(child: Icon(Icons.videocam, size: 48)),
                    ),
            ),
            // Title overlay
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  video.title,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}