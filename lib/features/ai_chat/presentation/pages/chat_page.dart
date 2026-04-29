import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/lottie_icon.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_bubble.dart';
import '../widgets/typing_dots.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, required this.sessionId});
  final int sessionId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ChatBloc>()..add(ChatHistoryRequested(sessionId)),
      child: const _ChatView(),
    );
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView();

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final _input = TextEditingController();
  final _scrollCtrl = ScrollController();
  final _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _input.dispose();
    _scrollCtrl.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollCtrl.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollCtrl.hasClients) return;
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _playWav(Uint8List bytes) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(BytesSource(bytes));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F0),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state.transcribedText != null &&
              state.transcribedText!.isNotEmpty) {
            _input.text = state.transcribedText!;
            _input.selection = TextSelection.fromPosition(
              TextPosition(offset: _input.text.length),
            );
          }
          if (state.ttsAudio != null) {
            _playWav(state.ttsAudio!.bytes);
            context.read<ChatBloc>().add(const ChatTtsCompleted());
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          _scrollToBottom();
        },
        builder: (context, state) {
          return Column(
            children: [
              _ChatHeader(
                onBack: () => context.canPop()
                    ? context.pop()
                    : context.go(AppRoutes.aiChat),
              ),
              Expanded(
                child: _Body(
                  state: state,
                  scrollCtrl: _scrollCtrl,
                  onSpeak: (id, text) => context.read<ChatBloc>().add(
                        ChatTtsRequested(messageId: id, text: text),
                      ),
                ),
              ),
              ChatInput(
                controller: _input,
                sending: state.sending,
                transcribing: state.transcribing,
                onSend: () {
                  final text = _input.text.trim();
                  if (text.isEmpty) return;
                  _input.clear();
                  context.read<ChatBloc>().add(ChatMessageSent(text));
                },
                onAudioRecorded: (path) {
                  context
                      .read<ChatBloc>()
                      .add(ChatVoiceTranscribed(path));
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        12,
        MediaQuery.paddingOf(context).top + 8,
        16,
        12,
      ),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                HapticFeedback.selectionClick();
                onBack();
              },
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          const LottieIcon(
            asset: 'assets/animations/robot-kalpak-wave.json',
            size: 52,
            loop: true,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Жел Айдар',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16.5,
                    color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'на связи',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.state,
    required this.scrollCtrl,
    required this.onSpeak,
  });

  final ChatState state;
  final ScrollController scrollCtrl;
  final void Function(int id, String text) onSpeak;

  @override
  Widget build(BuildContext context) {
    if (state.status == ChatStatus.loading && state.messages.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.messages.isEmpty) {
      return const _IntroBlock();
    }

    final showTyping = state.sending;
    final itemCount = state.messages.length + (showTyping ? 1 : 0);

    return RefreshIndicator(
      onRefresh: () async {
        final id = state.sessionId;
        if (id != null) {
          context.read<ChatBloc>().add(ChatHistoryRequested(id));
        }
      },
      child: ListView.builder(
        controller: scrollCtrl,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (_, i) {
        if (i == state.messages.length) {
          return const _AssistantTyping();
        }
        final m = state.messages[i];
        return MessageBubble(
          message: m,
          ttsLoading: state.ttsLoadingMessageId == m.id,
          onSpeak: () => onSpeak(m.id, m.content),
        ).animate().fadeIn(duration: 220.ms).slideY(
              begin: 0.1,
              end: 0,
              duration: 240.ms,
              curve: Curves.easeOutCubic,
            );
        },
      ),
    );
  }
}

class _IntroBlock extends StatelessWidget {
  const _IntroBlock();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LottieIcon(
              asset: 'assets/animations/robot-kalpak-wave.json',
              size: 130,
              loop: true,
            ).animate().scale(
                  begin: const Offset(0.6, 0.6),
                  end: const Offset(1, 1),
                  curve: Curves.easeOutBack,
                  duration: 480.ms,
                ),
            const SizedBox(height: 18),
            Text(
              'Чем могу помочь?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Спроси про маршрут, тур или место в Кыргызстане. Можно надиктовать голосом — удержи микрофон.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.4,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AssistantTyping extends StatelessWidget {
  const _AssistantTyping();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(6),
            ),
            border: Border.all(color: Theme.of(context).dividerColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const TypingDots(),
        ),
      ),
    ).animate().fadeIn(duration: 200.ms);
  }
}
