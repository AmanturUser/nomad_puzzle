import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../router/app_routes.dart';
import '../theme/app_colors.dart';
import 'lottie_icon.dart';

class ChatFab extends StatelessWidget {
  const ChatFab({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          HapticFeedback.lightImpact();
          context.push(AppRoutes.aiChat);
        },
        child: const SizedBox(
          width: 96,
          height: 96,
          child: Center(
            child: AiSpotlightIcon(
              asset: 'assets/animations/robot-kalpak-wave.json',
              size: 96,
              iconSize: 76,
            ),
          ),
        ),
      ),
    );
  }
}

/// Soft white circle with a primary border and a glowing halo behind a Lottie
/// icon. Mirrors the look of the active Lottie tab in the bottom nav.
class AiSpotlightIcon extends StatefulWidget {
  const AiSpotlightIcon({
    super.key,
    required this.asset,
    this.size = 76,
    this.iconSize = 56,
    this.loop = true,
  });

  final String asset;
  final double size;
  final double iconSize;
  final bool loop;

  @override
  State<AiSpotlightIcon> createState() => _AiSpotlightIconState();
}

class _AiSpotlightIconState extends State<AiSpotlightIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, child) {
          final t = _ctrl.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              // Soft outer halo (breathing).
              DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.30 + 0.10 * t),
                      AppColors.primary.withValues(alpha: 0),
                    ],
                  ),
                ),
                child: SizedBox(width: widget.size, height: widget.size),
              ),
              // Inner white pill with primary border and glow.
              Transform.scale(
                scale: 0.82 + 0.04 * t,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.45),
                        blurRadius: 14 + 6 * t,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: child,
                ),
              ),
            ],
          );
        },
        child: LottieIcon(
          asset: widget.asset,
          size: widget.iconSize,
          loop: widget.loop,
        ),
      ),
    );
  }
}
