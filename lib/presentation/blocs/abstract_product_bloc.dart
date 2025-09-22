import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/repositories/product_repo.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_all_bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/utils/log_manager.dart';

abstract class BaseProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepo;
  StreamSubscription<Product>? _repoSub;
  bool _isLoadingPage = false;

  BaseProductBloc(this.productRepo) : super(const ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadMore>(_onLoadMore);
    on<ToggleFavourite>(_onToggleFavourite);
    on<ExternalProductChanged>(onExternalProductChanged);

    _repoSub = productRepo.changes.listen((updatedProduct) {
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
    if (current == null) {
      return;
    }
    if (!current.hasMore) {
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

    final currentState = state is ProductStateWithData
        ? state as ProductStateWithData
        : null;
    final filterChanged = currentState?.productFilter != event.productFilter;

    final prevProducts = filterChanged
        ? <Product>[]
        : currentState?.products ?? [];
    final nextCursor = filterChanged ? null : currentState?.nextCursor;
    final prevHasMore = filterChanged ? true : (currentState?.hasMore ?? true);

    // emit pre-load state
    if (currentState == null || filterChanged) {
      emit(const ProductLoading());
    } else {
      emit(
        ProductLoaded(
          products: prevProducts,
          hasMore: prevHasMore,
          isLoadingMore: true,
          nextCursor: nextCursor,
          productFilter: event.productFilter,
        ),
      );
    }

    try {
      final pageResult = await productRepo.getAllProducts(
        nextCursor: nextCursor,
        limit: 20,
        productFilter: event.productFilter,
      );

      final incoming = pageResult.data;
      final existingIds = prevProducts.map((e) => e.id).toSet();
      final newItems = incoming
          .where((item) => !existingIds.contains(item.id))
          .toList();
      final combined = [...prevProducts, ...newItems];

      emit(
        ProductLoaded(
          products: combined,
          hasMore: pageResult.hasMore,
          nextCursor: pageResult.nextCursor,
          isLoadingMore: false,
          productFilter: event.productFilter,
        ),
      );
    } catch (e, st) {
      LogManager.error('failed to load products', e, st);
      final msg = e.toString();
      emit(
        ProductError(
          errorMessage: msg,
          products: prevProducts,
          nextCursor: nextCursor,
          hasMore: prevHasMore,
          productFilter: event.productFilter,
        ),
      );
    } finally {
      _isLoadingPage = false;
    }
  }

  Future<void> _onToggleFavourite(
    ToggleFavourite event,
    Emitter<ProductState> emit,
  ) async {
    LogManager.debug("favourite clicked for event ${event.productId}");

    // work when we have any state that contains data
    if (state is ProductStateWithData) {
      final currentState = state as ProductStateWithData;

      // keep a snapshot to revert if needed
      final previousProducts = List<Product>.from(currentState.products);

      // optimistic update
      final updatedProducts = currentState.products.map((product) {
        if (product.id == event.productId) {
          return product.copyWith(isFavourite: !product.isFavourite);
        }
        return product;
      }).toList();

      // emit updated state depending on whether current is loaded or error
      if (currentState is ProductLoaded) {
        emit(currentState.copyWith(products: updatedProducts));
      } else if (currentState is ProductError) {
        emit(currentState.copyWith(products: updatedProducts));
      } else {
        emit(
          ProductLoaded(
            products: updatedProducts,
            hasMore: currentState.hasMore,
            nextCursor: currentState.nextCursor,
            isLoadingMore: false,
            productFilter: currentState.productFilter,
          ),
        );
      }

      // attempt remote update
      try {
        await productRepo.toggleFavourite(event.productId);
      } catch (e, st) {
        LogManager.error('toggleFavourite failed', e, st);
        if (currentState is ProductLoaded) {
          emit(currentState.copyWith(products: previousProducts));
        } else if (currentState is ProductError) {
          emit(currentState.copyWith(products: previousProducts));
        } else {
          emit(
            ProductLoaded(
              products: previousProducts,
              hasMore: currentState.hasMore,
              nextCursor: currentState.nextCursor,
              isLoadingMore: false,
              productFilter: currentState.productFilter,
            ),
          );
        }
      }
    }
  }

  @override
  Future<void> close() {
    _repoSub?.cancel();
    return super.close();
  }
}
