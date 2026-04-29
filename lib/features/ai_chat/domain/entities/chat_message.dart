import 'package:equatable/equatable.dart';

enum ChatRole { user, assistant }

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.sessionId,
    required this.role,
    required this.content,
    required this.createdAt,
    this.isPending = false,
    this.hasFailed = false,
  });

  final int id;
  final int sessionId;
  final ChatRole role;
  final String content;
  final DateTime createdAt;

  /// User-side message that has not yet been confirmed by the server.
  final bool isPending;

  /// User-side message that failed to send (for retry).
  final bool hasFailed;

  bool get isUser => role == ChatRole.user;

  ChatMessage copyWith({bool? isPending, bool? hasFailed}) => ChatMessage(
        id: id,
        sessionId: sessionId,
        role: role,
        content: content,
        createdAt: createdAt,
        isPending: isPending ?? this.isPending,
        hasFailed: hasFailed ?? this.hasFailed,
      );

  @override
  List<Object?> get props =>
      [id, sessionId, role, content, createdAt, isPending, hasFailed];
}
