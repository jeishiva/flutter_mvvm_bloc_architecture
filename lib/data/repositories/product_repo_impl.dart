import 'package:flutter_mvvm_bloc_architecture/data/datasources/product_local_data_source.dart';
import 'package:flutter_mvvm_bloc_architecture/data/models/product_model.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product.dart';

import '../../domain/repositories/product_repo.dart';

class ProductRepoImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;

  const ProductRepoImpl({required this.localDataSource});

  @override
  Future<void> addProduct(Product product) async {
    await localDataSource.addProduct(ProductModel.fromEntity(product));
  }

  @override
  Future<List<Product>> getAllProducts() async {
    final models = await localDataSource.getAllProducts();
    return models.map((model) => model.toEntity()).toList();
  }
}
