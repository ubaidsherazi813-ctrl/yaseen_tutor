import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Pixel-perfect vector Google 'G' icon that renders offline at any size
/// using Google's official 4 brand colors: Blue, Red, Yellow, Green.
class GoogleLogo extends StatelessWidget {
  final double size;
  const GoogleLogo({super.key, this.size = 22});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GoogleLogoPainter(),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double cy = h / 2;
    final double stroke = w * 0.22;
    final double radius = (w - stroke) / 2;

    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: radius);

    // Official Google Brand Colors
    final redPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    final yellowPaint = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    final greenPaint = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    final bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    final blueFillPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;

    // 1. Red Arc: Top section (-45° to -145°)
    canvas.drawArc(rect, -math.pi / 4, -math.pi * 0.55, false, redPaint);

    // 2. Yellow Arc: Left section (-145° to -225°)
    canvas.drawArc(rect, -math.pi * 0.8, -math.pi * 0.45, false, yellowPaint);

    // 3. Green Arc: Bottom section (-225° to -315°)
    canvas.drawArc(rect, -math.pi * 1.25, -math.pi * 0.55, false, greenPaint);

    // 4. Blue Arc: Bottom-right section
    canvas.drawArc(rect, 0, math.pi * 0.2, false, bluePaint);

    // 5. Blue Horizontal Bar: From center to right edge
    final barRect = Rect.fromLTWH(
      cx - stroke * 0.2,
      cy - stroke / 2,
      radius + stroke * 0.5,
      stroke,
    );
    canvas.drawRect(barRect, blueFillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
