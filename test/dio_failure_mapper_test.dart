import 'package:dio/dio.dart';
import 'package:dummyjsontest/core/error/failure.dart';
import 'package:dummyjsontest/core/network/dio_failure_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('mapDioException', () {
    test('maps login HTTP 400 to UnauthorizedFailure with server message', () {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/auth/login'),
          statusCode: 400,
          data: {'message': 'Invalid credentials'},
        ),
      );

      final failure = mapDioException(exception, isLogin: true);

      expect(
        failure,
        const UnauthorizedFailure('Invalid credentials'),
      );
    });

    test('maps connectionError to NetworkFailure', () {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/products'),
        type: DioExceptionType.connectionError,
      );

      final failure = mapDioException(exception, isLogin: false);

      expect(failure, const NetworkFailure());
    });
  });
}
