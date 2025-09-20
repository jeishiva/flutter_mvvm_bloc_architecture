import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final int price;
  final DateTime createdAt;
  final String? description;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.createdAt,
    this.description,
  });

  Product copyWith({
    String? id,
    String? name,
    int? price,
    DateTime? createdAt,
    String? description,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [id, name, price];
}
