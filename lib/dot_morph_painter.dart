import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'utils/vec_3.dart';

/// A custom painter that morphs between two 3D dot shapes with rotation.
class DotMorphPainter extends CustomPainter {
  const DotMorphPainter({
    required this.from,
    required this.to,
    required this.t,
    required this.rotationY,
    required this.dotColor,
  });

  final List<Vec3> from;
  final List<Vec3> to;
  final double t;
  final double rotationY;
  final Color dotColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final baseScale = size.shortestSide * 0.42;
    final baseDotRadius = (size.shortestSide * 0.0042).clamp(1.2, 2.8).toDouble() * 0.5;

    const cameraDistance = 4.2;
    const tiltX = 0.35;

    final cosX = math.cos(tiltX);
    final sinX = math.sin(tiltX);
    final cosY = math.cos(rotationY);
    final sinY = math.sin(rotationY);

    final paint = Paint()..style = PaintingStyle.fill;

    for (var i = 0; i < from.length; i++) {
      final p = Vec3.lerp(from[i], to[i], t);

      final y1 = p.y * cosX - p.z * sinX;
      final z1 = p.y * sinX + p.z * cosX;

      final x2 = p.x * cosY - z1 * sinY;
      final z2 = p.x * sinY + z1 * cosY;

      final perspective = cameraDistance / (cameraDistance - z2);
      final depth01 = ((z2 + 1.25) / 2.5).clamp(0.0, 1.0).toDouble();

      final dx = center.dx + x2 * baseScale * perspective;
      final dy = center.dy + y1 * baseScale * perspective;

      final radius = baseDotRadius * (0.65 + 1.05 * depth01) * (0.82 + 0.22 * perspective);
      final opacity = (0.18 + 0.82 * depth01).clamp(0.0, 1.0).toDouble();

      paint.color = dotColor.withValues(alpha: opacity);
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant DotMorphPainter oldDelegate) {
    return oldDelegate.t != t ||
        oldDelegate.rotationY != rotationY ||
        oldDelegate.from != from ||
        oldDelegate.to != to ||
        oldDelegate.dotColor != dotColor;
  }
}
