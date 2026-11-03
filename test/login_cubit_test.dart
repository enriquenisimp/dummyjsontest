import 'package:bloc_test/bloc_test.dart';
import 'package:dummyjsontest/core/error/failure.dart';
import 'package:dummyjsontest/core/error/result.dart';
import 'package:dummyjsontest/features/auth/presentation/login/login_cubit.dart';
import 'package:dummyjsontest/features/auth/presentation/login/login_state.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  group('LoginCubit', () {
    late FakeAuthRepository repository;
    late List<String> authenticatedTokens;

    setUp(() {
      repository = FakeAuthRepository();
      authenticatedTokens = [];
    });

    LoginCubit buildCubit() {
      return LoginCubit(
        authRepository: repository,
        onAuthenticated: (token) async {
          authenticatedTokens.add(token);
        },
      );
    }

    blocTest<LoginCubit, LoginState>(
      'emits LoginFailure when username is empty and does not call repository',
      build: buildCubit,
      seed: () => const LoginIdle(username: '   ', password: 'secret'),
      act: (cubit) => cubit.submit(),
      expect: () => [
        const LoginFailure(
          username: '   ',
          password: 'secret',
          failure: UnexpectedFailure('Enter username and password.'),
        ),
      ],
      verify: (_) {
        expect(repository.loginCallCount, 0);
        expect(authenticatedTokens, isEmpty);
      },
    );

    blocTest<LoginCubit, LoginState>(
      'emits submitting then success and calls onAuthenticated',
      build: buildCubit,
      seed: () => const LoginIdle(username: 'emilys', password: 'emilyspass'),
      setUp: () {
        repository.nextResult = const Success('token-123');
      },
      act: (cubit) => cubit.submit(),
      expect: () => [
        const LoginSubmitting(username: 'emilys', password: 'emilyspass'),
        const LoginSuccess(username: 'emilys', password: 'emilyspass'),
      ],
      verify: (_) {
        expect(repository.loginCallCount, 1);
        expect(authenticatedTokens, ['token-123']);
      },
    );

    blocTest<LoginCubit, LoginState>(
      'emits submitting then failure on network error',
      build: buildCubit,
      seed: () => const LoginIdle(username: 'emilys', password: 'emilyspass'),
      setUp: () {
        repository.nextResult = const FailureResult(NetworkFailure());
      },
      act: (cubit) => cubit.submit(),
      expect: () => [
        const LoginSubmitting(username: 'emilys', password: 'emilyspass'),
        const LoginFailure(
          username: 'emilys',
          password: 'emilyspass',
          failure: NetworkFailure(),
        ),
      ],
      verify: (_) {
        expect(authenticatedTokens, isEmpty);
      },
    );
  });
}
