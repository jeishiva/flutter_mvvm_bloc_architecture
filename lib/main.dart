import 'package:flutter/material.dart';
import 'package:flutter_mvvm_bloc_architecture/di/injector.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/pages/home_page.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/pages/splash_page.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/routes.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjector();
  runApp(const MvvmBlocApp());
}

class MvvmBlocApp extends StatelessWidget {
  const MvvmBlocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MVVM BLoC Architecture',
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
