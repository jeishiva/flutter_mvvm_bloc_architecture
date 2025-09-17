
import 'package:flutter_mvvm_bloc_architecture/data/models/product_model.dart';

abstract class ProductLocalDataSource {
   Future<List<ProductModel>> getAllProducts();
   Future<void> addProduct(ProductModel product);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {

  final List<ProductModel> productList = [
    ProductModel(
      id: "product_1",
      name: 'Apple',
      createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      price: 300
    ),
    ProductModel(
        id: "product_2",
        name: 'Samsung',
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        price: 200
    ),
    ProductModel(
        id: "product_3",
        name: 'One Plus',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        price: 175
    ),
  ];

  @override
  Future<void> addProduct(ProductModel product) async {
     productList.insert(0, product);
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
     // simulating network delay
     await Future.delayed(const Duration(seconds: 3));
     return List.unmodifiable(productList);
  }

}