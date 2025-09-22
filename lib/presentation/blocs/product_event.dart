part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {
  const LoadProducts(this.productFilter);

  final ProductFilter productFilter;
}

class ToggleFavourite extends ProductEvent {
  final String productId;

  const ToggleFavourite(this.productId);
}

class LoadMore extends ProductEvent {
  const LoadMore();
}

class _ExternalProductChanged extends ProductEvent {
  const _ExternalProductChanged(this.product);
  final Product product;
}
