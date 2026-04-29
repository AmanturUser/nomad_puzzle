import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Three bouncing dots used as a typing indicator for the assistant.
class TypingDots extends StatefulWidget {
  const TypingDots({
    super.key,
    this.color = AppColors.primary,
    this.dotSize = 7,
  });

  final Color color;
  final double dotSize;

  @override
  State<TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final t = (_ctrl.value + i / 3) % 1.0;
            final scale = 0.6 + 0.6 * (0.5 + 0.5 * _wave(t));
            final opacity = 0.45 + 0.55 * _wave(t);
            return Padding(
              padding: EdgeInsets.only(right: i == 2 ? 0 : 5),
              child: Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: widget.dotSize,
                    height: widget.dotSize,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  /// Smooth 0..1..0 wave on a 0..1 input.
  double _wave(double t) {
    if (t < 0.5) return t * 2;
    return (1 - t) * 2;
  }
}
