import 'package:dio/dio.dart';
import 'package:dummyjsontest/core/error/failure.dart';
import 'package:dummyjsontest/core/error/result.dart';
import 'package:dummyjsontest/core/network/dio_failure_mapper.dart';
import 'package:dummyjsontest/features/products/data/dto/product_dto.dart';
import 'package:dummyjsontest/features/products/data/products_api.dart';

abstract class ProductsRepository {
  Future<Result<ProductPageDto>> fetchPage({
    required int limit,
    required int skip,
  });

  Future<Result<ProductDto>> fetchById(int id);
}

class ProductsRepositoryImpl implements ProductsRepository {
  ProductsRepositoryImpl(this._api);

  final ProductsApi _api;

  @override
  Future<Result<ProductPageDto>> fetchPage({
    required int limit,
    required int skip,
  }) async {
    try {
      final page = await _api.fetchPage(limit: limit, skip: skip);
      return Success(page);
    } on DioException catch (exception) {
      return FailureResult(mapDioException(exception, isLogin: false));
    } on FormatException catch (exception) {
      return FailureResult(UnexpectedFailure(exception.message));
    }
  }

  @override
  Future<Result<ProductDto>> fetchById(int id) async {
    try {
      final product = await _api.fetchById(id);
      return Success(product);
    } on DioException catch (exception) {
      return FailureResult(mapDioException(exception, isLogin: false));
    } on FormatException catch (exception) {
      return FailureResult(UnexpectedFailure(exception.message));
    }
  }
}
