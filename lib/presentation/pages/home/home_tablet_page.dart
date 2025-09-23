import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/di/injector.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product_filter.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_all_bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_bloc_base.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/pages/product/product_page.dart';

class HomeTabletPage extends StatelessWidget {
  const HomeTabletPage({super.key});

  BaseProductBloc _createBloc(String param) {
    final bloc = getIt<BaseProductBloc>(param1: param);
    return bloc;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: BlocProvider(
              create: (_) {
                final bloc = _createBloc('all');
                bloc.add(const LoadProducts(ProductFilter.noFilters()));
                return bloc;
              },
              child: const ProductPage.forHome(),
            ),
          ),
          Expanded(
            flex: 1,
            child: BlocProvider(
              create: (_) {
                final bloc = _createBloc('fav');
                bloc.add(const LoadProducts(ProductFilter.favourites()));
                return bloc;
              },
              child: const ProductPage.forFavourites(),
            ),
          ),
        ],
      ),
    );
  }
}
