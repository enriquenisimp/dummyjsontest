import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dummyjsontest/core/error/failure.dart';
import 'package:dummyjsontest/core/error/result.dart';
import 'package:dummyjsontest/features/products/data/repositories/products_repository.dart';
import 'package:dummyjsontest/features/products/presentation/product_list/product_list_state.dart';

const productsPageSize = 20;

class ProductListCubit extends Cubit<ProductListState> {
  ProductListCubit({
    required this.productsRepository,
    required this.onUnauthorized,
  }) : super(const ProductListInitial());

  final ProductsRepository productsRepository;
  final Future<void> Function() onUnauthorized;

  int _generation = 0;
  String? _refreshError;
  String? _loadMoreError;

  String? consumeRefreshError() {
    final error = _refreshError;
    _refreshError = null;
    return error;
  }

  String? consumeLoadMoreError() {
    final error = _loadMoreError;
    _loadMoreError = null;
    return error;
  }

  Future<void> load() async {
    final generation = ++_generation;
    emit(const ProductListLoading());

    final result = await productsRepository.fetchPage(
      limit: productsPageSize,
      skip: 0,
    );
    if (isClosed || generation != _generation) return;

    switch (result) {
      case Success(:final value):
        emit(
          ProductListLoaded(products: value.products, total: value.total),
        );
      case FailureResult(:final failure):
        if (failure is UnauthorizedFailure) {
          await onUnauthorized();
          return;
        }
        emit(ProductListFailure(failure: failure));
    }
  }

  Future<void> refresh() async {
    final previousProducts = state.products;
    final previousTotal = state.total;
    final generation = ++_generation;

    if (previousProducts.isEmpty) {
      emit(const ProductListLoading());
    } else {
      emit(
        ProductListRefreshing(
          products: previousProducts,
          total: previousTotal,
        ),
      );
    }

    final result = await productsRepository.fetchPage(
      limit: productsPageSize,
      skip: 0,
    );
    if (isClosed || generation != _generation) return;

    switch (result) {
      case Success(:final value):
        _refreshError = null;
        emit(
          ProductListLoaded(products: value.products, total: value.total),
        );
      case FailureResult(:final failure):
        if (failure is UnauthorizedFailure) {
          await onUnauthorized();
          return;
        }
        if (previousProducts.isEmpty) {
          emit(ProductListFailure(failure: failure));
        } else {
          _refreshError = failure.message;
          emit(
            ProductListLoaded(
              products: previousProducts,
              total: previousTotal,
            ),
          );
        }
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! ProductListLoaded || !current.hasMore) return;

    final previousProducts = current.products;
    final previousTotal = current.total;
    final generation = _generation;

    emit(
      ProductListLoadingMore(
        products: previousProducts,
        total: previousTotal,
      ),
    );

    final result = await productsRepository.fetchPage(
      limit: productsPageSize,
      skip: previousProducts.length,
    );
    if (isClosed || generation != _generation) return;

    switch (result) {
      case Success(:final value):
        if (value.products.isEmpty) {
          emit(
            ProductListLoaded(
              products: previousProducts,
              total: previousProducts.length,
            ),
          );
          return;
        }
        emit(
          ProductListLoaded(
            products: [...previousProducts, ...value.products],
            total: value.total,
          ),
        );
      case FailureResult(:final failure):
        if (failure is UnauthorizedFailure) {
          await onUnauthorized();
          return;
        }
        _loadMoreError = failure.message;
        emit(
          ProductListLoaded(
            products: previousProducts,
            total: previousTotal,
          ),
        );
    }
  }
}
