import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dummyjsontest/core/error/failure.dart';
import 'package:dummyjsontest/core/error/result.dart';
import 'package:dummyjsontest/features/products/data/repositories/products_repository.dart';
import 'package:dummyjsontest/features/products/presentation/product_detail/product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit({
    required this.productsRepository,
    required this.productId,
    required this.onUnauthorized,
  }) : super(const ProductDetailLoading());

  final ProductsRepository productsRepository;
  final int? productId;
  final Future<void> Function() onUnauthorized;

  Future<void> load() async {
    final id = productId;
    if (id == null) {
      emit(
        const ProductDetailFailure(
          UnexpectedFailure('Missing product id.'),
        ),
      );
      return;
    }

    emit(const ProductDetailLoading());

    final result = await productsRepository.fetchById(id);
    if (isClosed) return;

    switch (result) {
      case Success(:final value):
        emit(ProductDetailLoaded(value));
      case FailureResult(:final failure):
        if (failure is UnauthorizedFailure) {
          await onUnauthorized();
          return;
        }
        emit(ProductDetailFailure(failure));
    }
  }
}
