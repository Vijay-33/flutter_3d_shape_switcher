import 'package:flutter/material.dart';

/// A row of dots indicating the current page in a PageView.
class PageDots extends StatelessWidget {
  const PageDots({super.key, required this.controller, required this.count});

  final PageController controller;
  final int count;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final page = controller.hasClients ? (controller.page ?? controller.initialPage.toDouble()) : 0.0;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(count, (index) {
            final distance = (page - index).abs().clamp(0.0, 1.0).toDouble();
            final t = (1 - distance).toDouble();

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 7.0 + 5.0 * t,
              height: 7,
              decoration: BoxDecoration(
                color: const Color(0xFFB8F1FF).withValues(alpha: 0.25 + 0.55 * t),
                borderRadius: BorderRadius.circular(99),
              ),
            );
          }),
        );
      },
    );
  }
}
