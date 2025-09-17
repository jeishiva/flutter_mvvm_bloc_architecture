
import 'package:flutter_mvvm_bloc_architecture/data/models/product_model.dart';

abstract class ProductLocalDataSource {
   Future<List<ProductModel>> getAllProducts();
   Future<void> addProduct(ProductModel product);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {

  final List<ProductModel> productList = [];

  @override
  Future<void> addProduct(ProductModel product) async {
     productList.insert(0, product);
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
     return List.unmodifiable(productList);
  }
}