import 'package:equatable/equatable.dart';

class PageResult<T> extends Equatable {
  final List<T> data;
  final bool hasMore;
  final String? nextCursor;

  const PageResult({
    required this.data,
    required this.hasMore,
    required this.nextCursor,
  });

  @override
  List<Object?> get props => [data, hasMore, nextCursor];

}