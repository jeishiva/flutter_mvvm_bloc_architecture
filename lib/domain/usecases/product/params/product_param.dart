// Use case parameters
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product_filter.dart';

class GetProductsParams {
  final int limit;
  final String? nextCursor;
  final ProductFilter productFilter;

  const GetProductsParams({
    required this.limit,
    this.nextCursor,
    required this.productFilter,
  });
}

class ToggleFavouriteParams {
  final String productId;

  const ToggleFavouriteParams({required this.productId});
}