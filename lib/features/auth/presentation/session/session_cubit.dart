import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dummyjsontest/core/storage/token_storage.dart';

sealed class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object?> get props => [];
}

final class SessionUnknown extends SessionState {
  const SessionUnknown();
}

final class SessionUnauthenticated extends SessionState {
  const SessionUnauthenticated();
}

final class SessionAuthenticated extends SessionState {
  const SessionAuthenticated(this.accessToken);

  final String accessToken;

  @override
  List<Object?> get props => [accessToken];
}

class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this._tokenStorage) : super(const SessionUnknown()) {
    restore();
  }

  final TokenStorage _tokenStorage;

  Future<void> restore() async {
    try {
      final token = await _tokenStorage.read();
      if (isClosed) return;
      if (token == null || token.isEmpty) {
        emit(const SessionUnauthenticated());
      } else {
        emit(SessionAuthenticated(token));
      }
    } catch (_) {
      if (isClosed) return;
      emit(const SessionUnauthenticated());
    }
  }

  Future<void> signedIn(String accessToken) async {
    await _tokenStorage.write(accessToken);
    if (isClosed) return;
    emit(SessionAuthenticated(accessToken));
  }

  Future<void> signOut() async {
    await _tokenStorage.delete();
    if (isClosed) return;
    emit(const SessionUnauthenticated());
  }
}
