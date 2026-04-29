import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/lottie_icon.dart';
import '../bloc/chat_sessions_bloc.dart';

class ChatSessionsPage extends StatelessWidget {
  const ChatSessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ChatSessionsBloc>()..add(const ChatSessionsRequested()),
      child: const _ChatSessionsView(),
    );
  }
}

class _ChatSessionsView extends StatelessWidget {
  const _ChatSessionsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F0),
      body: BlocConsumer<ChatSessionsBloc, ChatSessionsState>(
        listenWhen: (p, n) =>
            p.lastCreatedId != n.lastCreatedId && n.lastCreatedId != null,
        listener: (context, state) {
          final id = state.lastCreatedId!;
          context.go('${AppRoutes.aiChat}/$id');
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<ChatSessionsBloc>()
                  .add(const ChatSessionsRequested());
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: _Header()),
                SliverToBoxAdapter(
                  child: _NewSessionButton(creating: state.creating),
                ),
              if (state.status == ChatSessionsStatus.loading &&
                  state.items.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state.status == ChatSessionsStatus.failure &&
                  state.items.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        state.errorMessage ?? 'Не удалось загрузить чаты',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              else if (state.items.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(),
                )
              else
                SliverPadding(
                  padding:
                      const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  sliver: SliverList.separated(
                    itemCount: state.items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final s = state.items[i];
                      return _SessionTile(
                        title: s.title,
                        updatedAt: s.updatedAt,
                        onTap: () => context.push('${AppRoutes.aiChat}/${s.id}'),
                        onDelete: () =>
                            _confirmDelete(context, s.id, s.title),
                      ).animate().fadeIn(
                            duration: 320.ms,
                            delay: (50 * i).ms,
                          ).slideY(
                            begin: 0.1,
                            end: 0,
                            curve: Curves.easeOutCubic,
                            duration: 320.ms,
                            delay: (50 * i).ms,
                          );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id, String title) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Удалить чат?'),
        content: Text('«$title» будет удалён без возможности восстановить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Отмена'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              context
                  .read<ChatSessionsBloc>()
                  .add(ChatSessionDeleted(id));
            },
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.paddingOf(context).top + 12,
        20,
        12,
      ),
      child: Row(
        children: [
          _CircleBtn(
            icon: Icons.arrow_back_rounded,
            onTap: () => context.canPop()
                ? context.pop()
                : context.go(AppRoutes.home),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Жел Айдар',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                Text(
                  'AI-проводник по Кыргызстану',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const LottieIcon(
            asset: 'assets/animations/robot-kalpak-wave.json',
            size: 56,
            loop: true,
          ),
        ],
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  const _CircleBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Icon(icon, color: AppColors.textPrimary, size: 22),
        ),
      ),
    );
  }
}

class _NewSessionButton extends StatelessWidget {
  const _NewSessionButton({required this.creating});
  final bool creating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.40),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            textStyle:
                const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          onPressed: creating
              ? null
              : () => context
                  .read<ChatSessionsBloc>()
                  .add(const ChatSessionCreated()),
          icon: creating
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.add_rounded, color: Colors.white, size: 22),
          label: const Text('Новый разговор',
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.forum_rounded,
              color: AppColors.primaryDeep,
              size: 56,
            ),
          ).animate().scale(
                begin: const Offset(0.6, 0.6),
                end: const Offset(1, 1),
                curve: Curves.easeOutBack,
                duration: 480.ms,
              ),
          const SizedBox(height: 20),
          Text(
            'Пока нет разговоров',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Спроси про маршрут, перевал, юрту или какой тур взять — Жел Айдар подскажет.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({
    required this.title,
    required this.updatedAt,
    required this.onTap,
    required this.onDelete,
  });

  final String title;
  final DateTime updatedAt;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 48,
                height: 48,
                child: LottieIcon(
                  asset: 'assets/animations/robot-kalpak-wave.json',
                  size: 48,
                  loop: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style:
                          Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatTime(updatedAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded),
                color: Theme.of(context).hintColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime t) {
    final now = DateTime.now();
    final diff = now.difference(t);
    if (diff.inMinutes < 1) return 'только что';
    if (diff.inHours < 1) return '${diff.inMinutes} мин назад';
    if (diff.inDays < 1) return DateFormat('сегодня, HH:mm', 'ru').format(t);
    if (diff.inDays < 2) return DateFormat('вчера, HH:mm', 'ru').format(t);
    if (diff.inDays < 7) {
      return DateFormat('EEE, HH:mm', 'ru').format(t);
    }
    return DateFormat('d MMM, HH:mm', 'ru').format(t);
  }
}
