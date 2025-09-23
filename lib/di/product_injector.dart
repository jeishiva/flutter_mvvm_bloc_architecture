import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:flutter_mvvm_bloc_architecture/data/datasources/product_local_data_source.dart';
import 'package:flutter_mvvm_bloc_architecture/data/repositories/product_repo_impl.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/repositories/product_repo.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/usecases/product/product_use_cases.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_bloc_base.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_all_bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_fav_bloc.dart';

Future<void> registerProductModule(GetIt getIt) async {
  // Register the local data source (async init)
  getIt.registerSingletonAsync<ProductLocalDataSource>(() async {
    final ds = ProductLocalDataSourceImpl();
    await ds.initialize();
    return ds;
  });

  // Register the repository which depends on the datasource
  getIt.registerSingletonAsync<ProductRepository>(
        () async {
      return ProductRepositoryImpl(
        localDataSource: getIt<ProductLocalDataSource>(),
        changesController: StreamController<Product>.broadcast(),
      );
    },
    dispose: (repo) => repo.dispose(),
    dependsOn: [ProductLocalDataSource],
  );

  // UseCases - factory (sync)
  getIt.registerFactory<ProductUseCases>(() {
    return ProductUseCases.create(getIt<ProductRepository>());
  });

  // Blocs - factory with param
  getIt.registerFactoryParam<BaseProductBloc, String, void>((param1, param2) {
    switch (param1) {
      case 'all':
        return ProductAllBloc(getIt<ProductUseCases>());
      case 'fav':
        return ProductFavBloc(getIt<ProductUseCases>());
      default:
        throw ArgumentError('Unknown bloc type: $param1');
    }
  });
}
