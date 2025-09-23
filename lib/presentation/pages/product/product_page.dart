import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/common/logging/log_manager.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_bloc_base.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_all_bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/pages/product/product_body.dart';
import 'package:rxdart/rxdart.dart';

class ProductPage extends StatefulWidget {
  final String pageTitle;
  final bool canToggleFavourite;

  const ProductPage({
    super.key,
    required this.pageTitle,
    required this.canToggleFavourite,
  });

  const ProductPage.forHome({Key? key})
    : this(key: key, pageTitle: "Products", canToggleFavourite: true);

  const ProductPage.forFavourites({Key? key})
    : this(key: key, pageTitle: "Favourites", canToggleFavourite: false);

  @override
  State<StatefulWidget> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductPage> {
  final ScrollController _scrollController = ScrollController();
  final _scrollSubject = PublishSubject<void>();

  bool _isLoadingMore = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    _scrollSubject
        .throttleTime(const Duration(milliseconds: 100)) // or debounceTime
        .listen((_) {
          const double threshold = 400.0;
          final remaining = _scrollController.position.extentAfter;

          if (remaining <= threshold) {
            LogManager.debug("threshold reached");
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
    final bloc = context.read<BaseProductBloc>();
    bloc.add(const LoadMore());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.pageTitle)),
      body: SafeArea(
        child: BlocListener<BaseProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductLoading) {
              Center(child: const CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              _hasMore = state.hasMore;
              _isLoadingMore = false;
            } else if (state is ProductError) {
              _isLoadingMore = false;
            }
          },
          child: ProductBody(
            controller: _scrollController,
            canToggleFavourite: widget.canToggleFavourite,
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
    super.dispose();
  }
}
