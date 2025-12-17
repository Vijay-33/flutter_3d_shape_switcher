import 'dart:math' as math;

/// Specifies the morphing state between two shapes.
class MorphSpec {
  const MorphSpec({required this.fromIndex, required this.toIndex, required this.t});

  final int fromIndex;
  final int toIndex;
  final double t;

  static MorphSpec fromPage({required double page, required int shapeCount}) {
    if (shapeCount <= 1) {
      return const MorphSpec(fromIndex: 0, toIndex: 0, t: 0);
    }

    final clamped = page.clamp(0.0, (shapeCount - 1).toDouble()).toDouble();
    final fromIndex = clamped.floor();
    final toIndex = math.min(fromIndex + 1, shapeCount - 1);
    final t = toIndex == fromIndex ? 0.0 : (clamped - fromIndex).clamp(0.0, 1.0).toDouble();

    return MorphSpec(fromIndex: fromIndex, toIndex: toIndex, t: t);
  }
}
