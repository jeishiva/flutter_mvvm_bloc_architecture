import 'package:equatable/equatable.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/repositories/product_repo.dart';

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
    final page = event.pageNumber;

    if (_isLoadingPage) return;
    _isLoadingPage = true;

    // preserve items whether we're in Loaded or Error state
    final previous = state is ProductLoaded
        ? List<Product>.from((state as ProductLoaded).products)
        : state is ProductError
        ? List<Product>.from((state as ProductError).products)
        : <Product>[];

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
        limit: event.limit,
        offset: event.offset,
      );
      final incoming = pageResult.data;
      final combined = [...previous, ...incoming];
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
      emit(ProductError(message: msg, products: previous));
    } finally {
      _isLoadingPage = false;
    }
  }
}
