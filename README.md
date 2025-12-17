# Flutter 3D Shape Switcher (3D Morph Animator)

A small Flutter demo that renders a rotating 3D point cloud and morphs it between multiple shapes (sphere, cube, heart, donut). The morph progress is driven by a `PageView`, so you can scrub transitions by swiping (or tap a card to jump).

## Demo Controls

- Swipe the bottom shape switcher to morph between shapes.
- Tap a shape card to animate directly to it.
- The shape continuously rotates around the Y axis.

## How It Works

- **Point cloud**: Each shape is represented as a `List<Vec3>` with a fixed number of points.
- **Stable correspondence**: A deterministic list of 2D seeds (`Seed2`) is generated once and reused, so each point index maps consistently across shapes. This makes morphing as simple as `Vec3.lerp(from[i], to[i], t)`.
- **Rendering**: `DotMorphPainter` applies a small X tilt, rotates the points around Y, projects them into 2D with a basic perspective transform, then draws each point as a circle with depth-based size/opacity.

## Key Files

- `lib/three_dot_animation_switcher_page.dart` — UI, shape generation, and morph/rotation wiring.
- `lib/dot_morph_painter.dart` — 3D → 2D projection and dot rendering.
- `lib/utils/utility_functions.dart` — point generators for sphere/cube/heart/donut.
- `lib/utils/morph_spec.dart` — maps page position to morph indices and progress (`t`).

## Run Locally

Prerequisites: Flutter (Dart SDK) installed. This demo can run on any platform Flutter supports (mobile, desktop, and web).

```bash
flutter pub get
flutter run
```

## Customize

- **Point density**: tweak `_pointCount` in `lib/three_dot_animation_switcher_page.dart`.
- **Add a new shape**: generate a new `List<Vec3>` of the same length and append it to `_shapes` (and add a label to `_shapeLabels`).
- **Look & feel**: adjust perspective/tilt/dot sizing in `lib/dot_morph_painter.dart`.

## License

Licensed under **The Unlicense** — do whatever you want with this code. See `LICENSE`.
