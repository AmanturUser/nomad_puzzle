import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/tour.dart';
import '../bloc/tour_details_bloc.dart';
import '../widgets/tour_card.dart' show formatPrice, pluralDays;

class TourDetailsPage extends StatelessWidget {
  const TourDetailsPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TourDetailsBloc>()..add(TourDetailsRequested(id)),
      child: const _TourDetailsView(),
    );
  }
}

class _TourDetailsView extends StatelessWidget {
  const _TourDetailsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TourDetailsBloc, TourDetailsState>(
        listener: (context, state) {
          if (state.errorMessage != null &&
              state.status != TourDetailsStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          final tour = state.tour;
          if (tour == null) {
            if (state.status == TourDetailsStatus.failure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(state.errorMessage ?? 'Ошибка загрузки тура'),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }
          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<TourDetailsBloc>()
                      .add(TourDetailsRequested(tour.id));
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(child: _HeroImage(tour: tour)),
                    SliverToBoxAdapter(
                      child: _Content(tour: tour, state: state),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: MediaQuery.paddingOf(context).bottom + 140,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: MediaQuery.paddingOf(context).top + 8,
                left: 12,
                child: _GlassButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () => context.pop(),
                ),
              ),
              if (tour.departures.any((d) => d.isOpen))
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.paddingOf(context).bottom + 16,
                  child: _BookCta(tour: tour),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.tour});
  final Tour tour;

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    return Stack(
      children: [
        Hero(
          tag: 'tour_image_${tour.id}',
          child: SizedBox(
            width: double.infinity,
            height: 360,
            child: tour.heroImageUrl.isEmpty
                ? const ColoredBox(color: AppColors.surfaceDim)
                : CachedNetworkImage(
                    imageUrl: tour.heroImageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, _) =>
                        const ColoredBox(color: AppColors.surfaceDim),
                    errorWidget: (_, _, _) =>
                        const ColoredBox(color: AppColors.surfaceDim),
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
  const _Content({required this.tour, required this.state});
  final Tour tour;
  final TourDetailsState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ChipsRow(tour: tour)
              .animate()
              .fadeIn(delay: 100.ms)
              .slideY(begin: 0.3, end: 0),
          const SizedBox(height: 16),
          Text(
            tour.title,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: 30,
                ),
          ).animate().fadeIn(delay: 160.ms).slideY(begin: 0.3, end: 0),
          const SizedBox(height: 8),
          if (tour.shortDescription.isNotEmpty)
            Text(
              tour.shortDescription,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
            ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 18),
          _PriceRow(tour: tour)
              .animate()
              .fadeIn(delay: 220.ms)
              .slideY(begin: 0.3, end: 0),
          const SizedBox(height: 24),
          _Section(
            title: 'Описание',
            child: Text(
              tour.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          if (tour.programDays.isNotEmpty) ...[
            const SizedBox(height: 24),
            _Section(
              title: 'Программа',
              child: _ProgramList(programDays: tour.programDays),
            ),
          ],
          if (tour.accommodations.isNotEmpty) ...[
            const SizedBox(height: 24),
            _Section(
              title: 'Проживание',
              child: _AccommodationsList(items: tour.accommodations),
            ),
          ],
          if (tour.inclusions.isNotEmpty || tour.includesText.isNotEmpty) ...[
            const SizedBox(height: 24),
            _Section(
              title: 'Включено',
              child: _FeatureList(
                icon: Icons.check_circle_rounded,
                color: AppColors.success,
                items: [
                  for (final f in tour.inclusions) f.title,
                  if (tour.inclusions.isEmpty && tour.includesText.isNotEmpty)
                    tour.includesText,
                ],
              ),
            ),
          ],
          if (tour.exclusions.isNotEmpty || tour.excludesText.isNotEmpty) ...[
            const SizedBox(height: 24),
            _Section(
              title: 'Не включено',
              child: _FeatureList(
                icon: Icons.cancel_rounded,
                color: AppColors.error,
                items: [
                  for (final f in tour.exclusions) f.title,
                  if (tour.exclusions.isEmpty && tour.excludesText.isNotEmpty)
                    tour.excludesText,
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          _Section(
            title: 'Даты заездов',
            child: _DeparturesBlock(
              departures: tour.departures,
              loading: state.departuresLoading,
              currency: tour.currency,
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ).animate().fadeIn(delay: 250.ms),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class _ChipsRow extends StatelessWidget {
  const _ChipsRow({required this.tour});
  final Tour tour;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (tour.rating > 0)
          _Chip(
            icon: Icons.star_rounded,
            label: '${tour.rating.toStringAsFixed(1)} '
                '(${tour.reviewsCount})',
            color: AppColors.warning,
          ),
        if (tour.durationDays > 0)
          _Chip(
            icon: Icons.schedule_rounded,
            label: '${tour.durationDays} ${pluralDays(tour.durationDays)}',
            color: AppColors.accent,
          ),
        if (tour.displayLocation.isNotEmpty && tour.displayLocation != '—')
          _Chip(
            icon: Icons.place_outlined,
            label: tour.displayLocation,
            color: AppColors.secondary,
          ),
        _Chip(
          icon: Icons.bolt_rounded,
          label: _difficultyLabel(tour.difficulty),
          color: _difficultyColor(tour.difficulty),
        ),
        if (tour.maxGroupSize > 0)
          _Chip(
            icon: Icons.groups_rounded,
            label: tour.minGroupSize > 0
                ? '${tour.minGroupSize}–${tour.maxGroupSize} чел.'
                : 'до ${tour.maxGroupSize} чел.',
            color: AppColors.primary,
          ),
      ],
    );
  }

  String _difficultyLabel(TourDifficulty d) => switch (d) {
        TourDifficulty.easy ||
        TourDifficulty.moderate =>
          'Классический',
        TourDifficulty.hard ||
        TourDifficulty.extreme =>
          'Отважный',
      };

  Color _difficultyColor(TourDifficulty d) => switch (d) {
        TourDifficulty.easy ||
        TourDifficulty.moderate =>
          AppColors.success,
        TourDifficulty.hard ||
        TourDifficulty.extreme =>
          AppColors.error,
      };
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.tour});
  final Tour tour;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.payments_outlined,
            color: AppColors.primaryDeep,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('от', style: Theme.of(context).textTheme.labelSmall),
            Text(
              formatPrice(tour.price, tour.currency),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.primaryDeep,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProgramList extends StatelessWidget {
  const _ProgramList({required this.programDays});
  final List<TourProgramDay> programDays;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final day in programDays) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'День ${day.dayNumber}',
                        style: const TextStyle(
                          color: AppColors.primaryDeep,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        day.title,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ],
                ),
                if (day.body.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    day.body,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _AccommodationsList extends StatelessWidget {
  const _AccommodationsList({required this.items});
  final List<TourAccommodation> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final a in items)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Row(
              children: [
                if (a.imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: CachedNetworkImage(
                        imageUrl: a.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, _) =>
                            const ColoredBox(color: AppColors.surfaceDim),
                        errorWidget: (_, _, _) =>
                            const ColoredBox(color: AppColors.surfaceDim),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDim,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.hotel_outlined,
                        color: AppColors.textSecondary),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(a.name,
                          style: Theme.of(context).textTheme.titleSmall),
                      if (a.location.isNotEmpty)
                        Text(
                          a.location,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      if (a.nights > 0)
                        Text(
                          '${a.nights} ноч.',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _FeatureList extends StatelessWidget {
  const _FeatureList({
    required this.icon,
    required this.color,
    required this.items,
  });
  final IconData icon;
  final Color color;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final t in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    t,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _DeparturesBlock extends StatelessWidget {
  const _DeparturesBlock({
    required this.departures,
    required this.loading,
    required this.currency,
  });

  final List<TourDeparture> departures;
  final bool loading;
  final String currency;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (departures.isEmpty) {
      return Text(
        'Дат пока нет — свяжитесь с туроператором.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).hintColor,
            ),
      );
    }
    return Column(
      children: [
        for (final d in departures) _DepartureTile(departure: d),
      ],
    );
  }
}

class _DepartureTile extends StatelessWidget {
  const _DepartureTile({required this.departure});
  final TourDeparture departure;

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('d MMM', 'ru');
    final color = switch (departure.status) {
      DepartureStatus.open => AppColors.success,
      DepartureStatus.full => AppColors.warning,
      DepartureStatus.cancelled => AppColors.error,
      DepartureStatus.completed => AppColors.textSecondary,
      DepartureStatus.unknown => AppColors.textSecondary,
    };
    final statusLabel = switch (departure.status) {
      DepartureStatus.open => 'Открыто',
      DepartureStatus.full => 'Мест нет',
      DepartureStatus.cancelled => 'Отменено',
      DepartureStatus.completed => 'Завершено',
      DepartureStatus.unknown => '',
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.calendar_today_rounded, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${fmt.format(departure.startDate)} — '
                  '${fmt.format(departure.endDate)}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Row(
                  children: [
                    if (departure.seatsTotal > 0)
                      Text(
                        'Свободно ${departure.seatsLeft} '
                        'из ${departure.seatsTotal}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    if (statusLabel.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        '· $statusLabel',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: color,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            formatPrice(departure.price, departure.currency),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primaryDeep,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
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

class _BookCta extends StatelessWidget {
  const _BookCta({required this.tour});
  final Tour tour;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.45),
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
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Бронирование скоро появится ✨'),
            ),
          );
        },
        icon: const Icon(Icons.flight_takeoff_rounded, size: 22),
        label: Text(
          'Забронировать от ${formatPrice(tour.price, tour.currency)}',
        ),
      ),
    );
  }
}
