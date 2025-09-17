import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/di/injector.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_bloc.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<StatefulWidget> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProductBloc>()..add(const LoadProducts()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Products')),
        body: SafeArea(child: ProductBody()),
      ),
    );
  }
}

class ProductBody extends StatelessWidget {
  const ProductBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return switch (state) {
          ProductLoading() => const ProductLoadingWidget(),
          ProductLoaded() => ProductList(products: state.products),
          ProductError() => ProductErrorWidget(message: state.message),
          _ => const SizedBox(),
        };
      },
    );
  }
}

class ProductLoadingWidget extends StatelessWidget {
  const ProductLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class ProductList extends StatelessWidget {
  final List<Product> products;

  const ProductList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductListItem(product: product);
      },
    );
  }
}

class ProductListItem extends StatelessWidget {
  final Product product;

  const ProductListItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      key: ValueKey(product.id),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 36,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            product.name.isNotEmpty ? product.name[0].toUpperCase() : '?',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        title: Text(
          product.name,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Price: ${product.price.toString()}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class ProductErrorWidget extends StatelessWidget {
  final String message;

  const ProductErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
