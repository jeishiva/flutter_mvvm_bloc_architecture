import 'package:flutter_mvvm_bloc_architecture/data/datasources/product_local_data_source.dart';
import 'package:flutter_mvvm_bloc_architecture/data/models/product_model.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/common/pagination/page_result.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product.dart';

import '../../domain/repositories/product_repo.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;

  const ProductRepositoryImpl({required this.localDataSource});

  @override
  Future<PageResult<Product>> getAllProducts({
    required int limit,
    String? nextCursor,
  }) async {
    final PageResult<ProductModel> pageResult = await localDataSource
        .getAllProducts(cursor: nextCursor, limit: limit);
    final PageResult<Product> result = PageResult(
      data: pageResult.data.map((model) => model.toEntity()).toList(),
      hasMore: pageResult.hasMore,
      nextCursor: pageResult.nextCursor,
    );
    return result;
  }

  @override
  Future<Product> toggleFavourite(String productId) async {
    return localDataSource
        .toggleFavourite(productId)
        .then((model) => model.toEntity());
  }
}
