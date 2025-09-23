// product_all_bloc.dart
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_mvvm_bloc_architecture/common/logging/log_manager.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product_filter.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_bloc_base.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductAllBloc extends BaseProductBloc {
  ProductAllBloc(super.productRepo);

  @override
  FutureOr<void> onExternalProductChanged(
      ExternalProductChanged event,
      Emitter<ProductState> emit,
      ) async {
    LogManager.debug("external product function called");

    final updated = event.product;
    final current = state;

    if (current is! ProductStateWithData) return;

    final newProducts = _updateProductInList(current.products, updated);
    _emitUpdatedProductState(emit, current, newProducts);
  }

  List<Product> _updateProductInList(
      List<Product> products,
      Product updatedProduct,
      ) {
    final idx = products.indexWhere((p) => p.id == updatedProduct.id);
    final newProducts = List<Product>.from(products);

    LogManager.debug("updated product ${updatedProduct.id}");

    if (idx == -1) {
      newProducts.add(updatedProduct);
    } else {
      newProducts[idx] = updatedProduct;
    }

    return newProducts;
  }

  void _emitUpdatedProductState(
      Emitter<ProductState> emit,
      ProductStateWithData currentState,
      List<Product> products,
      ) {
    // Emit preserving concrete state type where possible
    if (currentState is ProductLoaded) {
      emit(currentState.copyWith(products: products));
    } else if (currentState is ProductError) {
      emit(currentState.copyWith(products: products));
    } else {
      emit(
        ProductLoaded(
          products: products,
          hasMore: currentState.hasMore,
          nextCursor: currentState.nextCursor,
          isLoadingMore: false,
          productFilter: currentState.productFilter,
        ),
      );
    }
  }
}