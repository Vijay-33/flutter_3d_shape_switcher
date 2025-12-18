import 'package:flutter/material.dart';

class ShapeGlow extends StatelessWidget {
  const ShapeGlow({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(painter: _ShapeGlowPainter(color: color)),
    );
  }
}

class _ShapeGlowPainter extends CustomPainter {
  const _ShapeGlowPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final shortestSide = size.shortestSide;
    if (shortestSide <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = shortestSide * 0.5;

    final paint = Paint()
      ..blendMode = BlendMode.plus
      ..shader = RadialGradient(
        colors: [color.withValues(alpha: 0.33), color.withValues(alpha: 0.22), color.withValues(alpha: 0)],
        stops: const [0.0, 0.42, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _ShapeGlowPainter oldDelegate) => oldDelegate.color != color;
}
