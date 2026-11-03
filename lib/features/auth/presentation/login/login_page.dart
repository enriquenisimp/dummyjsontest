import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dummyjsontest/features/auth/data/repositories/auth_repository.dart';
import 'package:dummyjsontest/features/auth/presentation/login/login_cubit.dart';
import 'package:dummyjsontest/features/auth/presentation/login/login_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    super.key,
    required this.authRepository,
    required this.onAuthenticated,
  });

  final AuthRepository authRepository;
  final Future<void> Function(String accessToken) onAuthenticated;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(
        authRepository: authRepository,
        onAuthenticated: onAuthenticated,
      ),
      child: const LoginView(),
    );
  }
}
