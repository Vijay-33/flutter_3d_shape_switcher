/// A simple 3D vector class.
class Vec3 {
  const Vec3(this.x, this.y, this.z);

  final double x;
  final double y;
  final double z;

  static Vec3 lerp(Vec3 a, Vec3 b, double t) {
    return Vec3(a.x + (b.x - a.x) * t, a.y + (b.y - a.y) * t, a.z + (b.z - a.z) * t);
  }

  Vec3 operator -(Vec3 other) => Vec3(x - other.x, y - other.y, z - other.z);

  Vec3 operator /(double scalar) => Vec3(x / scalar, y / scalar, z / scalar);
}
