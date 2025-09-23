// Concrete use cases
import 'package:flutter_mvvm_bloc_architecture/common/logging/log_manager.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/common/pagination/page_result.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/repositories/product_repo.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/usecases/base/base_use_case.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/usecases/product/params/product_param.dart';

class GetProductsUseCase
    extends UseCase<PageResult<Product>, GetProductsParams> {
  final ProductRepository _repository;

  GetProductsUseCase(this._repository);

  @override
  Future<PageResult<Product>> call(GetProductsParams params) async {
    LogManager.debug(
      'GetProductsUseCase: Loading products with filter ${params.productFilter}',
    );

    try {
      final result = await _repository.getAllProducts(
        limit: params.limit,
        nextCursor: params.nextCursor,
        productFilter: params.productFilter,
      );

      LogManager.debug(
        'GetProductsUseCase: Loaded ${result.data.length} products',
      );
      return result;
    } catch (e, st) {
      LogManager.error('GetProductsUseCase: Failed to load products', e, st);
      rethrow;
    }
  }
}
