// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatSessionModel _$ChatSessionModelFromJson(Map<String, dynamic> json) =>
    ChatSessionModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$ChatSessionModelToJson(ChatSessionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) =>
    ChatMessageModel(
      id: (json['id'] as num).toInt(),
      sessionId: (json['session_id'] as num?)?.toInt() ?? 0,
      role: json['role'] as String? ?? 'assistant',
      content: json['content'] as String? ?? '',
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$ChatMessageModelToJson(ChatMessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'session_id': instance.sessionId,
      'role': instance.role,
      'content': instance.content,
      'created_at': instance.createdAt,
    };

SendMessageResponseModel _$SendMessageResponseModelFromJson(
  Map<String, dynamic> json,
) => SendMessageResponseModel(
  userMessage: ChatMessageModel.fromJson(
    json['user_message'] as Map<String, dynamic>,
  ),
  assistantMessage: ChatMessageModel.fromJson(
    json['assistant_message'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$SendMessageResponseModelToJson(
  SendMessageResponseModel instance,
) => <String, dynamic>{
  'user_message': instance.userMessage,
  'assistant_message': instance.assistantMessage,
};
