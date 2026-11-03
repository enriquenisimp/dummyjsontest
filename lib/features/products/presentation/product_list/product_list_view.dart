import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dummyjsontest/app/app_route.dart';
import 'package:dummyjsontest/features/products/data/dto/product_dto.dart';
import 'package:dummyjsontest/features/products/presentation/product_list/product_list_cubit.dart';
import 'package:dummyjsontest/features/products/presentation/product_list/product_list_state.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            tooltip: 'Log out',
            onPressed: onLogout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: BlocConsumer<ProductListCubit, ProductListState>(
        listener: (context, state) {
          final loadMoreError = context
              .read<ProductListCubit>()
              .consumeLoadMoreError();
          if (loadMoreError != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(loadMoreError)));
          }
        },
        builder: (context, state) {
          return switch (state) {
            ProductListInitial() || ProductListLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            ProductListFailure(:final failure) => RefreshIndicator(
              onRefresh: () => context.read<ProductListCubit>().refresh(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 120),
                  Text(failure.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  Center(
                    child: FilledButton(
                      onPressed: () =>
                          context.read<ProductListCubit>().load(),
                      child: const Text('Retry'),
                    ),
                  ),
                ],
              ),
            ),
            ProductListLoaded(products: final products)
                when products.isEmpty =>
              RefreshIndicator(
                onRefresh: () => _refresh(context),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 120),
                    Text('No products', textAlign: TextAlign.center),
                  ],
                ),
              ),
            ProductListLoaded() ||
            ProductListRefreshing() ||
            ProductListLoadingMore() =>
              NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.pixels >=
                      notification.metrics.maxScrollExtent - 240) {
                    context.read<ProductListCubit>().loadMore();
                  }
                  return false;
                },
                child: RefreshIndicator(
                  onRefresh: () => _refresh(context),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount:
                        state.products.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= state.products.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final product = state.products[index];
                      return _ProductTile(product: product);
                    },
                  ),
                ),
              ),
          };
        },
      ),
    );
  }

  Future<void> _refresh(BuildContext context) async {
    final cubit = context.read<ProductListCubit>();
    await cubit.refresh();
    if (!context.mounted) return;
    final error = cubit.consumeRefreshError();
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final ProductDto product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey(product.id),
      leading: Image.network(
        product.thumbnail,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const Icon(Icons.broken_image),
      ),
      title: Text(product.title),
      subtitle: Text(
        '${product.category} · \$${product.price.toStringAsFixed(2)}',
      ),
      onTap: () => context.pushNamed(
        AppRoute.productDetail.name,
        pathParameters: {'id': '${product.id}'},
      ),
    );
  }
}
