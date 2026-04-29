import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Generic Lottie asset renderer with explicit play control.
///
/// Plays once and holds on the final frame by default. Pass [loop] to
/// repeat indefinitely. Pass [paused] to freeze the animation at frame 0
/// — useful for nav tabs that should only animate while selected.
/// [LottieOptions(enableMergePaths: true)] is on so merge-path shape
/// modifiers (which the Nomad Puzzle assets use) render correctly.
class LottieIcon extends StatefulWidget {
  const LottieIcon({
    super.key,
    required this.asset,
    this.size,
    this.fit = BoxFit.contain,
    this.loop = false,
    this.paused = false,
    this.pausedAtEnd = false,
  });

  final String asset;
  final double? size;
  final BoxFit fit;
  final bool loop;
  final bool paused;

  /// When [paused] is true, freeze on the last frame instead of the
  /// first one. Useful for assembly-style animations where the resolved
  /// state is more meaningful than the intro state.
  final bool pausedAtEnd;

  @override
  State<LottieIcon> createState() => _LottieIconState();
}

class _LottieIconState extends State<LottieIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this);
  bool _loaded = false;

  @override
  void didUpdateWidget(covariant LottieIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_loaded && oldWidget.paused != widget.paused) {
      _applyPlayState();
    }
  }

  void _applyPlayState() {
    if (widget.paused) {
      _controller.stop();
      _controller.value = widget.pausedAtEnd ? 1 : 0;
    } else if (widget.loop) {
      _controller.repeat();
    } else {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lottie = Lottie.asset(
      widget.asset,
      fit: widget.fit,
      controller: _controller,
      options: LottieOptions(enableMergePaths: true),
      onLoaded: (composition) {
        _controller.duration = composition.duration;
        _loaded = true;
        _applyPlayState();
      },
    );
    if (widget.size == null) return lottie;
    return SizedBox(width: widget.size, height: widget.size, child: lottie);
  }
}
