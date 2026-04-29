part of 'chat_sessions_bloc.dart';

enum ChatSessionsStatus { initial, loading, success, failure }

final class ChatSessionsState extends Equatable {
  const ChatSessionsState({
    this.status = ChatSessionsStatus.initial,
    this.items = const [],
    this.creating = false,
    this.lastCreatedId,
    this.errorMessage,
  });

  final ChatSessionsStatus status;
  final List<ChatSession> items;
  final bool creating;
  final int? lastCreatedId;
  final String? errorMessage;

  ChatSessionsState copyWith({
    ChatSessionsStatus? status,
    List<ChatSession>? items,
    bool? creating,
    int? lastCreatedId,
    String? errorMessage,
  }) {
    return ChatSessionsState(
      status: status ?? this.status,
      items: items ?? this.items,
      creating: creating ?? this.creating,
      lastCreatedId: lastCreatedId ?? this.lastCreatedId,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, items, creating, lastCreatedId, errorMessage];
}
