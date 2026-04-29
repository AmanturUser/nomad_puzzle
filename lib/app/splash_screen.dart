import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/widgets/nomad_logo_lottie.dart';

/// Brand splash with the Nomad Puzzle Lottie animation. Plays the
/// puzzle-assembly animation once and holds on the final assembled
/// frame, then signals [onDone] after [duration] (default 5s).
class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    required this.onDone,
    this.duration = const Duration(seconds: 10),
  });

  final VoidCallback onDone;
  final Duration duration;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(widget.duration, () {
      if (mounted) widget.onDone();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.background,
      child: Center(
        child: NomadLogoLottie(size: 380, loop: true),
      ),
    );
  }
}
