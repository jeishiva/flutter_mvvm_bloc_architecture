import 'package:flutter_mvvm_bloc_architecture/domain/common/pagination/page_result.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product_filter.dart';

abstract class ProductRepository {

  Future<void> initialize();

  Future<PageResult<Product>> getAllProducts({
    required int limit,
    String? nextCursor,
    required ProductFilter productFilter,
  });

  Future<void> toggleFavourite(String productId);

  Stream<Product> get changes; // expose stream

  void dispose();

}
