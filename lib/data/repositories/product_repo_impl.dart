import 'package:flutter_mvvm_bloc_architecture/data/datasources/product_local_data_source.dart';
import 'package:flutter_mvvm_bloc_architecture/data/models/product_model.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/common/pagination/page_result.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product.dart';

import '../../domain/repositories/product_repo.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;

  const ProductRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addProduct(Product product) async {
    await localDataSource.addProduct(ProductModel.fromEntity(product));
  }

  @override
  Future<PageResult<Product>> getAllProducts({
    required int pageNumber,
    required int limit,
    required int offset,
  }) async {
    final PageResult<ProductModel> pageResult = await localDataSource
        .getAllProducts(pageNumber: pageNumber, limit: limit, offset: offset);
    final PageResult<Product> result = PageResult(
      data: pageResult.data.map((model) => model.toEntity()).toList(),
      hasMore: pageResult.hasMore,
      pageNumber: pageResult.pageNumber,
    );
    return result;
  }
}
