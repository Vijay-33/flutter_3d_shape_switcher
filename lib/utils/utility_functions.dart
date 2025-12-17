import 'dart:math' as math;

import 'seed_2.dart';
import 'vec_3.dart';

/// A collection of utility functions for generating and manipulating 3D shapes.
class UtilityFunctions {
  /// Generates a list of 2D seeds using the golden ratio conjugate method.
  static List<Seed2> generateSeeds(int count) {
    const goldenRatioConjugate = 0.6180339887498948;
    return List.generate(count, (i) {
      final u = (i + 0.5) / count;
      final v = (i * goldenRatioConjugate) % 1.0;
      return Seed2(u, v);
    }, growable: false);
  }

  /// Generates a sphere shape using spherical coordinates.
  static List<Vec3> generateSphere(List<Seed2> seeds) {
    return List.generate(seeds.length, (i) {
      final u = seeds[i].u;
      final v = seeds[i].v;

      final y = 1.0 - 2.0 * u;
      final theta = v * math.pi * 2;
      final r = math.sqrt(1 - y * y);

      return Vec3(r * math.cos(theta), y, r * math.sin(theta));
    }, growable: false);
  }

  /// Generates a cube shape by projecting points from a sphere onto a cube.
  static List<Vec3> generateCubeFromSphere(List<Vec3> sphere) {
    return List.generate(sphere.length, (i) {
      final p = sphere[i];
      final maxAbs = math.max(p.x.abs(), math.max(p.y.abs(), p.z.abs()));
      return Vec3(p.x / maxAbs, p.y / maxAbs, p.z / maxAbs);
    }, growable: false);
  }

  /// Generates a torus (donut) shape using parametric equations.
  static List<Vec3> generateDonut(List<Seed2> seeds) {
    const major = 0.66;
    const minor = 0.34;

    return List.generate(seeds.length, (i) {
      final theta = seeds[i].u * math.pi * 2;
      final phi = seeds[i].v * math.pi * 2;

      final tube = major + minor * math.cos(phi);
      final x = tube * math.cos(theta);
      final z = tube * math.sin(theta);
      final y = minor * math.sin(phi);

      return Vec3(x, y, z);
    }, growable: false);
  }

  /// Generates a heart shape using parametric equations.
  static List<Vec3> generateHeart(List<Seed2> seeds) {
    return List.generate(seeds.length, (i) {
      final u = seeds[i].u * math.pi;
      final v = seeds[i].v * math.pi * 2;

      final sinU = math.sin(u);
      final radial = 16 * sinU * sinU * sinU;

      final y = 13 * math.cos(u) - 5 * math.cos(2 * u) - 2 * math.cos(3 * u) - math.cos(4 * u);

      final x = radial * math.sin(v);
      final z = radial * math.cos(v);

      return Vec3(x, y, z);
    }, growable: false);
  }

  /// Centers the points around the origin.
  static List<Vec3> center(List<Vec3> points) {
    var minX = double.infinity;
    var maxX = -double.infinity;
    var minY = double.infinity;
    var maxY = -double.infinity;
    var minZ = double.infinity;
    var maxZ = -double.infinity;

    for (final p in points) {
      minX = math.min(minX, p.x);
      maxX = math.max(maxX, p.x);
      minY = math.min(minY, p.y);
      maxY = math.max(maxY, p.y);
      minZ = math.min(minZ, p.z);
      maxZ = math.max(maxZ, p.z);
    }

    final center = Vec3((minX + maxX) / 2, (minY + maxY) / 2, (minZ + maxZ) / 2);

    return List.generate(points.length, (i) => points[i] - center, growable: false);
  }

  /// Scales the points so that the point with the largest absolute coordinate
  /// has an absolute value of 1.0.
  static List<Vec3> normalizeToUnit(List<Vec3> points) {
    var maxAbs = 0.0;
    for (final p in points) {
      maxAbs = math.max(maxAbs, math.max(p.x.abs(), math.max(p.y.abs(), p.z.abs())));
    }

    if (maxAbs == 0) {
      return points;
    }

    return List.generate(points.length, (i) => points[i] / maxAbs, growable: false);
  }
}
