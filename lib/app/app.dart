import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dummyjsontest/app/router.dart';
import 'package:dummyjsontest/features/auth/data/repositories/auth_repository.dart';
import 'package:dummyjsontest/features/auth/presentation/session/session_cubit.dart';
import 'package:dummyjsontest/features/products/data/repositories/products_repository.dart';

class App extends StatefulWidget {
  const App({
    super.key,
    required this.sessionCubit,
    required this.authRepository,
    required this.productsRepository,
  });

  final SessionCubit sessionCubit;
  final AuthRepository authRepository;
  final ProductsRepository productsRepository;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router = createRouter(
    sessionCubit: widget.sessionCubit,
    authRepository: widget.authRepository,
    productsRepository: widget.productsRepository,
  );

  @override
  void dispose() {
    _router.dispose();
    widget.sessionCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.sessionCubit,
      child: MaterialApp.router(
        title: 'DummyJSON Shop',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        routerConfig: _router,
      ),
    );
  }
}
