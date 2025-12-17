import 'package:flutter/material.dart';

/// A card widget representing a shape option in the 3D animation switcher.
class ShapeCard extends StatelessWidget {
  const ShapeCard({super.key, required this.label, required this.index, required this.controller, required this.onTap});

  final String label;
  final int index;
  final PageController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final page = controller.hasClients ? (controller.page ?? controller.initialPage.toDouble()) : 0.0;
        final distance = (page - index).abs().clamp(0.0, 1.0).toDouble();
        final t = (1 - distance).toDouble();

        return Center(
          child: Transform.scale(
            scale: 0.92 + 0.08 * t,
            child: Opacity(
              opacity: 0.55 + 0.45 * t,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFB8F1FF).withValues(alpha: 0.22 + 0.28 * t), width: 1),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF0B1530).withValues(alpha: 0.55 + 0.15 * t),
                        const Color(0xFF070A10).withValues(alpha: 0.35 + 0.20 * t),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFEAF3FF).withValues(alpha: 0.8 + 0.2 * t),
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
