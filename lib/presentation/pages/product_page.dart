import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/di/injector.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_bloc.dart';
import 'package:rxdart/rxdart.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<StatefulWidget> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductPage> {
  late final ProductBloc _bloc;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _hasMore = true;
  final _scrollSubject = PublishSubject<void>();

  @override
  void initState() {
    super.initState();
    _bloc = getIt<ProductBloc>();
    _bloc.add(LoadProducts());
    _scrollController.addListener(_onScroll);
    _scrollSubject
        .throttleTime(const Duration(milliseconds: 100)) // or debounceTime
        .listen((_) {
          const double threshold = 400.0;
          final remaining = _scrollController.position.extentAfter;
          if (remaining <= threshold) {
            _loadNextPage();
          }
        });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    _scrollSubject.add(null);
  }

  void _loadNextPage() {
    if (_isLoadingMore || !_hasMore) {
      return;
    }
    _isLoadingMore = true;
    _bloc.add(LoadProducts());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Products')),
        body: SafeArea(
          child: BlocListener<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is ProductLoaded) {
                _hasMore = state.hasMore;
                _isLoadingMore = false;
              } else if (state is ProductError) {
                _isLoadingMore = false;
              }
            },
            child: ProductBody(controller: _scrollController),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollSubject.close();
    _bloc.close();
    super.dispose();
  }
}

class ProductBody extends StatelessWidget {
  final ScrollController? controller;

  const ProductBody({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return switch (state) {
          ProductLoading() => const ProductLoadingWidget(),

          ProductLoaded(
            :final products,
            :final hasMore,
            :final isLoadingMore,
          ) =>
            ProductListWidget(
              products: products,
              hasMore: hasMore,
              isLoadingMore: isLoadingMore,
              controller: controller,
            ),

          ProductError(errorMessage:final message) => ProductErrorWidget(message: message),

          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

class ProductLoadingWidget extends StatelessWidget {
  const ProductLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class ProductListWidget extends StatelessWidget {
  final List<Product> products;
  final bool hasMore;
  final ScrollController? controller;
  final bool isLoadingMore;

  const ProductListWidget({
    super.key,
    required this.products,
    required this.hasMore,
    required this.isLoadingMore,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final itemCount = products.length + (isLoadingMore ? 1 : 0);
    return ListView.builder(
      controller: controller,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index < products.length) {
          final product = products[index];
          return ProductListItem(
            product: product,
            onFavoriteToggle: (product) {
              context.read<ProductBloc>().add(ToggleFavourite(product.id));
            },
          );
        } else {
          // loading indicator at list bottom
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
      },
    );
  }
}

class ProductListItem extends StatelessWidget {
  final Product product;
  final ValueChanged<Product> onFavoriteToggle;

  const ProductListItem({
    super.key,
    required this.product,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      key: ValueKey(product.id),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 36,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            product.name.isNotEmpty ? product.name[0].toUpperCase() : '?',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        title: Text(
          "${product.name[0].toUpperCase()}:${product.id}",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Price: ${product.price.toString()}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: IconButton(
          onPressed: () => onFavoriteToggle(product),
          icon: Icon(
            product.isFavourite ? Icons.favorite : Icons.favorite_border,
            color: product.isFavourite
                ? Colors.red
                : theme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          tooltip: product.isFavourite
              ? 'Remove from favorites'
              : 'Add to favorites',
        ),
      ),
    );
  }
}

class ProductErrorWidget extends StatelessWidget {
  final String message;

  const ProductErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
