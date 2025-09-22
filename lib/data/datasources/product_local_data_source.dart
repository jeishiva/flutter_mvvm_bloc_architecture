import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_mvvm_bloc_architecture/data/models/product_model.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/common/pagination/page_result.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product_filter.dart';
import 'package:flutter_mvvm_bloc_architecture/utils/cursor_helper.dart';

abstract class ProductLocalDataSource {
  Future<PageResult<ProductModel>> getAllProducts({
    required int limit,
    required String? cursor,
    required ProductFilter productFilter,
  });

  Future<ProductModel> toggleFavourite(String productId);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  List<ProductModel> _productList = [];
  Map<ProductFilter, List<ProductModel>> _filteredCache = {};
  Map<ProductFilter, Map<String, int>> _filteredIndexCache = {};

  Future<void> _loadProductsIfNeeded() async {
    if (_productList.isNotEmpty) {
      return;
    }
    final jsonString = await rootBundle.loadString('assets/data/products.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    final productList = jsonList.map((e) => ProductModel.fromJson(e)).toList();
    for (final entry in productList.asMap().entries) {
      _productList.add(entry.value);
    }
    _clearFilterCaches();
  }

  @override
  Future<PageResult<ProductModel>> getAllProducts({
    required int limit,
    required String? cursor,
    required ProductFilter productFilter,
  }) async {
    // Ensure source is ready
    await _loadProductsIfNeeded();


    // Get or compute filtered products with caching
    final filteredProducts = _getCachedFilteredProducts(productFilter);

    // Handle empty results after filtering
    if (filteredProducts.isEmpty) {
      return PageResult(data: const [], hasMore: false, nextCursor: null);
    }

    // Get or build index map for filtered products
    final filteredIndexMap = _getOrBuildFilteredIndexMap(productFilter, filteredProducts);

    // Decode cursor to extract lastId
    final decoded = CursorHelper.decode(cursor);
    final String? lastId = decoded?['lastId'] as String?;

    // Find start index in filtered list using O(1) map lookup
    int start = 0;
    if (lastId != null) {
      final lastIndex = filteredIndexMap[lastId];
      start = lastIndex != null ? lastIndex + 1 : 0;
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

    return PageResult(
      data: items,
      hasMore: hasMore,
      nextCursor: nextCursor,
    );
  }

  List<ProductModel> _getCachedFilteredProducts(ProductFilter filter) {
    if (_filteredCache.containsKey(filter)) {
      return _filteredCache[filter]!;
    }

    final filtered = _getFilteredProducts(filter);
    _filteredCache[filter] = filtered;
    return filtered;
  }

  /// Get or build index map for filtered products
  Map<String, int> _getOrBuildFilteredIndexMap(ProductFilter filter, List<ProductModel> filteredProducts) {
    if (_filteredIndexCache.containsKey(filter)) {
      return _filteredIndexCache[filter]!;
    }

    final indexMap = <String, int>{};
    for (int i = 0; i < filteredProducts.length; i++) {
      indexMap[filteredProducts[i].id] = i;
    }

    _filteredIndexCache[filter] = indexMap;
    return indexMap;
  }

  /// Clear caches when underlying data changes
  void _clearFilterCaches() {
    _filteredCache.clear();
    _filteredIndexCache.clear();
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

  // Updated helper method with all filter conditions
  List<ProductModel> _getFilteredProducts(ProductFilter? filter) {
    if (filter == null || !filter.hasFilters) {
      return List.from(_productList);
    }

    return _productList.where((product) {
      // Favourite filter
      if (filter.isFavourite == true && !product.isFavourite) {
        return false;
      }

      // Search query filter
      if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
        final query = filter.searchQuery!.toLowerCase();
        final matchesName = product.name.toLowerCase().contains(query);
        final matchesDescription = product.description?.toLowerCase().contains(
            query) ?? false;

        if (!matchesName && !matchesDescription) {
          return false;
        }
      }

      return true;
    }).toList();
  }
}
