import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product_filter.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/usecases/product/extension/product_extension.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/usecases/product/params/product_param.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/usecases/product/product_use_cases.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_all_bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/common/logging/log_manager.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/mappers/product_ui_list_mapper.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/ui_models/product_ui_model.dart';

abstract class BaseProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductUseCases productUseCases;
  StreamSubscription<Product>? _repoSub;
  bool _isLoadingPage = false;

  BaseProductBloc(this.productUseCases) : super(const ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadMore>(_onLoadMore);
    on<ToggleFavourite>(_onToggleFavourite);
    on<ExternalProductChanged>(onExternalProductChanged);

    _repoSub = productUseCases.watchProductChanges().listen((updatedProduct) {
      LogManager.debug("external product changed ${updatedProduct.id}");
      add(ExternalProductChanged(updatedProduct));
    });
  }

  // Abstract method - must be implemented by subclasses
  FutureOr<void> onExternalProductChanged(
    ExternalProductChanged event,
    Emitter<ProductState> emit,
  );

  Future<void> _onLoadMore(LoadMore event, Emitter<ProductState> emit) async {
    LogManager.debug("load more called");

    final current = state is ProductStateWithData
        ? state as ProductStateWithData
        : null;

    if (current == null || !current.hasMore) {
      return;
    }

    add(LoadProducts(current.productFilter));
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    LogManager.debug('product filter ${event.productFilter}');

    if (_isLoadingPage) {
      LogManager.debug('already loading previous page');
      return;
    }

    _isLoadingPage = true;

    try {
      final loadContext = _prepareLoadContext(event);
      _emitPreLoadState(emit, loadContext, event.productFilter);

      final pageResult = await productUseCases.getProducts(GetProductsParams(
        nextCursor: loadContext.nextCursor,
        limit: 20,
        productFilter: event.productFilter,
      ));

      final combinedProducts = _combineProducts(
        loadContext.prevProducts,
        pageResult.data.toUiList(),
      );

      emit(
        ProductLoaded(
          products: combinedProducts,
          hasMore: pageResult.hasMore,
          nextCursor: pageResult.nextCursor,
          isLoadingMore: false,
          productFilter: event.productFilter,
        ),
      );
    } catch (e, st) {
      _handleLoadError(e, st, emit, event);
    } finally {
      _isLoadingPage = false;
    }
  }

  _LoadContext _prepareLoadContext(LoadProducts event) {
    final currentState = state is ProductStateWithData
        ? state as ProductStateWithData
        : null;
    final filterChanged = currentState?.productFilter != event.productFilter;

    return _LoadContext(
      prevProducts: filterChanged ? <ProductUiModel>[] : currentState?.products ?? [],
      nextCursor: filterChanged ? null : currentState?.nextCursor,
      prevHasMore: filterChanged ? true : (currentState?.hasMore ?? true),
      isFilterChanged: filterChanged,
      currentState: currentState,
    );
  }

  void _emitPreLoadState(
    Emitter<ProductState> emit,
    _LoadContext context,
    ProductFilter productFilter,
  ) {
    if (context.currentState == null || context.isFilterChanged) {
      emit(const ProductLoading());
    } else {
      emit(
        ProductLoaded(
          products: context.prevProducts,
          hasMore: context.prevHasMore,
          isLoadingMore: true,
          nextCursor: context.nextCursor,
          productFilter: productFilter,
        ),
      );
    }
  }

  List<ProductUiModel> _combineProducts(
    List<ProductUiModel> existingProducts,
    List<ProductUiModel> newProducts,
  ) {
    final existingIds = existingProducts.map((e) => e.id).toSet();
    final newItems = newProducts
        .where((item) => !existingIds.contains(item.id))
        .toList();
    return [...existingProducts, ...newItems];
  }

  void _handleLoadError(
    dynamic error,
    StackTrace stackTrace,
    Emitter<ProductState> emit,
    LoadProducts event,
  ) {
    LogManager.error('failed to load products', error, stackTrace);

    final context = _prepareLoadContext(event);

    emit(
      ProductError(
        errorMessage: error.toString(),
        products: context.prevProducts,
        nextCursor: context.nextCursor,
        hasMore: context.prevHasMore,
        productFilter: event.productFilter,
      ),
    );
  }

  Future<void> _onToggleFavourite(
    ToggleFavourite event,
    Emitter<ProductState> emit,
  ) async {
    LogManager.debug("favourite clicked for event ${event.productId}");

    if (state is! ProductStateWithData) return;

    final currentState = state as ProductStateWithData;
    final previousProducts = List<ProductUiModel>.from(currentState.products);
    final updatedProducts = _toggleProductFavourite(
      currentState.products,
      event.productId,
    );

    // Optimistic update
    _emitUpdatedState(emit, currentState, updatedProducts);

    // Attempt remote update with rollback on failure
    try {
      await productUseCases.toggleFavourite(ToggleFavouriteParams(productId: event.productId));
    } catch (e, st) {
      LogManager.error('toggleFavourite failed', e, st);
      _emitUpdatedState(emit, currentState, previousProducts);
    }
  }

  List<ProductUiModel> _toggleProductFavourite(
    List<ProductUiModel> products,
    String productId,
  ) {
    return products.map((product) {
      if (product.id == productId) {
        return product.copyWith(isFavourite: !product.isFavourite);
      }
      return product;
    }).toList();
  }

  void _emitUpdatedState(
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

  @override
  Future<void> close() {
    _repoSub?.cancel();
    return super.close();
  }
}

class _LoadContext {
  final List<ProductUiModel> prevProducts;
  final String? nextCursor;
  final bool prevHasMore;
  final bool isFilterChanged;
  final ProductStateWithData? currentState;

  const _LoadContext({
    required this.prevProducts,
    required this.nextCursor,
    required this.prevHasMore,
    required this.isFilterChanged,
    required this.currentState,
  });
}
