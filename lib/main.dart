import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/di/injector.dart';
import 'package:flutter_mvvm_bloc_architecture/domain/entities/product_filter.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/abstract_product_bloc.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/blocs/product_all_bloc.dart';
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
                      getIt<BaseProductBloc>(param1: 'all')
                        ..add(const LoadProducts(ProductFilter.noFilters())),
                  child: const ProductPage.home(),
                ),
              ),
              // Favourites
              Expanded(
                flex: 1,
                child: BlocProvider(
                  create: (_) =>
                      getIt<BaseProductBloc>(param1: 'fav')
                        ..add(const LoadProducts(ProductFilter.favourites())),
                  child: const ProductPage.favourites(),
                ),
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

  // create per-tab blocs so parent can trigger loads when needed
  late final BaseProductBloc _homeBloc;
  late final BaseProductBloc _favBloc;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _homeBloc = getIt<BaseProductBloc>(param1: 'all')
      ..add(const LoadProducts(ProductFilter.noFilters()));
    _favBloc = getIt<BaseProductBloc>(param1: 'fav')
      ..add(const LoadProducts(ProductFilter.favourites()));
    _pages.addAll([
      BlocProvider<BaseProductBloc>.value(
        value: _homeBloc,
        child: const ProductPage.home(),
      ),
      BlocProvider<BaseProductBloc>.value(
        value: _favBloc,
        child: const ProductPage.favourites(),
      ),
    ]);
  }

  @override
  void dispose() {
    // parent owns the blocs so close them here
    _homeBloc.close();
    _favBloc.close();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() => _selectedIndex = index);
    if (index == 0) {
      _homeBloc.add(const LoadProducts(ProductFilter.noFilters()));
    } else if (index == 1) {
      _favBloc.add(const LoadProducts(ProductFilter.favourites()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
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
