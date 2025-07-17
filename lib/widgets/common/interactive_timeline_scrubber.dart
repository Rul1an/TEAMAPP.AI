// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

/// A very lightweight replacement for the previously broken
/// `InteractiveTimelineScrubber` that triggered analyzer errors.
///
/// The original implementation used pattern-matching syntax that is no longer
/// supported for constant patterns.  Until the full feature is rebuilt, this
/// stub gives consumers a functional but simplified timeline scrubber that
/// still compiles on Dart 3.8 and can be gradually extended.
class InteractiveTimelineScrubber extends StatefulWidget {
  const InteractiveTimelineScrubber({
    super.key,
    required this.length,
    required this.position,
    required this.onChanged,
  });

  /// Total number of timeline points.
  final int length;

  /// Current position (0-based index).
  final int position;

  /// Callback when the user changes the position.
  final ValueChanged<int> onChanged;

  @override
  State<InteractiveTimelineScrubber> createState() => _InteractiveTimelineScrubberState();
}

class _InteractiveTimelineScrubberState extends State<InteractiveTimelineScrubber> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.position.toDouble();
  }

  @override
  void didUpdateWidget(covariant InteractiveTimelineScrubber oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.position != widget.position) {
      _value = widget.position.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      min: 0,
      max: (widget.length - 1).toDouble(),
      divisions: widget.length - 1,
      value: _value.clamp(0, (widget.length - 1).toDouble()),
      label: '${_value.round() + 1}/${widget.length}',
      onChanged: (newValue) {
        setState(() => _value = newValue);
        widget.onChanged(newValue.round());
      },
    );
  }
}