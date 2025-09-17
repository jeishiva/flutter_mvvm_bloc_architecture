import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

class ProductModel extends Equatable {
  final String id;
  final String name;
  final DateTime createdAt;
  final double price;
  final String? description;

  const ProductModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.price,
    this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      price: json['price'] as double,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'price': price,
      'description': description,
    };
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      createdAt: product.createdAt,
      price: product.price,
      description: product.description,
    );
  }

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      createdAt: createdAt,
      price: price,
      description: description,
    );
  }

  ProductModel copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    double? price,
    String? description,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      price: price ?? this.price,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [id, name, price];
}
