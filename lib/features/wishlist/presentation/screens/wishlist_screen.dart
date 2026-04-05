import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../../../../core/widgets/app_button.dart';
import '../cubit/wishlist_cubit.dart';
import '../cubit/wishlist_state.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.wishList),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, size: 22),
            onPressed: () => _showSortFilter(context),
          ),
        ],
      ),
      body: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {
          if (state.status == WishlistStatus.loading ||
              state.status == WishlistStatus.initial) {
            return const ProductGridShimmer(itemCount: 6);
          }

          return Column(
            children: [
              // Search bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  onChanged: (q) =>
                      context.read<WishlistCubit>().search(q),
                  decoration: InputDecoration(
                    hintText: AppStrings.searchHint,
                    hintStyle: const TextStyle(
                      color: AppColors.textHint,
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(Icons.search,
                        color: AppColors.textHint, size: 20),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              // Filter chips
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    _FilterChip(
                      label: AppStrings.allWishlist,
                      isSelected: state.activeSort == null,
                      onTap: () =>
                          context.read<WishlistCubit>().changeSort(null),
                    ),
                    const SizedBox(width: 8),
                    _DropdownChip(
                      label: AppStrings.sortBy,
                      onTap: () => _showSortFilter(context),
                    ),
                    const SizedBox(width: 8),
                    _DropdownChip(
                      label: AppStrings.category,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              // Grid
              Expanded(
                child: state.filteredItems.isEmpty
                    ? _buildEmptyState()
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.68,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: state.filteredItems.length,
                        itemBuilder: (context, index) {
                          final product = state.filteredItems[index];
                          return ProductCard(
                            id: product.id,
                            name: product.name,
                            imageUrl: product.imageUrl,
                            price: product.price,
                            originalPrice: product.originalPrice,
                            rating: product.rating,
                            reviewCount: product.reviewCount,
                            discountPercent: product.discountPercent,
                            isWishlisted: true,
                            onTap: () =>
                                context.push('/product/${product.id}'),
                            onWishlistToggle: () => context
                                .read<WishlistCubit>()
                                .removeItem(product.id),
                            onAddToCart: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('${product.name} added to cart'),
                                  backgroundColor: AppColors.primary,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_outline, size: 64, color: AppColors.textHint),
          SizedBox(height: 16),
          Text(
            'Your wishlist is empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Save items you love to your wishlist',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  void _showSortFilter(BuildContext context) {
    final cubit = context.read<WishlistCubit>();
    String? selected = cubit.state.activeSort;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        AppStrings.sortFilter,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _sortOption(
                    ctx,
                    AppStrings.latestSaved,
                    'latest',
                    selected,
                    (v) => setSheetState(() => selected = v),
                  ),
                  _sortOption(
                    ctx,
                    AppStrings.mostReviews,
                    'reviews',
                    selected,
                    (v) => setSheetState(() => selected = v),
                  ),
                  _sortOption(
                    ctx,
                    AppStrings.highestPrice,
                    'price_high',
                    selected,
                    (v) => setSheetState(() => selected = v),
                  ),
                  _sortOption(
                    ctx,
                    AppStrings.lowestPrice,
                    'price_low',
                    selected,
                    (v) => setSheetState(() => selected = v),
                  ),
                  _sortOption(
                    ctx,
                    AppStrings.mostPurchases,
                    'purchases',
                    selected,
                    (v) => setSheetState(() => selected = v),
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    text: 'Apply',
                    onPressed: () {
                      cubit.changeSort(selected);
                      Navigator.pop(ctx);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _sortOption(
    BuildContext context,
    String label,
    String value,
    String? selected,
    ValueChanged<String> onChanged,
  ) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 15),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected == value
                      ? AppColors.primary
                      : AppColors.divider,
                  width: 2,
                ),
              ),
              child: selected == value
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppColors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _DropdownChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DropdownChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down,
                size: 16, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
