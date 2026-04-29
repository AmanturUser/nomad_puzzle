import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_session.dart';

part 'chat_models.g.dart';

@JsonSerializable()
class ChatSessionModel {
  const ChatSessionModel({
    required this.id,
    this.title = '',
    this.createdAt,
    this.updatedAt,
  });

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionModelFromJson(json);

  final int id;
  @JsonKey(defaultValue: '')
  final String title;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  Map<String, dynamic> toJson() => _$ChatSessionModelToJson(this);

  ChatSession toEntity() => ChatSession(
        id: id,
        title: title.isEmpty ? 'Сессия #$id' : title,
        createdAt: DateTime.tryParse(createdAt ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(updatedAt ?? '') ?? DateTime.now(),
      );
}

@JsonSerializable()
class ChatMessageModel {
  const ChatMessageModel({
    required this.id,
    this.sessionId = 0,
    this.role = 'assistant',
    this.content = '',
    this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  final int id;
  @JsonKey(name: 'session_id', defaultValue: 0)
  final int sessionId;
  @JsonKey(defaultValue: 'assistant')
  final String role;
  @JsonKey(defaultValue: '')
  final String content;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);

  ChatMessage toEntity() => ChatMessage(
        id: id,
        sessionId: sessionId,
        role: role == 'user' ? ChatRole.user : ChatRole.assistant,
        content: content,
        createdAt: DateTime.tryParse(createdAt ?? '') ?? DateTime.now(),
      );
}

@JsonSerializable()
class SendMessageResponseModel {
  const SendMessageResponseModel({
    required this.userMessage,
    required this.assistantMessage,
  });

  factory SendMessageResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SendMessageResponseModelFromJson(json);

  @JsonKey(name: 'user_message')
  final ChatMessageModel userMessage;
  @JsonKey(name: 'assistant_message')
  final ChatMessageModel assistantMessage;

  Map<String, dynamic> toJson() => _$SendMessageResponseModelToJson(this);
}
