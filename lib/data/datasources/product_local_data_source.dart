import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_mvvm_bloc_architecture/data/models/product_model.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/common/pagination/page_result.dart';
import 'package:flutter_mvvm_bloc_architecture/utils/log_manager.dart';

abstract class ProductLocalDataSource {
  Future<PageResult<ProductModel>> getAllProducts({
    required int pageNumber,
    required int limit,
    required int offset,
  });

  Future<ProductModel> toggleFavourite(String productId);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  List<ProductModel> _productList = [];

  Future<void> _loadProductsIfNeeded() async {
    if (_productList.isNotEmpty) {
      return;
    }
    final jsonString = await rootBundle.loadString('assets/data/products.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    _productList.addAll(jsonList.map((e) => ProductModel.fromJson(e)).toList());
  }

  @override
  Future<PageResult<ProductModel>> getAllProducts({
    required int pageNumber,
    required int limit,
    required int offset,
  }) async {
    await _loadProductsIfNeeded();
    LogManager.debug('product page $pageNumber limit $limit offset $offset');
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

  @override
  Future<ProductModel> toggleFavourite(String productId) async {
    final newList = _productList.map((p) {
      if (p.id == productId) {
        return p.copyWith(isFavourite: !p.isFavourite);
      }
      return p;
    }).toList();
    final updated = newList.firstWhere((p) => p.id == productId);
    _productList = newList;
    await Future.delayed(Duration(milliseconds: 200));
    return updated;
  }


}
