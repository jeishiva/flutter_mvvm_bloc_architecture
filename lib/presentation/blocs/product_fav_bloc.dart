import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_bloc_base.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_all_bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/common/logging/log_manager.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/mappers/product_ui_mapper.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/ui_models/product_ui_model.dart';

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

  List<ProductUiModel> _updateFavoritesList(
    List<ProductUiModel> products,
    Product updatedProduct,
  ) {
    final newProducts = List<ProductUiModel>.from(products);
    final existingIndex = newProducts.indexWhere(
      (p) => p.id == updatedProduct.id,
    );

    if (updatedProduct.isFavourite) {
      _handleAddOrUpdateFavorite(newProducts, updatedProduct.toUiModel(), existingIndex);
    } else {
      _handleRemoveFavorite(newProducts, updatedProduct.toUiModel(), existingIndex);
    }

    return newProducts;
  }

  void _handleAddOrUpdateFavorite(
    List<ProductUiModel> products,
    ProductUiModel updatedProduct,
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
    List<ProductUiModel> products,
    ProductUiModel updatedProduct,
    int existingIndex,
  ) {
    if (existingIndex != -1) {
      products.removeAt(existingIndex);
      LogManager.debug("removed unfavorited product ${updatedProduct.id}");
    }
    // If product is not in list and not favorite, do nothing
  }

  void _emitUpdatedFavoritesState(
    Emitter<ProductState> emit,
    ProductStateWithData currentState,
    List<ProductUiModel> products,
  ) {
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
