part of 'product_bloc.dart';

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
  final List<Product> products;
  final bool hasMore;
  final String? nextCursor;

  const ProductStateWithData({
    required this.products,
    required this.hasMore,
    this.nextCursor,
  });
}

class ProductLoaded extends ProductStateWithData {
  final bool isLoadingMore;

  const ProductLoaded({
    required super.products,
    required super.hasMore,
    super.nextCursor,
    this.isLoadingMore = false,
  });

  /// Creates a copy of this [ProductLoaded] with the given fields replaced
  ProductLoaded copyWith({
    List<Product>? products,
    bool? hasMore,
    String? nextCursor,
    bool? isLoadingMore,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: nextCursor ?? this.nextCursor,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [products, hasMore, nextCursor, isLoadingMore];

  @override
  String toString() {
    return 'ProductLoaded('
        'products: ${products.length} items, '
        'hasMore: $hasMore, '
        'nextCursor: $nextCursor, '
        'isLoadingMore: $isLoadingMore'
        ')';
  }
}

class ProductError extends ProductStateWithData {
  final String errorMessage;

  const ProductError({
    required this.errorMessage,
    super.products = const <Product>[],
    super.hasMore = false,
    super.nextCursor,
  });

  /// Creates a copy of this [ProductError] with the given fields replaced
  ProductError copyWith({
    String? errorMessage,
    List<Product>? products,
    bool? hasMore,
    String? nextCursor,
  }) {
    return ProductError(
      errorMessage: errorMessage ?? this.errorMessage,
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: nextCursor ?? this.nextCursor,
    );
  }

  @override
  List<Object?> get props => [errorMessage, products, hasMore, nextCursor];

  @override
  String toString() {
    return 'ProductError('
        'errorMessage: $errorMessage, '
        'products: ${products.length} items, '
        'hasMore: $hasMore, '
        'nextCursor: $nextCursor'
        ')';
  }
}
