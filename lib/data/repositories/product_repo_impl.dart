import 'dart:async';

import 'package:flutter_mvvm_bloc_architecture/data/datasources/product_local_data_source.dart';
import 'package:flutter_mvvm_bloc_architecture/data/models/product_model.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/common/pagination/page_result.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product_filter.dart';

import '../../domain/repositories/product_repo.dart';

class ProductRepositoryImpl implements ProductRepository {
  @override
  Stream<Product> get changes => _changes.stream;

  final ProductLocalDataSource localDataSource;
  final StreamController<Product> _changes;

  ProductRepositoryImpl({
    required this.localDataSource,
    required StreamController<Product> changesController,
  }) : _changes = changesController;

  @override
  Future<PageResult<Product>> getAllProducts({
    required int limit,
    String? nextCursor,
    required ProductFilter productFilter,
  }) async {
    final PageResult<ProductModel> pageResult = await localDataSource
        .getAllProducts(
          cursor: nextCursor,
          limit: limit,
          productFilter: productFilter,
        );
    final PageResult<Product> result = PageResult(
      data: pageResult.data.map((model) => model.toEntity()).toList(),
      hasMore: pageResult.hasMore,
      nextCursor: pageResult.nextCursor,
    );
    return result;
  }

  @override
  Future<void> toggleFavourite(String productId) async {
    return localDataSource.toggleFavourite(productId);
  }

  @override
  Future<void> initialize() {
    return localDataSource.initialize();
  }

  @override
  void dispose() {
    _changes.close();
  }
}
