import 'package:equatable/equatable.dart';
import 'package:dummyjsontest/core/error/failure.dart';
import 'package:dummyjsontest/features/products/data/dto/product_dto.dart';

sealed class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object?> get props => [];
}

final class ProductDetailLoading extends ProductDetailState {
  const ProductDetailLoading();
}

final class ProductDetailLoaded extends ProductDetailState {
  const ProductDetailLoaded(this.product);

  final ProductDto product;

  @override
  List<Object?> get props => [product];
}

final class ProductDetailFailure extends ProductDetailState {
  const ProductDetailFailure(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
