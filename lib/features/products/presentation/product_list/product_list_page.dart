import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dummyjsontest/features/products/data/repositories/products_repository.dart';
import 'package:dummyjsontest/features/products/presentation/product_list/product_list_cubit.dart';
import 'package:dummyjsontest/features/products/presentation/product_list/product_list_view.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({
    super.key,
    required this.productsRepository,
    required this.onUnauthorized,
    required this.onLogout,
  });

  final ProductsRepository productsRepository;
  final Future<void> Function() onUnauthorized;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductListCubit(
        productsRepository: productsRepository,
        onUnauthorized: onUnauthorized,
      )..load(),
      child: ProductListView(onLogout: onLogout),
    );
  }
}
