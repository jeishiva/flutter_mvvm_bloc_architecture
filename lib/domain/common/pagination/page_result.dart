import 'package:equatable/equatable.dart';

class PageResult<T> extends Equatable {
  final List<T> data;
  final bool hasMore;
  final int pageNumber;

  const PageResult({
    required this.data,
    required this.hasMore,
    required this.pageNumber,
  });

  @override
  List<Object?> get props => [data, hasMore, pageNumber];

}