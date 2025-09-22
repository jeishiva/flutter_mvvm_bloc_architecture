import 'package:flutter_mvvm_bloc_architecture/domain/common/pagination/page_result.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product_filter.dart';

abstract class ProductRepository {
  Future<PageResult<Product>> getAllProducts({
    required int limit,
    String? nextCursor,
    required ProductFilter productFilter,
  });

  Future<Product> toggleFavourite(String productId);
}
