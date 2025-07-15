import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ThumbnailSelectorDialog extends StatelessWidget {
  const ThumbnailSelectorDialog({
    required this.thumbnails,
    super.key,
  });

  final List<String> thumbnails;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Selecteer thumbnail'),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 16 / 9,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: thumbnails.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () => Navigator.of(context).pop(thumbnails[index]),
            child: CachedNetworkImage(
              imageUrl: thumbnails[index],
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}