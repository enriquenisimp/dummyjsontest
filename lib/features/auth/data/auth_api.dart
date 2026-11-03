import 'package:dio/dio.dart';
import 'package:dummyjsontest/features/auth/data/dto/login_response_dto.dart';

class AuthApi {
  AuthApi(this._dio);

  final Dio _dio;

  Future<LoginResponseDto> login({
    required String username,
    required String password,
  }) async {
    final response = await _dio.post<dynamic>(
      '/auth/login',
      data: {'username': username, 'password': password},
    );
    final data = response.data;
    if (data is! Map) {
      throw const FormatException('Login response was not a JSON object');
    }
    return LoginResponseDto.fromJson(Map<String, dynamic>.from(data));
  }
}
