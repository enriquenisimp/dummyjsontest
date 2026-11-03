import 'package:bloc_test/bloc_test.dart';
import 'package:dummyjsontest/core/error/failure.dart';
import 'package:dummyjsontest/core/error/result.dart';
import 'package:dummyjsontest/features/products/data/dto/product_dto.dart';
import 'package:dummyjsontest/features/products/presentation/product_list/product_list_cubit.dart';
import 'package:dummyjsontest/features/products/presentation/product_list/product_list_state.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  group('ProductListCubit', () {
    late FakeProductsRepository repository;

    setUp(() {
      repository = FakeProductsRepository();
    });

    ProductListCubit buildCubit() {
      return ProductListCubit(
        productsRepository: repository,
        onUnauthorized: () async {},
      );
    }

    blocTest<ProductListCubit, ProductListState>(
      'load emits loading then loaded with hasMore true',
      build: buildCubit,
      setUp: () {
        repository.pageResults.add(
          Success(
            ProductPageDto(
              products: [testProduct(id: 1)],
              total: 40,
              skip: 0,
              limit: 20,
            ),
          ),
        );
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const ProductListLoading(),
        ProductListLoaded(products: [testProduct(id: 1)], total: 40),
      ],
      verify: (cubit) {
        expect(cubit.state.hasMore, isTrue);
      },
    );

    blocTest<ProductListCubit, ProductListState>(
      'load emits loading then failure',
      build: buildCubit,
      setUp: () {
        repository.pageResults.add(
          const FailureResult(NetworkFailure()),
        );
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const ProductListLoading(),
        const ProductListFailure(failure: NetworkFailure()),
      ],
    );

    blocTest<ProductListCubit, ProductListState>(
      'loadMore appends the next page',
      build: buildCubit,
      seed: () => ProductListLoaded(
        products: [testProduct(id: 1)],
        total: 2,
      ),
      setUp: () {
        repository.pageResults.add(
          Success(
            ProductPageDto(
              products: [testProduct(id: 2, title: 'Second')],
              total: 2,
              skip: 1,
              limit: 20,
            ),
          ),
        );
      },
      act: (cubit) => cubit.loadMore(),
      expect: () => [
        ProductListLoadingMore(
          products: [testProduct(id: 1)],
          total: 2,
        ),
        ProductListLoaded(
          products: [
            testProduct(id: 1),
            testProduct(id: 2, title: 'Second'),
          ],
          total: 2,
        ),
      ],
    );

    blocTest<ProductListCubit, ProductListState>(
      'loadMore emits nothing when products length equals total',
      build: buildCubit,
      seed: () => ProductListLoaded(
        products: [testProduct(id: 1)],
        total: 1,
      ),
      act: (cubit) => cubit.loadMore(),
      expect: () => <ProductListState>[],
      verify: (_) {
        expect(repository.fetchPageCallCount, 0);
      },
    );
  });
}
