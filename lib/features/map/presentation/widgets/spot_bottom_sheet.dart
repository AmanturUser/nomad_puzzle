import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/smart_image.dart';
import '../../../challenges/domain/entities/challenge.dart';

class SpotBottomSheet extends StatelessWidget {
  const SpotBottomSheet({
    super.key,
    required this.challenge,
    required this.isSubmitting,
    required this.onProveVisit,
  });

  final Challenge challenge;
  final bool isSubmitting;
  final Future<void> Function() onProveVisit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _HeroImage(challenge: challenge),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatusBadge(status: challenge.status)
                        .animate()
                        .fadeIn(delay: 80.ms, duration: 300.ms)
                        .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
                    const SizedBox(height: 12),
                    Text(
                      challenge.title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.6,
                            height: 1.1,
                          ),
                    )
                        .animate()
                        .fadeIn(delay: 140.ms, duration: 350.ms)
                        .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.place_outlined,
                          size: 18,
                          color: Theme.of(context).hintColor,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            challenge.location,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        _RewardChip(points: challenge.rewardPoints),
                      ],
                    )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 350.ms)
                        .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
                    const SizedBox(height: 18),
                    Text(
                      challenge.description,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.5,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    )
                        .animate()
                        .fadeIn(delay: 260.ms, duration: 400.ms)
                        .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: _ProveButton(
                    status: challenge.status,
                    isSubmitting: isSubmitting,
                    onTap: () async {
                      HapticFeedback.mediumImpact();
                      await onProveVisit();
                    },
                  ),
                )
                    .animate()
                    .fadeIn(delay: 340.ms, duration: 400.ms)
                    .slideY(begin: 0.4, end: 0, curve: Curves.easeOutCubic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.challenge});
  final Challenge challenge;

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    return Stack(
      children: [
        Hero(
          tag: 'challenge_image_${challenge.id}',
          child: SizedBox(
            width: double.infinity,
            height: 260,
            child: SmartImage(
              source: challenge.imageUrl,
              placeholder: (_) => Shimmer.fromColors(
                baseColor: AppColors.surfaceDim,
                highlightColor: Colors.white,
                child: Container(color: AppColors.surfaceDim),
              ),
              errorWidget: (_) => Container(
                color: AppColors.surfaceDim,
                child: const Center(
                  child: Icon(
                    Icons.landscape_rounded,
                    size: 48,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  surface.withValues(alpha: 0.7),
                  surface,
                ],
                stops: const [0, 0.45, 0.85, 1],
              ),
            ),
          ),
        ),
        const Positioned(top: 14, left: 0, right: 0, child: _DragHandle()),
      ],
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 44,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final ChallengeStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = switch (status) {
      ChallengeStatus.locked => (
        'Скоро откроется',
        const Color(0xFF6B6B6B),
        Icons.lock_outline_rounded,
      ),
      ChallengeStatus.available => (
        'Ещё не выполнено',
        const Color(0xFFE53935),
        Icons.flag_outlined,
      ),
      ChallengeStatus.inProgress => (
        'Проверяем фото…',
        const Color(0xFFE0A81F),
        Icons.hourglass_top_rounded,
      ),
      ChallengeStatus.completed => (
        'Выполнено',
        const Color(0xFF2FA84F),
        Icons.check_circle_rounded,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardChip extends StatelessWidget {
  const _RewardChip({required this.points});
  final int points;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Colors.white, size: 14),
          const SizedBox(width: 3),
          Text(
            '$points',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProveButton extends StatelessWidget {
  const _ProveButton({
    required this.status,
    required this.isSubmitting,
    required this.onTap,
  });

  final ChallengeStatus status;
  final bool isSubmitting;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (status == ChallengeStatus.completed) {
      return FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF2FA84F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        onPressed: null,
        icon: const Icon(Icons.check_circle_rounded),
        label: const Text('Квест выполнен'),
      );
    }
    if (isSubmitting || status == ChallengeStatus.inProgress) {
      return FilledButton(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: null,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 14),
            Text(
              'Сервер проверяет…',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFFE07A1F), Color(0xFFE53935)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE07A1F).withValues(alpha: 0.45),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
        onPressed: onTap,
        icon: const Icon(Icons.photo_camera_rounded, size: 22),
        label: const Text('Подтвердить визит'),
      )
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .shimmer(
            duration: 2500.ms,
            color: Colors.white.withValues(alpha: 0.35),
          ),
    );
  }
}
