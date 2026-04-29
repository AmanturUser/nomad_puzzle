import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/lottie_icon.dart';
import '../bloc/camera_bloc.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({super.key, this.challengeId});

  final String? challengeId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<CameraBloc>()..add(const CameraPermissionRequested()),
      child: _CameraView(challengeId: challengeId),
    );
  }
}

class _CameraView extends StatelessWidget {
  const _CameraView({this.challengeId});
  final String? challengeId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<CameraBloc, CameraState>(
          listener: (context, state) {
            if (state.status == CameraStatus.failure &&
                state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      const LottieIcon(
                        asset: 'assets/animations/camera-on-mountain.json',
                        size: 80,
                        loop: true,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Камера',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontSize: 28),
                            ),
                            Text(
                              'Фиксируй визиты и доказывай их',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 350.ms)
                      .slideY(begin: -0.2, end: 0, curve: Curves.easeOutCubic),
                  const SizedBox(height: 24),
                  Expanded(
                    child: _PreviewArea(state: state)
                        .animate()
                        .fadeIn(delay: 120.ms, duration: 400.ms)
                        .scale(
                          begin: const Offset(0.96, 0.96),
                          end: const Offset(1, 1),
                          curve: Curves.easeOutCubic,
                        ),
                  ),
                  const SizedBox(height: 20),
                  _Actions(state: state, challengeId: challengeId)
                      .animate()
                      .fadeIn(delay: 220.ms, duration: 400.ms)
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        curve: Curves.easeOutCubic,
                      ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PreviewArea extends StatelessWidget {
  const _PreviewArea({required this.state});
  final CameraState state;

  @override
  Widget build(BuildContext context) {
    if (state.status == CameraStatus.permissionDenied) {
      return _PlaceholderCard(
        icon: Icons.no_photography_outlined,
        title: 'Нужен доступ к камере',
        subtitle:
            'Разреши камеру в настройках, чтобы фиксировать визиты к местам на карте.',
      );
    }
    if (state.photo != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Image.file(
          File(state.photo!.path),
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
    }
    return _PlaceholderCard(
      icon: Icons.photo_camera_rounded,
      title: 'Готов сделать снимок?',
      subtitle:
          'Сделай фото или выбери из галереи — это доказательство визита.',
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  const _PlaceholderCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.primarySoft.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 34),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.state, this.challengeId});

  final CameraState state;
  final String? challengeId;

  @override
  Widget build(BuildContext context) {
    final isBusy = state.status == CameraStatus.capturing;
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
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
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onPressed: isBusy
                  ? null
                  : () => context.read<CameraBloc>().add(
                        CameraPhotoTaken(challengeId: challengeId),
                      ),
              icon: const Icon(Icons.photo_camera_rounded, size: 20),
              label: const Text('Сделать фото'),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: isBusy
                ? null
                : () => context.read<CameraBloc>().add(
                      CameraPhotoPicked(challengeId: challengeId),
                    ),
            icon: const Icon(Icons.photo_library_outlined, size: 20),
            label: const Text('Галерея'),
          ),
        ),
      ],
    );
  }
}
