import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/chat_message.dart';
import '../entities/chat_session.dart';
import '../repositories/chat_repository.dart';

@injectable
class ListChatSessions {
  ListChatSessions(this._repo);
  final ChatRepository _repo;
  Future<Either<Failure, List<ChatSession>>> call({int limit = 30, int offset = 0}) =>
      _repo.listSessions(limit: limit, offset: offset);
}

@injectable
class CreateChatSession {
  CreateChatSession(this._repo);
  final ChatRepository _repo;
  Future<Either<Failure, ChatSession>> call({String? title}) =>
      _repo.createSession(title: title);
}

@injectable
class GetChatSession {
  GetChatSession(this._repo);
  final ChatRepository _repo;
  Future<Either<Failure, ChatSession>> call(int id) => _repo.getSession(id);
}

@injectable
class DeleteChatSession {
  DeleteChatSession(this._repo);
  final ChatRepository _repo;
  Future<Either<Failure, Unit>> call(int id) => _repo.deleteSession(id);
}

@injectable
class ListChatMessages {
  ListChatMessages(this._repo);
  final ChatRepository _repo;
  Future<Either<Failure, List<ChatMessage>>> call(int sessionId) =>
      _repo.listMessages(sessionId);
}

@injectable
class SendChatMessage {
  SendChatMessage(this._repo);
  final ChatRepository _repo;
  Future<Either<Failure, SendMessageOutcome>> call(int sessionId, String content) =>
      _repo.sendMessage(sessionId, content);
}
