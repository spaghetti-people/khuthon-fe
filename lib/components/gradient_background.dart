import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 단색 배경
        Container(color: const Color(0xFFF3F4F6)),
        // 그라데이션 오버레이
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFFCFCFC).withAlpha((255 * 0.05).toInt()),
                const Color(0xFF3B82F6).withAlpha((255 * 0.05).toInt()),
              ],
              stops: const [0.4, 1.0],
            ),
          ),
        ),
        // 실제 내용
        child,
      ],
    );
  }
}
