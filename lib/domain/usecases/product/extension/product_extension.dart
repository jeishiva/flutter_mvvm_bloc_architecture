import 'package:flutter_mvvm_bloc_architecture/domain/common/pagination/page_result.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product_filter.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/usecases/base/params/no_param.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/usecases/product/params/product_param.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/usecases/product/product_use_cases.dart';

extension ProductUseCasesExtensions on ProductUseCases {
  Future<PageResult<Product>> loadProducts({
    required int limit,
    String? nextCursor,
    required ProductFilter productFilter,
  }) {
    return getProducts(
      GetProductsParams(
        limit: limit,
        nextCursor: nextCursor,
        productFilter: productFilter,
      ),
    );
  }

  Future<void> toggleProductFavourite(String productId) {
    return toggleFavourite(ToggleFavouriteParams(productId: productId));
  }

  Stream<Product> watchProductChanges() {
    return observeChanges(const NoParams());
  }
}
