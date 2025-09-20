import 'package:flutter_mvvm_bloc_architecture/domain/common/pagination/page_result.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product.dart';

abstract class ProductRepository {
  Future<PageResult<Product>> getAllProducts({
    required int pageNumber,
    required int limit,
    required int offset,
  });

  Future<void> addProduct(Product product);
}
