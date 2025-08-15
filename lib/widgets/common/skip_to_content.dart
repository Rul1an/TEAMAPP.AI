// Flutter imports:
import 'package:flutter/material.dart';

/// Accessible "Skip to content" control for keyboard users (2025 best practice)
///
/// - Appears when focused/hovered
/// - Large tap target and high-contrast styling
/// - Calls [onActivate] to move focus/scroll to main content
class SkipToContent extends StatefulWidget {
  const SkipToContent({
    super.key,
    required this.onActivate,
    this.label = 'Sla navigatie over en ga naar hoofdinhoud',
  });

  final VoidCallback onActivate;
  final String label;

  @override
  State<SkipToContent> createState() => _SkipToContentState();
}

class _SkipToContentState extends State<SkipToContent> {
  bool _show = false;

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      onShowHoverHighlight: (v) => setState(() => _show = v),
      onShowFocusHighlight: (v) => setState(() => _show = v),
      child: AnimatedOpacity(
        opacity: _show ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 150),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              onPressed: widget.onActivate,
              child: Text(
                widget.label,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
