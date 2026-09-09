import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Paints a dashed border line along the top edge of a rounded rect.
/// The truck rides on this line.
class TruckTrackPainter extends CustomPainter {
  final double radius;
  final Color trackColor;
  final double strokeWidth;

  const TruckTrackPainter({
    required this.radius,
    this.trackColor = const Color(0xFFE0E0E0),
    this.strokeWidth = 1.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Start at top-right rounded corner entry (right edge, top)
    path.moveTo(size.width, radius);

    // Right top corner arc
    path.arcTo(
      Rect.fromLTWH(size.width - radius * 2, 0, radius * 2, radius * 2),
      0,            // start angle (right)
      -math.pi / 2, // sweep CCW to top
      false,
    );

    // Straight top edge
    path.lineTo(radius, 0);

    // Left top corner arc
    path.arcTo(
      Rect.fromLTWH(0, 0, radius * 2, radius * 2),
      -math.pi / 2, // start at top
      -math.pi / 2, // sweep CCW to left
      false,
    );

    // Draw dashed
    _drawDashed(canvas, path, paint);
  }

  void _drawDashed(Canvas canvas, Path path, Paint paint) {
    const dashLen  = 6.0;
    const gapLen   = 4.0;
    final metrics  = path.computeMetrics();
    for (final metric in metrics) {
      double dist = 0;
      bool   draw = true;
      while (dist < metric.length) {
        final len = draw ? dashLen : gapLen;
        if (draw) {
          canvas.drawPath(
            metric.extractPath(dist, dist + len),
            paint,
          );
        }
        dist += len;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(TruckTrackPainter old) =>
      old.trackColor != trackColor || old.strokeWidth != strokeWidth;
}