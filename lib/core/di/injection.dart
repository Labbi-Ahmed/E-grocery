import 'package:get_it/get_it.dart';
import '../api/api_client.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Core
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());

  // Register feature dependencies here as they are built
  // Example:
  // getIt.registerFactory(() => AuthCubit(getIt()));
}
