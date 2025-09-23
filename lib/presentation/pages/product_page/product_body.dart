import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_bloc_base.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_all_bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/pages/product_page/product_list.dart';

class ProductBody extends StatelessWidget {
  final ScrollController? controller;

  const ProductBody({super.key, this.controller});

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
            ProductListWidget(
              products: products,
              hasMore: hasMore,
              isLoadingMore: isLoadingMore,
              controller: controller,
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
