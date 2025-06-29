import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 24,
    this.color,
    this.emptyColor,
    this.showNumber = false,
    this.onRatingChanged,
  });
  final int rating;
  final int maxRating;
  final double size;
  final Color? color;
  final Color? emptyColor;
  final bool showNumber;
  final void Function(int)? onRatingChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final starColor = color ?? theme.colorScheme.primary;
    final emptyStarColor =
        emptyColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.3);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(maxRating, (index) {
          final starIndex = index + 1;
          final isFilled = starIndex <= rating;

          return GestureDetector(
            onTap: onRatingChanged != null
                ? () => onRatingChanged!(starIndex)
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Icon(
                isFilled ? Icons.star : Icons.star_border,
                size: size,
                color: isFilled ? starColor : emptyStarColor,
              ),
            ),
          );
        }),
        if (showNumber) ...[
          const SizedBox(width: 8),
          Text(
            '$rating/$maxRating',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: starColor,
            ),
          ),
        ],
      ],
    );
  }
}

class InteractiveStarRating extends StatefulWidget {
  const InteractiveStarRating({
    super.key,
    required this.initialRating,
    required this.onRatingChanged,
    this.maxRating = 5,
    this.size = 32,
    this.label,
  });
  final int initialRating;
  final int maxRating;
  final double size;
  final String? label;
  final void Function(int) onRatingChanged;

  @override
  State<InteractiveStarRating> createState() => _InteractiveStarRatingState();
}

class _InteractiveStarRatingState extends State<InteractiveStarRating> {
  late int _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
        ],
        StarRating(
          rating: _currentRating,
          maxRating: widget.maxRating,
          size: widget.size,
          onRatingChanged: (rating) {
            setState(() {
              _currentRating = rating;
            });
            widget.onRatingChanged(rating);
          },
        ),
      ],
    );
  }
}
