import 'package:dummyjsontest/core/error/result.dart';
import 'package:dummyjsontest/core/storage/token_storage.dart';
import 'package:dummyjsontest/features/auth/data/repositories/auth_repository.dart';
import 'package:dummyjsontest/features/products/data/dto/product_dto.dart';
import 'package:dummyjsontest/features/products/data/repositories/products_repository.dart';

class FakeAuthRepository implements AuthRepository {
  Result<String>? nextResult;
  int loginCallCount = 0;

  @override
  Future<Result<String>> login({
    required String username,
    required String password,
  }) async {
    loginCallCount++;
    final result = nextResult;
    if (result == null) {
      throw StateError('FakeAuthRepository.nextResult was not set');
    }
    return result;
  }
}

class FakeProductsRepository implements ProductsRepository {
  final List<Result<ProductPageDto>> pageResults = [];
  int fetchPageCallCount = 0;

  @override
  Future<Result<ProductPageDto>> fetchPage({
    required int limit,
    required int skip,
  }) async {
    fetchPageCallCount++;
    if (pageResults.isEmpty) {
      throw StateError('FakeProductsRepository.pageResults is empty');
    }
    return pageResults.removeAt(0);
  }

  @override
  Future<Result<ProductDto>> fetchById(int id) {
    throw UnimplementedError();
  }
}

class InMemoryTokenStorage implements TokenStorage {
  String? _token;

  @override
  Future<String?> read() async => _token;

  @override
  Future<void> write(String token) async {
    _token = token;
  }

  @override
  Future<void> delete() async {
    _token = null;
  }
}

ProductDto testProduct({
  required int id,
  String title = 'Title',
}) {
  return ProductDto(
    id: id,
    title: title,
    description: 'Description',
    category: 'beauty',
    price: 9.99,
    rating: 4.5,
    stock: 10,
    thumbnail: 'https://example.com/thumb.png',
    brand: 'Brand',
    images: const ['https://example.com/image.png'],
  );
}
