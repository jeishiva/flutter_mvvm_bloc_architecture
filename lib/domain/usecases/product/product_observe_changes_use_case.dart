import 'package:flutter_mvvm_bloc_architecture/common/logging/log_manager.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/repositories/product_repo.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/usecases/base/base_use_case.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/usecases/base/params/no_param.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/usecases/product/params/product_param.dart';

class ObserveProductChangesUseCase extends StreamUseCase<Product, NoParams> {
  final ProductRepository _repository;

  ObserveProductChangesUseCase(this._repository);

  @override
  Stream<Product> call(NoParams params) {
    LogManager.debug('ObserveProductChangesUseCase: Starting to observe product changes');

    return _repository.changes.map((product) {
      LogManager.debug('ObserveProductChangesUseCase: Product changed ${product.id}');
      return product;
    });
  }
}
