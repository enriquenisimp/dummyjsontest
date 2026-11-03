import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dummyjsontest/features/products/presentation/product_detail/product_detail_cubit.dart';
import 'package:dummyjsontest/features/products/presentation/product_detail/product_detail_state.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailCubit, ProductDetailState>(
      builder: (context, state) {
        return switch (state) {
          ProductDetailLoading() => Scaffold(
            appBar: AppBar(title: const Text('Product')),
            body: const Center(child: CircularProgressIndicator()),
          ),
          ProductDetailFailure(:final failure) => Scaffold(
            appBar: AppBar(title: const Text('Product')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(failure.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () =>
                          context.read<ProductDetailCubit>().load(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ProductDetailLoaded(:final product) => Scaffold(
            appBar: AppBar(title: Text(product.title)),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Image.network(
                  product.images.isNotEmpty
                      ? product.images.first
                      : product.thumbnail,
                  height: 240,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox(
                    height: 240,
                    child: Center(child: Icon(Icons.broken_image)),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  product.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (product.brand != null && product.brand!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(product.brand!),
                ],
                const SizedBox(height: 8),
                Text('\$${product.price.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                Text(
                  'Rating ${product.rating.toStringAsFixed(2)} · Stock ${product.stock}',
                ),
                const SizedBox(height: 16),
                Text(product.description),
              ],
            ),
          ),
        };
      },
    );
  }
}
