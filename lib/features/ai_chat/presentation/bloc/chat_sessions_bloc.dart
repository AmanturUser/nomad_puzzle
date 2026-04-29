import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/chat_session.dart';
import '../../domain/usecases/chat_usecases.dart';

part 'chat_sessions_event.dart';
part 'chat_sessions_state.dart';

@injectable
class ChatSessionsBloc extends Bloc<ChatSessionsEvent, ChatSessionsState> {
  ChatSessionsBloc(this._listSessions, this._createSession, this._deleteSession)
      : super(const ChatSessionsState()) {
    on<ChatSessionsRequested>(_onRequested);
    on<ChatSessionCreated>(_onCreated);
    on<ChatSessionDeleted>(_onDeleted);
  }

  final ListChatSessions _listSessions;
  final CreateChatSession _createSession;
  final DeleteChatSession _deleteSession;

  Future<void> _onRequested(
    ChatSessionsRequested event,
    Emitter<ChatSessionsState> emit,
  ) async {
    emit(state.copyWith(status: ChatSessionsStatus.loading, errorMessage: null));
    final result = await _listSessions();
    result.fold(
      (f) => emit(state.copyWith(
        status: ChatSessionsStatus.failure,
        errorMessage: f.message,
      )),
      (items) => emit(state.copyWith(
        status: ChatSessionsStatus.success,
        items: items,
      )),
    );
  }

  Future<void> _onCreated(
    ChatSessionCreated event,
    Emitter<ChatSessionsState> emit,
  ) async {
    emit(state.copyWith(creating: true, errorMessage: null));
    final result = await _createSession(title: event.title);
    result.fold(
      (f) => emit(state.copyWith(creating: false, errorMessage: f.message)),
      (session) => emit(state.copyWith(
        creating: false,
        items: [session, ...state.items],
        lastCreatedId: session.id,
      )),
    );
  }

  Future<void> _onDeleted(
    ChatSessionDeleted event,
    Emitter<ChatSessionsState> emit,
  ) async {
    final result = await _deleteSession(event.id);
    result.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (_) => emit(state.copyWith(
        items: state.items.where((s) => s.id != event.id).toList(),
      )),
    );
  }
}
