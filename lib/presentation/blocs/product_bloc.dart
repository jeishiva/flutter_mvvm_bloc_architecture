import 'package:equatable/equatable.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/repositories/product_repo.dart';
import 'package:flutter_mvvm_bloc_architecture/utils/log_manager.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepo;

  bool _isLoadingPage = false;

  ProductBloc(this.productRepo) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (_isLoadingPage) {
      LogManager.debug('already loading previous page');
      return;
    }
    _isLoadingPage = true;
    final previous = state is ProductLoaded
        ? List<Product>.from((state as ProductLoaded).products)
        : state is ProductError
        ? List<Product>.from((state as ProductError).products)
        : <Product>[];
    final page = state is ProductLoaded
        ? (state as ProductLoaded).pageNumber + 1
        : state is ProductError
        ? (state as ProductError).pageNumber + 1
        : 1;

    // emit appropriate loading indicator
    if (page == 1) {
      emit(const ProductLoading());
    } else {
      final prevHasMore = state is ProductLoaded
          ? (state as ProductLoaded).hasMore
          : true;
      emit(
        ProductLoaded(
          products: previous,
          hasMore: prevHasMore,
          pageNumber: page - 1,
          isLoadingMore: true,
        ),
      );
    }
    try {
      final pageResult = await productRepo.getAllProducts(
        pageNumber: page,
        limit: 20,
        offset: (page - 1) * 20,
      );
      final incoming = pageResult.data;
      final existingIds = previous.map((item) => item.id).toSet();
      final newItems = incoming
          .where((item) => !existingIds.contains(item.id))
          .toList();
      final combined = [...previous, ...newItems];
      emit(
        ProductLoaded(
          products: combined,
          hasMore: pageResult.hasMore,
          pageNumber: pageResult.pageNumber,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      final msg = e.toString();
      emit(ProductError(message: msg, products: previous, pageNumber: page));
    } finally {
      _isLoadingPage = false;
    }
  }
}
