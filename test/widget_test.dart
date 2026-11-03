import 'package:dummyjsontest/features/auth/presentation/login/login_cubit.dart';
import 'package:dummyjsontest/features/auth/presentation/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  testWidgets('LoginView shows Sign in', (tester) async {
    final repository = FakeAuthRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => LoginCubit(
            authRepository: repository,
            onAuthenticated: (_) async {},
          ),
          child: const LoginView(),
        ),
      ),
    );

    expect(find.text('Sign in'), findsWidgets);
  });
}
