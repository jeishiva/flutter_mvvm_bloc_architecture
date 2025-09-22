import 'package:equatable/equatable.dart';

class ProductFilter extends Equatable {
  final bool? isFavourite;
  final String? searchQuery;

  const ProductFilter.noFilters() : this(isFavourite: null, searchQuery: null);

  const ProductFilter({this.isFavourite, this.searchQuery});

  // Factory constructor for favourite filter only
  const ProductFilter.favourites() : this(isFavourite: true);

  // Check if any filter is applied
  bool get hasFilters =>
      isFavourite != null || (searchQuery != null && searchQuery!.isNotEmpty);

  @override
  List<Object?> get props => [isFavourite, searchQuery];
}
