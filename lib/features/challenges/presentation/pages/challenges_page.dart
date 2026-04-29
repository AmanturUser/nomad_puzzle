import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/lottie_icon.dart';
import '../bloc/challenges_bloc.dart';
import '../widgets/challenge_tile.dart';

class ChallengesPage extends StatelessWidget {
  const ChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ChallengesBloc>()..add(const ChallengesRequested()),
      child: const _ChallengesView(),
    );
  }
}

class _ChallengesView extends StatelessWidget {
  const _ChallengesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ChallengesBloc, ChallengesState>(
          builder: (context, state) {
            return switch (state.status) {
              ChallengesStatus.loading || ChallengesStatus.initial =>
                const Center(child: CircularProgressIndicator()),
              ChallengesStatus.failure => Center(
                  child: Text(state.errorMessage ?? 'Error'),
                ),
              ChallengesStatus.success => RefreshIndicator(
                  onRefresh: () async {
                    context
                        .read<ChallengesBloc>()
                        .add(const ChallengesRequested());
                  },
                  child: CustomScrollView(
                    slivers: [
                      const SliverToBoxAdapter(child: _HeroHeader()),
                      SliverPadding(
                        padding:
                            const EdgeInsets.fromLTRB(20, 4, 20, 120),
                        sliver: SliverList.separated(
                          itemCount: state.items.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 14),
                          itemBuilder: (_, i) {
                            final ch = state.items[i];
                            return ChallengeTile(
                              challenge: ch,
                              index: i,
                              onTap: () => context.go(
                                '${AppRoutes.challenges}/${AppRoutes.challengeDetails}/${ch.id}',
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
            };
          },
        ),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const LottieIcon(
                asset: 'assets/animations/challenges.json',
                size: 80,
                loop: true,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Квесты',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontSize: 28,
                              ),
                    ),
                    Text(
                      'Выполняй задания и собирай очки',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 350.ms)
        .slideY(begin: -0.2, end: 0, curve: Curves.easeOutCubic);
  }
}
