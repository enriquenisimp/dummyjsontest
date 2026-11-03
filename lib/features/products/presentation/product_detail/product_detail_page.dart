import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dummyjsontest/features/products/data/repositories/products_repository.dart';
import 'package:dummyjsontest/features/products/presentation/product_detail/product_detail_cubit.dart';
import 'package:dummyjsontest/features/products/presentation/product_detail/product_detail_view.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({
    super.key,
    required this.productsRepository,
    required this.productId,
    required this.onUnauthorized,
  });

  final ProductsRepository productsRepository;
  final int? productId;
  final Future<void> Function() onUnauthorized;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductDetailCubit(
        productsRepository: productsRepository,
        productId: productId,
        onUnauthorized: onUnauthorized,
      )..load(),
      child: const ProductDetailView(),
    );
  }
}
