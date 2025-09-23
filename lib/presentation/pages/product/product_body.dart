import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_bloc_base.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_all_bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/pages/product/product_list.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/ui_models/product_ui_model.dart';

class ProductBody extends StatelessWidget {
  final ScrollController? controller;
  final bool canToggleFavourite;

  const ProductBody({
    super.key,
    this.controller,
    required this.canToggleFavourite,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseProductBloc, ProductState>(
      builder: (context, state) {
        return switch (state) {
          ProductLoading() => const ProductLoadingWidget(),

          ProductLoaded(
            :final products,
            :final hasMore,
            :final isLoadingMore,
          ) =>
            _buildLoaded(
              products,
              hasMore,
              isLoadingMore,
              controller,
              canToggleFavourite,
            ),

          ProductError(errorMessage: final message) => ProductErrorWidget(
            message: message,
          ),

          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

Widget _buildLoaded(
  List<ProductUiModel> products,
  bool hasMore,
  bool isLoadingMore,
  ScrollController? controller,
  bool canToggleFavourite,
) {
  if (products.isEmpty) {
    return const Center(
      child: Text(
        "No products",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  return ProductListWidget(
    products: products,
    hasMore: hasMore,
    isLoadingMore: isLoadingMore,
    controller: controller,
    canToggleFavourite: canToggleFavourite,
  );
}

class ProductLoadingWidget extends StatelessWidget {
  const ProductLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
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
