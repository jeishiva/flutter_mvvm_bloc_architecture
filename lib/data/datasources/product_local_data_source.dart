import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_mvvm_bloc_architecture/data/models/product_model.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/common/pagination/page_result.dart';
import 'package:flutter_mvvm_bloc_architecture/utils/cursor_helper.dart';
import 'package:flutter_mvvm_bloc_architecture/utils/log_manager.dart';

abstract class ProductLocalDataSource {
  Future<PageResult<ProductModel>> getAllProducts({
    required int limit,
    required String? cursor,
  });

  Future<ProductModel> toggleFavourite(String productId);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  List<ProductModel> _productList = [];
  Map<String, int> _cursorMapToIndex = {};

  Future<void> _loadProductsIfNeeded() async {
    if (_productList.isNotEmpty) {
      return;
    }
    final jsonString = await rootBundle.loadString('assets/data/products.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    final productList = jsonList.map((e) => ProductModel.fromJson(e)).toList();
    for (final entry in productList.asMap().entries) {
      _productList.add(entry.value);
      _cursorMapToIndex[entry.value.id] = entry.key;
    }
  }

  @override
  Future<PageResult<ProductModel>> getAllProducts({
    required int limit,
    required String? cursor,
  }) async {
    // ensure source is ready
    await _loadProductsIfNeeded();

    // keep id->index map up-to-date
    _ensureCursorMap();

    // decode cursor to extract lastId (string)
    final decoded = CursorHelper.decode(cursor);
    final String? lastId = decoded == null
        ? null
        : (decoded['lastId'] as String?);

    // compute start index
    int start;
    if (lastId == null) {
      start = 0;
    } else {
      final idx = _cursorMapToIndex[lastId];
      // if cursor id not found (e.g., item removed), fallback to 0 or choose policy
      start = (idx == null) ? 0 : idx + 1;
    }

    // clamp bounds
    final end = (start + limit).clamp(0, _productList.length);

    // nothing to return
    if (start >= _productList.length) {
      return PageResult(data: const [], hasMore: false, nextCursor: null);
    }

    // slice page
    final items = _productList.sublist(start, end);

    // compute hasMore and nextCursor
    final hasMore = end < _productList.length;
    final nextCursor = hasMore
        ? CursorHelper.encode({'lastId': items.last.id})
        : null;
    await Future.delayed(const Duration(milliseconds: 200));
    return PageResult(data: items, hasMore: hasMore, nextCursor: nextCursor);
  }

  void _ensureCursorMap() {
    if (_cursorMapToIndex.length != _productList.length) {
      _cursorMapToIndex = {
        for (final entry in _productList.asMap().entries)
          entry.value.id: entry.key,
      };
    }
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
