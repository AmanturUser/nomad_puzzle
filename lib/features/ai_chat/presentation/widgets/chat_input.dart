import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../../../core/theme/app_colors.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({
    super.key,
    required this.controller,
    required this.sending,
    required this.transcribing,
    required this.onSend,
    required this.onAudioRecorded,
  });

  final TextEditingController controller;
  final bool sending;
  final bool transcribing;
  final VoidCallback onSend;
  final ValueChanged<String> onAudioRecorded;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _recorder = AudioRecorder();
  bool _recording = false;

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final granted = await Permission.microphone.request().isGranted;
    if (!granted) return;
    if (!await _recorder.hasPermission()) return;
    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/chat_voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc, numChannels: 1),
      path: path,
    );
    HapticFeedback.lightImpact();
    if (!mounted) return;
    setState(() {
      _recording = true;
    });
  }

  Future<void> _stop({bool cancelled = false}) async {
    if (!_recording) return;
    final path = await _recorder.stop();
    HapticFeedback.lightImpact();
    if (!mounted) return;
    setState(() => _recording = false);
    if (cancelled) {
      if (path != null) {
        try {
          await File(path).delete();
        } catch (_) {}
      }
      return;
    }
    if (path != null) widget.onAudioRecorded(path);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canSend = widget.controller.text.trim().isNotEmpty && !widget.sending;
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      padding: EdgeInsets.fromLTRB(
        12,
        10,
        12,
        MediaQuery.paddingOf(context).bottom + 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              minLines: 1,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: widget.transcribing
                    ? 'Расшифровываю…'
                    : 'Напиши Жел Айдару…',
                filled: true,
                fillColor: AppColors.surfaceDim,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.45),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (canSend)
            _RoundButton(
              icon: Icons.send_rounded,
              gradient: AppColors.primaryGradient,
              onTap: widget.sending ? null : widget.onSend,
            )
          else
            GestureDetector(
              onLongPressStart: (_) => _start(),
              onLongPressEnd: (_) => _stop(),
              onLongPressCancel: () => _stop(cancelled: true),
              child: _RoundButton(
                icon: _recording ? Icons.stop_rounded : Icons.mic_rounded,
                gradient: _recording
                    ? const LinearGradient(
                        colors: [Color(0xFFD9534F), Color(0xFFB52A2A)],
                      )
                    : AppColors.primaryGradient,
                onTap: null,
              ),
            ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  final IconData icon;
  final Gradient gradient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: gradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}
