import 'package:equatable/equatable.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/repositories/product_repo.dart';
import 'package:uuid/uuid.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepo;
  final Uuid _uuid = const Uuid();

  ProductBloc(this.productRepo) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<AddProduct>(_onAddProduct);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await productRepo.getAllProducts();
      emit(ProductLoaded(products));
    } catch (e, st) {
      emit(ProductError('Failed to load products: $e'));
    }
  }

  Future<void> _onAddProduct(
    AddProduct event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final newProduct = Product(
        id: _uuid.v4(),
        name: event.name,
        createdAt: DateTime.now(),
        price: 100,
      );
      await productRepo.addProduct(newProduct);
      final products = await productRepo.getAllProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError('Failed to add product: $e'));
    }
  }
}
