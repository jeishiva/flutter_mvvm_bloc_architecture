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

class ProductLoaded extends ProductState {
  final List<Product> products;
  final bool hasMore;
  final int pageNumber;
  final bool isLoadingMore;

  const ProductLoaded({
    required this.products,
    required this.hasMore,
    required this.pageNumber,
    this.isLoadingMore = false,
  });

  copyWith({
    List<Product>? products,
    bool? hasMore,
    int? pageNumber,
    bool? isLoadingMore,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      pageNumber: pageNumber ?? this.pageNumber,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [products, hasMore, pageNumber, isLoadingMore];
}

class ProductError extends ProductState {
  final String message;
  final List<Product> products;
  final int pageNumber;

  const ProductError({
    required this.message,
    this.products = const [],
    this.pageNumber = 1,
  });

  @override
  List<Object?> get props => [message, products];
}
