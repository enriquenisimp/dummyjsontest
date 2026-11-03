import 'package:dio/dio.dart';
import 'package:dummyjsontest/core/error/failure.dart';

Failure mapDioException(DioException exception, {required bool isLogin}) {
  switch (exception.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
    case DioExceptionType.transformTimeout:
      return const NetworkFailure();
    case DioExceptionType.badResponse:
    case DioExceptionType.cancel:
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      break;
  }

  final statusCode = exception.response?.statusCode;
  final serverMessage = _serverMessage(exception.response?.data);

  if (statusCode == 401 || statusCode == 403) {
    return UnauthorizedFailure(
      serverMessage ?? 'Your session expired. Log in again.',
    );
  }

  if (statusCode == 400 && isLogin) {
    return UnauthorizedFailure(
      serverMessage ?? 'Invalid username or password.',
    );
  }

  return UnexpectedFailure(serverMessage ?? 'Something went wrong.');
}

String? _serverMessage(Object? data) {
  if (data is Map && data['message'] is String) {
    return data['message'] as String;
  }
  return null;
}
