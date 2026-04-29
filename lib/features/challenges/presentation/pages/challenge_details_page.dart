import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/smart_image.dart';
import '../../domain/entities/challenge.dart';
import '../bloc/challenge_details_bloc.dart';

class ChallengeDetailsPage extends StatelessWidget {
  const ChallengeDetailsPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ChallengeDetailsBloc>()
        ..add(ChallengeDetailsRequested(id)),
      child: const _ChallengeDetailsView(),
    );
  }
}

class _ChallengeDetailsView extends StatelessWidget {
  const _ChallengeDetailsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ChallengeDetailsBloc, ChallengeDetailsState>(
        builder: (context, state) {
          final ch = state.challenge;
          if (state.status == ChallengeDetailsStatus.loading || ch == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == ChallengeDetailsStatus.failure) {
            return Center(child: Text(state.errorMessage ?? 'Ошибка'));
          }
          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _HeroImage(challenge: ch)),
                  SliverToBoxAdapter(child: _Content(challenge: ch)),
                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ),
              Positioned(
                top: MediaQuery.paddingOf(context).top + 8,
                left: 12,
                child: _GlassButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () => context.pop(),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: MediaQuery.paddingOf(context).bottom + 16,
                child: _CompleteButton(challenge: ch),
              ),
            ],
          );
        },
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
        SizedBox(
          width: double.infinity,
          height: 340,
          child: SmartImage(
            source: challenge.imageUrl,
            placeholder: (_) =>
                const ColoredBox(color: AppColors.surfaceDim),
            errorWidget: (_) =>
                const ColoredBox(color: AppColors.surfaceDim),
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
                  surface.withValues(alpha: 0.6),
                  surface,
                ],
                stops: const [0, 0.55, 0.88, 1],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.challenge});
  final Challenge challenge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Chip(
                icon: Icons.bolt_rounded,
                label: _diffLabel(challenge.difficulty),
                color: _diffColor(challenge.difficulty),
              ),
              const SizedBox(width: 8),
              _Chip(
                icon: Icons.star_rounded,
                label: '${challenge.rewardPoints} pts',
                color: AppColors.primary,
              ),
              if (challenge.estimatedMinutes != null) ...[
                const SizedBox(width: 8),
                _Chip(
                  icon: Icons.schedule_rounded,
                  label: '${challenge.estimatedMinutes} мин',
                  color: AppColors.accent,
                ),
              ],
            ],
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.3, end: 0),
          const SizedBox(height: 16),
          Text(
            challenge.title,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: 30,
                ),
          ).animate().fadeIn(delay: 160.ms).slideY(begin: 0.3, end: 0),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.place_outlined,
                size: 18,
                color: Theme.of(context).hintColor,
              ),
              const SizedBox(width: 6),
              Text(
                challenge.location,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ).animate().fadeIn(delay: 220.ms).slideY(begin: 0.3, end: 0),
          const SizedBox(height: 20),
          Text(
            challenge.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ).animate().fadeIn(delay: 280.ms).slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }

  String _diffLabel(ChallengeDifficulty d) => switch (d) {
        ChallengeDifficulty.easy => 'Классический',
        ChallengeDifficulty.hard => 'Отважный',
      };

  Color _diffColor(ChallengeDifficulty d) => switch (d) {
        ChallengeDifficulty.easy => AppColors.success,
        ChallengeDifficulty.hard => AppColors.error,
      };
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 15),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  const _GlassButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.85),
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: AppColors.textPrimary, size: 22),
        ),
      ),
    );
  }
}

class _CompleteButton extends StatelessWidget {
  const _CompleteButton({required this.challenge});
  final Challenge challenge;

  @override
  Widget build(BuildContext context) {
    final isDone = challenge.status == ChallengeStatus.completed;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: isDone ? null : AppColors.primaryGradient,
        color: isDone ? AppColors.success : null,
        boxShadow: [
          BoxShadow(
            color: (isDone ? AppColors.success : AppColors.primary)
                .withValues(alpha: 0.45),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: const Size.fromHeight(60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        onPressed: isDone
            ? null
            : () => context
                .read<ChallengeDetailsBloc>()
                .add(ChallengeDetailsCompleted(challenge.id)),
        icon: Icon(
          isDone ? Icons.check_circle_rounded : Icons.flag_circle_rounded,
          size: 22,
        ),
        label: Text(isDone ? 'Квест выполнен' : 'Отметить выполненным'),
      ),
    );
  }
}
