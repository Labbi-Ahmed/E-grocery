import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../cubit/categories_cubit.dart';
import '../cubit/categories_state.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  static const _categoryIcons = <String, IconData>{
    'grocery': Icons.shopping_basket,
    'meats': Icons.restaurant,
    'fish': Icons.set_meal,
    'drinks': Icons.local_drink,
    'bakery': Icons.bakery_dining,
    'fruits': Icons.apple,
    'poultry': Icons.egg,
    'sweets': Icons.cake,
    'noodles': Icons.ramen_dining,
    'frozen': Icons.ac_unit,
    'others': Icons.more_horiz,
    'african': Icons.public,
  };

  static const _categoryColors = <String, Color>{
    'grocery': Color(0xFFE8F5E9),
    'meats': Color(0xFFFFEBEE),
    'fish': Color(0xFFE3F2FD),
    'drinks': Color(0xFFFFF3E0),
    'bakery': Color(0xFFFCE4EC),
    'fruits': Color(0xFFF1F8E9),
    'poultry': Color(0xFFFFF8E1),
    'sweets': Color(0xFFF3E5F5),
    'noodles': Color(0xFFFFECB3),
    'frozen': Color(0xFFE0F7FA),
    'others': Color(0xFFF5F5F5),
    'african': Color(0xFFE8F5E9),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.categories),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      body: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          if (state.status == CategoriesStatus.loading ||
              state.status == CategoriesStatus.initial) {
            return _buildShimmer();
          }

          if (state.status == CategoriesStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage ?? 'Something went wrong'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<CategoriesCubit>().loadCategories(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.85,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final category = state.categories[index];
              final key = category.name.toLowerCase();
              final icon = _categoryIcons[key] ?? Icons.category;
              final color =
                  _categoryColors[key] ?? AppColors.primaryLight;

              return GestureDetector(
                onTap: () => context.push(
                  '/products/${category.id}',
                  extra: category.name,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        icon,
                        color: AppColors.primaryDark,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildShimmer() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        return Column(
          children: [
            LoadingShimmer(height: 72, width: 72, borderRadius: 20),
            const SizedBox(height: 8),
            LoadingShimmer(height: 12, width: 50, borderRadius: 4),
          ],
        );
      },
    );
  }
}
