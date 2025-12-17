import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'dot_morph_painter.dart';
import 'utils/morph_spec.dart';
import 'utils/scroll_behaviour.dart';
import 'utils/utility_functions.dart';
import 'utils/vec_3.dart';
import 'widgets/page_dots.dart';
import 'widgets/shape_card.dart';
import 'widgets/title_widget.dart';

class ThreeDAnimationSwitcherPage extends StatefulWidget {
  const ThreeDAnimationSwitcherPage({super.key});

  @override
  State<ThreeDAnimationSwitcherPage> createState() => _ThreeDAnimationSwitcherPageState();
}

class _ThreeDAnimationSwitcherPageState extends State<ThreeDAnimationSwitcherPage> with SingleTickerProviderStateMixin {
  static const _shapeLabels = ['Sphere', 'Cube', 'Heart', 'Donut'];
  static const int _pointCount = 1200;

  late final AnimationController _rotationController;
  late final PageController _pageController;

  late final List<List<Vec3>> _shapes;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat();

    _pageController = PageController(initialPage: 0, viewportFraction: 0.6);

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

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF070A10), Color(0xFF0A1224)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(top: MediaQuery.viewPaddingOf(context).top + 12, left: 16, right: 16, child: const PageTitle()),
            Center(
              child: AnimatedBuilder(
                animation: Listenable.merge([_rotationController, _pageController]),
                builder: (context, _) {
                  final page = _pageController.hasClients ? (_pageController.page ?? 0.0) : 0.0;
                  final morph = MorphSpec.fromPage(page: page, shapeCount: _shapes.length);

                  final dotAreaSize = math.min(size.width, size.height) * 0.62;

                  return SizedBox.square(
                    dimension: dotAreaSize,
                    child: CustomPaint(
                      painter: DotMorphPainter(
                        from: _shapes[morph.fromIndex],
                        to: _shapes[morph.toIndex],
                        t: morph.t,
                        rotationY: _rotationController.value * math.pi * 2,
                        dotColor: const Color(0xFFB8F1FF),
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                top: false,
                minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: SizedBox(
                  height: 128,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 82,
                        child: ScrollConfiguration(
                          behavior: const MouseDraggableScrollBehavior(),
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: _shapeLabels.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ShapeCard(
                                label: _shapeLabels[index],
                                index: index,
                                controller: _pageController,
                                onTap: () {
                                  _pageController.animateToPage(
                                    index,
                                    duration: const Duration(milliseconds: 350),
                                    curve: Curves.easeOutCubic,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      PageDots(controller: _pageController, count: _shapeLabels.length),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
