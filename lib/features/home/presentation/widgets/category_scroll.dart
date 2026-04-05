import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/category_model.dart';

class CategoryScroll extends StatelessWidget {
  final List<CategoryModel> categories;
  final ValueChanged<CategoryModel>? onCategoryTap;

  const CategoryScroll({
    super.key,
    required this.categories,
    this.onCategoryTap,
  });

  static const _categoryIcons = <String, IconData>{
    'grocery': Icons.shopping_basket,
    'meats': Icons.restaurant,
    'fish': Icons.set_meal,
    'drinks': Icons.local_drink,
    'bakery': Icons.bakery_dining,
    'fruits': Icons.apple,
    'poultry': Icons.egg,
    'others': Icons.more_horiz,
    'african': Icons.public,
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _CategoryItem(
            category: category,
            icon: _categoryIcons[category.name.toLowerCase()] ??
                Icons.category,
            onTap: () => onCategoryTap?.call(category),
          );
        },
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final CategoryModel category;
  final IconData icon;
  final VoidCallback? onTap;

  const _CategoryItem({
    required this.category,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: category.iconUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: category.iconUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            Icon(icon, color: AppColors.primaryDark),
                      ),
                    )
                  : Icon(icon, color: AppColors.primaryDark),
            ),
            const SizedBox(height: 6),
            Text(
              category.name,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
