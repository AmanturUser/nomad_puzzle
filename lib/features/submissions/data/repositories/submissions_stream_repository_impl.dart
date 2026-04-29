import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../../../core/network/api_constants.dart';
import '../../../../core/network/sse_client.dart';
import '../../domain/entities/submission_event.dart';
import '../../domain/repositories/submissions_stream_repository.dart';

@LazySingleton(as: SubmissionsStreamRepository)
class SubmissionsStreamRepositoryImpl implements SubmissionsStreamRepository {
  SubmissionsStreamRepositoryImpl(this._sse);

  final SseClient _sse;

  @override
  Stream<SubmissionEvent> watch() {
    return _sse.connect(ApiConstants.meStream).transform(
      StreamTransformer<SseEvent, SubmissionEvent>.fromHandlers(
        handleData: (sse, sink) {
          final parsed = _parse(sse);
          if (parsed != null) sink.add(parsed);
        },
      ),
    );
  }

  SubmissionEvent? _parse(SseEvent raw) {
    Map<String, dynamic> payload;
    try {
      payload = jsonDecode(raw.data) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
    switch (raw.event) {
      case 'connected':
        final userId = (payload['user_id'] as num?)?.toInt() ?? 0;
        return SubmissionConnected(userId: userId);
      case 'status':
        final id = (payload['submission_id'] as num?)?.toInt();
        final status = _verdict(payload['status']);
        if (id == null) return null;
        return SubmissionStatusChanged(submissionId: id, status: status);
      case 'result':
        final id = (payload['id'] as num?)?.toInt();
        final challengeId = (payload['challenge_id'] as num?)?.toInt();
        final status = _verdict(payload['status']);
        if (id == null || challengeId == null) return null;
        return SubmissionResultReceived(
          submissionId: id,
          challengeId: challengeId,
          status: status,
          confidence: (payload['ai_confidence'] as num?)?.toDouble(),
          reasoning: payload['ai_reasoning'] as String?,
        );
      case 'error':
        final id = (payload['submission_id'] as num?)?.toInt() ?? 0;
        return SubmissionFailed(
          submissionId: id,
          error: (payload['error'] as String?) ?? 'Verifier failed',
        );
      default:
        return null;
    }
  }

  SubmissionVerdict _verdict(Object? value) {
    switch (value) {
      case 'approved':
        return SubmissionVerdict.approved;
      case 'rejected':
        return SubmissionVerdict.rejected;
      case 'failed':
        return SubmissionVerdict.failed;
      case 'processing':
      default:
        return SubmissionVerdict.processing;
    }
  }
}
