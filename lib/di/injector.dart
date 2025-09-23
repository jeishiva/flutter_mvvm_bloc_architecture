// lib/di/get_it_setup.dart
import 'package:get_it/get_it.dart';
import 'product_injector.dart';

final GetIt getIt = GetIt.instance;

/// Call this once at app startup to register modules.
/// You can add more module registration functions (auth, analytics, etc.)
Future<void> initInjector() async {
  // register product module
  await registerProductModule(getIt);

  // register other modules here

  // Wait for all async singletons to finish initialization
  await getIt.allReady();
}
