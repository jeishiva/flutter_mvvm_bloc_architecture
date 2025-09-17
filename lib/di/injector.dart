import 'package:flutter_mvvm_bloc_architecture/data/datasources/product_local_data_source.dart';
import 'package:flutter_mvvm_bloc_architecture/data/repositories/product_repo_impl.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/repositories/product_repo.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_bloc.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void initInjector() {
  getIt.registerLazySingleton<ProductLocalDataSource>(() => ProductLocalDataSourceImpl());
  getIt.registerLazySingleton<ProductRepository>(
          () => ProductRepositoryImpl(localDataSource: getIt<ProductLocalDataSource>())
  );
  getIt.registerFactory<ProductBloc>(
        () => ProductBloc(getIt<ProductRepository>()),
  );
}