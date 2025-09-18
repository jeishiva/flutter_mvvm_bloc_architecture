import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_mvvm_bloc_architecture/data/models/product_model.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/common/pagination/page_result.dart';

abstract class ProductLocalDataSource {
  Future<PageResult<ProductModel>> getAllProducts({
    required int pageNumber,
    required int limit,
    required int offset,
  });

  Future<void> addProduct(ProductModel product);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final List<ProductModel> _productList = [];

  Future<void> _loadProductsIfNeeded() async {
    if (_productList.isNotEmpty) {
      return;
    }
    final jsonString = await rootBundle.loadString('assets/data/products.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    _productList.addAll(jsonList.map((e) => ProductModel.fromJson(e)).toList());
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    _productList.insert(0, product);
  }

  @override
  Future<PageResult<ProductModel>> getAllProducts({
    required int pageNumber,
    required int limit,
    required int offset,
  }) async {
    await _loadProductsIfNeeded();

    final start = offset;
    final end = (start + limit).clamp(0, _productList.length);

    if (start >= _productList.length) {
      return PageResult(data: const [], hasMore: false, pageNumber: pageNumber);
    }

    final items = _productList.sublist(start, end);
    final hasMore = end < _productList.length;
    await Future.delayed(const Duration(seconds: 2));
    return PageResult(data: items, hasMore: hasMore, pageNumber: pageNumber);
  }
}
