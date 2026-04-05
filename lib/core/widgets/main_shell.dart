import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../di/injection.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/cart/presentation/cubit/cart_state.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/wishlist')) return 1;
    if (location.startsWith('/cart')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
      case 1:
        context.go('/wishlist');
      case 3:
        context.go('/cart');
      case 4:
        context.go('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);

    return BlocProvider.value(
      value: getIt<CartCubit>(),
      child: Scaffold(
        body: child,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: 'Home',
                    isActive: currentIndex == 0,
                    onTap: () => _onTap(context, 0),
                  ),
                  _NavItem(
                    icon: Icons.favorite_outline,
                    activeIcon: Icons.favorite,
                    label: 'Wishlist',
                    isActive: currentIndex == 1,
                    onTap: () => _onTap(context, 1),
                  ),
                  // Center FAB
                  GestureDetector(
                    onTap: () => context.push('/categories'),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryDark,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.grid_view_rounded,
                        color: AppColors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  BlocBuilder<CartCubit, CartState>(
                    builder: (context, cartState) {
                      return _NavItem(
                        icon: Icons.shopping_cart_outlined,
                        activeIcon: Icons.shopping_cart,
                        label: 'Cart',
                        isActive: currentIndex == 3,
                        onTap: () => _onTap(context, 3),
                        badgeCount: cartState.itemCount,
                      );
                    },
                  ),
                  _NavItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: 'Profile',
                    isActive: currentIndex == 4,
                    onTap: () => _onTap(context, 4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final int badgeCount;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            badgeCount > 0
                ? Badge(
                    label: Text(
                      '$badgeCount',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 10,
                      ),
                    ),
                    child: Icon(
                      isActive ? activeIcon : icon,
                      color: isActive ? AppColors.primary : AppColors.textHint,
                      size: 24,
                    ),
                  )
                : Icon(
                    isActive ? activeIcon : icon,
                    color: isActive ? AppColors.primary : AppColors.textHint,
                    size: 24,
                  ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.primary : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
