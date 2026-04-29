import 'package:flutter/material.dart';

import 'lottie_icon.dart';

/// Renders the Nomad Puzzle Lottie logo. Shorthand around [LottieIcon].
class NomadLogoLottie extends StatelessWidget {
  const NomadLogoLottie({
    super.key,
    this.size,
    this.fit = BoxFit.contain,
    this.loop = false,
    this.paused = false,
    this.pausedAtEnd = false,
  });

  final double? size;
  final BoxFit fit;
  final bool loop;
  final bool paused;
  final bool pausedAtEnd;

  static const String asset = 'assets/animations/nomad-puzzle3.json';

  @override
  Widget build(BuildContext context) => LottieIcon(
        asset: asset,
        size: size,
        fit: fit,
        loop: loop,
        paused: paused,
        pausedAtEnd: pausedAtEnd,
      );
}
