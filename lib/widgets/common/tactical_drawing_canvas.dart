import 'dart:math' as math;
import 'package:flutter/material.dart';

enum DrawingTool { line, arrow, circle, text, erase }

class DrawingElement {
  DrawingElement({
    required this.tool,
    required this.points,
    required this.color,
    this.strokeWidth = 3.0,
    this.text,
  });
  final DrawingTool tool;
  final List<Offset> points;
  final Color color;
  final double strokeWidth;
  final String? text;
}

class TacticalDrawingCanvas extends StatefulWidget {
  const TacticalDrawingCanvas({
    super.key,
    required this.child,
    required this.drawings,
    required this.onDrawingsChanged,
    required this.isDrawingMode,
    required this.selectedTool,
    required this.selectedColor,
  });
  final Widget child;
  final List<DrawingElement> drawings;
  final void Function(List<DrawingElement>) onDrawingsChanged;
  final bool isDrawingMode;
  final DrawingTool selectedTool;
  final Color selectedColor;

  @override
  State<TacticalDrawingCanvas> createState() => _TacticalDrawingCanvasState();
}

class _TacticalDrawingCanvasState extends State<TacticalDrawingCanvas> {
  List<Offset> _currentPoints = [];
  bool _isDrawing = false;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          widget.child,
          if (widget.isDrawingMode)
            Positioned.fill(
              child: GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                onTapUp: _onTap,
                child: CustomPaint(
                  painter: TacticalDrawingPainter(
                    drawings: widget.drawings,
                    currentPoints: _currentPoints,
                    currentTool: widget.selectedTool,
                    currentColor: widget.selectedColor,
                    isDrawing: _isDrawing,
                  ),
                ),
              ),
            ),
        ],
      );

  void _onPanStart(DragStartDetails details) {
    if (!widget.isDrawingMode) return;

    setState(() {
      _isDrawing = true;
      _currentPoints = [details.localPosition];
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.isDrawingMode || !_isDrawing) return;

    setState(() {
      _currentPoints.add(details.localPosition);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (!widget.isDrawingMode || !_isDrawing) return;

    _addDrawingElement();
  }

  void _onTap(TapUpDetails details) {
    if (!widget.isDrawingMode) return;

    if (widget.selectedTool == DrawingTool.text) {
      _showTextDialog(details.localPosition);
    } else if (widget.selectedTool == DrawingTool.erase) {
      _eraseAtPosition(details.localPosition);
    } else if (widget.selectedTool == DrawingTool.circle) {
      // Create a circle at tap position
      final center = details.localPosition;
      const radius = 30.0; // Default radius
      final points = _generateCirclePoints(center, radius);

      final element = DrawingElement(
        tool: DrawingTool.circle,
        points: points,
        color: widget.selectedColor,
      );

      final updatedDrawings = [...widget.drawings, element];
      widget.onDrawingsChanged(updatedDrawings);
    }
  }

  void _addDrawingElement() {
    if (_currentPoints.isEmpty) return;

    DrawingElement element;

    if (widget.selectedTool == DrawingTool.arrow &&
        _currentPoints.length >= 2) {
      // For arrows, we only need start and end points
      element = DrawingElement(
        tool: DrawingTool.arrow,
        points: [_currentPoints.first, _currentPoints.last],
        color: widget.selectedColor,
      );
    } else {
      element = DrawingElement(
        tool: widget.selectedTool,
        points: List.from(_currentPoints),
        color: widget.selectedColor,
      );
    }

    final updatedDrawings = [...widget.drawings, element];
    widget.onDrawingsChanged(updatedDrawings);

    setState(() {
      _currentPoints = [];
      _isDrawing = false;
    });
  }

  void _showTextDialog(Offset position) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tekst Toevoegen'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Voer tekst in...',
          ),
          onSubmitted: (text) {
            if (text.isNotEmpty) {
              final element = DrawingElement(
                tool: DrawingTool.text,
                points: [position],
                color: widget.selectedColor,
                text: text,
              );

              final updatedDrawings = [...widget.drawings, element];
              widget.onDrawingsChanged(updatedDrawings);
            }
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuleren'),
          ),
        ],
      ),
    );
  }

  void _eraseAtPosition(Offset position) {
    const eraseRadius = 30.0;

    final updatedDrawings = widget.drawings
        .where(
          (element) => !element.points.any((point) {
            final distance = (point - position).distance;
            return distance <= eraseRadius;
          }),
        )
        .toList();

    widget.onDrawingsChanged(updatedDrawings);
  }

  List<Offset> _generateCirclePoints(Offset center, double radius) {
    final points = <Offset>[];
    const steps = 64;

    for (int i = 0; i <= steps; i++) {
      final angle = (i / steps) * 2 * 3.14159;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      points.add(Offset(x, y));
    }

    return points;
  }
}

class TacticalDrawingPainter extends CustomPainter {
  TacticalDrawingPainter({
    required this.drawings,
    required this.currentPoints,
    required this.currentTool,
    required this.currentColor,
    required this.isDrawing,
  });
  final List<DrawingElement> drawings;
  final List<Offset> currentPoints;
  final DrawingTool currentTool;
  final Color currentColor;
  final bool isDrawing;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw existing elements
    for (final element in drawings) {
      _drawElement(canvas, element);
    }

    // Draw current element being drawn
    if (isDrawing && currentPoints.isNotEmpty) {
      final tempElement = DrawingElement(
        tool: currentTool,
        points: currentPoints,
        color: currentColor,
      );
      _drawElement(canvas, tempElement);
    }
  }

  void _drawElement(Canvas canvas, DrawingElement element) {
    final paint = Paint()
      ..color = element.color
      ..strokeWidth = element.strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    switch (element.tool) {
      case DrawingTool.line:
        _drawLine(canvas, element.points, paint);
        break;
      case DrawingTool.arrow:
        _drawArrow(canvas, element.points, paint);
        break;
      case DrawingTool.circle:
        _drawCircle(canvas, element.points, paint);
        break;
      case DrawingTool.text:
        _drawText(canvas, element);
        break;
      case DrawingTool.erase:
        break; // Erase doesn't draw anything
    }
  }

  void _drawLine(Canvas canvas, List<Offset> points, Paint paint) {
    if (points.length < 2) return;

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);
  }

  void _drawArrow(Canvas canvas, List<Offset> points, Paint paint) {
    if (points.length < 2) return;

    final start = points.first;
    final end = points.last;

    // Draw line
    canvas.drawLine(start, end, paint);

    // Draw arrowhead
    const arrowLength = 20.0;
    const arrowAngle = 0.5;

    final direction = end - start;
    final length = direction.distance;
    if (length == 0) return;

    final unitVector = direction / length;
    final perpVector = Offset(-unitVector.dy, unitVector.dx);

    final arrowBase = end - unitVector * arrowLength;
    final arrowLeft =
        arrowBase + perpVector * arrowLength * math.sin(arrowAngle);
    final arrowRight =
        arrowBase - perpVector * arrowLength * math.sin(arrowAngle);

    final arrowPath = Path();
    arrowPath.moveTo(end.dx, end.dy);
    arrowPath.lineTo(arrowLeft.dx, arrowLeft.dy);
    arrowPath.lineTo(arrowRight.dx, arrowRight.dy);
    arrowPath.close();

    paint.style = PaintingStyle.fill;
    canvas.drawPath(arrowPath, paint);
  }

  void _drawCircle(Canvas canvas, List<Offset> points, Paint paint) {
    if (points.isEmpty) return;

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);
  }

  void _drawText(Canvas canvas, DrawingElement element) {
    if (element.text == null || element.points.isEmpty) return;

    final textStyle = TextStyle(
      color: element.color,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    final textSpan = TextSpan(
      text: element.text,
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, element.points.first);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
