import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/nomad_logo_lottie.dart';
import '../../../challenges/domain/entities/challenge.dart';
import '../../data/kg_border_points.dart';
import '../../data/kg_zones.dart';
import '../bloc/map_bloc.dart';
import '../widgets/spot_bottom_sheet.dart';
import '../widgets/spot_marker.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MapBloc>()..add(const MapChallengesRequested()),
      child: const _MapView(),
    );
  }
}

class _MapView extends StatefulWidget {
  const _MapView();

  @override
  State<_MapView> createState() => _MapViewState();
}

class _MapViewState extends State<_MapView> {
  static final _kgBounds = LatLngBounds(
    const LatLng(39.18, 69.27),
    const LatLng(43.27, 80.29),
  );
  static const _kgCenter = LatLng(41.3, 74.9);

  final _controller = MapController();
  final _picker = ImagePicker();
  final _confetti = ConfettiController(duration: const Duration(seconds: 2));

  Set<ChallengeDifficulty> _enabledDifficulties = {
    ChallengeDifficulty.easy,
    ChallengeDifficulty.hard,
  };
  bool _showCompleted = true;

  bool _passesFilter(Challenge c) {
    if (!_enabledDifficulties.contains(c.difficulty)) return false;
    if (!_showCompleted && c.status == ChallengeStatus.completed) {
      return false;
    }
    return true;
  }

  void _toggleDifficulty(ChallengeDifficulty d) {
    setState(() {
      if (_enabledDifficulties.contains(d)) {
        if (_enabledDifficulties.length > 1) {
          _enabledDifficulties = {..._enabledDifficulties}..remove(d);
        }
      } else {
        _enabledDifficulties = {..._enabledDifficulties, d};
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _confetti.dispose();
    super.dispose();
  }

  static const _cityLabels = <_PlaceLabel>[
    _PlaceLabel('Бишкек', 42.87, 74.59, _LabelKind.capital),
    _PlaceLabel('Ош', 40.51, 72.80, _LabelKind.bigCity),
    _PlaceLabel('Каракол', 42.49, 78.39, _LabelKind.city),
    _PlaceLabel('Нарын', 41.42, 75.99, _LabelKind.city),
    _PlaceLabel('Талас', 42.52, 72.24, _LabelKind.city),
    _PlaceLabel('Жалал-Абад', 40.93, 73.00, _LabelKind.city),
    _PlaceLabel('Баткен', 40.06, 70.81, _LabelKind.city),
    _PlaceLabel('Токмок', 42.84, 75.30, _LabelKind.smallCity),
    _PlaceLabel('Балыкчы', 42.46, 76.18, _LabelKind.smallCity),
    _PlaceLabel('Чолпон-Ата', 42.65, 77.08, _LabelKind.smallCity),
    _PlaceLabel('Кочкор', 42.21, 75.76, _LabelKind.smallCity),
    _PlaceLabel('Ат-Башы', 41.17, 75.81, _LabelKind.smallCity),
    _PlaceLabel('оз. Иссык-Куль', 42.45, 77.20, _LabelKind.water),
    _PlaceLabel('оз. Сон-Көль', 41.83, 75.12, _LabelKind.water),
    _PlaceLabel('оз. Чатыр-Көль', 40.61, 75.38, _LabelKind.water),
  ];

  List<Marker> _buildLabelMarkers(BuildContext context) {
    return [
      for (final p in _cityLabels)
        Marker(
          point: LatLng(p.lat, p.lng),
          width: 130,
          height: 26,
          alignment: Alignment.center,
          child: IgnorePointer(
            child: _PlaceLabelChip(label: p),
          ),
        ),
    ];
  }

  Color _zoneColor(Challenge c) => switch (c.status) {
        ChallengeStatus.locked =>
          const Color(0xFF6B6B6B).withValues(alpha: 0.45),
        ChallengeStatus.available =>
          const Color(0xFFDC4D3E).withValues(alpha: 0.55),
        ChallengeStatus.inProgress =>
          const Color(0xFFE0A81F).withValues(alpha: 0.45),
        ChallengeStatus.completed =>
          const Color(0xFF2D8B57).withValues(alpha: 0.18),
      };

  Color _zoneBorder(Challenge c) => switch (c.status) {
        ChallengeStatus.locked =>
          const Color(0xFF6B6B6B).withValues(alpha: 0.7),
        ChallengeStatus.available =>
          const Color(0xFFDC4D3E).withValues(alpha: 0.85),
        ChallengeStatus.inProgress =>
          const Color(0xFFE0A81F).withValues(alpha: 0.85),
        ChallengeStatus.completed =>
          const Color(0xFF2D8B57).withValues(alpha: 0.55),
      };

  Future<void> _onProveVisit(Challenge challenge) async {
    final source = await showModalBottomSheet<_PhotoSource>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(ctx).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 18),
            ListTile(
              leading: const Icon(Icons.photo_camera_rounded),
              title: const Text('Сделать фото'),
              subtitle: const Text('Одно фото с камеры'),
              onTap: () => Navigator.of(ctx).pop(_PhotoSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('Выбрать из галереи'),
              subtitle: const Text('До 10 фото'),
              onTap: () => Navigator.of(ctx).pop(_PhotoSource.gallery),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;

    final paths = <String>[];
    if (source == _PhotoSource.camera) {
      final file = await _picker.pickImage(source: ImageSource.camera);
      if (file != null) paths.add(file.path);
    } else {
      final files = await _picker.pickMultiImage(limit: 10);
      paths.addAll(files.map((f) => f.path));
    }

    if (paths.isEmpty || !mounted) return;
    if (!context.mounted) return;
    context.read<MapBloc>().add(
          MapChallengeVisitSubmitted(
            challengeId: challenge.id,
            photoPaths: paths,
          ),
        );
    Navigator.of(context).pop();
  }

  void _openChallenge(BuildContext pageCtx, Challenge challenge) {
    final bloc = pageCtx.read<MapBloc>();
    showModalBottomSheet<void>(
      context: pageCtx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => BlocProvider.value(
        value: bloc,
        child: BlocBuilder<MapBloc, MapState>(
          builder: (innerCtx, state) {
            final current = state.challenges.firstWhere(
              (c) => c.id == challenge.id,
              orElse: () => challenge,
            );
            final submitting = state.submittingChallengeId == challenge.id;
            return SpotBottomSheet(
              challenge: current,
              isSubmitting: submitting,
              onProveVisit: () => _onProveVisit(current),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BlocConsumer<MapBloc, MapState>(
        listener: (context, state) {
          if (state.justCompletedChallengeId != null) {
            final challenge = state.challenges.firstWhere(
              (c) => c.id == state.justCompletedChallengeId,
            );
            HapticFeedback.heavyImpact();
            _confetti.play();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: const Color(0xFF2FA84F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  margin: const EdgeInsets.all(16),
                  content: Row(
                    children: [
                      const Icon(Icons.emoji_events_rounded,
                          color: Colors.white),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '«${challenge.title}» — выполнено! +${challenge.rewardPoints}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              FlutterMap(
                mapController: _controller,
                options: MapOptions(
                  initialCenter: _kgCenter,
                  initialZoom: 6.2,
                  minZoom: 5.6,
                  maxZoom: 14,
                  cameraConstraint: CameraConstraint.containCenter(
                    bounds: _kgBounds,
                  ),
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.pinchZoom |
                        InteractiveFlag.drag |
                        InteractiveFlag.doubleTapZoom,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.basemaps.cartocdn.com/rastertiles/voyager_nolabels/{z}/{x}/{y}{r}.png',
                    subdomains: const ['a', 'b', 'c', 'd'],
                    retinaMode: false,
                    userAgentPackageName: 'com.dreamdivers.nomadpuzzle',
                    maxNativeZoom: 19,
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 750),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: PolygonLayer(
                      key: ValueKey(
                        state.challenges.where(_passesFilter)
                            .map((c) => '${c.id}:${c.status.name}')
                            .join('|'),
                      ),
                      polygons: [
                        for (final challenge in state.challenges.where(_passesFilter))
                          for (final ring
                              in (kgZonesByChallengeId[challenge.id] ??
                                  const []))
                            Polygon(
                              points: ring,
                              color: _zoneColor(challenge),
                              borderColor: _zoneBorder(challenge),
                              borderStrokeWidth: 1.2,
                            ),
                      ],
                    ),
                  ),
                  MarkerLayer(markers: _buildLabelMarkers(context)),
                  PolygonLayer(
                    polygons: [
                      Polygon(
                        points: kgCoverBox,
                        holePointsList: [kgBorderPoints],
                        color: Theme.of(context).colorScheme.surface,
                        borderStrokeWidth: 0,
                      ),
                      for (final enclave in kgEnclaves)
                        Polygon(
                          points: enclave,
                          color: Theme.of(context).colorScheme.surface,
                          borderStrokeWidth: 1,
                          borderColor: AppColors.primaryDeep
                              .withValues(alpha: 0.6),
                        ),
                    ],
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: [...kgBorderPoints, kgBorderPoints.first],
                        strokeWidth: 2.5,
                        color: AppColors.primaryDeep,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      for (final challenge in state.challenges.where(_passesFilter))
                        Marker(
                          point: challenge.latLng,
                          width: 56,
                          height: 70,
                          alignment: Alignment.topCenter,
                          child: SpotMarker(
                            challenge: challenge,
                            onTap: () => _openChallenge(context, challenge),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _TopGradient(),
              ),
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _FloatingHeader(),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: MediaQuery.paddingOf(context).top + 100,
                child: _FilterChips(
                  enabled: _enabledDifficulties,
                  showCompleted: _showCompleted,
                  onToggleDifficulty: _toggleDifficulty,
                  onToggleCompleted: () => setState(
                    () => _showCompleted = !_showCompleted,
                  ),
                ),
              ),
              if (state.status == MapStatus.loading) const _ShimmerLoader(),
              const Positioned(
                right: 16,
                bottom: 145,
                child: _Legend(),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ConfettiWidget(
                  confettiController: _confetti,
                  blastDirectionality: BlastDirectionality.explosive,
                  emissionFrequency: 0.05,
                  numberOfParticles: 22,
                  maxBlastForce: 28,
                  minBlastForce: 10,
                  gravity: 0.4,
                  shouldLoop: false,
                  colors: const [
                    Color(0xFFE07A1F),
                    Color(0xFFE53935),
                    Color(0xFF2FA84F),
                    Color(0xFFE0A81F),
                    Color(0xFF1F7AE0),
                    Colors.white,
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TopGradient extends StatelessWidget {
  const _TopGradient();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        height: 180,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x77000000), Color(0x00000000)],
          ),
        ),
      ),
    );
  }
}

class _FloatingHeader extends StatelessWidget {
  const _FloatingHeader();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.78),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const NomadLogoLottie(size: 52, loop: true),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nomad Puzzle',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 17,
                            color: Color(0xFF1F1F1F),
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          'Исследуй Кыргызстан • собирай пазл',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B6B6B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const _CounterBadge(),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 100.ms)
        .slideY(begin: -0.5, end: 0, curve: Curves.easeOutCubic);
  }
}

class _CounterBadge extends StatelessWidget {
  const _CounterBadge();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      buildWhen: (p, c) => p.challenges != c.challenges,
      builder: (context, state) {
        final completed = state.challenges
            .where((c) => c.status == ChallengeStatus.completed)
            .length;
        final total = state.challenges.length;
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeOutCubic,
          tween: Tween(begin: 0, end: completed.toDouble()),
          builder: (context, value, _) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFF2FA84F).withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFF2FA84F).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF2FA84F),
                    size: 14,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${value.round()} / $total',
                    style: const TextStyle(
                      color: Color(0xFF2FA84F),
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.6),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _LegendCaption('Сложность'),
              SizedBox(height: 6),
              _LegendRow(
                color: Color(0xFFFFC857),
                label: 'Классический',
                icon: Icons.spa_rounded,
              ),
              SizedBox(height: 6),
              _LegendRow(
                color: Color(0xFF4A90B8),
                label: 'Отважный',
                icon: Icons.ac_unit_rounded,
              ),
              SizedBox(height: 10),
              Divider(height: 1),
              SizedBox(height: 8),
              _LegendCaption('Зоны'),
              SizedBox(height: 6),
              _LegendRow(
                color: Color(0xFFDC4D3E),
                label: 'Не сдано',
                icon: Icons.flag_outlined,
              ),
              SizedBox(height: 6),
              _LegendRow(
                color: Color(0xFF2FA84F),
                label: 'Сдано',
                icon: Icons.check_rounded,
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 250.ms)
        .slideX(begin: 0.3, end: 0, curve: Curves.easeOutCubic);
  }
}

class _LegendCaption extends StatelessWidget {
  const _LegendCaption(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.6,
        color: Color(0xFF8A8A8F),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.label,
    required this.icon,
  });
  final Color color;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: 4,
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 11),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _ShimmerLoader extends StatelessWidget {
  const _ShimmerLoader();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Shimmer.fromColors(
        baseColor: const Color(0xFFF3EFE8),
        highlightColor: const Color(0xFFFFFFFF),
        child: Container(color: const Color(0xFFF3EFE8)),
      ),
    );
  }
}

enum _PhotoSource { camera, gallery }

enum _LabelKind { capital, bigCity, city, smallCity, water }

class _PlaceLabel {
  const _PlaceLabel(this.name, this.lat, this.lng, this.kind);
  final String name;
  final double lat;
  final double lng;
  final _LabelKind kind;
}

class _PlaceLabelChip extends StatelessWidget {
  const _PlaceLabelChip({required this.label});
  final _PlaceLabel label;

  @override
  Widget build(BuildContext context) {
    final (size, weight, color, italic) = switch (label.kind) {
      _LabelKind.capital => (
        13.5,
        FontWeight.w800,
        const Color(0xFF1D1D1F),
        FontStyle.normal,
      ),
      _LabelKind.bigCity => (
        12.5,
        FontWeight.w800,
        const Color(0xFF1D1D1F),
        FontStyle.normal,
      ),
      _LabelKind.city => (
        12.0,
        FontWeight.w700,
        const Color(0xFF333339),
        FontStyle.normal,
      ),
      _LabelKind.smallCity => (
        10.5,
        FontWeight.w600,
        const Color(0xFF555560),
        FontStyle.normal,
      ),
      _LabelKind.water => (
        11.5,
        FontWeight.w600,
        const Color(0xFF1F5FA0),
        FontStyle.italic,
      ),
    };
    return Center(
      child: Text(
        label.name,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: size,
          fontWeight: weight,
          color: color,
          fontStyle: italic,
          letterSpacing: 0.1,
          height: 1,
          shadows: const [
            Shadow(color: Colors.white, blurRadius: 3),
            Shadow(color: Colors.white, blurRadius: 3),
            Shadow(color: Color(0x55FFFFFF), blurRadius: 6),
          ],
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.enabled,
    required this.showCompleted,
    required this.onToggleDifficulty,
    required this.onToggleCompleted,
  });

  final Set<ChallengeDifficulty> enabled;
  final bool showCompleted;
  final ValueChanged<ChallengeDifficulty> onToggleDifficulty;
  final VoidCallback onToggleCompleted;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _FilterChip(
            label: 'Классический',
            icon: Icons.spa_rounded,
            color: const Color(0xFFFFC857),
            active: enabled.contains(ChallengeDifficulty.easy),
            onTap: () => onToggleDifficulty(ChallengeDifficulty.easy),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Отважный',
            icon: Icons.ac_unit_rounded,
            color: const Color(0xFF4A90B8),
            active: enabled.contains(ChallengeDifficulty.hard),
            onTap: () => onToggleDifficulty(ChallengeDifficulty.hard),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Выполненные',
            icon: Icons.check_rounded,
            color: const Color(0xFF2FA84F),
            active: showCompleted,
            onTap: onToggleCompleted,
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: active
                ? color.withValues(alpha: 0.95)
                : Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: active
                  ? color
                  : Colors.white.withValues(alpha: 0.6),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: (active ? color : Colors.black)
                    .withValues(alpha: active ? 0.35 : 0.08),
                blurRadius: active ? 12 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: active ? Colors.white : color,
                size: 14,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  color: active ? Colors.white : const Color(0xFF1F1F1F),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
