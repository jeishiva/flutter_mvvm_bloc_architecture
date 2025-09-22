import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/abstract_product_bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_all_bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/utils/log_manager.dart';

// product_fav_bloc.dart
class ProductFavBloc extends BaseProductBloc {
  ProductFavBloc(super.productRepo);

  @override
  FutureOr<void> onExternalProductChanged(
    ExternalProductChanged event,
    Emitter<ProductState> emit,
  ) async {
    LogManager.debug("external product function called for favorites");
    final updated = event.product;
    final current = state;

    if (current is ProductStateWithData) {
      final newProducts = List<Product>.from(current.products);
      final existingIndex = newProducts.indexWhere((p) => p.id == updated.id);

      if (updated.isFavourite) {
        // Product is marked as favorite
        if (existingIndex == -1) {
          // Add new favorite product
          newProducts.add(updated);
          LogManager.debug("added favorite product ${updated.id}");
        } else {
          // Replace existing favorite product
          newProducts[existingIndex] = updated;
          LogManager.debug("updated favorite product ${updated.id}");
        }
      } else {
        // Product is not marked as favorite
        if (existingIndex != -1) {
          // Remove unfavorited product from favorites list
          newProducts.removeAt(existingIndex);
          LogManager.debug("removed unfavorited product ${updated.id}");
        }
        // If product is not in list and not favorite, do nothing
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
