import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../api/api_client.dart';
import '../../features/auth/data/datasources/auth_mock_datasource.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/password_reset_cubit.dart';
import '../../features/home/data/datasources/home_mock_datasource.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/product_detail/data/datasources/product_detail_mock_datasource.dart';
import '../../features/product_detail/data/repositories/product_detail_repository_impl.dart';
import '../../features/product_detail/domain/repositories/product_detail_repository.dart';
import '../../features/categories/data/datasources/categories_mock_datasource.dart';
import '../../features/categories/data/repositories/categories_repository_impl.dart';
import '../../features/categories/domain/repositories/categories_repository.dart';
import '../../features/categories/presentation/cubit/categories_cubit.dart';
import '../../features/categories/presentation/cubit/search_cubit.dart';
import '../../features/cart/data/datasources/cart_mock_datasource.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/cart/presentation/cubit/checkout_cubit.dart';
import '../../features/store/data/datasources/store_mock_datasource.dart';
import '../../features/store/data/repositories/store_repository_impl.dart';
import '../../features/store/domain/repositories/store_repository.dart';
import '../../features/store/presentation/cubit/store_list_cubit.dart';
import '../../features/orders/data/datasources/orders_mock_datasource.dart';
import '../../features/orders/data/repositories/orders_repository_impl.dart';
import '../../features/orders/domain/repositories/orders_repository.dart';
import '../../features/orders/presentation/cubit/orders_cubit.dart';
import '../../features/wholesale/data/datasources/wholesale_mock_datasource.dart';
import '../../features/wholesale/data/repositories/wholesale_repository_impl.dart';
import '../../features/wholesale/domain/repositories/wholesale_repository.dart';
import '../../features/wholesale/presentation/cubit/wholesale_cubit.dart';
import '../../features/wishlist/data/datasources/wishlist_mock_datasource.dart';
import '../../features/wishlist/data/repositories/wishlist_repository_impl.dart';
import '../../features/wishlist/domain/repositories/wishlist_repository.dart';
import '../../features/wishlist/presentation/cubit/wishlist_cubit.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Core
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // Auth (using mock datasource for frontend-first development)
  getIt.registerLazySingleton<AuthMockDatasource>(
    () => AuthMockDatasource(),
  );
  getIt.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasource(getIt<FlutterSecureStorage>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthMockDatasource>(),
      getIt<AuthLocalDatasource>(),
    ),
  );
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt<AuthRepository>()),
  );
  getIt.registerFactory<PasswordResetCubit>(
    () => PasswordResetCubit(getIt<AuthRepository>()),
  );

  // Home
  getIt.registerLazySingleton<HomeMockDatasource>(
    () => HomeMockDatasource(),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt<HomeMockDatasource>()),
  );
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(getIt<HomeRepository>()),
  );

  // Categories
  getIt.registerLazySingleton<CategoriesMockDatasource>(
    () => CategoriesMockDatasource(),
  );
  getIt.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepositoryImpl(getIt<CategoriesMockDatasource>()),
  );
  getIt.registerFactory<CategoriesCubit>(
    () => CategoriesCubit(getIt<CategoriesRepository>()),
  );
  getIt.registerFactory<SearchCubit>(
    () => SearchCubit(getIt<CategoriesRepository>()),
  );

  // Product Detail
  getIt.registerLazySingleton<ProductDetailMockDatasource>(
    () => ProductDetailMockDatasource(),
  );
  getIt.registerLazySingleton<ProductDetailRepository>(
    () => ProductDetailRepositoryImpl(getIt<ProductDetailMockDatasource>()),
  );

  // Cart & Checkout
  getIt.registerLazySingleton<CartMockDatasource>(
    () => CartMockDatasource(),
  );
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(getIt<CartMockDatasource>()),
  );
  getIt.registerLazySingleton<CartCubit>(
    () => CartCubit(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton<CheckoutCubit>(
    () => CheckoutCubit(getIt<CartRepository>()),
  );

  // Store
  getIt.registerLazySingleton<StoreMockDatasource>(
    () => StoreMockDatasource(),
  );
  getIt.registerLazySingleton<StoreRepository>(
    () => StoreRepositoryImpl(getIt<StoreMockDatasource>()),
  );
  getIt.registerFactory<StoreListCubit>(
    () => StoreListCubit(getIt<StoreRepository>()),
  );

  // Orders
  getIt.registerLazySingleton<OrdersMockDatasource>(
    () => OrdersMockDatasource(),
  );
  getIt.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(getIt<OrdersMockDatasource>()),
  );
  getIt.registerLazySingleton<OrdersCubit>(
    () => OrdersCubit(getIt<OrdersRepository>()),
  );

  // Wholesale
  getIt.registerLazySingleton<WholesaleMockDatasource>(
    () => WholesaleMockDatasource(),
  );
  getIt.registerLazySingleton<WholesaleRepository>(
    () => WholesaleRepositoryImpl(getIt<WholesaleMockDatasource>()),
  );
  getIt.registerLazySingleton<WholesaleCubit>(
    () => WholesaleCubit(getIt<WholesaleRepository>()),
  );

  // Wishlist
  getIt.registerLazySingleton<WishlistMockDatasource>(
    () => WishlistMockDatasource(),
  );
  getIt.registerLazySingleton<WishlistRepository>(
    () => WishlistRepositoryImpl(getIt<WishlistMockDatasource>()),
  );
  getIt.registerLazySingleton<WishlistCubit>(
    () => WishlistCubit(getIt<WishlistRepository>()),
  );
}
