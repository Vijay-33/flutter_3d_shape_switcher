import 'package:flutter/material.dart';

/// A widget that displays the title and subtitle for the 3D Morph Switcher.
class PageTitle extends StatelessWidget {
  const PageTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '3D Morph Switcher',
          style: TextStyle(color: Color(0xFFEAF3FF), fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.6),
        ),
        const SizedBox(height: 8),
        Text(
          'Swipe the switcher to morph shapes.',
          style: TextStyle(
            color: const Color(0xFFEAF3FF).withValues(alpha: 0.72),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
