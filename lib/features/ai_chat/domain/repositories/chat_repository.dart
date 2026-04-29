import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/chat_message.dart';
import '../entities/chat_session.dart';

class SendMessageOutcome {
  const SendMessageOutcome({required this.userMessage, required this.assistantMessage});
  final ChatMessage userMessage;
  final ChatMessage assistantMessage;
}

abstract class ChatRepository {
  Future<Either<Failure, List<ChatSession>>> listSessions({int limit = 30, int offset = 0});
  Future<Either<Failure, ChatSession>> createSession({String? title});
  Future<Either<Failure, ChatSession>> getSession(int id);
  Future<Either<Failure, Unit>> deleteSession(int id);
  Future<Either<Failure, List<ChatMessage>>> listMessages(int sessionId);
  Future<Either<Failure, SendMessageOutcome>> sendMessage(
    int sessionId,
    String content,
  );
}
