import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import '../auth/auth_token_storage.dart';
import 'api_constants.dart';

class SseEvent {
  const SseEvent({required this.event, required this.data});

  final String event;
  final String data;

  @override
  String toString() => 'SseEvent($event, ${data.length} bytes)';
}

/// Server-Sent Events client built on raw `dart:io.HttpClient`.
///
/// Dio's stream adapter buffers SSE responses on some platforms (Android
/// in particular), causing the response stream to complete instantly. The
/// raw HttpClient avoids the issue because it forwards chunks to the
/// caller as they land on the socket.
class SseClient {
  SseClient(this._tokenStorage);

  final AuthTokenStorage _tokenStorage;

  /// Opens an SSE connection to [path] and yields parsed events.
  /// Auto-reconnects forever until the consumer cancels.
  Stream<SseEvent> connect(String path) async* {
    while (true) {
      final connectedAt = DateTime.now();
      developer.log('▶ connecting to $path', name: 'sse');
      HttpClient? httpClient;
      try {
        httpClient = HttpClient()
          ..connectionTimeout = const Duration(seconds: 30)
          ..idleTimeout = const Duration(days: 365);
        final uri = Uri.parse('${ApiConstants.baseUrl}$path');
        final request = await httpClient.getUrl(uri);
        final token = await _tokenStorage.read();
        if (token != null && token.isNotEmpty) {
          request.headers.add('Authorization', 'Bearer $token');
        }
        request.headers.add('Accept', 'text/event-stream');
        request.headers.add('Cache-Control', 'no-cache');
        final response = await request.close();
        developer.log(
          '✓ connected (${response.statusCode})',
          name: 'sse',
        );
        if (response.statusCode != 200) {
          await response.drain<void>();
          throw HttpException('SSE handshake failed: ${response.statusCode}');
        }
        yield* _parseEvents(response);
        developer.log('— stream ended cleanly', name: 'sse');
      } catch (e, st) {
        developer.log('✗ error: $e', error: e, stackTrace: st, name: 'sse');
      } finally {
        httpClient?.close(force: true);
      }
      final elapsed = DateTime.now().difference(connectedAt);
      final delay = elapsed < const Duration(seconds: 10)
          ? const Duration(seconds: 15)
          : const Duration(seconds: 5);
      developer.log(
        'reconnecting in ${delay.inSeconds}s (lasted ${elapsed.inSeconds}s)',
        name: 'sse',
      );
      await Future<void>.delayed(delay);
    }
  }

  Stream<SseEvent> _parseEvents(Stream<List<int>> bytes) async* {
    final lines = bytes
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    var eventName = 'message';
    final dataBuffer = StringBuffer();

    await for (final line in lines) {
      if (line.isEmpty) {
        if (dataBuffer.isNotEmpty) {
          final data = dataBuffer.toString();
          developer.log(
            '◉ $eventName: ${data.length > 200 ? "${data.substring(0, 200)}…" : data}',
            name: 'sse',
          );
          yield SseEvent(event: eventName, data: data);
        }
        eventName = 'message';
        dataBuffer.clear();
        continue;
      }
      if (line.startsWith(':')) {
        developer.log('· heartbeat', name: 'sse');
        continue;
      }
      if (line.startsWith('event:')) {
        eventName = line.substring(6).trim();
      } else if (line.startsWith('data:')) {
        if (dataBuffer.isNotEmpty) dataBuffer.write('\n');
        dataBuffer.write(line.substring(5).trim());
      }
    }
  }
}
