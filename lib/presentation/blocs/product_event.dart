part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {
  final int pageNumber;
  final int offset;
  final int limit;
  const LoadProducts({required this.pageNumber, required this.offset, required this.limit});
}
