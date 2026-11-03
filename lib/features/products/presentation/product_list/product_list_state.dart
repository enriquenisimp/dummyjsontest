import 'package:equatable/equatable.dart';
import 'package:dummyjsontest/core/error/failure.dart';
import 'package:dummyjsontest/features/products/data/dto/product_dto.dart';

sealed class ProductListState extends Equatable {
  const ProductListState({required this.products, required this.total});

  final List<ProductDto> products;
  final int total;

  bool get hasMore => products.length < total;

  @override
  List<Object?> get props => [products, total];
}

final class ProductListInitial extends ProductListState {
  const ProductListInitial() : super(products: const [], total: 0);
}

final class ProductListLoading extends ProductListState {
  const ProductListLoading() : super(products: const [], total: 0);
}

final class ProductListLoaded extends ProductListState {
  const ProductListLoaded({required super.products, required super.total});
}

final class ProductListRefreshing extends ProductListState {
  const ProductListRefreshing({required super.products, required super.total});
}

final class ProductListLoadingMore extends ProductListState {
  const ProductListLoadingMore({required super.products, required super.total});
}

final class ProductListFailure extends ProductListState {
  const ProductListFailure({required this.failure})
    : super(products: const [], total: 0);

  final Failure failure;

  @override
  List<Object?> get props => [products, total, failure];
}
