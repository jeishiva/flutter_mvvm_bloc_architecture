import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product.dart';
import 'package:flutter_mvvm_bloc_architecture/extensions/string_extension.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_bloc_base.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_all_bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/ui_models/product_ui_model.dart';

class ProductListWidget extends StatelessWidget {
  final List<ProductUiModel> products;
  final bool hasMore;
  final ScrollController? controller;
  final bool isLoadingMore;

  const ProductListWidget({
    super.key,
    required this.products,
    required this.hasMore,
    required this.isLoadingMore,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final itemCount = products.length + (isLoadingMore ? 1 : 0);
    return ListView.builder(
      controller: controller,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index < products.length) {
          final product = products[index];
          return ProductListItem(
            product: product,
            onFavoriteToggle: (product) {
              context.read<BaseProductBloc>().add(ToggleFavourite(product.id));
            },
          );
        } else {
          // loading indicator at list bottom
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
      },
    );
  }
}

class ProductListItem extends StatelessWidget {
  final ProductUiModel product;
  final ValueChanged<ProductUiModel> onFavoriteToggle;

  const ProductListItem({
    super.key,
    required this.product,
    required this.onFavoriteToggle,
  });

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
            product.title.isNotEmpty ? product.title[0].toUpperCase() : '?',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        title: Text(
          product.title.capitalize(),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          'Price: ${product.subtitle.toString()}',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: IconButton(
          onPressed: () => onFavoriteToggle(product),
          icon: Icon(
            product.isFavourite ? Icons.favorite : Icons.favorite_border,
            color: product.isFavourite
                ? Colors.red
                : theme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          tooltip: product.isFavourite
              ? 'Remove from favorites'
              : 'Add to favorites',
        ),
      ),
    );
  }
}