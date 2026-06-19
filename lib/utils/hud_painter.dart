import 'dart:math';
import 'package:flutter/material.dart';
import 'constants.dart';

class HUDPainter extends CustomPainter {
  final Rect? scanLineRect;
  final bool showGrid;
  final Color gridColor;

  HUDPainter({
    this.scanLineRect,
    this.showGrid = true,
    this.gridColor = AppConstants.neonBlue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (showGrid) {
      _drawGrid(canvas, size);
    }
    if (scanLineRect != null) {
      _drawScanLine(canvas, size);
    }
    _drawCornerBrackets(canvas, size);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor.withAlpha(13)
      ..strokeWidth = 0.5;

    const spacing = 30.0;
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _drawScanLine(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppConstants.neonBlue.withAlpha(26)
      ..strokeWidth = 1.5;

    final t = DateTime.now().millisecondsSinceEpoch / 1000.0;
    final y = size.height * (0.5 + 0.5 * sin(t * 0.5));
    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
  }

  void _drawCornerBrackets(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppConstants.neonBlue.withAlpha(77)
      ..strokeWidth = 1.0;

    const bracketSize = 20.0;
    const margin = 10.0;

    canvas.drawLine(
        Offset(margin, margin + bracketSize), Offset(margin, margin), paint);
    canvas.drawLine(
        Offset(margin, margin), Offset(margin + bracketSize, margin), paint);

    canvas.drawLine(Offset(size.width - margin - bracketSize, margin),
        Offset(size.width - margin, margin), paint);
    canvas.drawLine(Offset(size.width - margin, margin),
        Offset(size.width - margin, margin + bracketSize), paint);

    canvas.drawLine(Offset(margin, size.height - margin - bracketSize),
        Offset(margin, size.height - margin), paint);
    canvas.drawLine(Offset(margin, size.height - margin),
        Offset(margin + bracketSize, size.height - margin), paint);

    canvas.drawLine(
        Offset(size.width - margin - bracketSize, size.height - margin),
        Offset(size.width - margin, size.height - margin), paint);
    canvas.drawLine(Offset(size.width - margin, size.height - margin),
        Offset(size.width - margin, size.height - margin - bracketSize), paint);
  }

  @override
  bool shouldRepaint(covariant HUDPainter oldDelegate) => true;
}

class RadialGlowPainter extends CustomPainter {
  final Color color;
  final double radius;
  final Offset center;

  RadialGlowPainter({
    required this.color,
    required this.radius,
    required this.center,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = RadialGradient(
      colors: [
        color.withAlpha(51),
        color.withAlpha(13),
        Colors.transparent,
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(
        center: center,
        radius: radius,
      ));

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant RadialGlowPainter oldDelegate) => true;
}

class NeonLinePainter extends CustomPainter {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  NeonLinePainter({
    required this.points,
    required this.color,
    this.strokeWidth = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final outerPaint = Paint()
      ..color = color.withAlpha(51)
      ..strokeWidth = strokeWidth + 4
      ..style = PaintingStyle.stroke;

    final innerPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, outerPaint);
    canvas.drawPath(path, innerPaint);
  }

  @override
  bool shouldRepaint(covariant NeonLinePainter oldDelegate) => true;
}
