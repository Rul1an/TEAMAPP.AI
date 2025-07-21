import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../models/veo_highlight.dart';
import '../providers/veo_highlights_provider.dart';
import 'async_value_widget.dart';

/// HighlightGallery – horizontally scrollable list of video highlights.
///
/// [matchId] – Veo match identifier.
///
/// Lazy behaviour:
/// • Highlights list fetched via Riverpod only when widget becomes visible.
/// • Video asset (signed URL) is fetched and controller initialised only when
///   user taps a thumbnail – preventing unnecessary network usage.
class HighlightGallery extends ConsumerWidget {
  const HighlightGallery({required this.matchId, super.key});

  final String matchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final highlightsValue = ref.watch(veoHighlightsProvider(matchId));

    return AsyncValueWidget<List<VeoHighlight>>(
      value: highlightsValue,
      data: (highlights) {
        if (highlights.isEmpty) {
          return const Center(child: Text('Geen highlights beschikbaar'));
        }
        return SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: highlights.length,
            itemBuilder: (context, index) {
              final h = highlights[index];
              return _HighlightThumbnail(highlight: h);
            },
          ),
        );
      },
    );
  }
}

class _HighlightThumbnail extends ConsumerStatefulWidget {
  const _HighlightThumbnail({required this.highlight});

  final VeoHighlight highlight;

  @override
  ConsumerState<_HighlightThumbnail> createState() =>
      _HighlightThumbnailState();
}

class _HighlightThumbnailState extends ConsumerState<_HighlightThumbnail> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;
  bool _loadingUrl = false;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initAndPlay() async {
    if (_controller != null) {
      setState(() => _isPlaying = true);
      await _controller!.play();
      return;
    }

    setState(() => _loadingUrl = true);
    final url = await ref
        .read(highlightPlaybackUrlProvider(widget.highlight.id).future)
        .catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
      return '';
    });
    if (!mounted || url.isEmpty) return;

    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    await controller.initialize();
    controller.setLooping(true);

    setState(() {
      _controller = controller;
      _isPlaying = true;
      _loadingUrl = false;
    });
    await controller.play();
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.highlight;
    return GestureDetector(
      onTap: _isPlaying ? null : _initAndPlay,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          width: 120,
          child: Column(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: _loadingUrl
                      ? const Center(child: CircularProgressIndicator())
                      : _controller != null && _controller!.value.isInitialized
                          ? VideoPlayer(_controller!)
                          : const ColoredBox(
                              color: Colors.black12,
                              child: Icon(Icons.play_arrow, size: 48),
                            ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                h.title ?? 'Clip',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
