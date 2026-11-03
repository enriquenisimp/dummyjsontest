import 'package:flutter/material.dart';
import 'package:dummyjsontest/app/app.dart';
import 'package:dummyjsontest/core/network/dio_client.dart';
import 'package:dummyjsontest/core/storage/token_storage.dart';
import 'package:dummyjsontest/features/auth/data/auth_api.dart';
import 'package:dummyjsontest/features/auth/data/repositories/auth_repository.dart';
import 'package:dummyjsontest/features/auth/presentation/session/session_cubit.dart';
import 'package:dummyjsontest/features/products/data/products_api.dart';
import 'package:dummyjsontest/features/products/data/repositories/products_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final tokenStorage = SecureTokenStorage();
  final sessionCubit = SessionCubit(tokenStorage);
  final dio = createDio(
    readAccessToken: () {
      final state = sessionCubit.state;
      return state is SessionAuthenticated ? state.accessToken : null;
    },
  );

  runApp(
    App(
      sessionCubit: sessionCubit,
      authRepository: AuthRepositoryImpl(AuthApi(dio)),
      productsRepository: ProductsRepositoryImpl(ProductsApi(dio)),
    ),
  );
}
