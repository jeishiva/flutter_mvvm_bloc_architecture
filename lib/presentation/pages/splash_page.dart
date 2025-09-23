import 'package:flutter/material.dart';
import 'package:flutter_mvvm_bloc_architecture/common/logging/log_manager.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacementNamed(context, Routes.home);
    } catch (e) {
       LogManager.error("app init failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
