part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {}

class ToggleFavourite extends ProductEvent {
  final String productId;
  const ToggleFavourite(this.productId);
}

class LoadMore extends ProductEvent {}
