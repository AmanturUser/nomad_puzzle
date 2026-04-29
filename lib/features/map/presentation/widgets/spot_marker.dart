import 'package:flutter/material.dart';

import '../../../../core/widgets/smart_image.dart';
import '../../../challenges/domain/entities/challenge.dart';

class SpotMarker extends StatelessWidget {
  const SpotMarker({
    super.key,
    required this.challenge,
    required this.onTap,
  });

  final Challenge challenge;
  final VoidCallback onTap;

  static const _easyColor = Color(0xFFFFC857);
  static const _hardColor = Color(0xFF4A90B8);
  static const _completedColor = Color(0xFF2FA84F);
  static const _pendingColor = Color(0xFFE0A81F);

  Color get _ringColor {
    if (challenge.status == ChallengeStatus.completed) return _completedColor;
    if (challenge.status == ChallengeStatus.inProgress) return _pendingColor;
    return switch (challenge.difficulty) {
      ChallengeDifficulty.easy => _easyColor,
      ChallengeDifficulty.hard => _hardColor,
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: RepaintBoundary(
        child: SizedBox(
          width: 56,
          height: 70,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              if (challenge.status == ChallengeStatus.completed)
                _VisitedAura(color: _ringColor),
              if (challenge.status == ChallengeStatus.inProgress)
                _PulsingRing(color: _ringColor),
              Positioned(
                bottom: 4,
                child: CustomPaint(
                  size: const Size(14, 14),
                  painter: _PinTailPainter(color: _ringColor),
                ),
              ),
              _PhotoPin(
                imageUrl: challenge.imageUrl,
                ringColor: _ringColor,
                status: challenge.status,
                difficulty: challenge.difficulty,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotoPin extends StatelessWidget {
  const _PhotoPin({
    required this.imageUrl,
    required this.ringColor,
    required this.status,
    required this.difficulty,
  });

  final String imageUrl;
  final Color ringColor;
  final ChallengeStatus status;
  final ChallengeDifficulty difficulty;

  IconData get _difficultyIcon => switch (difficulty) {
        ChallengeDifficulty.easy => Icons.spa_rounded,
        ChallengeDifficulty.hard => Icons.ac_unit_rounded,
      };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: ringColor, width: 3.5),
              boxShadow: [
                BoxShadow(
                  color: ringColor.withValues(alpha: 0.45),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.5),
              child: ClipOval(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    SmartImage(
                      source: imageUrl,
                      placeholder: (_) =>
                          const ColoredBox(color: Color(0xFFEFEFEF)),
                      errorWidget: (_) => ColoredBox(
                        color: ringColor.withValues(alpha: 0.2),
                        child: const Icon(Icons.landscape, size: 20),
                      ),
                    ),
                    if (status == ChallengeStatus.completed)
                      ColoredBox(
                        color: Colors.black.withValues(alpha: 0.18),
                        child: const Center(
                          child: Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 26,
                            shadows: [
                              Shadow(color: Colors.black54, blurRadius: 6),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -3,
            right: -3,
            child: _DifficultyBadge(
              icon: _difficultyIcon,
              color: ringColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  const _DifficultyBadge({required this.icon, required this.color});
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 6,
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 11),
    );
  }
}

class _PinTailPainter extends CustomPainter {
  _PinTailPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PinTailPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _PulsingRing extends StatefulWidget {
  const _PulsingRing({required this.color});
  final Color color;

  @override
  State<_PulsingRing> createState() => _PulsingRingState();
}

class _PulsingRingState extends State<_PulsingRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
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
      builder: (_, _) {
        final t = _ctrl.value;
        return Positioned(
          top: -10,
          child: Container(
            width: 72 + 40 * t,
            height: 72 + 40 * t,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color.withValues(alpha: 0.35 * (1 - t)),
            ),
          ),
        );
      },
    );
  }
}

class _VisitedAura extends StatefulWidget {
  const _VisitedAura({required this.color});
  final Color color;

  @override
  State<_VisitedAura> createState() => _VisitedAuraState();
}

class _VisitedAuraState extends State<_VisitedAura>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2800),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, _) {
        return Container(
          width: 60 + 8 * _ctrl.value,
          height: 60 + 8 * _ctrl.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color.withValues(alpha: 0.22 * _ctrl.value),
          ),
        );
      },
    );
  }
}
