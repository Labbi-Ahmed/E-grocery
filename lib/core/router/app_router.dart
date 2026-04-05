import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../di/injection.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/product_detail/presentation/cubit/product_detail_cubit.dart';
import '../../features/product_detail/domain/repositories/product_detail_repository.dart';
import '../../features/categories/presentation/cubit/categories_cubit.dart';
import '../../features/categories/presentation/cubit/product_list_cubit.dart';
import '../../features/categories/presentation/cubit/search_cubit.dart';
import '../../features/categories/domain/repositories/categories_repository.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/cart/presentation/cubit/checkout_cubit.dart';
import '../../features/store/presentation/cubit/store_list_cubit.dart';
import '../../features/store/presentation/cubit/store_detail_cubit.dart';
import '../../features/store/domain/repositories/store_repository.dart';
import '../../features/orders/presentation/cubit/orders_cubit.dart';
import '../../features/wholesale/presentation/cubit/wholesale_cubit.dart';
import '../../features/wholesale/presentation/screens/wholesale_product_detail_screen.dart';
import '../../features/wholesale/presentation/screens/wholesale_cart_screen.dart';
import '../../features/wholesale/presentation/screens/wholesale_account_screen.dart';
import '../../features/wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/otp_verification_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/password_success_screen.dart';
import '../widgets/main_shell.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/wishlist/presentation/screens/wishlist_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/categories/presentation/screens/categories_screen.dart';
import '../../features/categories/presentation/screens/search_screen.dart';
import '../../features/categories/presentation/screens/product_list_screen.dart';
import '../../features/product_detail/presentation/screens/product_detail_screen.dart';
import '../../features/checkout/presentation/screens/checkout_screen.dart';
import '../../features/checkout/presentation/screens/payment_method_screen.dart';
import '../../features/checkout/presentation/screens/new_address_screen.dart';
import '../../features/checkout/presentation/screens/order_confirmed_screen.dart';
import '../../features/store/presentation/screens/store_list_screen.dart';
import '../../features/store/presentation/screens/store_detail_screen.dart';
import '../../features/orders/presentation/screens/my_orders_screen.dart';
import '../../features/orders/presentation/screens/order_detail_screen.dart';
import '../../features/orders/presentation/screens/track_order_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/notification_settings_screen.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      // Auth routes
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/otp-verification',
        builder: (context, state) => OtpVerificationScreen(
          email: state.extra as String? ?? '',
        ),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final extra = state.extra as Map<String, String>? ?? {};
          return ResetPasswordScreen(
            email: extra['email'] ?? '',
            otp: extra['otp'] ?? '',
          );
        },
      ),
      GoRoute(
        path: '/password-success',
        builder: (context, state) => const PasswordSuccessScreen(),
      ),

      // Main shell with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => NoTransitionPage(
              child: BlocProvider(
                create: (_) => getIt<HomeCubit>()..loadHome(),
                child: const HomeScreen(),
              ),
            ),
          ),
          GoRoute(
            path: '/wishlist',
            pageBuilder: (context, state) => NoTransitionPage(
              child: BlocProvider.value(
                value: getIt<WishlistCubit>()..loadWishlist(),
                child: const WishlistScreen(),
              ),
            ),
          ),
          GoRoute(
            path: '/cart',
            pageBuilder: (context, state) => NoTransitionPage(
              child: BlocProvider.value(
                value: getIt<CartCubit>()..loadCart(),
                child: const CartScreen(),
              ),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),

      // Categories & Search
      GoRoute(
        path: '/categories',
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<CategoriesCubit>()..loadCategories(),
          child: const CategoriesScreen(),
        ),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<SearchCubit>()..init(),
          child: const SearchScreen(),
        ),
      ),
      GoRoute(
        path: '/products/:categoryId',
        builder: (context, state) {
          final categoryId = state.pathParameters['categoryId']!;
          return BlocProvider(
            create: (_) => ProductListCubit(
              repository: getIt<CategoriesRepository>(),
              categoryId: categoryId,
            )..loadProducts(),
            child: ProductListScreen(
              categoryId: categoryId,
              categoryName: state.extra as String? ?? 'Products',
            ),
          );
        },
      ),

      // Product Detail
      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return BlocProvider(
            create: (_) => ProductDetailCubit(
              repository: getIt<ProductDetailRepository>(),
              productId: productId,
            )..loadProduct(),
            child: ProductDetailScreen(productId: productId),
          );
        },
      ),

      // Checkout flow
      GoRoute(
        path: '/checkout',
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: getIt<CartCubit>()),
            BlocProvider(
              create: (_) => getIt<CheckoutCubit>()..loadAddresses(),
            ),
          ],
          child: const CheckoutScreen(),
        ),
      ),
      GoRoute(
        path: '/payment-method',
        builder: (context, state) => BlocProvider.value(
          value: getIt<CheckoutCubit>(),
          child: const PaymentMethodScreen(),
        ),
      ),
      GoRoute(
        path: '/new-address',
        builder: (context, state) => BlocProvider.value(
          value: getIt<CheckoutCubit>(),
          child: const NewAddressScreen(),
        ),
      ),
      GoRoute(
        path: '/order-confirmed',
        builder: (context, state) => const OrderConfirmedScreen(),
      ),

      // Store
      GoRoute(
        path: '/stores',
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<StoreListCubit>()..loadStores(),
          child: const StoreListScreen(),
        ),
      ),
      GoRoute(
        path: '/store/:id',
        builder: (context, state) {
          final storeId = state.pathParameters['id']!;
          return BlocProvider(
            create: (_) => StoreDetailCubit(
              repository: getIt<StoreRepository>(),
              storeId: storeId,
            )..loadStore(),
            child: StoreDetailScreen(storeId: storeId),
          );
        },
      ),

      // Orders
      GoRoute(
        path: '/my-orders',
        builder: (context, state) => BlocProvider.value(
          value: getIt<OrdersCubit>()..loadOrders(),
          child: const MyOrdersScreen(),
        ),
      ),
      GoRoute(
        path: '/order/:id',
        builder: (context, state) => BlocProvider.value(
          value: getIt<OrdersCubit>(),
          child: OrderDetailScreen(
            orderId: state.pathParameters['id']!,
          ),
        ),
      ),
      GoRoute(
        path: '/track-order/:id',
        builder: (context, state) => BlocProvider.value(
          value: getIt<OrdersCubit>(),
          child: TrackOrderScreen(
            orderId: state.pathParameters['id']!,
          ),
        ),
      ),

      // Wholesale
      GoRoute(
        path: '/wholesale/product/:id',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return BlocProvider.value(
            value: getIt<WholesaleCubit>()..loadProductDetail(productId),
            child: WholesaleProductDetailScreen(productId: productId),
          );
        },
      ),
      GoRoute(
        path: '/wholesale/cart',
        builder: (context, state) => BlocProvider.value(
          value: getIt<WholesaleCubit>()..loadCart(),
          child: const WholesaleCartScreen(),
        ),
      ),
      GoRoute(
        path: '/wholesale/account',
        builder: (context, state) => const WholesaleAccountScreen(),
      ),

      // Profile sub-pages
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/notification-settings',
        builder: (context, state) => const NotificationSettingsScreen(),
      ),
    ],
  );
}
