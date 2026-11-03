import 'package:go_router/go_router.dart';
import 'package:dummyjsontest/app/app_route.dart';
import 'package:dummyjsontest/app/go_router_refresh_stream.dart';
import 'package:dummyjsontest/app/splash_page.dart';
import 'package:dummyjsontest/features/auth/data/repositories/auth_repository.dart';
import 'package:dummyjsontest/features/auth/presentation/login/login_page.dart';
import 'package:dummyjsontest/features/auth/presentation/session/session_cubit.dart';
import 'package:dummyjsontest/features/products/data/repositories/products_repository.dart';
import 'package:dummyjsontest/features/products/presentation/product_detail/product_detail_page.dart';
import 'package:dummyjsontest/features/products/presentation/product_list/product_list_page.dart';

GoRouter createRouter({
  required SessionCubit sessionCubit,
  required AuthRepository authRepository,
  required ProductsRepository productsRepository,
}) {
  return GoRouter(
    initialLocation: AppRoute.splash.path,
    refreshListenable: GoRouterRefreshStream(sessionCubit.stream),
    redirect: (context, state) {
      final session = sessionCubit.state;
      final location = state.matchedLocation;

      return switch (session) {
        SessionUnknown() =>
          location == AppRoute.splash.path ? null : AppRoute.splash.path,
        SessionUnauthenticated() =>
          location == AppRoute.login.path ? null : AppRoute.login.path,
        SessionAuthenticated() =>
          location == AppRoute.login.path || location == AppRoute.splash.path
              ? AppRoute.products.path
              : null,
      };
    },
    routes: [
      GoRoute(
        path: AppRoute.splash.path,
        name: AppRoute.splash.name,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoute.login.path,
        name: AppRoute.login.name,
        builder: (context, state) => LoginPage(
          authRepository: authRepository,
          onAuthenticated: sessionCubit.signedIn,
        ),
      ),
      GoRoute(
        path: AppRoute.products.path,
        name: AppRoute.products.name,
        builder: (context, state) => ProductListPage(
          productsRepository: productsRepository,
          onUnauthorized: sessionCubit.signOut,
          onLogout: () {
            sessionCubit.signOut();
          },
        ),
      ),
      GoRoute(
        path: AppRoute.productDetail.path,
        name: AppRoute.productDetail.name,
        builder: (context, state) {
          final productId = int.tryParse(state.pathParameters['id'] ?? '');
          return ProductDetailPage(
            productsRepository: productsRepository,
            productId: productId,
            onUnauthorized: sessionCubit.signOut,
          );
        },
      ),
    ],
  );
}
