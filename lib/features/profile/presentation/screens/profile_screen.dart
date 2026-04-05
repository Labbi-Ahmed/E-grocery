import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.myAccount)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar + name
            const CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primaryLight,
              child: Icon(Icons.person, size: 40, color: AppColors.primaryDark),
            ),
            const SizedBox(height: 12),
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'john.doe@email.com',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            // Menu items
            _MenuItem(
              icon: Icons.shopping_bag_outlined,
              title: AppStrings.myOrders,
              onTap: () => context.push('/my-orders'),
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
            _MenuItem(
              icon: Icons.notifications_outlined,
              title: AppStrings.notifications,
              onTap: () => context.push('/notification-settings'),
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
                    content: const Text('Are you sure you want to logout?'),
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
                        child: const Text(
                          'Logout',
                          style: TextStyle(color: AppColors.error),
                        ),
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: isDestructive ? AppColors.error : AppColors.textSecondary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDestructive ? AppColors.error : AppColors.textPrimary,
                ),
              ),
            ),
            if (!isDestructive)
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textHint,
              ),
          ],
        ),
      ),
    );
  }
}
