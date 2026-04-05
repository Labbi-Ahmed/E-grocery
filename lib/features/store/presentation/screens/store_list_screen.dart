import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../../data/models/store_model.dart';
import '../cubit/store_list_cubit.dart';
import '../cubit/store_list_state.dart';

class StoreListScreen extends StatelessWidget {
  const StoreListScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.store),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: BlocBuilder<StoreListCubit, StoreListState>(
        builder: (context, state) {
          return Column(
            children: [
              // Sort tabs
              _buildSortTabs(context, state),
              // Content
              Expanded(
                child: state.status == StoreListStatus.loading
                    ? _buildShimmer()
                    : state.status == StoreListStatus.error
                        ? Center(child: Text(state.errorMessage ?? 'Error'))
                        : _buildContent(context, state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSortTabs(BuildContext context, StoreListState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _SortChip(
              label: 'All stores',
              isSelected: state.activeSort == null,
              onTap: () => context.read<StoreListCubit>().changeSort(null),
            ),
            _SortChip(
              label: 'Popular',
              isSelected: state.activeSort == 'popular',
              onTap: () =>
                  context.read<StoreListCubit>().changeSort('popular'),
            ),
            _SortChip(
              label: 'Newest',
              isSelected: state.activeSort == 'newest',
              onTap: () =>
                  context.read<StoreListCubit>().changeSort('newest'),
            ),
            _SortChip(
              label: 'Best Seller',
              isSelected: state.activeSort == 'best_seller',
              onTap: () =>
                  context.read<StoreListCubit>().changeSort('best_seller'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, StoreListState state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store list
          ...state.stores.map((store) => _StoreCard(store: store)),
          const SizedBox(height: 16),
          // Category grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 0.85,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: _categoryIcons.entries.map((entry) {
                return Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        entry.value,
                        color: AppColors.primaryDark,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      entry.key[0].toUpperCase() + entry.key.substring(1),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: LoadingShimmer(height: 80, borderRadius: 12),
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  final StoreModel store;

  const _StoreCard({required this.store});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/store/${store.id}'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: store.imageUrl ?? '',
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorWidget: (c, u, e) => Container(
                  width: 56,
                  height: 56,
                  color: AppColors.primaryLight,
                  child: const Icon(Icons.store, color: AppColors.primaryDark),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: AppColors.ratingStar),
                      const SizedBox(width: 2),
                      Text(
                        store.rating?.toStringAsFixed(1) ?? '0.0',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '  (${store.reviewCount ?? 0})',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
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
      ),
    );
  }
}
