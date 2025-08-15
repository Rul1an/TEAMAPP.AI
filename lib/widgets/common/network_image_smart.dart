// Flutter imports:
import 'package:flutter/material.dart';

/// Smart network image with placeholder, error fallback, and tuned filterQuality.
/// 2025 best practice: avoid layout shifts and expensive filtering.
class NetworkImageSmart extends StatelessWidget {
  const NetworkImageSmart(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.filterQuality = FilterQuality.medium,
    this.placeholderColor = const Color(0xFFEAEAEA),
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final BorderRadius borderRadius;
  final FilterQuality filterQuality;
  final Color placeholderColor;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final int? cacheW = width != null ? (width! * dpr).round() : null;
    final int? cacheH = height != null ? (height! * dpr).round() : null;

    final image = Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      filterQuality: filterQuality,
      gaplessPlayback: true,
      cacheWidth: cacheW,
      cacheHeight: cacheH,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _skeleton();
      },
      errorBuilder: (context, error, stackTrace) => _errorBox(),
    );

    return ClipRRect(
      borderRadius: borderRadius,
      child: image,
    );
  }

  Widget _skeleton() => DecoratedBox(
        decoration: BoxDecoration(color: placeholderColor),
        child: const Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );

  Widget _errorBox() => const DecoratedBox(
        decoration: BoxDecoration(color: Color(0xFFEEEEEE)),
        child: Center(
          child: Icon(Icons.broken_image, size: 20, color: Colors.grey),
        ),
      );
}
