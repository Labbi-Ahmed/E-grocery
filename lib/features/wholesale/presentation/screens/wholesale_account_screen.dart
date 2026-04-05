import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class WholesaleAccountScreen extends StatelessWidget {
  const WholesaleAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.myAccount)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar with wholesale badge
            Stack(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primaryLight,
                  child: Icon(Icons.person, size: 40,
                      color: AppColors.primaryDark),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'PRO',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'John Doe',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Wholesale Customer',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accentDark,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _MenuItem(
              icon: Icons.shopping_bag_outlined,
              title: AppStrings.myOrders,
              onTap: () => context.push('/my-orders'),
            ),
            _MenuItem(
              icon: Icons.shopping_cart_outlined,
              title: 'Wholesale Cart',
              onTap: () => context.push('/wholesale/cart'),
            ),
            _MenuItem(
              icon: Icons.location_on_outlined,
              title: AppStrings.shippingAddresses,
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.payment_outlined,
              title: AppStrings.paymentMethods,
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.settings_outlined,
              title: AppStrings.settings,
              onTap: () => context.push('/edit-profile'),
            ),
            const SizedBox(height: 8),
            _MenuItem(
              icon: Icons.logout,
              title: AppStrings.logout,
              isDestructive: true,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Logout'),
                    content:
                        const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          context.read<AuthCubit>().logout();
                          context.go('/sign-in');
                        },
                        child: const Text('Logout',
                            style: TextStyle(color: AppColors.error)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22,
                color: isDestructive ? AppColors.error : AppColors.textSecondary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDestructive ? AppColors.error : AppColors.textPrimary,
                  )),
            ),
            if (!isDestructive)
              const Icon(Icons.arrow_forward_ios,
                  size: 16, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
