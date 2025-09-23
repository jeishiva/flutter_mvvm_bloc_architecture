
import 'package:flutter_mvvm_bloc_architecture/common/logging/log_manager.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/repositories/product_repo.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/usecases/base/base_use_case.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/usecases/product/params/product_param.dart';

class ToggleFavouriteUseCase extends UseCase<void, ToggleFavouriteParams> {
  final ProductRepository _repository;

  ToggleFavouriteUseCase(this._repository);

  @override
  Future<void> call(ToggleFavouriteParams params) async {
    LogManager.debug('ToggleFavouriteUseCase: Toggling favourite for product ${params.productId}');

    try {
      await _repository.toggleFavourite(params.productId);
      LogManager.debug('ToggleFavouriteUseCase: Successfully toggled favourite for ${params.productId}');
    } catch (e, st) {
      LogManager.error('ToggleFavouriteUseCase: Failed to toggle favourite for ${params.productId}', e, st);
      rethrow;
    }
  }
}