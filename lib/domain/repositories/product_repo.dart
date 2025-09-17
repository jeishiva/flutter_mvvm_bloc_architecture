import 'package:flutter_mvvm_bloc_architecture/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getAllProducts();

  Future<void> addProduct(Product product);
}
