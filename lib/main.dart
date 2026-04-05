import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/di/injection.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';
import 'features/wishlist/presentation/cubit/wishlist_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize dependencies
  await configureDependencies();

  // Pre-load cart and wishlist so badge counts are ready
  getIt<CartCubit>().loadCart();
  getIt<WishlistCubit>().loadWishlist();

  runApp(const EGroceryApp());
}

class EGroceryApp extends StatelessWidget {
  const EGroceryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>()..checkAuthStatus(),
      child: MaterialApp.router(
        title: 'AfricanFood Market',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
