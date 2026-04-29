part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => const [];
}

final class ChatHistoryRequested extends ChatEvent {
  const ChatHistoryRequested(this.sessionId);
  final int sessionId;

  @override
  List<Object?> get props => [sessionId];
}

final class ChatMessageSent extends ChatEvent {
  const ChatMessageSent(this.content);
  final String content;

  @override
  List<Object?> get props => [content];
}

final class ChatVoiceTranscribed extends ChatEvent {
  const ChatVoiceTranscribed(this.audioPath);
  final String audioPath;

  @override
  List<Object?> get props => [audioPath];
}

final class ChatTtsRequested extends ChatEvent {
  const ChatTtsRequested({required this.messageId, required this.text});
  final int messageId;
  final String text;

  @override
  List<Object?> get props => [messageId, text];
}

final class ChatTtsCompleted extends ChatEvent {
  const ChatTtsCompleted();
}
