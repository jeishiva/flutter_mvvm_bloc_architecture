import 'dart:async';

import 'package:flutter_mvvm_bloc_architecture/data/datasources/product_local_data_source.dart';
import 'package:flutter_mvvm_bloc_architecture/data/repositories/product_repo_impl.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/repositories/product_repo.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_bloc_base.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_all_bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_fav_bloc.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> initInjector() async {

  getIt.registerSingletonAsync<ProductLocalDataSource>(() async {
    final ds = ProductLocalDataSourceImpl();
    await ds.initialize();
    return ds;
  });

  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      localDataSource: getIt<ProductLocalDataSource>(),
      changesController: StreamController<Product>.broadcast(),
    ),
    dispose: (repo) => repo.dispose(),
  );

  getIt.registerFactoryParam<BaseProductBloc, String, void>(
        (param1, param2) {
      switch (param1) {
        case 'all':
          return ProductAllBloc(getIt<ProductRepository>());
        case 'fav':
          return ProductFavBloc(getIt<ProductRepository>());
        default:
          throw ArgumentError('Unknown bloc type: $param1');
      }
    },
  );

  await getIt.allReady();
}
