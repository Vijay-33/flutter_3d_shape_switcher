import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'dot_morph_painter.dart';
import 'utils/morph_spec.dart';
import 'utils/scroll_behaviour.dart';
import 'utils/utility_functions.dart';
import 'utils/vec_3.dart';
import 'widgets/page_dots.dart';
import 'widgets/shape_glow.dart';

class ThreeDAnimationSwitcherPage extends StatefulWidget {
  const ThreeDAnimationSwitcherPage({super.key});

  @override
  State<ThreeDAnimationSwitcherPage> createState() => _ThreeDAnimationSwitcherPageState();
}

class _ThreeDAnimationSwitcherPageState extends State<ThreeDAnimationSwitcherPage> with SingleTickerProviderStateMixin {
  static const int _pointCount = 2400;
  static const _dotColor = Color(0xFFB8F1FF);

  late final AnimationController _rotationController;
  late final PageController _pageController;

  late final List<List<Vec3>> _shapes;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat();

    _pageController = PageController(initialPage: 0);

    final seeds = UtilityFunctions.generateSeeds(_pointCount);

    final sphere = UtilityFunctions.generateSphere(seeds);
    final cube = UtilityFunctions.generateCubeFromSphere(sphere);
    final heart = UtilityFunctions.normalizeToUnit(UtilityFunctions.center(UtilityFunctions.generateHeart(seeds)));
    final donut = UtilityFunctions.generateDonut(seeds);

    _shapes = [sphere, cube, heart, donut];
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final dotAreaSize = math.min(size.width, size.height) * 0.62;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: ScrollConfiguration(
              behavior: const MouseDraggableScrollBehavior(),
              child: PageView.builder(
                controller: _pageController,
                itemCount: _shapes.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => const SizedBox.expand(),
              ),
            ),
          ),
          IgnorePointer(
            child: SizedBox.square(
              dimension: dotAreaSize,
              child: Stack(
                fit: StackFit.expand,
                clipBehavior: Clip.none,
                children: [
                  Transform.scale(scale: 1.18, child: const ShapeGlow(color: _dotColor)),
                  AnimatedBuilder(
                    animation: Listenable.merge([_rotationController, _pageController]),
                    builder: (context, _) {
                      final page = _pageController.hasClients
                          ? (_pageController.page ?? _pageController.initialPage.toDouble())
                          : 0.0;
                      final morph = MorphSpec.fromPage(page: page, shapeCount: _shapes.length);

                      return CustomPaint(
                        painter: DotMorphPainter(
                          from: _shapes[morph.fromIndex],
                          to: _shapes[morph.toIndex],
                          t: morph.t,
                          rotationY: _rotationController.value * math.pi * 2,
                          dotColor: _dotColor,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: IgnorePointer(
                child: PageDots(controller: _pageController, count: _shapes.length),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
