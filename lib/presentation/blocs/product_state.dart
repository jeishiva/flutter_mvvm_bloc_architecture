part of 'product_all_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

abstract class ProductStateWithData extends ProductState {
  final List<ProductUiModel> products;
  final bool hasMore;
  final String? nextCursor;
  final ProductFilter productFilter;

  const ProductStateWithData({
    required this.products,
    required this.hasMore,
    required this.productFilter,
    this.nextCursor,
  });
}

class ProductLoaded extends ProductStateWithData {
  final bool isLoadingMore;

  const ProductLoaded({
    required super.products,
    required super.hasMore,
    required super.productFilter,
    super.nextCursor,
    this.isLoadingMore = false,
  });

  ProductLoaded copyWith({
    List<ProductUiModel>? products,
    bool? hasMore,
    String? nextCursor,
    bool? isLoadingMore,
    ProductFilter? productFilter,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: nextCursor ?? this.nextCursor,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      productFilter: productFilter ?? this.productFilter,
    );
  }

  @override
  List<Object?> get props => [
    products,
    hasMore,
    nextCursor,
    isLoadingMore,
    productFilter,
  ];
}

class ProductError extends ProductStateWithData {
  final String errorMessage;

  const ProductError({
    required this.errorMessage,
    super.products = const <ProductUiModel>[],
    super.hasMore = false,
    required super.productFilter,
    super.nextCursor,
  });

  ProductError copyWith({
    String? errorMessage,
    List<ProductUiModel>? products,
    bool? hasMore,
    String? nextCursor,
    ProductFilter? productFilter,
  }) {
    return ProductError(
      errorMessage: errorMessage ?? this.errorMessage,
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: nextCursor ?? this.nextCursor,
      productFilter: productFilter ?? this.productFilter,
    );
  }

  @override
  List<Object?> get props => [
    errorMessage,
    products,
    hasMore,
    nextCursor,
    productFilter,
  ];
}
