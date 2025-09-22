// product_all_bloc.dart
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product_filter.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/abstract_product_bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/utils/log_manager.dart';

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

    if (current is ProductStateWithData) {
      final idx = current.products.indexWhere((p) => p.id == updated.id);
      final newProducts = List<Product>.from(current.products);
      LogManager.debug("updated product ${updated.id}");
      if (idx == -1) {
        newProducts.add(updated);
      } else {
        newProducts[idx] = updated;
      }
      // Emit preserving concrete state type where possible
      if (current is ProductLoaded) {
        emit(current.copyWith(products: newProducts));
      } else if (current is ProductError) {
        emit(current.copyWith(products: newProducts));
      } else {
        emit(
          ProductLoaded(
            products: newProducts,
            hasMore: current.hasMore,
            nextCursor: current.nextCursor,
            isLoadingMore: false,
            productFilter: current.productFilter,
          ),
        );
      }
    }
  }
}
