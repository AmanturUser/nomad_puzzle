import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_constants.dart';
import '../models/chat_models.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatSessionModel>> listSessions({int limit, int offset});
  Future<ChatSessionModel> createSession({String? title});
  Future<ChatSessionModel> getSession(int id);
  Future<void> deleteSession(int id);
  Future<List<ChatMessageModel>> listMessages(int sessionId);
  Future<SendMessageResponseModel> sendMessage(int sessionId, String content);
}

@LazySingleton(as: ChatRemoteDataSource)
class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  ChatRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<ChatSessionModel>> listSessions({int limit = 30, int offset = 0}) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        ApiConstants.agentSessions,
        queryParameters: {'limit': limit, 'offset': offset},
      );
      return (response.data ?? [])
          .cast<Map<String, dynamic>>()
          .map(ChatSessionModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load sessions');
    }
  }

  @override
  Future<ChatSessionModel> createSession({String? title}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.agentSessions,
        data: {if (title != null && title.isNotEmpty) 'title': title},
      );
      return ChatSessionModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to create session');
    }
  }

  @override
  Future<ChatSessionModel> getSession(int id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiConstants.agentSessionById(id),
      );
      return ChatSessionModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load session');
    }
  }

  @override
  Future<void> deleteSession(int id) async {
    try {
      await _dio.delete<void>(ApiConstants.agentSessionById(id));
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to delete session');
    }
  }

  @override
  Future<List<ChatMessageModel>> listMessages(int sessionId) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        ApiConstants.agentSessionMessages(sessionId),
      );
      return (response.data ?? [])
          .cast<Map<String, dynamic>>()
          .map(ChatMessageModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load messages');
    }
  }

  @override
  Future<SendMessageResponseModel> sendMessage(int sessionId, String content) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.agentSessionMessages(sessionId),
        data: {'content': content},
      );
      return SendMessageResponseModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to send message');
    }
  }
}
