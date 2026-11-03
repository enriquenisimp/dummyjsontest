import 'package:dio/dio.dart';
import 'package:dummyjsontest/core/error/failure.dart';
import 'package:dummyjsontest/core/error/result.dart';
import 'package:dummyjsontest/core/network/dio_failure_mapper.dart';
import 'package:dummyjsontest/features/auth/data/auth_api.dart';

abstract class AuthRepository {
  Future<Result<String>> login({
    required String username,
    required String password,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._api);

  final AuthApi _api;

  @override
  Future<Result<String>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _api.login(
        username: username,
        password: password,
      );
      return Success(response.accessToken);
    } on DioException catch (exception) {
      return FailureResult(mapDioException(exception, isLogin: true));
    } on FormatException catch (exception) {
      return FailureResult(UnexpectedFailure(exception.message));
    }
  }
}
