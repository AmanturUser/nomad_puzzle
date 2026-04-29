part of 'chat_bloc.dart';

enum ChatStatus { initial, loading, success, failure }

class ChatTtsPayload extends Equatable {
  const ChatTtsPayload({required this.messageId, required this.bytes});
  final int messageId;
  final Uint8List bytes;

  @override
  List<Object?> get props => [messageId, bytes.length];
}

final class ChatState extends Equatable {
  const ChatState({
    this.status = ChatStatus.initial,
    this.sessionId,
    this.messages = const [],
    this.sending = false,
    this.transcribing = false,
    this.transcribedText,
    this.ttsLoadingMessageId,
    this.ttsAudio,
    this.errorMessage,
  });

  final ChatStatus status;
  final int? sessionId;
  final List<ChatMessage> messages;
  final bool sending;
  final bool transcribing;
  final String? transcribedText;
  final int? ttsLoadingMessageId;
  final ChatTtsPayload? ttsAudio;
  final String? errorMessage;

  ChatState copyWith({
    ChatStatus? status,
    int? sessionId,
    List<ChatMessage>? messages,
    bool? sending,
    bool? transcribing,
    String? transcribedText,
    int? ttsLoadingMessageId,
    ChatTtsPayload? ttsAudio,
    String? errorMessage,
  }) {
    return ChatState(
      status: status ?? this.status,
      sessionId: sessionId ?? this.sessionId,
      messages: messages ?? this.messages,
      sending: sending ?? this.sending,
      transcribing: transcribing ?? this.transcribing,
      transcribedText: transcribedText,
      ttsLoadingMessageId: ttsLoadingMessageId,
      ttsAudio: ttsAudio,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        sessionId,
        messages,
        sending,
        transcribing,
        transcribedText,
        ttsLoadingMessageId,
        ttsAudio,
        errorMessage,
      ];
}
