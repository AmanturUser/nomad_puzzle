part of 'chat_sessions_bloc.dart';

sealed class ChatSessionsEvent extends Equatable {
  const ChatSessionsEvent();

  @override
  List<Object?> get props => const [];
}

final class ChatSessionsRequested extends ChatSessionsEvent {
  const ChatSessionsRequested();
}

final class ChatSessionCreated extends ChatSessionsEvent {
  const ChatSessionCreated({this.title});
  final String? title;

  @override
  List<Object?> get props => [title];
}

final class ChatSessionDeleted extends ChatSessionsEvent {
  const ChatSessionDeleted(this.id);
  final int id;

  @override
  List<Object?> get props => [id];
}
