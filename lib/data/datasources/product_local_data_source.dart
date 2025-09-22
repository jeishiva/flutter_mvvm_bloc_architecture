import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mvvm_bloc_architecture/data/models/product_model.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/common/pagination/page_result.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product_filter.dart';
import 'package:flutter_mvvm_bloc_architecture/utils/cursor_helper.dart';
import 'package:flutter_mvvm_bloc_architecture/utils/log_manager.dart';

abstract class ProductLocalDataSource {
  Future<void> initialize();

  Future<PageResult<ProductModel>> getAllProducts({
    required int limit,
    required String? cursor,
    required ProductFilter productFilter,
  });

  Future<ProductModel> toggleFavourite(String productId);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  List<ProductModel> _productList = [];

  Future<void> _loadProductsIfNeeded() async {
    if (_productList.isNotEmpty) return;
    const assetPath = 'assets/data/products.json';
    final jsonString = await rootBundle.loadString(assetPath);
    final List<ProductModel> parsed = await compute(_parseProductsFromJson, jsonString);
    _productList = parsed;
    LogManager.debug('Loaded ${_productList.length} products');
  }
  static List<ProductModel> _parseProductsFromJson(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList.map((e) => ProductModel.fromJson(e)).toList();
  }

  @override
  Future<PageResult<ProductModel>> getAllProducts({
    required int limit,
    required String? cursor,
    required ProductFilter productFilter,
  }) async {
    // Compute filtered products (no caching)
    final filteredProducts = _getFilteredProducts(productFilter);

    // Handle empty results after filtering
    if (filteredProducts.isEmpty) {
      return PageResult(data: const [], hasMore: false, nextCursor: null);
    }

    // Decode cursor to extract lastId
    final decoded = CursorHelper.decode(cursor);
    final String? lastId = decoded?['lastId'] as String?;

    // Find start index in filtered list
    int start = 0;
    if (lastId != null) {
      final lastIndex = filteredProducts.indexWhere((p) => p.id == lastId);
      start = lastIndex != -1 ? lastIndex + 1 : 0;
    }

    // Handle out of bounds
    if (start >= filteredProducts.length) {
      return PageResult(data: const [], hasMore: false, nextCursor: null);
    }

    // Calculate end index
    final end = (start + limit).clamp(start, filteredProducts.length);

    // Get page slice
    final items = filteredProducts.sublist(start, end);

    // Determine if there are more items
    final hasMore = end < filteredProducts.length;

    // Generate next cursor
    final nextCursor = hasMore && items.isNotEmpty
        ? CursorHelper.encode({'lastId': items.last.id})
        : null;

    // Simulate network delay for demo
    await Future.delayed(const Duration(milliseconds: 200));

    return PageResult(data: items, hasMore: hasMore, nextCursor: nextCursor);
  }

  @override
  Future<ProductModel> toggleFavourite(String productId) async {
    ProductModel? updated;
    final newList = _productList.map((p) {
      if (p.id == productId) {
        updated = p.copyWith(isFavourite: !p.isFavourite);
        return updated!;
      }
      return p;
    }).toList();
    _productList = newList;
    await Future.delayed(const Duration(milliseconds: 200));
    if (updated == null) {
      throw Exception("Product with id $productId not found");
    }
    return updated!;
  }

  // Helper method with all filter conditions
  List<ProductModel> _getFilteredProducts(ProductFilter filter) {
    LogManager.debug("filtering products ${filter.toString()}");
    if (!filter.hasFilters) {
      return List.from(_productList);
    }
    LogManager.debug(" products ${_productList.length}");
    return _productList.where((product) {
      // Favourite filter
      if (filter.isFavourite == true && product.isFavourite) {
        return true;
      }
      // Search query filter
      if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
        final query = filter.searchQuery!.toLowerCase();
        final matchesName = product.name.toLowerCase().contains(query);
        final matchesDescription =
            product.description?.toLowerCase().contains(query) ?? false;
        if (matchesName && matchesDescription) {
          return true;
        }
      }
      return false;
    }).toList();
  }

  @override
  Future<void> initialize() async {
    _loadProductsIfNeeded();
  }
}
