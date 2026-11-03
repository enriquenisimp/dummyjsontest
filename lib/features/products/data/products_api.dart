import 'package:dio/dio.dart';
import 'package:dummyjsontest/features/products/data/dto/product_dto.dart';

class ProductsApi {
  ProductsApi(this._dio);

  final Dio _dio;

  Future<ProductPageDto> fetchPage({
    required int limit,
    required int skip,
  }) async {
    final response = await _dio.get<dynamic>(
      '/products',
      queryParameters: {'limit': limit, 'skip': skip},
    );
    final data = response.data;
    if (data is! Map) {
      throw const FormatException('Products response was not a JSON object');
    }
    return ProductPageDto.fromJson(Map<String, dynamic>.from(data));
  }

  Future<ProductDto> fetchById(int id) async {
    final response = await _dio.get<dynamic>('/products/$id');
    final data = response.data;
    if (data is! Map) {
      throw const FormatException('Product response was not a JSON object');
    }
    return ProductDto.fromJson(Map<String, dynamic>.from(data));
  }
}
