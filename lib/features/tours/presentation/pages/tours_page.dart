import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/lottie_icon.dart';
import '../bloc/tours_bloc.dart';
import '../widgets/tour_card.dart';

class ToursPage extends StatelessWidget {
  const ToursPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ToursBloc>()..add(const ToursRequested()),
      child: const _ToursView(),
    );
  }
}

class _ToursView extends StatelessWidget {
  const _ToursView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ToursBloc, ToursState>(
          builder: (context, state) {
            return switch (state.status) {
              ToursStatus.loading || ToursStatus.initial =>
                const Center(child: CircularProgressIndicator()),
              ToursStatus.failure =>
                Center(child: Text(state.errorMessage ?? 'Error')),
              ToursStatus.success => RefreshIndicator(
                  onRefresh: () async {
                    context.read<ToursBloc>().add(const ToursRequested());
                  },
                  child: CustomScrollView(
                    slivers: [
                      const SliverToBoxAdapter(child: _HeroHeader()),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
                        sliver: SliverList.separated(
                          itemCount: state.items.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 14),
                          itemBuilder: (_, i) {
                            final tour = state.items[i];
                            return TourCard(
                              tour: tour,
                              index: i,
                              onTap: () => context.go(
                                '${AppRoutes.tours}/${AppRoutes.tourDetails}/${tour.id}',
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
      child: Row(
        children: [
          const LottieIcon(
            asset: 'assets/animations/backpack-on-mountains.json',
            size: 80,
            loop: true,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Туры',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 28,
                      ),
                ),
                Text(
                  'Авторские путешествия с местными гидами',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 350.ms)
        .slideY(begin: -0.2, end: 0, curve: Curves.easeOutCubic);
  }
}
