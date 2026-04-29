import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../widgets/chat_fab.dart';
import '../widgets/fab_visibility.dart';
import '../widgets/lottie_icon.dart';
import '../widgets/nomad_logo_lottie.dart';

class ScaffoldWithNav extends StatelessWidget {
  const ScaffoldWithNav({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static final List<_NavItem> _items = [
    _NavItem.kg(),
    _NavItem.lottie(
      lottieAsset: 'assets/animations/challenges.json',
      lottieScale: 1.45,
    ),
    _NavItem.lottie(
      lottieAsset: 'assets/animations/camera-on-mountain.json',
      lottieScale: 1.45,
    ),
    _NavItem.lottie(
      lottieAsset: 'assets/animations/backpack-on-mountains.json',
      lottieScale: 1.45,
    ),
    _NavItem.lottie(
      lottieAsset: 'assets/animations/kalpak-bounce.json',
      lottieScale: 1.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isMap = navigationShell.currentIndex == 0;
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 86),
        child: ValueListenableBuilder<bool>(
          valueListenable: FabVisibility.instance.hasModal,
          builder: (_, hasModal, child) {
            return IgnorePointer(
              ignoring: hasModal,
              child: AnimatedScale(
                scale: hasModal ? 0 : 1,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                child: AnimatedOpacity(
                  opacity: hasModal ? 0 : 1,
                  duration: const Duration(milliseconds: 180),
                  child: child,
                ),
              ),
            );
          },
          child: const ChatFab(),
        ),
      ),
      floatingActionButtonLocation: isMap
          ? FloatingActionButtonLocation.startFloat
          : FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _GlassBottomNav(
        items: _items,
        currentIndex: navigationShell.currentIndex,
        onTap: (i) => navigationShell.goBranch(
          i,
          initialLocation: i == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required IconData this.icon,
    required IconData this.active,
  })  : isKg = false,
        lottieAsset = null,
        lottieScale = 1.0;

  const _NavItem.kg()
      : icon = null,
        active = null,
        isKg = true,
        lottieAsset = null,
        lottieScale = 1.25;

  const _NavItem.lottie({
    required String this.lottieAsset,
    this.lottieScale = 1.0,
  })  : icon = null,
        active = null,
        isKg = false;

  final IconData? icon;
  final IconData? active;
  final bool isKg;
  final String? lottieAsset;
  final double lottieScale;
}

class _GlassBottomNav extends StatelessWidget {
  const _GlassBottomNav({
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<_NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const double _barHeight = 86;
  static const double _spotlightSize = 76;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark
        ? scheme.surface.withValues(alpha: 0.78)
        : Colors.white.withValues(alpha: 0.85);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              height: _barHeight,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: (isDark ? Colors.white : Colors.white)
                      .withValues(alpha: isDark ? 0.08 : 0.6),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 26,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final tabWidth = constraints.maxWidth / items.length;
                  return Stack(
                    children: [
                      // Sliding spotlight under active icon. Lottie tabs
                      // get a soft white spotlight so their own colours
                      // read clearly; icon tabs get the orange gradient.
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 480),
                        curve: Curves.easeOutCubic,
                        left: tabWidth * currentIndex +
                            (tabWidth - _spotlightSize) / 2,
                        top: (_barHeight - _spotlightSize) / 2,
                        width: _spotlightSize,
                        height: _spotlightSize,
                        child: RepaintBoundary(
                          child: _Spotlight(
                            soft: items[currentIndex].isKg ||
                                items[currentIndex].lottieAsset != null,
                          ),
                        ),
                      ),
                      // Tab row
                      Row(
                        children: [
                          for (var i = 0; i < items.length; i++)
                            Expanded(
                              child: _NavTab(
                                item: items[i],
                                selected: i == currentIndex,
                                onTap: () {
                                  if (i == currentIndex) return;
                                  HapticFeedback.selectionClick();
                                  onTap(i);
                                },
                              ),
                            ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Spotlight extends StatefulWidget {
  const _Spotlight({this.soft = false});

  /// Use a neutral white-with-warm-glow background instead of the orange
  /// gradient. Lottie tabs ship their own colourful artwork, so the
  /// orange spotlight competes with their palette — soft mode lets the
  /// Lottie read clearly while keeping the breathing halo cue.
  final bool soft;

  @override
  State<_Spotlight> createState() => _SpotlightState();
}

class _SpotlightState extends State<_Spotlight>
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
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, _) {
        final t = _ctrl.value;
        return Stack(
          alignment: Alignment.center,
          children: [
            // Soft outer halo (breathing)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.30 + 0.10 * t),
                    AppColors.primary.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
            // Inner pill — subtle scale pulse
            Transform.scale(
              scale: 0.78 + 0.04 * t,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.soft ? Colors.white : null,
                  gradient: widget.soft ? null : AppColors.primaryGradient,
                  border: widget.soft
                      ? Border.all(
                          color: AppColors.primary.withValues(alpha: 0.5),
                          width: 1.5,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.45),
                      blurRadius: 14 + 6 * t,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NavTab extends StatefulWidget {
  const _NavTab({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_NavTab> createState() => _NavTabState();
}

class _NavTabState extends State<_NavTab>
    with SingleTickerProviderStateMixin {
  bool get _hasLottie =>
      widget.item.isKg || widget.item.lottieAsset != null;

  late final AnimationController _bounce = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 520),
  );

  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(begin: 1.0, end: 0.78)
          .chain(CurveTween(curve: Curves.easeOut)),
      weight: 25,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 0.78, end: 1.18)
          .chain(CurveTween(curve: Curves.easeOut)),
      weight: 35,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 1.18, end: 0.96)
          .chain(CurveTween(curve: Curves.easeOut)),
      weight: 25,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 0.96, end: 1.0)
          .chain(CurveTween(curve: Curves.easeOut)),
      weight: 15,
    ),
  ]).animate(_bounce);

  @override
  void didUpdateWidget(covariant _NavTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.selected && widget.selected) {
      _bounce.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _bounce.dispose();
    super.dispose();
  }

  void _onTap() {
    widget.onTap();
    _bounce.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTap,
      child: ScaleTransition(
        scale: _scale,
        child: Center(
          child: SizedBox(
            width: _hasLottie ? 76 * widget.item.lottieScale : 32,
            height: _hasLottie ? 76 * widget.item.lottieScale : 32,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                switchInCurve: Curves.easeOutBack,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: Tween<double>(begin: 0.5, end: 1).animate(animation),
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: _buildIcon(selected: selected),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon({required bool selected}) {
    final color = selected ? Colors.white : Theme.of(context).hintColor;
    final size = selected ? 26.0 : 24.0;
    if (widget.item.isKg) {
      if (selected) {
        return const NomadLogoLottie(
          key: ValueKey('kg_lottie'),
          size: 90,
          loop: true,
        );
      }
      return Image.asset(
        'assets/icons/app_logo.png',
        key: const ValueKey('kg_static'),
        width: 62,
        height: 62,
        fit: BoxFit.contain,
      );
    }
    final lottie = widget.item.lottieAsset;
    if (lottie != null) {
      final scale = widget.item.lottieScale;
      return LottieIcon(
        key: ValueKey('lottie_$lottie'),
        asset: lottie,
        size: (selected ? 72 : 50) * scale,
        loop: true,
        paused: !selected,
        pausedAtEnd: true,
      );
    }
    return Icon(
      selected ? widget.item.active : widget.item.icon,
      key: ValueKey('${widget.item.icon}_$selected'),
      color: color,
      size: size,
    );
  }
}
