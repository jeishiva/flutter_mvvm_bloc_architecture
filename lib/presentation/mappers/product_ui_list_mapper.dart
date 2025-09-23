import 'package:flutter_mvvm_bloc_architecture/presentation/ui_models/product_ui_model.dart';

import '../../domain/entities/product.dart';
import 'product_ui_mapper.dart';

extension ProductListUiMapper on List<Product> {
  List<ProductUiModel> toUiList() {
    return map((product) => product.toUiModel()).toList();
  }
}