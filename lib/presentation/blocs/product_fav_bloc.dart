import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_bloc_base.dart';
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

    if (current is! ProductStateWithData) return;

    final newProducts = _updateFavoritesList(current.products, updated);
    _emitUpdatedFavoritesState(emit, current, newProducts);
  }

  List<Product> _updateFavoritesList(
      List<Product> products,
      Product updatedProduct,
      ) {
    final newProducts = List<Product>.from(products);
    final existingIndex = newProducts.indexWhere((p) => p.id == updatedProduct.id);

    if (updatedProduct.isFavourite) {
      _handleAddOrUpdateFavorite(newProducts, updatedProduct, existingIndex);
    } else {
      _handleRemoveFavorite(newProducts, updatedProduct, existingIndex);
    }

    return newProducts;
  }

  void _handleAddOrUpdateFavorite(
      List<Product> products,
      Product updatedProduct,
      int existingIndex,
      ) {
    if (existingIndex == -1) {
      // Add new favorite product
      products.add(updatedProduct);
      LogManager.debug("added favorite product ${updatedProduct.id}");
    } else {
      // Replace existing favorite product
      products[existingIndex] = updatedProduct;
      LogManager.debug("updated favorite product ${updatedProduct.id}");
    }
  }

  void _handleRemoveFavorite(
      List<Product> products,
      Product updatedProduct,
      int existingIndex,
      ) {
    if (existingIndex != -1) {
      // Remove unfavorited product from favorites list
      products.removeAt(existingIndex);
      LogManager.debug("removed unfavorited product ${updatedProduct.id}");
    }
    // If product is not in list and not favorite, do nothing
  }

  void _emitUpdatedFavoritesState(
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