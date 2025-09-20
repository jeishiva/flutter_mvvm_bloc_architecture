import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final int price;
  final DateTime createdAt;
  final String? description;
  final bool isFavourite;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.createdAt,
    required this.isFavourite,
    this.description,
  });

  Product copyWith({
    String? id,
    String? name,
    int? price,
    DateTime? createdAt,
    String? description,
    bool? isFavourite,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      isFavourite: isFavourite ?? this.isFavourite,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [id, name, price, isFavourite, createdAt, description];
}
