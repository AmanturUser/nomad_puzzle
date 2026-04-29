import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/chat_message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.onSpeak,
    this.ttsLoading = false,
  });

  final ChatMessage message;
  final VoidCallback onSpeak;
  final bool ttsLoading;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final theme = Theme.of(context);
    final fg = isUser ? Colors.white : AppColors.textPrimary;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment:
                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: isUser ? AppColors.primaryGradient : null,
                  color: isUser ? null : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(isUser ? 20 : 6),
                    bottomRight: Radius.circular(isUser ? 6 : 20),
                  ),
                  border: isUser
                      ? null
                      : Border.all(color: theme.dividerColor),
                  boxShadow: [
                    BoxShadow(
                      color: (isUser ? AppColors.primary : Colors.black)
                          .withValues(alpha: isUser ? 0.30 : 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SelectableText(
                  message.content,
                  style: TextStyle(color: fg, fontSize: 15, height: 1.4),
                ),
              ),
              const SizedBox(height: 4),
              _Meta(message: message, onSpeak: onSpeak, ttsLoading: ttsLoading),
            ],
          ),
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({
    required this.message,
    required this.onSpeak,
    required this.ttsLoading,
  });

  final ChatMessage message;
  final VoidCallback onSpeak;
  final bool ttsLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final time = DateFormat('HH:mm').format(message.createdAt);

    if (message.isUser) {
      // For the user side: time + status icon (sending / sent / failed).
      Widget statusIcon;
      if (message.hasFailed) {
        statusIcon = Icon(
          Icons.error_outline_rounded,
          size: 13,
          color: AppColors.error,
        );
      } else if (message.isPending) {
        statusIcon = SizedBox(
          width: 11,
          height: 11,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: theme.hintColor,
          ),
        );
      } else {
        statusIcon = Icon(
          Icons.done_all_rounded,
          size: 13,
          color: theme.hintColor,
        );
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.hasFailed ? 'не отправлено' : time,
              style: TextStyle(
                fontSize: 11,
                color: message.hasFailed
                    ? AppColors.error
                    : theme.hintColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            statusIcon,
          ],
        ),
      );
    }

    // Assistant side: time + speak button.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            time,
            style: TextStyle(
              fontSize: 11,
              color: theme.hintColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: ttsLoading ? null : onSpeak,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ttsLoading
                      ? const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 1.8),
                        )
                      : Icon(
                          Icons.volume_up_rounded,
                          size: 14,
                          color: theme.hintColor,
                        ),
                  const SizedBox(width: 3),
                  Text(
                    'Озвучить',
                    style: TextStyle(
                      color: theme.hintColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
