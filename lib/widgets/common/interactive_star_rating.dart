import 'package:flutter/material.dart';

class InteractiveStarRating extends StatefulWidget {
  final int rating;
  final Function(int) onRatingChanged;
  final int maxRating;
  final double size;
  final Color color;

  const InteractiveStarRating({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    this.maxRating = 5,
    this.size = 24,
    this.color = Colors.amber,
  });

  @override
  State<InteractiveStarRating> createState() => _InteractiveStarRatingState();
}

class _InteractiveStarRatingState extends State<InteractiveStarRating> {
  int _currentRating = 0;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating;
  }

  @override
  void didUpdateWidget(InteractiveStarRating oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rating != widget.rating) {
      _currentRating = widget.rating;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.maxRating, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _currentRating = index + 1;
            });
            widget.onRatingChanged(_currentRating);
          },
          child: Icon(
            index < _currentRating ? Icons.star : Icons.star_border,
            color: widget.color,
            size: widget.size,
          ),
        );
      }),
    );
  }
}
