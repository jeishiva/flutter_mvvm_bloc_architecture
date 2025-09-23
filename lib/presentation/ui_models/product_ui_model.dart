class ProductUiModel {
  final String id;
  final String title;
  final String? subtitle;
  final bool isFavourite;

  const ProductUiModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.isFavourite,
  });

  ProductUiModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    bool? isFavourite,
  }) {
    return ProductUiModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }
}
