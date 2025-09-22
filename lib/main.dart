import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/di/injector.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product_filter.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/pages/product_page.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/pages/splash_page.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/routes.dart';


 main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjector();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Big Billion App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      initialRoute: Routes.splash,
      routes: {
        Routes.splash: (_) => const SplashPage(),
        Routes.home: (_) => const HomePage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isTablet = constraints.maxWidth > 600;
        if (isTablet) {
          return Row(
            children: [
              Expanded(
                flex: 1,
                child: BlocProvider(
                  create: (_) =>
                      getIt<ProductBloc>()
                        ..add(const LoadProducts(ProductFilter.favourites())),
                  child: const ProductPage(),
                ),
              ),
              // Favourites
              BlocProvider(
                create: (_) =>
                    getIt<ProductBloc>()
                      ..add(const LoadProducts(ProductFilter.favourites())),
                child: const ProductPage(),
              ),
            ],
          );
        } else {
          // Phone: Bottom navigation
          return const BottomNavigationScaffold();
        }
      },
    );
  }
}

class BottomNavigationScaffold extends StatefulWidget {
  const BottomNavigationScaffold({super.key});

  @override
  _BottomNavigationScaffoldState createState() =>
      _BottomNavigationScaffoldState();
}

class _BottomNavigationScaffoldState extends State<BottomNavigationScaffold> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Home (no filters)
          BlocProvider(
            create: (_) =>
                getIt<ProductBloc>()
                  ..add(const LoadProducts(ProductFilter.noFilters())),
            child: const ProductPage(),
          ),

          // Favourites
          BlocProvider(
            create: (_) =>
                getIt<ProductBloc>()
                  ..add(const LoadProducts(ProductFilter.favourites())),
            child: const ProductPage(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourite',
          ),
        ],
      ),
    );
  }
}
