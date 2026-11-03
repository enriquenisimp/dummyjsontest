import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dummyjsontest/core/error/failure.dart';
import 'package:dummyjsontest/core/error/result.dart';
import 'package:dummyjsontest/features/auth/data/repositories/auth_repository.dart';
import 'package:dummyjsontest/features/auth/presentation/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required this.authRepository,
    required this.onAuthenticated,
  }) : super(const LoginIdle());

  final AuthRepository authRepository;
  final Future<void> Function(String accessToken) onAuthenticated;

  void usernameChanged(String username) {
    emit(LoginIdle(username: username, password: state.password));
  }

  void passwordChanged(String password) {
    emit(LoginIdle(username: state.username, password: password));
  }

  Future<void> submit() async {
    if (state is LoginSubmitting) return;

    final username = state.username.trim();
    final password = state.password;

    if (username.isEmpty || password.isEmpty) {
      emit(
        LoginFailure(
          username: state.username,
          password: password,
          failure: const UnexpectedFailure('Enter username and password.'),
        ),
      );
      return;
    }

    emit(LoginSubmitting(username: state.username, password: password));

    final result = await authRepository.login(
      username: username,
      password: password,
    );
    if (isClosed) return;

    switch (result) {
      case Success(:final value):
        await onAuthenticated(value);
        if (isClosed) return;
        emit(LoginSuccess(username: state.username, password: password));
      case FailureResult(:final failure):
        emit(
          LoginFailure(
            username: state.username,
            password: password,
            failure: failure,
          ),
        );
    }
  }
}
