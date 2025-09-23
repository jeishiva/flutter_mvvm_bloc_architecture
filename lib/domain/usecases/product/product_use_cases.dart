import 'package:flutter_mvvm_bloc_architecture/domain/repositories/product_repo.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/usecases/product/product_get_use_case.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/usecases/product/product_observe_changes_use_case.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/usecases/product/product_toggle_fav_use_case.dart';

class ProductUseCases {
  final GetProductsUseCase getProducts;
  final ToggleFavouriteUseCase toggleFavourite;
  final ObserveProductChangesUseCase observeChanges;

  ProductUseCases({
    required this.getProducts,
    required this.toggleFavourite,
    required this.observeChanges,
  });

  // Factory constructor for easier setup
  factory ProductUseCases.create(ProductRepository repository) {
    return ProductUseCases(
      getProducts: GetProductsUseCase(repository),
      toggleFavourite: ToggleFavouriteUseCase(repository),
      observeChanges: ObserveProductChangesUseCase(repository),
    );
  }
}
