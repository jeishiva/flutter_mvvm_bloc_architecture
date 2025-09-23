import 'package:flutter_mvvm_bloc_architecture/presentation/ui_models/product_ui_model.dart';
import '../../domain/entities/product.dart';

extension ProductUiMapper on Product {
  ProductUiModel toUiModel() {
    return ProductUiModel(
      id: id,
      title: name,
      subtitle: label,
      isFavourite: isFavourite,
    );
  }
}
