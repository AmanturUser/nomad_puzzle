import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/chat_usecases.dart';
import '../../domain/usecases/voice_usecases.dart';

part 'chat_event.dart';
part 'chat_state.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(
    this._listMessages,
    this._sendMessage,
    this._transcribeAudio,
    this._synthesizeSpeech,
  ) : super(const ChatState()) {
    on<ChatHistoryRequested>(_onHistory);
    on<ChatMessageSent>(_onSent);
    on<ChatVoiceTranscribed>(_onTranscribed);
    on<ChatTtsRequested>(_onTts);
    on<ChatTtsCompleted>(_onTtsDone);
  }

  final ListChatMessages _listMessages;
  final SendChatMessage _sendMessage;
  final TranscribeAudio _transcribeAudio;
  final SynthesizeSpeech _synthesizeSpeech;

  Future<void> _onHistory(
    ChatHistoryRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(
      status: ChatStatus.loading,
      sessionId: event.sessionId,
      errorMessage: null,
    ));
    final result = await _listMessages(event.sessionId);
    result.fold(
      (f) => emit(state.copyWith(
        status: ChatStatus.failure,
        errorMessage: f.message,
      )),
      (messages) => emit(state.copyWith(
        status: ChatStatus.success,
        messages: messages,
      )),
    );
  }

  Future<void> _onSent(
    ChatMessageSent event,
    Emitter<ChatState> emit,
  ) async {
    final sessionId = state.sessionId;
    final content = event.content.trim();
    if (sessionId == null || content.isEmpty) return;

    // Optimistically push the user's message.
    final pendingId = -DateTime.now().millisecondsSinceEpoch;
    final pending = ChatMessage(
      id: pendingId,
      sessionId: sessionId,
      role: ChatRole.user,
      content: content,
      createdAt: DateTime.now(),
      isPending: true,
    );
    emit(state.copyWith(
      sending: true,
      messages: [...state.messages, pending],
      errorMessage: null,
    ));

    final result = await _sendMessage(sessionId, content);
    result.fold(
      (f) {
        final updated = state.messages
            .map((m) => m.id == pendingId
                ? m.copyWith(isPending: false, hasFailed: true)
                : m)
            .toList();
        emit(state.copyWith(
          sending: false,
          messages: updated,
          errorMessage: f.message,
        ));
      },
      (outcome) {
        final cleaned =
            state.messages.where((m) => m.id != pendingId).toList();
        emit(state.copyWith(
          sending: false,
          messages: [
            ...cleaned,
            outcome.userMessage,
            outcome.assistantMessage,
          ],
        ));
      },
    );
  }

  Future<void> _onTranscribed(
    ChatVoiceTranscribed event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(transcribing: true, errorMessage: null));
    final result = await _transcribeAudio(event.audioPath);
    result.fold(
      (f) => emit(state.copyWith(transcribing: false, errorMessage: f.message)),
      (text) => emit(state.copyWith(
        transcribing: false,
        transcribedText: text,
      )),
    );
  }

  Future<void> _onTts(
    ChatTtsRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(
      ttsLoadingMessageId: event.messageId,
      ttsAudio: null,
      errorMessage: null,
    ));
    final result = await _synthesizeSpeech(event.text);
    result.fold(
      (f) => emit(state.copyWith(
        ttsLoadingMessageId: null,
        errorMessage: f.message,
      )),
      (bytes) => emit(state.copyWith(
        ttsLoadingMessageId: null,
        ttsAudio: ChatTtsPayload(messageId: event.messageId, bytes: bytes),
      )),
    );
  }

  Future<void> _onTtsDone(
    ChatTtsCompleted event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(ttsAudio: null));
  }
}
