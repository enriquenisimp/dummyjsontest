import 'package:equatable/equatable.dart';
import 'package:dummyjsontest/core/error/failure.dart';

sealed class LoginState extends Equatable {
  const LoginState({required this.username, required this.password});

  final String username;
  final String password;

  @override
  List<Object?> get props => [username, password];
}

final class LoginIdle extends LoginState {
  const LoginIdle({super.username = '', super.password = ''});
}

final class LoginSubmitting extends LoginState {
  const LoginSubmitting({required super.username, required super.password});
}

final class LoginFailure extends LoginState {
  const LoginFailure({
    required super.username,
    required super.password,
    required this.failure,
  });

  final Failure failure;

  @override
  List<Object?> get props => [username, password, failure];
}

final class LoginSuccess extends LoginState {
  const LoginSuccess({required super.username, required super.password});
}
