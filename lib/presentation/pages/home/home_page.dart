import 'package:flutter/material.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/pages/home/home_mobile_page.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/pages/home/home_tablet_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isTablet = constraints.maxWidth > 600;
        if (isTablet) {
          return const HomeTabletPage();
        } else {
          return const HomePhonePage();
        }
      },
    );
  }
}

